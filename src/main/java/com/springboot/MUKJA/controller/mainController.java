package com.springboot.MUKJA.controller;

import java.security.Principal;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.springboot.MUKJA.dao.mukjaSearchDAO;
import com.springboot.MUKJA.dao.restaurantDAO;
import com.springboot.MUKJA.dao.usersDAO;
import com.springboot.MUKJA.dto.menuDTO;
import com.springboot.MUKJA.dto.mukjaSearchDTO;
import com.springboot.MUKJA.dto.restaurantDTO;
import com.springboot.MUKJA.dto.usersDTO;
import com.springboot.MUKJA.service.EsRatingService;

@Controller
public class mainController {
    
    @Autowired
    private restaurantDAO restaurantDao;
    
    @Autowired
    private mukjaSearchDAO mukjaSearchDao;
    
    @Autowired
    private usersDAO usersDao;
    
    @Autowired
    private EsRatingService esRatingService;

    // 메인페이지 진입 컨트롤러
    @GetMapping("/")
    public String index() {
        return "redirect:/main";
    }
    
    // ⚡ 1. 지역별 가게 추천
    @GetMapping("/api/store/region")
    @ResponseBody
    public List<restaurantDTO> getStoresByRegion(@RequestParam(value = "region", defaultValue = "전체") String region) {
        return restaurantDao.restaurantListRegion(region);
    }
    
    // ⚡ 2. 평점별 매장 목록 (타입 안전성 강화 버전)
    @GetMapping("/api/store/top-rating")
    @ResponseBody
    public List<restaurantDTO> getStoresByTopRating(@RequestParam(value = "filter", defaultValue = "all") String filter) {
        List<restaurantDTO> storeList = restaurantDao.restaurantListAll();
        Map<Integer, Map<String, Object>> ratingMap = esRatingService.getRestaurantRatings();

        return storeList.stream()
            .filter(store -> {
                double avgRating = getAvgRatingFromMap(ratingMap, store.getR_no());

                // 탭 필터 조건 비교 (이상 조건 적용)
                if ("rating_4.8".equals(filter)) {
                    return avgRating >= 4.8;
                } else if ("rating_4.5".equals(filter)) {
                    return avgRating >= 4.5 && avgRating < 4.8; // 4.5 ~ 4.7점대 매장만
                } else if ("rating_4.0".equals(filter)) {
                    return avgRating >= 4.0 && avgRating < 4.5; // 4.0 ~ 4.4점대 매장만
                }
                return true; // all (전체보기)
            })
            .sorted((s1, s2) -> {
                // ES 평점 기준 내림차순 정렬 (5.0 -> 4.9 -> 4.8 ...)
                double p1 = getAvgRatingFromMap(ratingMap, s1.getR_no());
                double p2 = getAvgRatingFromMap(ratingMap, s2.getR_no());
                return Double.compare(p2, p1);
            })
            .collect(Collectors.toList());
    }

    // [안전 헬퍼 메서드] Map에서 평점을 안전하게 Double로 추출
    private double getAvgRatingFromMap(Map<Integer, Map<String, Object>> ratingMap, Object rNoObj) {
        if (ratingMap == null || rNoObj == null) return 0.0;
        try {
            int rNo = Integer.parseInt(String.valueOf(rNoObj));
            Map<String, Object> rData = ratingMap.get(rNo);
            if (rData != null && rData.get("avgRating") != null) {
                return Double.parseDouble(String.valueOf(rData.get("avgRating")));
            }
        } catch (Exception e) {
            return 0.0;
        }
        return 0.0;
    }
    
    // ⚡ 3. 전체 매장 목록
    @GetMapping("/api/store/all")
    @ResponseBody
    public List<restaurantDTO> getStoresAll() {
        return restaurantDao.restaurantListAll();
    }
    
    // ⚡ 4. 메인페이지 실행 컨트롤러
    @RequestMapping("/main")
    public String main(
            @RequestParam(value = "page", defaultValue = "1") int page,
            Model model,
            Principal principal) {

        int pageSize = 20;
        int start = (page - 1) * pageSize;

        List<restaurantDTO> restaurantList = restaurantDao.mainrestaurantList(start, pageSize);
        
        // ES 평점 데이터를 메인 모델에 바인딩
        Map<Integer, Map<String, Object>> ratingMap = esRatingService.getRestaurantRatings();
        model.addAttribute("ratingMap", ratingMap);

        int count = restaurantDao.restaurantCount();
        int totalPage = (int) Math.ceil((double) count / pageSize);

        int pageBlock = 5;
        int startPage = ((page - 1) / pageBlock) * pageBlock + 1;
        int endPage = startPage + pageBlock - 1;

        if (endPage > totalPage) { endPage = totalPage; }

        model.addAttribute("restaurantList", restaurantList);
        model.addAttribute("categoryList", restaurantDao.foodcategoryList());
        model.addAttribute("regionList", restaurantDao.regionList());

        model.addAttribute("page", page);
        model.addAttribute("totalPage", totalPage);
        model.addAttribute("startPage", startPage);
        model.addAttribute("endPage", endPage);

        List<mukjaSearchDTO> popularSearchList = mukjaSearchDao.popularSearchList();
        model.addAttribute("popularSearchList", popularSearchList);

        if (principal != null) {
            usersDTO user = usersDao.findById(principal.getName());
            model.addAttribute("user", user);
        }

        return "main";
    }
    
    // ⚡ 5. 카테고리 페이지 이동 컨트롤러 (ES 캐싱 및 정렬 완벽 적용)
    @GetMapping("/category")
    public String storeCategory(
            @RequestParam(value = "cate", defaultValue = "0") String cateParam,
            @RequestParam(value = "sort", defaultValue = "default") String sort,
            @RequestParam(value = "page", defaultValue = "1") int page,
            Model model) {

        int mukja_c_no = 0;
        if (cateParam != null && !"all".equalsIgnoreCase(cateParam)) {
            try {
                mukja_c_no = Integer.parseInt(cateParam);
            } catch (NumberFormatException e) {
                mukja_c_no = 0;
            }
        }

        int pageSize = 20;
        int start = (page - 1) * pageSize;

        List<restaurantDTO> storeList;
        int totalCount;

        // ES 캐싱 평점 Map 가져오기 (메인페이지와 동일한 타입)
        Map<Integer, Map<String, Object>> ratingMap = esRatingService.getRestaurantRatings();

        // 평점순 정렬 요청 시 ("rating" 또는 "score") 인메모리 ES 평점 정렬
        if ("rating".equals(sort) || "score".equals(sort)) {
            List<restaurantDTO> allStores;
            if (mukja_c_no == 0) {
                allStores = restaurantDao.restaurantListAll();
            } else {
                allStores = restaurantDao.restaurantListCategory(mukja_c_no, sort, 0, 1000);
            }

            // getAvgRatingFromMap 헬퍼 메서드로 ES 평점 기준 내림차순 정렬
            allStores.sort((s1, s2) -> {
                double p1 = getAvgRatingFromMap(ratingMap, s1.getR_no());
                double p2 = getAvgRatingFromMap(ratingMap, s2.getR_no());
                return Double.compare(p2, p1);
            });

            totalCount = allStores.size();
            int end = Math.min(start + pageSize, totalCount);
            storeList = (start < totalCount) ? allStores.subList(start, end) : new ArrayList<>();
        } else {
            // 기본 정렬 (DB 페이징)
            if (mukja_c_no == 0) {
                storeList = restaurantDao.mainrestaurantList(start, pageSize);
                totalCount = restaurantDao.restaurantCount();
            } else {
                storeList = restaurantDao.restaurantListCategory(mukja_c_no, sort, start, pageSize);
                totalCount = restaurantDao.restaurantCountCategory(mukja_c_no);
            }
        }

        int totalPage = (int) Math.ceil((double) totalCount / pageSize);
        int pageBlock = 5;

	    // 현재 페이지가 포함된 페이지 번호 구간
	    int startPage = ((page - 1) / pageBlock) * pageBlock + 1;
	
	    // 마지막 페이지가 totalPage를 넘지 않도록 처리
	    int endPage = Math.min(startPage + pageBlock - 1, totalPage);

        String categoryName = "전체 맛집";
        switch(mukja_c_no) {
            case 1: categoryName = "한식"; break;
            case 2: categoryName = "중식"; break;
            case 3: categoryName = "일식"; break;
            case 4: categoryName = "양식 / 세계음식"; break;
            case 5: categoryName = "육류"; break;
            case 6: categoryName = "해산물"; break;
            case 7: categoryName = "카페 / 디저트"; break;
            case 8: categoryName = "주점"; break;
            case 9: categoryName = "기타"; break;
        }

        model.addAttribute("storeList", storeList);
        model.addAttribute("ratingMap", ratingMap); // 메인페이지처럼 ratingMap을 JSP로 전달!
        model.addAttribute("totalCount", totalCount);
        model.addAttribute("selectedCate", mukja_c_no);
        model.addAttribute("selectedCategory", categoryName);
        model.addAttribute("sort", sort);
        model.addAttribute("page", page);
        model.addAttribute("totalPage", totalPage);
        model.addAttribute("startPage", startPage);
        model.addAttribute("endPage", endPage);

        return "category";
    }
    
    // 식당 상세 페이지 이동 
    @GetMapping({"/restaurant/restaurantDetail", "/store/detail"})
    public String storeDetail(@RequestParam("r_no") int r_no, Model model) {
        restaurantDTO store = restaurantDao.restaurantDetail(r_no);
        
        model.addAttribute("dto", store);
        model.addAttribute("restaurant", store);
        model.addAttribute("store", store);

        List<menuDTO> menuList = restaurantDao.menuList(r_no);
        model.addAttribute("menuList", menuList);

        List<restaurantDTO> menuBoardImageList = restaurantDao.menuBoardImageList(r_no);
        model.addAttribute("menuBoardImageList", menuBoardImageList);

        return "redirect:/restaurant/detail?r_no=" + r_no;
    }
    
    // visual_dashboard 실행 컨트롤러
    @GetMapping("/admin/visual/dashboard")
    public String visualDashboard(Model model) {
        int restaurantCount = restaurantDao.restaurantCount();
        model.addAttribute("restaurantCount", restaurantCount);
        return "admin/visual_dashboard";
    }
}
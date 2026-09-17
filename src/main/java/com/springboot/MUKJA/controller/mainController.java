package com.springboot.MUKJA.controller;

import java.security.Principal;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.springboot.MUKJA.dao.mukjaSearchDAO;
import com.springboot.MUKJA.dao.restaurantDAO;
import com.springboot.MUKJA.dao.reviewDAO;
import com.springboot.MUKJA.dao.usersDAO;
import com.springboot.MUKJA.dto.menuDTO;
import com.springboot.MUKJA.dto.mukjaSearchDTO;
import com.springboot.MUKJA.dto.restaurantDTO;
import com.springboot.MUKJA.dto.usersDTO;

@Controller
public class mainController {
	
	@Autowired
	private restaurantDAO restaurantDao;
	
	@Autowired
	private mukjaSearchDAO mukjaSearchDao;
	
	@Autowired
	private usersDAO usersDao;
	
	@Autowired
	private reviewDAO rvdao;

	// 메인페이지 진입 컨트롤러
	@GetMapping("/")
	public String index() {
		return "redirect:/main";
	}
	
	// 지역별 가게 추천 
	@GetMapping("/api/store/region")
    @ResponseBody
    public List<restaurantDTO> getStoresByRegion(@RequestParam(value = "region", defaultValue = "전체") String region) {
        // XML에서 #{r_region}으로 받고 있으므로 region 값을 전달
        //return restaurantDao.restaurantListRegion(region);
        // 지역별 식당 목록 조회
        List<restaurantDTO> storeList =
                restaurantDao.restaurantListRegion(region);

        // 각 식당의 리뷰 평균을 r_point에 적용
        for (restaurantDTO restaurant : storeList) {
            double avgPoint = rvdao.reviewAvg(restaurant.getR_no());
            restaurant.setR_point(avgPoint);
        }
        return storeList;
    }
    
    // 평정별 매장 목록
    @GetMapping("/api/store/top-rating")
    @ResponseBody
    public List<restaurantDTO> getStoresByTopRating(@RequestParam(value = "filter", defaultValue = "all") String filter) {
        // 사용자가 누른 탭 값('rating_4.5', 'review_500' 등)을 DAO로 전달
        //return restaurantDao.restaurantListTopRating(filter);
        List<restaurantDTO> storeList =
                restaurantDao.restaurantListTopRating(filter);

        for (restaurantDTO restaurant : storeList) {
            double avgPoint = rvdao.reviewAvg(restaurant.getR_no());
            restaurant.setR_point(avgPoint);
        }
        return storeList;
    }
    
	 // 전체 매장 목록 
	 @GetMapping("/api/store/all")
	 @ResponseBody
	 public List<restaurantDTO> getStoresAll() {
	    //return restaurantDao.restaurantListAll();
		// 전체 식당 목록 조회
		List<restaurantDTO> storeList =
		        restaurantDao.restaurantListAll();

		// 각 식당의 리뷰 평균을 r_point에 적용
		for (restaurantDTO restaurant : storeList) {
		    double avgPoint = rvdao.reviewAvg(restaurant.getR_no());
		    restaurant.setR_point(avgPoint);
		}
		return storeList;	 
	 }
	
	//메인페이지 실행 컨트롤러
	@RequestMapping("/main")
    public String main(
            @RequestParam(value = "page", defaultValue = "1") int page,
            Model model,
            Principal principal) {

        int pageSize = 20;
        int start = (page - 1) * pageSize;

        // 현재 페이지 식당 목록
        List<restaurantDTO> restaurantList = restaurantDao.mainrestaurantList(start, pageSize);
        
        // 평점 평균
        for (restaurantDTO restaurant : restaurantList) {
            double avgPoint = rvdao.reviewAvg(restaurant.getR_no());
            restaurant.setR_point(avgPoint);
        }
        
        int count = restaurantDao.restaurantCount();
        int totalPage = (int) Math.ceil((double) count / pageSize);

        // 페이지 번호 5개씩
        int pageBlock = 5;

        int startPage = ((page - 1) / pageBlock) * pageBlock + 1;

        int endPage = startPage + pageBlock - 1;

        if (endPage > totalPage) {endPage = totalPage;}

        model.addAttribute("restaurantList", restaurantList);
        model.addAttribute("categoryList", restaurantDao.foodcategoryList());
        model.addAttribute("regionList", restaurantDao.regionList());

        model.addAttribute("page", page);
        model.addAttribute("totalPage", totalPage);
        model.addAttribute("startPage", startPage);
        model.addAttribute("endPage", endPage);

        // 인기검색어 TOP 5
        List<mukjaSearchDTO> popularSearchList = mukjaSearchDao.popularSearchList();
        model.addAttribute("popularSearchList",popularSearchList);

        if (principal != null) {
            usersDTO user = usersDao.findById(principal.getName());
            model.addAttribute("user", user);
        }

        return "main";
    }
	
	// 카테고리 페이지 이동
	@GetMapping("/category")
	public String storeCategory(
	        @RequestParam(value = "cate", defaultValue = "0") String cateParam,
	        @RequestParam(value = "sort", defaultValue = "default") String sort,
	        @RequestParam(value = "page", defaultValue = "1") int page,
	        Model model) {

	    // 1. 카테고리 번호 예외 처리 ("all" -> 0 변환)
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

	    // 2. DB 기본 조회 (기본순: r_no 내림차순)
	    if (mukja_c_no == 0) {
	        storeList = restaurantDao.mainrestaurantList(start, pageSize);
	        totalCount = restaurantDao.restaurantCount();
	    } else {
	        storeList = restaurantDao.restaurantListCategory(mukja_c_no, sort, start, pageSize);
	        totalCount = restaurantDao.restaurantCountCategory(mukja_c_no);
	    }
	    
	    // 평점 평균
	    for (restaurantDTO restaurant : storeList) {
	        double avgPoint = rvdao.reviewAvg(restaurant.getR_no());
	        restaurant.setR_point(avgPoint);
	    }
	    
		// 3. 평점 높은순(sort=rating) 정렬 로직
		    if ("rating".equals(sort) && storeList != null) {
		        storeList.sort((r1, r2) -> {
		            double p1 = r1.getR_point();
		            double p2 = r2.getR_point();
		            return Double.compare(p2, p1); // 평점 높은 순(내림차순)
		        });
		    }

	    int totalPage = (int) Math.ceil((double) totalCount / pageSize);

	    // 4. 카테고리 타이틀 명칭 매핑
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

	    // 5. Model 데이터 저장
	    model.addAttribute("storeList", storeList);
	    model.addAttribute("totalCount", totalCount);
	    model.addAttribute("selectedCate", mukja_c_no);
	    model.addAttribute("selectedCategory", categoryName);
	    model.addAttribute("sort", sort);
	    model.addAttribute("page", page);
	    model.addAttribute("totalPage", totalPage);

	    return "category";
	}
	
	// 🍽️ 식당 상세 페이지 이동 
		@GetMapping({"/restaurant/restaurantDetail", "/store/detail"})
		public String storeDetail(@RequestParam("r_no") int r_no, Model model) {
			
			// 1) 식당 기본 정보 조회 (r_no 기준)
			restaurantDTO store = restaurantDao.restaurantDetail(r_no);
			
			// restaurantDetail.jsp의 변수명(${dto}, ${restaurant}, ${store}) 모두 대응
			model.addAttribute("dto", store);
			model.addAttribute("restaurant", store);
			model.addAttribute("store", store);

			// 2) 해당 식당 메뉴 목록
			List<menuDTO> menuList = restaurantDao.menuList(r_no);
			model.addAttribute("menuList", menuList);

			// 3) 메뉴판 이미지 목록
			List<restaurantDTO> menuBoardImageList = restaurantDao.menuBoardImageList(r_no);
			model.addAttribute("menuBoardImageList", menuBoardImageList);

			return "redirect:/restaurant/detail?r_no=" + r_no;
		}
		
		 //  visual_dashboard 실행 컨트롤러
        @GetMapping("/admin/visual/dashboard")
        public String visualDashboard() {
           
            return "admin/visual_dashboard"; 
        }
	

}

package com.springboot.MUKJA.controller;

import java.security.Principal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.springboot.MUKJA.dao.bookmarkDAO;
import com.springboot.MUKJA.dao.mukjaSearchDAO;
import com.springboot.MUKJA.dao.restaurantDAO;
import com.springboot.MUKJA.dao.reviewDAO;
import com.springboot.MUKJA.dao.usersDAO;
import com.springboot.MUKJA.dto.bookmarkDTO;
import com.springboot.MUKJA.dto.menuDTO;
import com.springboot.MUKJA.dto.mukjaSearchDTO;
import com.springboot.MUKJA.dto.restaurantDTO;
import com.springboot.MUKJA.dto.usersDTO;
import com.springboot.MUKJA.service.RestaurantESService;
import com.springboot.MUKJA.service.RestaurantService;
import com.springboot.MUKJA.service.reviewService;

@Controller
public class restaurantController {
	@Autowired
	private restaurantDAO restaurantdao;
	
	@Autowired
    private RestaurantESService service;
	
	@Autowired
	private usersDAO usersdao;
	
	@Autowired
	private reviewDAO reviewdao;
	
	@Autowired
	private RestaurantService restaurantService;
	
	@Autowired
	private reviewService rvService;
	
	@Autowired
	private mukjaSearchDAO searchdao;
	
	@Autowired
	private bookmarkDAO bkdao;
	
	@Autowired
	private mukjaSearchDAO mukjaSearchdao;
	
	@RequestMapping("/restaurant/es/index")
	public String restaurantESIndex() throws Exception {

	    List<restaurantDTO> list = restaurantdao.restaurantESList();
	    for (restaurantDTO dto : list) {
	        service.save(dto);
	    }

	    return "redirect:/main";
	}
	
    // Elasticsearch 식당 검색
	@RequestMapping("/restaurant/search")
	public String restaurantSearch(@RequestParam(value = "keyword",required = false) String keyword,
	        						Model model) throws Exception {
		
	    if (keyword == null || keyword.trim().isEmpty()) {
	        return "redirect:/main";
	    }
	    
		// 검색로그 저장
	    mukjaSearchDTO searchDTO = new mukjaSearchDTO();
	    searchDTO.setMs_word(keyword);
	    searchdao.searchLogInsert(searchDTO);
	    service.saveSearchLog(searchDTO);
	    
	    // Elasticsearch에도 검색로그 저장
	    service.saveSearchLog(searchDTO);
	    
	    // Elasticsearch 검색
	    List<restaurantDTO> restaurantList = service.search(keyword);
	    
	    for (restaurantDTO restaurant : restaurantList) {
	        int reviewCount = reviewdao.reviewCount(restaurant.getR_no());
	        double reviewAvg = reviewdao.reviewAvg(restaurant.getR_no());

	        restaurant.setReviewCount(reviewCount);
	        restaurant.setReviewAvg(reviewAvg);
	    }

	    model.addAttribute("restaurantList", restaurantList);
	    model.addAttribute("keyword", keyword);
	    model.addAttribute("categoryList", restaurantdao.foodcategoryList());
	    model.addAttribute("regionList", restaurantdao.regionList());

	    return "restaurant/restaurantList";
	}
	
	
	@RequestMapping("/admin/restaurantList")
	public String adminRestaurantList(
	        @RequestParam(value = "page", defaultValue = "1") int page,
	        Model model) throws Exception {

	    // 한 페이지에 식당 20개
	    int pageSize = 20;

	    int start = (page - 1) * pageSize;

	    // 전체 식당 수
	    int totalCount = restaurantdao.restaurantCount();

	    // 전체 페이지 수
	    int totalPage = (int) Math.ceil((double) totalCount / pageSize);

	    // 페이지 번호는 10개씩
	    int pageBlock = 10;

	    // 현재 페이지가 속한 시작 페이지
	    int startPage = ((page - 1) / pageBlock) * pageBlock + 1;

	    // 끝 페이지
	    int endPage = Math.min(startPage + pageBlock - 1, totalPage);

	    // 식당 목록
	    List<restaurantDTO> restaurantList = restaurantdao.adminRestaurantList(start, pageSize);

	    for (restaurantDTO restaurant : restaurantList) {

	        // 영업시간 + 휴무일
	        restaurantService.setRestaurantListTime(restaurant);
	        // 리뷰
	        int reviewCount = reviewdao.reviewCount(restaurant.getR_no());

	        double reviewAvg =
	                reviewdao.reviewAvg(restaurant.getR_no());

	        restaurant.setReviewCount(reviewCount);
	        restaurant.setReviewAvg(reviewAvg);
	    }
	    model.addAttribute("restaurantList", restaurantList);
	    model.addAttribute("page", page);
	    model.addAttribute("totalPage", totalPage);

	    // 10개 단위 페이징
	    model.addAttribute("startPage", startPage);
	    model.addAttribute("endPage", endPage);

	    return "admin/adminRestaurantList";
	}
	
	  	// 음식종류별 식당 목록
	    @RequestMapping("/restaurant/category")
	    public String restaurantListCategory(
	            @RequestParam("mukja_c_no") int mukja_c_no,
	            @RequestParam(value = "page", defaultValue = "1") int page,
	            @RequestParam(value = "sort", defaultValue = "1") String sort,
	            Principal principal, Model model) {

	        int pageSize = 20;
	        int start = (page - 1) * pageSize;

	        List<restaurantDTO> restaurantList
	            = restaurantdao.restaurantListCategory(mukja_c_no,sort,start,pageSize);

	        int count = restaurantdao.restaurantCountCategory(mukja_c_no);
	        int totalPage = (int) Math.ceil((double) count / pageSize);

	        model.addAttribute("restaurantList", restaurantList);
	        model.addAttribute("categoryList", restaurantdao.foodcategoryList());
	        model.addAttribute("regionList", restaurantdao.regionList());

	        model.addAttribute("mukja_c_no", mukja_c_no);
	        model.addAttribute("page", page);
	        model.addAttribute("totalPage", totalPage);
	        model.addAttribute("count", count);
	        
	        if (principal != null) {
	            usersDTO user =
	                    usersdao.findById(principal.getName());

	            model.addAttribute("user", user);
	        }

	        return "main";
	    }
	    
	    
	    // 지역별 식당 목록
	    @RequestMapping("/restaurant/region")
	    public String restaurantListRegion(
	            @RequestParam("r_region") String r_region,
	            @RequestParam(value = "page", defaultValue = "1") int page,
	            Principal principal, Model model) {

	        int pageSize = 20;
	        int start = (page - 1) * pageSize;

	        List<restaurantDTO> restaurantList = restaurantdao.restaurantListRegion(r_region,start,pageSize);

	        int count = restaurantdao.restaurantCountRegion(r_region);
	        int totalPage = (int) Math.ceil((double) count / pageSize);

	        model.addAttribute("restaurantList", restaurantList);
	        model.addAttribute("categoryList", restaurantdao.foodcategoryList());
	        model.addAttribute("regionList", restaurantdao.regionList());
	        model.addAttribute("r_region", r_region);
	        model.addAttribute("page", page);
	        model.addAttribute("totalPage", totalPage);
	        model.addAttribute("count", count);

	        if (principal != null) {
	            usersDTO user =
	                    usersdao.findById(principal.getName());

	            model.addAttribute("user", user);
	        }

	        return "main";
	    }
	    
	    // 식당 하나 선택했을때 상세
	    @RequestMapping("/restaurant/detail")
	    public String restaurantDetail(
	            @RequestParam("r_no") int r_no,
	            Model model,
	            @RequestParam(value="keyword", required=false) String keyword,
	            Authentication auth) {

	        restaurantDTO restaurant = restaurantdao.restaurantDetail(r_no);

	        if (restaurant == null) {
	            return "redirect:/main";
	        }

	        List<menuDTO> menuList = restaurantdao.menuList(r_no);
	        List<restaurantDTO> menuBoardImageList = restaurantdao.menuBoardImageList(r_no);

	        restaurant.setDisplay_time(
	            restaurantService.formatRestaurantDetailTime(
	                restaurant.getR_time()
	            )
	        );

	        restaurant.setToday_time(
	            restaurantService.getTodayRestaurantTime(
	                restaurant.getR_time()
	            )
	        );

	        int reviewCount = reviewdao.reviewCount(r_no);
	        double reviewAvg = reviewdao.reviewAvg(r_no);

	        int bookmarkCheck = 0;

	        if (auth != null &&
	            auth.isAuthenticated() &&
	            !"anonymousUser".equals(auth.getName())) {

	            usersDTO users = usersdao.findById(auth.getName());

	            bookmarkDTO bkdto = new bookmarkDTO();
	            bkdto.setR_no(r_no);
	            bkdto.setU_no(users.getU_no());

	            bookmarkCheck = bkdao.bookmarkCheck(bkdto);
	        }

	        model.addAttribute("bookmarkCheck", bookmarkCheck);

	        List<LocalDate> dateList = new ArrayList<>();
	        LocalDate today = LocalDate.now();

	        for (int i = 0; i < 7; i++) {
	            dateList.add(today.plusDays(i));
	        }
	        model.addAttribute("restaurant", restaurant);
	        model.addAttribute("keyword", keyword);
	        model.addAttribute("reviewCount", reviewCount);
	        model.addAttribute("reviewAvg", reviewAvg);
	        model.addAttribute("dateList", dateList);
	        model.addAttribute("rvPList", rvService.reviewPList(r_no));
	        model.addAttribute("menuList", menuList);
	        model.addAttribute("menuBoardImageList", menuBoardImageList);

	        return "restaurant/restaurantDetail";
	    }
	    
	 @RequestMapping("/restaurant/restaurantWriteForm")
	 public String restaurantWriteForm(Model model) {
		 
		// 점주, 관리자가 음식종류 선택할 수 있도록
	     model.addAttribute("categoryList", restaurantdao.foodcategoryList());

	     return "restaurant/restaurantWriteForm";
	 }
	 
	// 식당 등록 처리
	 @RequestMapping("/restaurant/insert")
	 public String restaurantInsert(
	         restaurantDTO dto,
	         @RequestParam(value = "r_upload", required = false) MultipartFile file,
	         @RequestParam(value = "mn_name", required = false) List<String> mnNameList,
	         @RequestParam(value = "mn_content", required = false) List<String> mnContentList,
	         @RequestParam(value = "mn_price", required = false) List<Integer> mnPriceList,
	         @RequestParam(value = "mn_upload", required = false) List<MultipartFile> mnUploadList,
	         @RequestParam(value = "mbi_upload", required = false) List<MultipartFile> mbiUploadList,
	         @RequestParam(value = "delete_mn_no", required = false) List<Integer> deleteMnNoList,
	         Principal principal) throws Exception {

	     System.out.println("===== 식당 등록 Controller 진입 =====");
	     System.out.println("principal = " + principal);

	     if (principal != null) {
	         System.out.println("로그인 아이디 = " + principal.getName());
	     }

	     restaurantService.insertRestaurant(
	         dto,
	         file,
	         mnNameList,
	         mnContentList,
	         mnPriceList,
	         mnUploadList,
	         mbiUploadList,
	         principal.getName()
	     );

	     return "redirect:/main";
	 }
	 
	// 식당 수정 폼
	 @RequestMapping("/restaurant/updateForm")
	 public String restaurantUpdateForm(
	         @RequestParam("r_no") int r_no,
	         Model model,
	         Principal principal) {

	     usersDTO user = usersdao.findById(principal.getName());

	     // 본인 식당이 아니면 접근 불가
	     if (user.getR_no() != r_no) {
	         return "redirect:/main";
	     }

	     restaurantDTO restaurant =
	             restaurantdao.restaurantDetail(r_no);

	     List<menuDTO> menuList =
	             restaurantdao.menuList(r_no);

	     List<restaurantDTO> menuBoardImageList =
	             restaurantdao.menuBoardImageList(r_no);

	     model.addAttribute("restaurant", restaurant);
	     model.addAttribute(
	             "categoryList",
	             restaurantdao.foodcategoryList()
	     );
	     model.addAttribute("menuList", menuList);
	     model.addAttribute(
	             "menuBoardImageList",
	             menuBoardImageList
	     );

	     return "restaurant/restaurantUpdateForm";
	 }

	 
	// 식당 수정 처리
	 @RequestMapping("/restaurant/update")
	 public String restaurantUpdate(@ModelAttribute("updateDto") restaurantDTO dto,
	         @RequestParam("old_r_img") String old_r_img,
	         @RequestParam(value = "r_upload", required = false) MultipartFile file,
	         @RequestParam(value = "mn_no", required = false) List<String> mnNoList,
	         @RequestParam(value = "mn_name", required = false) List<String> mnNameList,
	         @RequestParam(value = "mn_content", required = false) List<String> mnContentList,
	         @RequestParam(value = "mn_price", required = false) List<String> mnPriceList,
	         @RequestParam( value = "old_mn_img", required = false) List<String> oldMnImgList,
	         @RequestParam( value = "mn_upload", required = false)List<MultipartFile> mnUploadList,
	         @RequestParam( value = "mbi_upload", required = false) List<MultipartFile> mbiUploadList,
	         @RequestParam( value = "delete_mbi_no", required = false) List<Integer> deleteMbiNoList,
	         @RequestParam(value = "delete_mn_no", required = false) List<Integer> deleteMnNoList,
	         Principal principal) throws Exception {

	     usersDTO user = usersdao.findById(principal.getName());

	     // 본인 식당만 수정 가능
	     if (user.getR_no() != dto.getR_no()) {
	         return "redirect:/main";
	     }

	     restaurantService.updateRestaurant(dto, old_r_img, file, mnNoList, mnNameList, mnContentList,
	             mnPriceList, oldMnImgList, mnUploadList, deleteMbiNoList, mbiUploadList, deleteMnNoList
	     );

	     return "redirect:/restaurant/detail?r_no=" + dto.getR_no();
	 }
	 
	 @RequestMapping("/restaurant/delete")
	 public String restaurantDelete(
	         @RequestParam("r_no") int r_no,
	         @RequestParam(value="keyword" , required = false) String keyword,
	         RedirectAttributes redirectAttributes) throws Exception {
		 
		 usersdao.deleteR_no(r_no);
	     restaurantdao.restaurantDelete(r_no);
	     service.delete(r_no);

	     redirectAttributes.addAttribute("keyword", keyword);

	     return "redirect:/restaurant/search";
	 }
	 
	 @InitBinder("updateDto")
	 public void initUpdateBinder(WebDataBinder binder) {
	     binder.setDisallowedFields(
	         "mn_no",
	         "mn_name",
	         "mn_content",
	         "mn_price",
	         "mn_img",
	         "mbi_no",
	         "mbi_img"
	     );
	 }
	 
	 @RequestMapping("/restaurant/ownerpage")
	 public String ownerPage(Principal principal, Model model) {

	     usersDTO user = usersdao.findById(principal.getName());
	     model.addAttribute("user", user);
	     
	     List<mukjaSearchDTO> popularSearchList =
	    	        mukjaSearchdao.popularSearchList();

	    	model.addAttribute("popularSearchList", popularSearchList);

	     return "restaurant/ownerpage";
	 }
	 
	 @ResponseBody
	 @RequestMapping("/autocomplete")
	 public List<Map<String, String>> autocomplete(
	         @RequestParam("keyword") String keyword)
	         throws Exception {

	     return service.autocompleteHighlight(keyword);
	 }
	 
}

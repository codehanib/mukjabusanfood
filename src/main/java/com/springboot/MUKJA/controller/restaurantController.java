package com.springboot.MUKJA.controller;

import java.io.File;
import java.security.Principal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.springboot.MUKJA.dao.mukjaSearchDAO;
import com.springboot.MUKJA.dao.restaurantDAO;
import com.springboot.MUKJA.dao.reviewDAO;
import com.springboot.MUKJA.dao.usersDAO;
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
	public String restaurantSearch(@RequestParam("keyword") String keyword,
	        						Model model) throws Exception {
		
		// 검색로그 저장
	    mukjaSearchDTO searchDTO = new mukjaSearchDTO();
	    searchDTO.setMs_word(keyword);
	    searchdao.searchLogInsert(searchDTO);
	    
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
	
	  	// 음식종류별 식당 목록
	    @RequestMapping("/restaurant/category")
	    public String restaurantListCategory(
	            @RequestParam("mukja_c_no") int mukja_c_no,
	            @RequestParam(value = "page", defaultValue = "1") int page,
	            Principal principal, Model model) {

	        int pageSize = 20;
	        int start = (page - 1) * pageSize;

	        List<restaurantDTO> restaurantList
	            = restaurantdao.restaurantListCategory(mukja_c_no,start,pageSize);

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
	    public String restaurantDetail(@RequestParam("r_no") int r_no, Model model) {

	        restaurantDTO restaurant = restaurantdao.restaurantDetail(r_no);
	        
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

	        List<LocalDate> dateList = new ArrayList<>();
	        LocalDate today = LocalDate.now();

	        for (int i = 0; i < 7; i++) {
	            dateList.add(today.plusDays(i));
	        }

	        model.addAttribute("restaurant", restaurant);
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
	         Principal principal) throws Exception {

	     if (file != null && !file.isEmpty()) {

	         String fileName = file.getOriginalFilename();

	         File saveFile = new File("C:/upload/" + fileName);

	         file.transferTo(saveFile);

	         dto.setR_img(fileName);
	     }

	     // DB 저장
	     restaurantdao.restaurantInsert(dto);

	     // OWNER와 식당 연결
	     usersDTO user = usersdao.findById(principal.getName());

	     user.setR_no(dto.getR_no());

	     usersdao.usersRestaurantUpdate(user);

	     // DB에서 다시 조회
	     restaurantDTO savedRestaurant =
	             restaurantdao.restaurantDetail(dto.getR_no());

	     // Elasticsearch 저장
	     service.save(savedRestaurant);

	     return "redirect:/main";
	 }
	
	 
	// 식당 수정 폼
	 @RequestMapping("/restaurant/updateForm")
	 public String restaurantUpdateForm(@RequestParam("r_no") int r_no,Model model,Principal principal, Authentication authentication) {

	     usersDTO user = usersdao.findById(principal.getName());

	     boolean isAdmin = authentication.getAuthorities()
	    		 .stream()
	    		 .anyMatch(auth -> auth.getAuthority()
	    		 .equals("ROLE_ADMIN"));

	     // 관리자가 아니면서 자기 식당도 아니면 접근 차단
	     if (!isAdmin && user.getR_no() != r_no) {return "redirect:/main";}

	     restaurantDTO restaurant = restaurantdao.restaurantDetail(r_no);

	     model.addAttribute("restaurant", restaurant);
	     model.addAttribute("categoryList", restaurantdao.foodcategoryList());

	     return "restaurant/restaurantUpdateForm";
	 }

	 
	// 식당 수정 처리
	 @RequestMapping("/restaurant/update")
	 public String restaurantUpdate(
	         restaurantDTO dto,
	         @RequestParam("old_r_img") String old_r_img,
	         @RequestParam(value = "r_upload", required = false) MultipartFile file,
	         Principal principal,
	         Authentication authentication) throws Exception {

	     usersDTO user = usersdao.findById(principal.getName());

	     boolean isAdmin = authentication.getAuthorities()
	             .stream()
	             .anyMatch(auth ->auth.getAuthority().equals("ROLE_ADMIN"));

	     if (!isAdmin && user.getR_no() != dto.getR_no()) {
	         return "redirect:/main";
	     }

	     // 새 사진을 등록한 경우
	     if (file != null && !file.isEmpty()) {
	         String fileName = file.getOriginalFilename();

	         File saveFile = new File("C:/upload/" + fileName);
	         file.transferTo(saveFile);

	         dto.setR_img(fileName);
	     } else {
	    	 
	         // 사진을 안 넣은 경우 기존 사진 유지
	         dto.setR_img(old_r_img);
	     }

	     restaurantdao.restaurantUpdate(dto);

	  // 수정된 식당 다시 조회
	  restaurantDTO updatedRestaurant =
	          restaurantdao.restaurantDetail(dto.getR_no());

	  // Elasticsearch도 갱신
	  service.save(updatedRestaurant);

	  return "redirect:/restaurant/detail?r_no=" + dto.getR_no();
	 }
	 
	 
	 @RequestMapping("/restaurant/delete")
	 public String restaurantDelete(@RequestParam("r_no") int r_no,
			 						@RequestParam("keyword") String keyword) throws Exception  {

	     restaurantdao.restaurantDelete(r_no);
	     service.delete(r_no);
	     
	     return "redirect:/restaurant/search?keyword=" + keyword;
	 }
	 
	 
}

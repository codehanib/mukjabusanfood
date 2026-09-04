package com.springboot.MUKJA.controller;

import java.security.Principal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.springboot.MUKJA.dao.restaurantDAO;
import com.springboot.MUKJA.dao.usersDAO;
import com.springboot.MUKJA.dto.restaurantDTO;
import com.springboot.MUKJA.dto.usersDTO;
import com.springboot.MUKJA.dao.reviewDAO;
import com.springboot.MUKJA.service.RestaurantESService;

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
	
    // Elasticsearch 식당 검색
	 @RequestMapping("/restaurant/search")
	    public String restaurantSearch(@RequestParam("keyword") String keyword, Model model) throws Exception {

	        List<restaurantDTO> list = service.search(keyword);
	        model.addAttribute("list", list);
	        model.addAttribute("keyword", keyword);

	        return "restaurant/restaurantESList";
	    }
	
//	// 메인 화면 식당 목록 조회
//  @RequestMapping("/main")
//	public String main(Model model) {
//
//	    int start = 0;
//	    int pageSize = 20;
//
//	    List<restaurantDTO> restaurantList = restaurantdao.mainrestaurantList(start, pageSize);
//
//	    model.addAttribute("restaurantList", restaurantList);
//
//	    return "main";
//	}
	
	  	// 음식종류별 식당 목록
	    @RequestMapping("/restaurant/category")
	    public String restaurantListCategory(
	            @RequestParam("mukja_c_no") int mukja_c_no,
	            @RequestParam(value = "page", defaultValue = "1") int page,
	            Model model) {

	        int pageSize = 20;
	        int start = (page - 1) * pageSize;

	        List<restaurantDTO> restaurantList
	            = restaurantdao.restaurantListCategory(
	                    mukja_c_no,
	                    start,
	                    pageSize
	            );

	        int count
	            = restaurantdao.restaurantCountCategory(mukja_c_no);

	        int totalPage
	            = (int) Math.ceil((double) count / pageSize);

	        model.addAttribute("restaurantList", restaurantList);
	        model.addAttribute("categoryList", restaurantdao.foodcategoryList());

	        model.addAttribute("mukja_c_no", mukja_c_no);
	        model.addAttribute("page", page);
	        model.addAttribute("totalPage", totalPage);
	        model.addAttribute("count", count);

	        return "restaurant/restaurantList";
	    }
	 
	    
	    @RequestMapping("/restaurant/detail")
	    public String restaurantDetail(@RequestParam("r_no") int r_no, Model model) {

	        restaurantDTO restaurant = restaurantdao.restaurantDetail(r_no);

	        int reviewCount = reviewdao.reviewCount(r_no);

	        // 오늘부터 7일
	        List<LocalDate> dateList = new ArrayList<>();

	        LocalDate today = LocalDate.now();

	        for (int i = 0; i < 7; i++) {
	            dateList.add(today.plusDays(i));
	        }

	        model.addAttribute("restaurant", restaurant);
	        model.addAttribute("reviewCount", reviewCount);
	        model.addAttribute("dateList", dateList);

	        return "restaurant/restaurantDetail";
	    }
	    
	 @RequestMapping("/restaurant/restaurantWriteForm")
	 public String restaurantWriteForm(Model model) {
		 
		// 점주, 관리자가 음식종류 선택할 수 있도록
	     model.addAttribute("categoryList", restaurantdao.foodcategoryList());

	     return "restaurant/restaurantWriteForm";
	 }
	 
	// 식당 등록 처리
	 @RequestMapping("/restaurant/Insert")
	 public String restaurantInsert(restaurantDTO dto) {

	     restaurantdao.restaurantInsert(dto);

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

	     restaurantDTO restaurant =
	             restaurantdao.restaurantDetail(r_no);

	     model.addAttribute("restaurant", restaurant);
	     model.addAttribute("categoryList", restaurantdao.foodcategoryList());

	     return "restaurant/restaurantUpdateForm";
	 }

	 
	// 식당 수정 처리
	 @RequestMapping("/restaurant/update")
	 public String restaurantUpdate( restaurantDTO dto, Principal principal, Authentication authentication) {

	     usersDTO user = usersdao.findById(principal.getName());

	     boolean isAdmin = authentication.getAuthorities() 
	    		 .stream()
	    		 .anyMatch(auth ->auth.getAuthority()
	    				 .equals("ROLE_ADMIN"));

	     // OWNER는 자기 식당만 수정 가능
	     if (!isAdmin && user.getR_no() != dto.getR_no()) {return "redirect:/main";}

	     restaurantdao.restaurantUpdate(dto);

	     return "redirect:/restaurant/detail?r_no="+ dto.getR_no();
	 }
	 
	 
	 @RequestMapping("/restaurant/delete")
	 public String restaurantDelete(@RequestParam("r_no") int r_no) {

	     restaurantdao.restaurantDelete(r_no);

	     return "redirect:/main";
	 }
	 
	 
}

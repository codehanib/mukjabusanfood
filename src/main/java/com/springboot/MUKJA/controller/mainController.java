package com.springboot.MUKJA.controller;

import java.security.Principal;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.springboot.MUKJA.dao.mukjaSearchDAO;
import com.springboot.MUKJA.dao.restaurantDAO;
import com.springboot.MUKJA.dao.usersDAO;
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

	@GetMapping("/")
	public String index() {
		return "redirect:/main";
	}
	
	@RequestMapping("/main")
    public String main(
            @RequestParam(value = "page", defaultValue = "1") int page,
            Model model,
            Principal principal) {

        int pageSize = 20;
        int start = (page - 1) * pageSize;

        // 현재 페이지 식당 목록
        List<restaurantDTO> restaurantList = restaurantDao.mainrestaurantList(start, pageSize);

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
	
	@GetMapping("/category")
	public String storeCategory(
	        @RequestParam(value = "mukja_c_no", defaultValue = "1") int mukja_c_no,
	        @RequestParam(value = "page", defaultValue = "1") int page,
	        Model model) {

	    int pageSize = 20;
	    int start = (page - 1) * pageSize;

	    // 1. 해당 카테고리의 매장 목록 조회
	    List<restaurantDTO> storeList = restaurantDao.restaurantListCategory(mukja_c_no, start, pageSize);

	    // 2. 해당 카테고리의 전체 매장 개수 및 페이징 계산
	    int totalCount = restaurantDao.restaurantCountCategory(mukja_c_no);
	    int totalPage = (int) Math.ceil((double) totalCount / pageSize);

	    model.addAttribute("storeList", storeList);
	    model.addAttribute("mukja_c_no", mukja_c_no);
	    model.addAttribute("page", page);
	    model.addAttribute("totalPage", totalPage);

	    return "category";
	}
}

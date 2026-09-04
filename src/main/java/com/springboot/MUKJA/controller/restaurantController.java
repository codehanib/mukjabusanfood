package com.springboot.MUKJA.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.springboot.MUKJA.dao.restaurantDAO;

@Controller
public class restaurantController {
	@Autowired
	private restaurantDAO restaurantdao;
	
	// 가게 전체 목록 조회
	@RequestMapping("/restaurant/list")
	public String restaurantList(
	        @RequestParam(value = "page", defaultValue = "1") int page,
	        @RequestParam(value = "mukja_c_no", required = false) Integer mukja_c_no,
	        @RequestParam(value = "sort", defaultValue = "pno") String sort,
	        Model model){
		
		// 한 페이지에 보여줄 가게 수
	int pageSize = 20;
	
	return "restaurant/restaurantList";
	}
}

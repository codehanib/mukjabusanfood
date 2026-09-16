package com.springboot.MUKJA.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.springboot.MUKJA.dao.noticeDAO;
import com.springboot.MUKJA.dao.restaurantDAO;
import com.springboot.MUKJA.dto.noticeDTO;
import com.springboot.MUKJA.dto.restaurantDTO;

@Controller
public class clickbuttonController {
	@Autowired
	private restaurantDAO rdao;
	
	@Autowired
	private noticeDAO ntdao;
	
	@RequestMapping("/clickbuttons")
	@ResponseBody
	public List<restaurantDTO> getRestaurants(
	        								@RequestParam("mukja_c_no") int mukja_c_no) {
	    return rdao.restaurantListCategory(
	            mukja_c_no,
	            "rating",
	            0,
	            5
	    );
	}
	
	// 공지사항
    @RequestMapping("/clickbuttons/notices")
    @ResponseBody
    public List<noticeDTO> getNotices() {
        return ntdao.noticeList();
    }
	
}

package com.springboot.MUKJA.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.springboot.MUKJA.dao.bookmarkDAO;
import com.springboot.MUKJA.dao.usersDAO;
import com.springboot.MUKJA.dto.bookmarkDTO;
import com.springboot.MUKJA.dto.usersDTO;

@Controller
public class bookmarkController {
	@Autowired
	private bookmarkDAO bkdao;
	@Autowired
	private usersDAO udao;
	
	// 북마크 목록 조회
	@RequestMapping("/users/bookmarkList")
	public String bookmarkList(Authentication auth,Model model) {
		String u_id = auth.getName();
		usersDTO users = udao.findById(u_id);
		int u_no = users.getU_no();
		
		List<bookmarkDTO> bookmarklist = bkdao.bookmarkList(u_no);
		
		model.addAttribute("bklist",bookmarklist);
		
		return "users/bookmarkList";
	}
	
	// 북마크 등록
	@RequestMapping("/users/bookmarkInsert")
	public String bookmarkInsert(Authentication auth,
								 @RequestParam("r_no") int r_no) {
		String u_id = auth.getName();
		usersDTO users = udao.findById(u_id);
		int u_no = users.getU_no();
		
		bookmarkDTO bkdto = new bookmarkDTO();
		
		bkdto.setR_no(r_no);
		bkdto.setU_no(u_no);
		
		bkdao.bookmarkInsert(bkdto);
		
		return "redirect:/users/bookmarkList";
	}
	
	// 북마크 삭제
	@RequestMapping("/users/bookmarkDelete")
	public String bookmarkDelete(@RequestParam("bk_no") int bk_no) {
		
		bkdao.bookmarkDelete(bk_no);
		
		return "redirect:/users/bookmarkList";
	}
	
}

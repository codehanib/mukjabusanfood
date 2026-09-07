package com.springboot.MUKJA.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.springboot.MUKJA.dao.noticeDAO;
import com.springboot.MUKJA.dao.usersDAO;
import com.springboot.MUKJA.dto.noticeDTO;
import com.springboot.MUKJA.dto.usersDTO;

@Controller
public class noticeController {
	@Autowired
	private usersDAO udao;
	
	@Autowired
	private noticeDAO ntdao;
	
	// 공지 목록 보기
	// 공지 상세 보기
	
	// 공지 작성폼으로
	@RequestMapping("/admin/noticeWrite")
	public String noticeWriteForm() {

		return "admin/noticeWriteForm";
	}
	
	// 공지 작성 insert
	@RequestMapping("/admin/noticeInsert")
	public String noticeInsert(Authentication auth,noticeDTO ntdto) {
		String u_id = auth.getName();
		usersDTO users = udao.findById(u_id);
		int u_no = users.getU_no();
		
		ntdto.setU_no(u_no);
		ntdao.noticeInsert(ntdto);
		
		return "redirect:/noticeList";
	}
	
	// 공지 업데이트폼으로
	
	// 공지 업데이트 update
	
	
	// 공지 삭제
	@RequestMapping("/admin/noticeDelete")
	public String noticeDelete(@RequestParam("nt_no")int nt_no) {
		
		ntdao.noticeDelete(nt_no);
		return "redirect:/noticeList";
	}
}

package com.springboot.MUKJA.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.springboot.MUKJA.dao.inquiryDAO;
import com.springboot.MUKJA.dao.usersDAO;
import com.springboot.MUKJA.dto.inquiryDTO;

@Controller
public class inquiryController {
	@Autowired
	private inquiryDAO idao;
	@Autowired
	private usersDAO udao;
	
	// 문의 목록 조회 (10개씩 페이징)
	@RequestMapping("/users/inquiryList")
	public String inquiryList(@RequestParam(defaultValue="1") int page,
								Model model) {
		int offset = (page-1) * 10;
		List<inquiryDTO> inquirylist = idao.inquiryList(offset);
		int count = idao.inquiryCount();
		
		model.addAttribute("ilist",inquirylist);
		model.addAttribute("count",count);
		model.addAttribute("page",page);
		return "users/inquiryList";
	}
	
	// 문의 내용 조회
	@RequestMapping("/users/inquiryView")
	public String inquiryView(@RequestParam("mi_no") int mi_no,
							   Model model) {
		inquiryDTO inquiryview = idao.inquiryView(mi_no);
		model.addAttribute("iview",inquiryview);
		
		return "users/inquiryView";
	}
	
	// 문의 작성폼
	@RequestMapping("/users/inquiryWriteForm")
	public String inquiryWriteForm() {
		
		return "users/inquiryWriteForm";
	}
	
	// 문의 작성
	@RequestMapping("/users/inquiryInsert")
	public String inquiryInsert(Authentication auth,
								inquiryDTO idto) {
		
		return "redirect:/users/inquiryList";
	}
	
	// 문의 수정폼
	@RequestMapping("/users/inquiryUpdateForm")
	public String inquiryUpdateForm() {
		return "users/inquiryUpdateForm";
	}
	
	// 문의 수정
	@RequestMapping("/users/inquiryUpdate")
	public String inquiryUpdate(int mi_no) {
		return "redirect:/users/inquiryView?mi_no=" + mi_no;
	}
	
	// 문의 답변폼 (관리자)
	@RequestMapping("/admin/inquiryAnswerForm")
	public String inquiryAnswerForm() {
		return "admin/inquiryAnswerForm";
	}
	
	// 문의 답변 (관리자)
	@RequestMapping("/admin/inquiryAnswer")
	public String inquiryAnswer(int mi_no) {
		return "redirect:/users/inquiryView?mi_no=" + mi_no;
	}
	
	// 문의 삭제
	@RequestMapping("/users/inquiryDelete")
	public String inquiryDelete() {
		return "redirect:/users/inquiryList";
	}
}

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
import com.springboot.MUKJA.dto.usersDTO;

@Controller
public class inquiryController {
	@Autowired
	private inquiryDAO idao;
	@Autowired
	private usersDAO udao;
	
	// 문의 목록 조회 (10개씩 페이징)
	@RequestMapping("/users/inquiryList")
	public String inquiryList(@RequestParam(value="page",defaultValue="1") int page,
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
	public String inquiryView(Authentication auth,
							  @RequestParam("mi_no") int mi_no,
							   Model model) {
		String u_id = auth.getName();
		usersDTO users = udao.findById(u_id);
		int u_no = users.getU_no();
		
		boolean isAdmin = auth.getAuthorities().stream()
		        .anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN"));
		
		inquiryDTO inquiryview = idao.inquiryView(mi_no);
		
		// 자기 문의 아니면 리스트로 돌려보내기
		if (!isAdmin && inquiryview.getU_no() != u_no) {
	        return "redirect:/users/inquiryList?error=notOwner";
	    }
		
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
		String u_id = auth.getName();
		usersDTO users = udao.findById(u_id);
		int u_no = users.getU_no();
		
		idto.setU_no(u_no);
		idao.inquiryInsert(idto);
		
		return "redirect:/users/inquiryList";
	}
	
	// 문의 수정폼
	@RequestMapping("/users/inquiryUpdateForm")
	public String inquiryUpdateForm(Authentication auth,
									@RequestParam("mi_no") int mi_no,
									Model model) {
		String u_id = auth.getName();
		usersDTO users = udao.findById(u_id);
		int u_no = users.getU_no();
		
		inquiryDTO inquiryview = idao.inquiryView(mi_no);
		if (inquiryview.getU_no() != u_no) {
		    return "redirect:/users/inquiryList";
		}
		
		model.addAttribute("iview",inquiryview);
		
		return "users/inquiryUpdateForm";
	}
	
	// 문의 수정
	@RequestMapping("/users/inquiryUpdate")
	public String inquiryUpdate(inquiryDTO idto) {
		
		idao.inquiryUpdate(idto);
		
		return "redirect:/users/inquiryView?mi_no=" + idto.getMi_no();
	}
	
	// 문의 답변폼 (관리자)
	@RequestMapping("/admin/inquiryAnswerForm")
	public String inquiryAnswerForm(@RequestParam("mi_no") int mi_no,
									Model model) {
		inquiryDTO inquiryview = idao.inquiryView(mi_no);
		model.addAttribute("ianswer",inquiryview);
		
		return "admin/inquiryAnswerForm";
	}
	
	// 문의 답변 (관리자)
	@RequestMapping("/admin/inquiryAnswer")
	public String inquiryAnswer(inquiryDTO idto) {
		
		idao.inquiryAnswer(idto);
		
		return "admin/inquiryAnswerComplete";
	}
	
	// 문의 삭제
	@RequestMapping("/users/inquiryDelete")
	public String inquiryDelete(Authentication auth,
								@RequestParam("mi_no") int mi_no) {
		String u_id = auth.getName();
		usersDTO users = udao.findById(u_id);
		int u_no = users.getU_no();
		
		inquiryDTO inquiryview = idao.inquiryView(mi_no);
		
		if (inquiryview.getU_no() != u_no) {
	        return "redirect:/users/inquiryList";
	    }
		
		idao.inquiryDelete(mi_no);
		
		return "redirect:/users/inquiryList";
	}
}

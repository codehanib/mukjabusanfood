package com.springboot.MUKJA.controller;

import java.io.File;
import java.io.IOException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

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
	@RequestMapping("/noticeList")
	public String noticeList(Model model) {
		
		List<noticeDTO> noticelist = ntdao.noticeList();
		model.addAttribute("ntlist",noticelist);
		
		return "noticeList";
	}
	
	// 공지 상세 보기
	@RequestMapping("/noticeView")
	public String noticeView(Model model,@RequestParam("nt_no") int nt_no) {
		
		noticeDTO ntview = ntdao.noticeView(nt_no);
		model.addAttribute("ntview", ntview);
		
		return "noticeView";
	}
	
	// 공지 작성폼
	@RequestMapping("/admin/noticeWrite")
	public String noticeWriteForm() {

		return "admin/noticeWriteForm";
	}
	
	// 공지 작성 insert
	@RequestMapping("/admin/noticeInsert")
	public String noticeInsert(Authentication auth,noticeDTO ntdto,
							@RequestParam("ntfile") MultipartFile file) throws IOException{
		String u_id = auth.getName();
		usersDTO users = udao.findById(u_id);
		int u_no = users.getU_no();

		// 파일업로드
	    if (!file.isEmpty()) {
	        String fileName = file.getOriginalFilename();

	        File saveFile = new File("C:/upload/"+fileName);
	        file.transferTo(saveFile);

	        ntdto.setNt_img(fileName);
	    }
		ntdto.setU_no(u_no);
		ntdao.noticeInsert(ntdto);
		
		return "redirect:/noticeList";
	}
	
	// 공지 업데이트폼
	@RequestMapping("/admin/noticeUpdateForm")
	public String noticeUpdateForm(@RequestParam("nt_no")int nt_no,Model model) {
		
		noticeDTO ntupdate = ntdao.noticeView(nt_no);
		model.addAttribute("nt",ntupdate);
		
		return "admin/noticeUpdateForm";
	}
	
	// 공지 업데이트 update
	@RequestMapping("/admin/noticeUpdate")
	public String noticeUpdate(noticeDTO ntdto,
	        @RequestParam("ntfile") MultipartFile file) throws IOException{
		
		// 새 파일을 선택했을 경우
	    if (!file.isEmpty()) {
	        String fileName = file.getOriginalFilename();

	        File saveFile = new File("C:/upload/" + fileName);
	        file.transferTo(saveFile);

	        ntdto.setNt_img(fileName);
	    }

	    ntdao.noticeUpdate(ntdto);
		
		return "redirect:/noticeView?nt_no=" + ntdto.getNt_no();
	}
	
	
	// 공지 삭제
	@RequestMapping("/admin/noticeDelete")
	public String noticeDelete(@RequestParam("nt_no")int nt_no) {
		
		ntdao.noticeDelete(nt_no);
		return "redirect:/noticeList";
	}
}

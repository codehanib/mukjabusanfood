package com.springboot.MUKJA.controller;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.springboot.MUKJA.dao.reviewDAO;
import com.springboot.MUKJA.dao.usersDAO;
import com.springboot.MUKJA.dto.reviewDTO;
import com.springboot.MUKJA.dto.reviewimgDTO;
import com.springboot.MUKJA.dto.usersDTO;
import com.springboot.MUKJA.service.reviewService;

@Controller
public class reviewController {
	@Autowired
	private reviewService rvService;
	@Autowired
	private reviewDAO rvdao;
	@Autowired
	private usersDAO udao;
	
	// 리뷰 작성폼으로 가기 수정필요
	@RequestMapping("/rev")
	public String reviewWriteForm(Authentication auth) {
		String u_id = auth.getName();
		usersDTO users = udao.findById(u_id);
		int u_no = users.getU_no();
		return "restaurant/reviewWriteForm";
	}
	
	// 식당 페이지 리뷰 조회(3개)
	@RequestMapping("/restaurant/view")
	public String reviewPList(@RequestParam("r_no") int r_no,
								Model model) {
		List<reviewDTO> reviewList = rvdao.reviewPList(r_no);
		int reviewCount = rvdao.reviewCount(r_no);
		
		model.addAttribute("rvPList",reviewList);
		model.addAttribute("rvcount",reviewCount);
		model.addAttribute("r_no", r_no);
		
		return "restaurant";
	}
	
	// 리뷰 페이지 리뷰 조회
	@RequestMapping("/restaurant/review")
	public String reviewList(@RequestParam("r_no") int r_no,
								Model model) {
		List<reviewDTO> reviewList = rvdao.reviewList(r_no);
		int reviewCount = rvdao.reviewCount(r_no);
		
		model.addAttribute("rvList",reviewList);
		model.addAttribute("rvcount",reviewCount);
		model.addAttribute("r_no",r_no);
		
		return "restaurant/reviews";
	}
	
	// 리뷰 작성
	@RequestMapping("/restaurant/reviewInsert")
	public String reviewInsert(Authentication auth,reviewDTO rvdto,
								@RequestParam("r_no") int r_no,
								@RequestParam(value="reviewFiles",required=false)
								 List<MultipartFile> reviewFiles) throws IOException {
		
		String u_id = auth.getName();
		usersDTO users = udao.findById(u_id);
		int u_no = users.getU_no();
		
		List<reviewimgDTO> rvimgList = new ArrayList<>();

		if(reviewFiles !=null) {
			for(MultipartFile file : reviewFiles) {
				if(!file.isEmpty()) {
					String fileName = file.getOriginalFilename();
					
					// upload에 파일 저장
					File saveFile = new File("C:/upload/"+fileName);
					file.transferTo(saveFile);
					
					// 이미지 DTO 생성
					reviewimgDTO rvimg = new reviewimgDTO();
					rvimg.setRvimg_img(fileName);
					
					rvimgList.add(rvimg);
				}
			}
		}
		
		rvdto.setU_no(u_no);
		rvdto.setR_no(r_no);
		rvdto.setReviewImages(rvimgList);
		rvService.reviewInsert(rvdto);
		
		return "restaurant/reviewtest";
	}
	
	// 리뷰 수정
	@RequestMapping("/restaurant/reviewUpdate")
	public String reviewUpdate(Authentication auth,reviewDTO rvdto,
								@RequestParam("r_no") int r_no,
								@RequestParam(value="reviewFiles",required=false)
								 List<MultipartFile> reviewFiles) throws IOException {
		String u_id = auth.getName();
		usersDTO users = udao.findById(u_id);
		int u_no = users.getU_no();
		
		List<reviewimgDTO> rvimgList = new ArrayList<>();
		
		if(reviewFiles !=null) {
			for(MultipartFile file : reviewFiles) {
				if(!file.isEmpty()) {
					String fileName = file.getOriginalFilename();
					
					// upload에 파일 저장
					File saveFile = new File("C:/upload/"+fileName);
					file.transferTo(saveFile);
					
					// 이미지 DTO 생성
					reviewimgDTO rvimg = new reviewimgDTO();
					rvimg.setRvimg_img(fileName);
					
					rvimgList.add(rvimg);
				}
			}
		}		
		
		rvdto.setU_no(u_no);
		rvdto.setReviewImages(rvimgList);
		rvService.reviewUpdate(rvdto);
		
		return "redirect:reviewlist";
	}
	
	// 리뷰 삭제
	@RequestMapping("/restaurant/reviewDelete")
	public String reviewDelete(int rv_no,Authentication auth) {
		
		String u_id = auth.getName();
		usersDTO users = udao.findById(u_id);
		int u_no = users.getU_no();
		
		rvdao.reviewDelete(rv_no, u_no);
		
		return "redirect:reviewlist";
	}
}

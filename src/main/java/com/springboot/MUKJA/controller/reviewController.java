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
import org.springframework.web.bind.annotation.ResponseBody;
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
	
	// 리뷰 작성폼으로 가기
	@RequestMapping("/users/reviewWrite")
	public String reviewWriteForm(@RequestParam("r_no")int r_no,Model model) {
		
		model.addAttribute("r_no",r_no);
		
		return "restaurant/reviewWriteForm";
	}
	
	// 리뷰 페이지 리뷰 조회
	@RequestMapping("/restaurant/review")
	public String reviewList(Authentication auth,
								@RequestParam("r_no") int r_no,
								Model model) {
		String u_id = auth.getName();
		usersDTO users = udao.findById(u_id);
		int u_no = users.getU_no();
		
		List<reviewDTO> reviewList = rvdao.reviewList(r_no);
		int reviewCount = rvdao.reviewCount(r_no);
		
		model.addAttribute("rvList",reviewList);
		model.addAttribute("rvcount",reviewCount);
		model.addAttribute("r_no",r_no);
		model.addAttribute("loginUserNo",u_no);
		
		return "restaurant/reviews";
	}
	
	// 리뷰 작성
	@RequestMapping("/restaurant/reviewInsert")
	@ResponseBody
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
		
		return "<script>" +
		        "alert('리뷰를 등록했습니다.');" +
		        "location.href='/restaurant/detail?r_no=" + r_no + "';" +
		        "</script>";
	}
	
	// 리뷰 수정폼으로 가기
	@RequestMapping("/users/reviewUpdateForm")
	public String reviewUpdateForm(@RequestParam("rv_no") int rv_no, Model model) {

	    reviewDTO rvupdate = rvdao.reviewUP(rv_no);

	    model.addAttribute("rvUP", rvupdate);

	    return "restaurant/reviewUpdateForm";
	}
	
	// 리뷰 수정
	@RequestMapping("/restaurant/reviewUpdate")
	@ResponseBody
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
		rvdto.setR_no(r_no);
		rvdto.setReviewImages(rvimgList);
		rvService.reviewUpdate(rvdto);
		
		return "<script>" +
		        "alert('리뷰를 수정했습니다.');" +
		        "location.href='/restaurant/detail?r_no=" + r_no + "';" +
		        "</script>";
	}
	
	// 리뷰 삭제
	@RequestMapping("/restaurant/reviewDelete")
	public String reviewDelete(@RequestParam("rv_no") int rv_no,
								@RequestParam("r_no") int r_no) {
		
		rvdao.reviewDelete(rv_no);
		
		return "redirect:/restaurant/review?r_no="+r_no;
	}
}

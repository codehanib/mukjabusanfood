package com.springboot.MUKJA.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.springboot.MUKJA.dao.reviewDAO;
import com.springboot.MUKJA.dto.reviewDTO;
import com.springboot.MUKJA.dto.reviewimgDTO;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class reviewService {
	private final reviewDAO rvdao;
	
	// 리뷰 등록
	@Transactional
	public void reviewInsert(reviewDTO rvdto) {
		rvdao.reviewInsert(rvdto);
		
		// 이미지 등록
		if(rvdto.getReviewImages()!=null) {
			for(reviewimgDTO rvimg : rvdto.getReviewImages()) {
				rvimg.setRv_no(rvdto.getRv_no());
				rvdao.reviewImgInsert(rvimg);
			}
		}
	}
	
	// 리뷰 수정
	@Transactional
	public void reviewUpdate(reviewDTO rvdto) {
		rvdao.reviewUpdate(rvdto);
		
		// 기존 이미지 삭제하고 업로드
		rvdao.reviewimgDelete(rvdto.getRv_no());
		
		if(rvdto.getReviewImages()!=null) {
			for(reviewimgDTO rvimg : rvdto.getReviewImages()) {
				rvimg.setRv_no(rvdto.getRv_no());
				rvdao.reviewImgInsert(rvimg);
			}
		}
	}
	
	// 식당 페이지에서 리뷰 3개 출력
	public List<reviewDTO> reviewPList(int r_no) {
	    return rvdao.reviewPList(r_no);
	}
	
}

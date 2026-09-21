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

	    // 리뷰 내용 / 평점 수정
	    rvdao.reviewUpdate(rvdto);
	    // 새 이미지가 있을 때만 기존 이미지 삭제 후 새 이미지 등록
	    if (rvdto.getReviewImages() != null
	            && !rvdto.getReviewImages().isEmpty()) {
	        // 기존 이미지 삭제
	        rvdao.reviewimgDelete(rvdto.getRv_no());
	        // 새 이미지 등록
	        for (reviewimgDTO rvimg : rvdto.getReviewImages()) {
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

package com.springboot.MUKJA.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.springboot.MUKJA.dto.reviewDTO;
import com.springboot.MUKJA.dto.reviewimgDTO;

@Mapper
public interface reviewDAO {
	
	// 식당별 리뷰 갯수
	public int reviewCount(@Param("r_no") int r_no);
	// 식당별 리뷰 조회 -식당페이지-
	public List<reviewDTO> reviewPList(@Param("r_no") int r_no);
	// 식당별 리뷰 조회 -리뷰페이지-
	public List<reviewDTO> reviewList(@Param("r_no") int r_no);
	// 리뷰 1개 조회 (수정페이지용)
	public reviewDTO reviewUP(@Param("rv_no") int rv_no);
	
	// 리뷰 작성
	public int reviewInsert(reviewDTO rvdto);
	// 리뷰 이미지 등록
	public int reviewImgInsert(reviewimgDTO rvimgdto);
	
	// 리뷰 수정 - 본인만
	public int reviewUpdate(reviewDTO rvdto);
	// 리뷰 이미지 삭제 (수정용)
	public int reviewimgDelete(@Param("rv_no") int rv_no);
	
	// 리뷰 삭제
	public int reviewDelete(@Param("rv_no") int rv_no);
	
	// 리뷰 이미지 조회
	public List<reviewimgDTO> reviewImgView(@Param("rv_no") int rv_no);
	
}

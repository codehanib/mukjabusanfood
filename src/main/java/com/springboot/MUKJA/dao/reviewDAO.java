package com.springboot.MUKJA.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.springboot.MUKJA.dto.reviewDTO;
import com.springboot.MUKJA.dto.reviewimgDTO;

@Mapper
public interface reviewDAO {
	
	// 식당별 리뷰 갯수
	public int reviewCount(int r_no);
	// 식당별 리뷰 조회 -식당페이지-
	public List<reviewDTO> reviewPList(int r_no);
	// 식당별 리뷰 조회 -리뷰페이지-
	public List<reviewDTO> reviewList(int r_no);
	
	// 리뷰 작성
	public int reviewInsert(reviewDTO rvdto);
	// 리뷰 이미지 작성
	public int reviewImgInsert();
	
	// 리뷰 수정 - 본인만
	public int reviewUpdate(reviewDTO rvdto);
	// 리뷰 삭제 - 본인만
	public int reviewDelete(@Param("rv_no") int rv_no,
							@Param("u_no") int u_no);
	
	// 리뷰 이미지 등록
	public int reviewImgInsert(reviewimgDTO rvimgdto);
	// 리뷰 이미지 조회
	public List<reviewimgDTO> reviewImgView(int rv_no);
	
}

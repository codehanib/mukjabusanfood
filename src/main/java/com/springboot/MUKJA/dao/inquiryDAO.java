package com.springboot.MUKJA.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.springboot.MUKJA.dto.inquiryDTO;

public interface inquiryDAO {
	
	// 관리자의 문의 전체 조회
	public List<inquiryDTO> inquiryAdminList();
	// 관리자의 문의 상세 조회
	public inquiryDTO inquiryAdminView(int mi_no);
	
	// 회원의 1:1 문의 조회
	public List<inquiryDTO> inquiryList(int u_no);
	// 회원의 1:1 문의 상세조회
	public inquiryDTO inquiryView(@Param("mi_no") int mi_no,
								  @Param("u_no") int u_no);
	// 1:1 문의 작성
	public int inquiryInsert(inquiryDTO midto);
	// 1:1 문의 수정
	public int inquiryUpdate(inquiryDTO midto);
	// 1:1 문의 답변(관리자)
	public int inquiryAnswer(inquiryDTO midto);
	// 1:1 문의 삭제
	public int inquiryDelete(@Param("mi_no") int mi_no,
			  				 @Param("u_no") int u_no);
}

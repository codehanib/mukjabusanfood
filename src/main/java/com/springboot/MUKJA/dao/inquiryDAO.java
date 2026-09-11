package com.springboot.MUKJA.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.springboot.MUKJA.dto.inquiryDTO;

@Mapper	
public interface inquiryDAO {
	
	// 문의 전체 목록 조회
	public List<inquiryDTO> inquiryList(@Param("offset") int offset);
	// 문의 개수 (for 페이징)
	public int inquiryCount();

	// 문의 상세 조회
	public inquiryDTO inquiryView(@Param("mi_no")int mi_no);

	// 문의 작성
	public int inquiryInsert(inquiryDTO midto);

	// 문의 수정
	public int inquiryUpdate(inquiryDTO midto);

	// 문의 답변
	public int inquiryAnswer(inquiryDTO midto);

	// 문의 삭제
	public int inquiryDelete(int mi_no);
}

package com.springboot.MUKJA.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.springboot.MUKJA.dto.bookmarkDTO;

public interface bookmarkDAO {
	
	// 북마크 조회
	public List<bookmarkDTO> bookmarkList(@Param("u_no") int u_no);
	// 북마크 여부 확인
	public int bookmarkCheck(bookmarkDTO bkdto);
	// 북마크 생성
	public int bookmarkInsert(bookmarkDTO bkdto);
	// 북마크 삭제
	public int bookmarkDelete(@Param("bk_no") int bk_no);
	
}

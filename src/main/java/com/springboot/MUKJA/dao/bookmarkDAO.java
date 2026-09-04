package com.springboot.MUKJA.dao;

import java.util.List;

import com.springboot.MUKJA.dto.bookmarkDTO;

public interface bookmarkDAO {
	
	// 북마크 조회
	public List<bookmarkDTO> bookmarkList(int u_no);
	// 북마크 여부 확인
	public int bookmarkCheck(bookmarkDTO bkdto);
	// 북마크 생성
	public int bookmarkInsert(bookmarkDTO bkdto);
	// 북마크 삭제
	public int bookmarkDelete(int bk_no);
	
}

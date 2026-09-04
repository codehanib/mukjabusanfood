package com.springboot.MUKJA.dao;

import java.util.List;

import com.springboot.MUKJA.dto.noticeDTO;

public interface noticeDAO {
	
	// 공지 목록 조회 (권한 모두 가능)
	public List<noticeDTO> noticeList();
	// 공지 내용 조회 (권한 모두 가능)
	public noticeDTO noticeView(int nt_no);
	// 공지 작성 (관리자만 가능)
	public int noticeInsert(noticeDTO ntdto);
	// 공지 수정 (관리자만 가능)
	public int noticeUpdate(noticeDTO ntdto);
	// 공지 삭제 (관리자만 가능)
	public int noticeDelete(int nt_no);
	
}

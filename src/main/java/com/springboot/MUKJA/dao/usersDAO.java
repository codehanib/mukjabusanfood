package com.springboot.MUKJA.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.springboot.MUKJA.dto.usersDTO;

@Mapper
public interface usersDAO {
	
	//로그인용 조회,회원정보 상세보기, 수정폼
	public usersDTO findById(String u_id);
	
	//회원 목록
	public List<usersDTO> userList();
	
	//회원가입
	public int usersInsert(usersDTO dto);
	
	//회원정보 수정
	public int usersUpdate(usersDTO dto);
	
	//회원 탈퇴
	public int userDelete(int u_id);
	
	//관리자가 회원 삭제
	public int adminDelete(int u_no);
	
	// 관리자 회원 상세조회
	public usersDTO userView(int u_no);
	
	public int orderCount(int u_no);
	public int wishlistCount(int u_no);
	public int one_inquiryCount(int u_no);
}

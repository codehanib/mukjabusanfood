package com.springboot.MUKJA.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.springboot.MUKJA.dto.usersDTO;

@Mapper
public interface usersDAO {
	
	//로그인용 조회,회원정보 상세보기, 수정폼
	public usersDTO findById(String u_id);
	
	//회원 목록
	public List<usersDTO> usersList();
	
	//회원가입
	public int usersInsert(usersDTO dto);
	
	//회원정보 수정
	public int usersUpdate(usersDTO dto);
	
	//회원 탈퇴
	public int usersDelete(String u_id);
	
	//관리자가 회원 삭제
	public int adminDelete(int u_no);
	
	//비밀번호 변경
	public int userspasswd(usersDTO dto);
	
	// 관리자 회원 상세조회
	public usersDTO usersView(int u_no);
	
	// 관리자 회원 권한변경
	public int usersAuthUpdate(usersDTO dto);
	
	public int delivery(int u_no);
	public int bookmark(int u_no);
	public int mukja_inquiry(int u_no);
	public int review(int u_no);
	public int reservation(int u_no);
}

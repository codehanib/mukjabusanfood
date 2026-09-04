package com.springboot.MUKJA.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.springboot.MUKJA.dto.paymentDTO;

@Mapper
public interface paymentDAO {
	
	// 결제 정보 조회
	public List<paymentDTO> paymentList();
	// 결제 상세 조회
	public paymentDTO paymentView(int py_no);
	// 결제 정보 저장
	public int paymentInsert(paymentDTO pydto);
	// 결제 정보 삭제
	public int paymentDelete(int py_no);
	
}

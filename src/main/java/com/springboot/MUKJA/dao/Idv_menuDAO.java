package com.springboot.MUKJA.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.springboot.MUKJA.dto.dv_menuDTO;

@Mapper
public interface Idv_menuDAO {
	// 1. 주문 상세 메뉴 등록 (장바구니 메뉴들을 주문 메뉴로 저장)
    int insertDeliveryMenu(dv_menuDTO dto);

    // 2. 특정 주문번호(d_no)에 포함된 메뉴 목록 조회
    List<dv_menuDTO> selectDeliveryMenusByOrder(int d_no);
}

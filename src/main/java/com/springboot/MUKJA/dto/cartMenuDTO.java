package com.springboot.MUKJA.dto;

import lombok.Data;

@Data
public class cartMenuDTO {
	private int mcm_no;    // 장바구니메뉴번호 (PK)
    private int mcm_count; // 장바구니메뉴수량
    private int mcm_price; // 장바구니메뉴가격
    private int mc_no;     // 장바구니번호 (FK)
    private int mn_no;     // 메뉴번호 (FK)
    
    // 조인 시 화면에 메뉴명을 보여주기 위한 추가 필드
    private String mn_name;
}

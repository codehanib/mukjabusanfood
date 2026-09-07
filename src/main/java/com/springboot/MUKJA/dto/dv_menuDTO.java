package com.springboot.MUKJA.dto;

import lombok.Data;

@Data		
public class dv_menuDTO {
	private int dvm_no;
	private int dvm_count;
	private int dvm_price;
	private int d_no;
	private int mn_no;
	
	//테이블 조회용
	private String mn_name;
	private String mn_content;
	private String mn_img;
}
	
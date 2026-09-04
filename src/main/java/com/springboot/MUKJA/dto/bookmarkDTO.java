package com.springboot.MUKJA.dto;

import lombok.Data;

@Data
public class bookmarkDTO {
	private int bk_no;
	private int r_no;
	private int u_no;
	// 식당 조회용
	private String r_img;
	private String r_name;
	private String r_region;
}

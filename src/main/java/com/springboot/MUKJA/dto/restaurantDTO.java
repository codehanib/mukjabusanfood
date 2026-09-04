package com.springboot.MUKJA.dto;

import lombok.Data;

@Data
public class restaurantDTO {
	private int r_no;
	private String r_name;
	private String r_addr;
	private String r_region;
	private int r_lat;
	private int r_lon;
	private int r_point;
	private String r_info;
	private String r_desc;
	private String r_time;
	private String r_rest;
	private String r_img;
	
	private int mukja_c_no;
    private String mukja_c_name;

    private String mn_name;
}

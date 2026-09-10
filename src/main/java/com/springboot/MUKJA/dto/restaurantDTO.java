package com.springboot.MUKJA.dto;

import java.util.List;

import lombok.Data;

@Data
public class restaurantDTO {
	private int r_no;
	private String r_name;
	private String r_addr;
	private String r_region;
	private double r_lat;
	private double r_lon;
	private double r_point;
	private String r_info;
	private String r_desc;
	private String r_time;
	private String r_rest;
	private String r_img;
	
	private int mukja_c_no;
    private String mukja_c_name;
    
    private int reviewCount;
    private double reviewAvg;
    
    private String simple_time;
    private String display_time;
    private String rest_day;
    private String today_time;
    
    private String mn_name;
    private String mn_content;
    private int mn_price;
    private String mn_img;
    
    private int mbi_no;
 	private String mbi_img;

}

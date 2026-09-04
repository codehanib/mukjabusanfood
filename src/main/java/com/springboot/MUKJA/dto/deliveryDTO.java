package com.springboot.MUKJA.dto;

import java.util.Date;

import lombok.Data;

@Data
public class deliveryDTO {
	private int d_no;
	private String d_addr;
	private String d_stats;
	private Date d_reg_date;
	private int d_cooking_time;
	private int d_delivert_time;
	private Date d_arrival_time;
	private int d_lat;
	private int d_lng;
	private int r_no;
	private int u_no;
}

package com.springboot.MUKJA.dto;

import java.util.Date;

import lombok.Data;

@Data
public class paymentDTO {
	private int py_no;
	private String py_type;
	private int py_price;
	private Date py_reg_date;
	private String py_stats;
	private int res_no;
	private int d_no;
}

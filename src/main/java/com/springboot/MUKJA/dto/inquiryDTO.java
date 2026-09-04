package com.springboot.MUKJA.dto;

import java.util.Date;

import lombok.Data;

@Data
public class inquiryDTO {
	private int mi_no;
	private String mi_content;
	private String mi_answer;
	private Date mi_reg_date;
	private String mi_stats;
	private int u_no;
}

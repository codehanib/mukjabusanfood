package com.springboot.MUKJA.dto;

import java.util.Date;
import java.util.List;

import lombok.Data;

@Data
public class reviewDTO {
	private int rv_no;
	private Double rv_point;
	private String rv_content;
	private Date rv_reg_date;
	private int r_no;
	private int u_no;
	private String u_name;
	private List<reviewimgDTO> reviewImages;
}

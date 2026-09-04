package com.springboot.MUKJA.dto;

import java.util.Date;

import lombok.Data;

@Data
public class noticeDTO {
	private int nt_no;
	private String nt_title;
	private String nt_content;
	private String nt_img;
	private Date nt_reg_date;
	private int u_no;
}

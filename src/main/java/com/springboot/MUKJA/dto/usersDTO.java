package com.springboot.MUKJA.dto;

import java.util.Date;

import lombok.Data;

@Data
public class usersDTO {
	
	private int 	u_no;
	private String	u_id;
	private String 	u_passwd;
	private String	u_name;
	private String 	u_tel;
	private String 	u_addr;
	private String 	u_zipno;
	private String 	u_email;
	private String 	u_auth;
	private Date 	u_date;
	private String 	u_stats;
	private int 	r_no;
}

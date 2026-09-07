package com.springboot.MUKJA.dto;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

import lombok.Data;

@Data
public class reservationDTO {
	
	private int res_no;
	private String res_num;
	private String res_name;
	private String res_tel;
	@DateTimeFormat(pattern = "yyyy-MM-dd")
	private Date res_day;
	private String res_time;
	private int res_count;
	private Integer res_price;
	private String res_stats;
	private Integer res_wait;
	private Date res_reg_date;
	private Date res_update;
	
	private Integer u_no;
    private Integer r_no;
}

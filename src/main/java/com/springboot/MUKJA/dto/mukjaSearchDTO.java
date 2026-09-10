package com.springboot.MUKJA.dto;

import java.util.Date;

import lombok.Data;

@Data
public class mukjaSearchDTO {
    private int ms_no;
    private String ms_word;
    private Date ms_date;
}

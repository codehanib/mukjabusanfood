package com.springboot.MUKJA.dto;

import java.util.Date;

import org.springframework.data.annotation.Id;
import org.springframework.data.elasticsearch.annotations.Document;
import org.springframework.data.elasticsearch.annotations.Field;
import org.springframework.data.elasticsearch.annotations.FieldType;

import lombok.Data;

@Data
@Document(indexName = "mukja_search")
public class mukjaSearchDTO {

    @Id
    private int ms_no;

    @Field(type = FieldType.Keyword)
    private String ms_word;

    @Field(type = FieldType.Date)
    private Date ms_date;

    // 인기검색어 검색 횟수
    private int ms_count;
}
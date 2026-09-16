package com.springboot.MUKJA.dto;

import org.springframework.data.annotation.Id;
import org.springframework.data.elasticsearch.annotations.Document;
import org.springframework.data.elasticsearch.annotations.Field;
import org.springframework.data.elasticsearch.annotations.FieldType;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
@Document(indexName = "mukja_review")
public class MukjaReviewESDTO {

    @Id
    private Integer rev_no; // 리뷰 번호 (PK)

    @Field(type = FieldType.Integer)
    private Integer r_no;

    @Field(type = FieldType.Text)
    private String r_name;

    @Field(type = FieldType.Keyword)
    private String user_id;

    @Field(type = FieldType.Float) // 리뷰 평점 (1.0 ~ 5.0)
    private Float rev_score;

    @Field(type = FieldType.Text) // 리뷰 내용
    private String rev_content;

    @Field(type = FieldType.Keyword)
    private String rev_date;

    @Field(type = FieldType.Keyword)
    private String r_region;
}
package com.springboot.MUKJA.dto;

import org.springframework.data.annotation.Id;
import org.springframework.data.elasticsearch.annotations.Document;
import org.springframework.data.elasticsearch.annotations.Field;
import org.springframework.data.elasticsearch.annotations.FieldType;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
@Document(indexName = "mukja_reservation")
public class MukjaReservationESDTO {

    @Id
    private Integer res_no; // 예약 번호 (PK)

    @Field(type = FieldType.Integer)
    private Integer r_no;

    @Field(type = FieldType.Text)
    private String r_name;

    @Field(type = FieldType.Keyword)
    private String user_id;

    @Field(type = FieldType.Integer)
    private Integer res_people; // 예약 인원수

    @Field(type = FieldType.Keyword) // 예약 상태 (예약완료/취소/방문완료 등)
    private String res_status;

    @Field(type = FieldType.Keyword)
    private String res_date; // 예약 날짜

    @Field(type = FieldType.Keyword)
    private String r_region;
}
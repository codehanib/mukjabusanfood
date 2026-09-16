package com.springboot.MUKJA.dto;

import org.springframework.data.annotation.Id;
import org.springframework.data.elasticsearch.annotations.Document;
import org.springframework.data.elasticsearch.annotations.Field;
import org.springframework.data.elasticsearch.annotations.FieldType;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
@Document(indexName = "mukja_delivery")
public class MukjaDeliveryESDTO {

    @Id
    private Integer d_no; // 배달 번호 (PK)

    @Field(type = FieldType.Integer)
    private Integer r_no; // 식당 번호

    @Field(type = FieldType.Text)
    private String r_name; // 식당 이름

    @Field(type = FieldType.Keyword)
    private String user_id; // 주문 유저 ID

    @Field(type = FieldType.Keyword) // 키바나 상태별(배달완료/취소 등) 차트용
    private String d_status;

    @Field(type = FieldType.Integer)
    private Integer d_price; // 주문 금액

    @Field(type = FieldType.Keyword)
    private String d_date; // 주문 일자

    @Field(type = FieldType.Keyword)
    private String r_region; // 지역구
}
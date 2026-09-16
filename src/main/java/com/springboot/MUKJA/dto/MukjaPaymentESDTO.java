package com.springboot.MUKJA.dto;

import org.springframework.data.annotation.Id;
import org.springframework.data.elasticsearch.annotations.Document;
import org.springframework.data.elasticsearch.annotations.Field;
import org.springframework.data.elasticsearch.annotations.FieldType;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
@Document(indexName = "mukja_payment")
public class MukjaPaymentESDTO {

    @Id
    private Integer p_no; // 결제 번호 (PK)

    @Field(type = FieldType.Keyword)
    private String user_id;

    @Field(type = FieldType.Keyword) // 결제 수단 (카카오페이/신용카드 등)
    private String p_method;

    @Field(type = FieldType.Integer) // 결제 총액
    private Integer p_amount;

    @Field(type = FieldType.Keyword) // 결제 상태 (결제완료/환불 등)
    private String p_status;

    @Field(type = FieldType.Keyword)
    private String p_date;
}
package com.springboot.MUKJA.dto;

import org.springframework.data.annotation.Id;
import org.springframework.data.elasticsearch.annotations.Document;
import org.springframework.data.elasticsearch.annotations.Field;
import org.springframework.data.elasticsearch.annotations.FieldType;
import org.springframework.data.elasticsearch.annotations.GeoPointField;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
@Document(indexName = "mukja_restaurant") // 엘라스틱서치 데이터객체임을 선언하고 연결할 인덱스명 지정
public class MukjaRestaurantESDTO {
	
	@Id // ES 문서의 _id로 쓰일 PK
    private Integer r_no;

    @Field(type = FieldType.Text, analyzer = "korean")
    private String r_name;

    @Field(type = FieldType.Text)
    private String r_addr;

    @Field(type = FieldType.Keyword) //  Kibana 시각화/그룹화용 필드
    private String r_region;

    @Field(type = FieldType.Float)
    private Float r_lat;

    @Field(type = FieldType.Float)
    private Float r_lon;

    @Field(type = FieldType.Float)
    private Float r_point;

    @Field(type = FieldType.Integer)
    private Integer mukja_c_no;

    @Field(type = FieldType.Keyword) //  카테고리별 차트용 필드
    private String mukja_c_name;
    
    @Field(type = FieldType.Integer)
    private Integer r_avg_price; // 식당 평균 메뉴 가격
    
    @GeoPointField
    private String location;  //지도용
}

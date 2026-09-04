package com.springboot.MUKJA.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.springboot.MUKJA.dto.foodcategoryDTO;
import com.springboot.MUKJA.dto.restaurantDTO;

@Mapper
public interface restaurantDAO {
		
		// Elasticsearch 인덱싱용 전체 식당 select (페이징/정렬)
		public List<restaurantDTO> restaurantESList();
		
		// 메인 식당 목록
		public List<restaurantDTO> mainrestaurantList(@Param("start") int start,
		        									@Param("pageSize") int pageSize);
		
		// 음식종류 목록
	    public List<foodcategoryDTO> foodcategoryList();

	    // 음식종류별 식당 목록
	    public List<restaurantDTO> restaurantListCategory(
	            @Param("mukja_c_no") int mukja_c_no,
	            @Param("start") int start,
	            @Param("pageSize") int pageSize);
	    
		// 식당 하나의 기본 정보 select
		public restaurantDTO restaurantDetail(int r_no);
		
		// 식당 전체 개수
		public int restaurantCount();
		
		// 음식종류별 식당 개수
		public int restaurantCountCategory(@Param("mukja_c_no") int mukja_c_no);
		
		// 식당 등록 insert
		public int restaurantInsert(restaurantDTO dto);
				
		//  식당 수정 update
		public int restaurantUpdate(restaurantDTO dto);
		
		// 식당 삭제 delete
		public int restaurantDelete(int r_no);
		
}

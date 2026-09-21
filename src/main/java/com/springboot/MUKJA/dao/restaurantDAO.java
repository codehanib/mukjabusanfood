package com.springboot.MUKJA.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.springboot.MUKJA.dto.foodcategoryDTO;
import com.springboot.MUKJA.dto.menuDTO;
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
	            @Param("sort") String sort,
	            @Param("start") int start,
	            @Param("pageSize") int pageSize);
	    
	    // 지역 목록
	    public List<String> regionList();
	    
	    // 지역별 식당 목록
	    public List<restaurantDTO> restaurantListRegion(
	            @Param("r_region") String r_region,
	            @Param("start") int start,
	            @Param("pageSize") int pageSize
	    );
	    
		// 식당 하나의 기본 정보 select
		public restaurantDTO restaurantDetail(int r_no);
		
		// 식당 전체 개수
		public int restaurantCount();
		
		// 음식종류별 식당 개수
		public int restaurantCountCategory(@Param("mukja_c_no") int mukja_c_no);
		
		// 지역별 식당 개수
		public int restaurantCountRegion(@Param("r_region") String r_region);
		
		// 식당 등록 insert
		public int restaurantInsert(restaurantDTO dto);
				
		//  식당 수정 update
		public int restaurantUpdate(restaurantDTO dto);
		
		// 식당 삭제 delete
		public int restaurantDelete(int r_no);
		
		//메뉴판
		public List<restaurantDTO> menuBoardImageList(@Param("r_no") int r_no);
				
		// 메뉴
		public List<menuDTO> menuList(@Param("r_no")int r_no);
		
		// 메뉴 등록
		public int menuInsert(menuDTO dto);
		
		// 메뉴 수정
		public int menuUpdate(menuDTO dto);
		
		// 메뉴 삭제
		public int menuDelete(@Param("mn_no") int mn_no);
		
		// 메뉴판 이미지 등록
		public int menuBoardImageInsert(restaurantDTO dto);
		
		// 메뉴판 이미지 삭제
		public int menuBoardImageDelete(@Param("mbi_no") int mbi_no);
		
		// 메인화면 지역별 가게 자동 전환 ajax용 
		public List<restaurantDTO> restaurantListRegion(@Param("r_region") String r_region);
		
		// 메인화면 평점 조건별 TOP 매장 조회 (AJAX)
		public List<restaurantDTO> restaurantListTopRating(@Param("filter") String filter);

		// 메인화면 전체 매장 목록 조회 (AJAX)
		public List<restaurantDTO> restaurantListAll();
		
	    //관리자용 식당 목록
	    public List<restaurantDTO> adminRestaurantList(
	           @Param("start") int start,
	           @Param("pageSize") int pageSize
	    ) throws Exception;
		
}

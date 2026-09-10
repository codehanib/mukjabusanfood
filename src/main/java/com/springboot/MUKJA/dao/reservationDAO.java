package com.springboot.MUKJA.dao;

import java.util.Date;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.springboot.MUKJA.dto.foodcategoryDTO;
import com.springboot.MUKJA.dto.reservationDTO;

@Mapper
public interface reservationDAO {
		
		// Elasticsearch 인덱싱용 전체 예약 select (페이징/정렬)
		public List<reservationDTO> reservationESList();
		
		// 메인 예약 목록
		public List<reservationDTO> mainreservationList(@Param("start") int start,
		        									@Param("pageSize") int pageSize);
		
		// 예약종류 목록
	    public List<foodcategoryDTO> foodcategoryList();

	    // 예약종류별 예약 목록
	    public List<reservationDTO> reservationListCategory(
	            @Param("mukja_c_no") int mukja_c_no,
	            @Param("start") int start,
	            @Param("pageSize") int pageSize);
	    
		// 예약 하나의 기본 정보 select
		public reservationDTO reservationDetail(@Param("res_no")int res_no);
		
		// 예약 전체 개수
		public int reservationCount();
		
		
		// 예약 등록 insert
		public int reservationInsert(reservationDTO dto);
				
		//  예약 수정 update
		public int reservationUpdate(reservationDTO dto);
		
		// 예약 삭제 delete
		public int reservationDelete(@Param("res_no") int res_no);		
		
		// 예약 목록 확인
		public List<reservationDTO> myReservationList(@Param("u_no") int u_no);
		// 예약 기록
		public List<reservationDTO> myReservationHistory(@Param("u_no") int u_no);
		// 예약전 대기줄 확인
		public int reservationWaitCount(@Param("r_no") int r_no, @Param("res_day") Date res_day);
		// 사장님 예약확인
		public List<reservationDTO> ownerReservationList(@Param("r_no") int r_no);
		public int reservationStatusUpdate(@Param("res_no") int res_no, @Param("res_stats") String res_stats);
		public int recalculateWait(@Param("r_no") int r_no, @Param("res_day") Date res_day);
		// 비회원
		public List<reservationDTO> myReservationGuest(@Param("res_tel") String res_tel, @Param("res_name") String res_name);
}

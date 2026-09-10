package com.springboot.MUKJA.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.springboot.MUKJA.dto.deliveryDTO;

@Mapper
public interface IdeliveryDAO {
	// 1. 고객 주문 등록 (주문 접수)
    int insertDelivery(deliveryDTO dto);

    // 2. 점주용: 식당별 주문 목록 조회
    List<deliveryDTO> selectOrdersByRestaurant(int r_no);

    // 3. 점주용: 주문 승인 (조리시간, 배달시간, 도착예정시간, 상태 업데이트)
    int updateOrderAccept(deliveryDTO dto);

    // 4. 점주용: 주문 거절/취소
    int updateOrderStatus(deliveryDTO dto);

    // 5. 고객용: 주문 단건 상세 조회 (배달 상태 및 남은 시간 확인)
    deliveryDTO selectOrderById(int d_no);

    // 6. 고객용: 내 배달 주문 내역 목록 조회
    List<deliveryDTO> selectOrdersByUser(int u_no);
    
 	// 7. 점주 전체 주문 목록 조회
    List<deliveryDTO> selectOrderList();
    
    // 8. 시간대별 배달 소요시간 통계
    List<Map<String, Object>> selectTimeStatistics();
}



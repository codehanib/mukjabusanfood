package com.springboot.MUKJA.controller;

import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.springboot.MUKJA.dao.IdeliveryDAO;
import com.springboot.MUKJA.dao.Idv_menuDAO;
import com.springboot.MUKJA.dto.deliveryDTO;
import com.springboot.MUKJA.dto.dv_menuDTO;
import com.springboot.MUKJA.service.DeliveryService;

@Controller
public class DeliveryController {
	
	@Autowired
	private IdeliveryDAO deliveryDao;
	
	@Autowired
	private Idv_menuDAO dvMenuDao;
	
	@Autowired
	private DeliveryService deliveryService;
	
	// 1. 고객: 주문 상세 현황 페이지 이동
	@GetMapping("/delivery/detail")
	public String deliveryDetail(@RequestParam("d_no") int d_no, Model model) {
		deliveryDTO delivery = deliveryDao.selectOrderById(d_no);
		List<dv_menuDTO> menuList = dvMenuDao.selectDeliveryMenusByOrder(d_no);
		
		//테스트용 식당 좌표(부산신청 기준)
		double storeLat = 35.1795588;
		double storeLng = 129.0756416;
		
		model.addAttribute("delivery",delivery);
		model.addAttribute("menuList",menuList);
		model.addAttribute("storeLat",storeLat);
		model.addAttribute("storeLng",storeLng);
		
		return "delivery/delivery_detail";
	}
	
	// 2. 점주: 주문 숭인 처리(조리시간 수령후 거리/시간 계산)
	
	@PostMapping("/store/order/accept")
	public String acceptOrder(@RequestParam("d_no") int d_no,
	                          @RequestParam("d_cooking_time") int cookingTime) {
	    // 1. 배달 주문 정보 조회
	    deliveryDTO delivery = deliveryDao.selectOrderById(d_no);
	    
	    // 테스트용 시작 위치 좌표 (식당 위치)
	    double storeLat = 35.1795588;
	    double storeLng = 129.0756416;
	    
	    // 2. 식당 ~ 배송지 거리계산 (km)
	    double distance = deliveryService.calculateDistance(storeLat, storeLng, delivery.getD_lat(), delivery.getD_lng());
	    
	    // 3. 배달 소요시간 계산 (분)
	    int deliveryTime = deliveryService.estimateDeliveryTimeMinutes(distance);
	     
	    // 4. 최종 도착 예정 시각 계산
	    Date arrivalTime = deliveryService.calculateArrivalTime(cookingTime, deliveryTime);
	     
	    // 5. DTO 정보 저장
	    delivery.setD_cooking_time(cookingTime);
	    delivery.setD_delivery_time(deliveryTime);
	    delivery.setD_arrival_time(arrivalTime);
	     
	    // 6. DB 승인 정보 업데이트
	    deliveryDao.updateOrderAccept(delivery);
	     
	    // [수정] 승인 처리 완료 후 다시 해당 주문 상세 페이지로 리다이렉트
	    return "redirect:/store/order/detail?d_no=" + d_no;
	}
	
	
	// 3. 점주 : 주문 상태 진행변경
	// 상세페이지 이동
//	@PostMapping("/store/order/updateStatus")
//	public String updateStatus(@RequestParam("d_no") int d_no,
//							   @RequestParam("nextStatus")String nextStatus) {
//		deliveryDTO dto = new deliveryDTO();
//		dto.setD_no(d_no);
//		dto.setD_stats(nextStatus);
//		
//		deliveryDao.updateOrderStatus(dto);
//		
//		deliveryDTO currentOrder = deliveryDao.selectOrderById(d_no);
//		
//		return "redirect:/store/orders?r_no=" + currentOrder.getR_no();
//	}
	
	// 테스트용 현재 주문페이지이동
	@PostMapping("/store/order/updateStatus")
	public String updateStatus(@RequestParam("d_no") int d_no,
	                           @RequestParam("nextStatus") String nextStatus) {
	    deliveryDTO dto = new deliveryDTO();
	    dto.setD_no(d_no);
	    dto.setD_stats(nextStatus);
	    
	    // 1. DB 상태 변경
	    deliveryDao.updateOrderStatus(dto);
	    
	    // 2. 목록 페이지가 없으므로 현재 주문 상세 페이지로 다시 이동
	    return "redirect:/store/order/detail?d_no=" + d_no;
	}
	
	
	// 점주 주문 상세 보기 컨트롤러
	@GetMapping("/store/order/detail")
	public String storeOrderDetail(@RequestParam("d_no") int d_no, Model model) {
	    // 1. 배달 주문 기본 정보 조회
	    deliveryDTO delivery = deliveryDao.selectOrderById(d_no);
	    
	    // 2. 해당 배달 주문의 상세 메뉴 목록 조회
	    List<dv_menuDTO> orderMenuList = dvMenuDao.selectDeliveryMenusByOrder(d_no);
	    
	    // 3. 식당 정보 조회 (필요 시 restaurantDao 연결)
	    // restaurantDTO restaurant = restaurantDao.selectRestaurantById(delivery.getR_no());

	    // JSP 변수명과 동일하게 Model에 저장
	    model.addAttribute("delivery", delivery);             // order -> delivery로 수정
	    model.addAttribute("orderMenuList", orderMenuList);   // 메뉴 목록 추가
	    // model.addAttribute("restaurant", restaurant);       // 식당 정보 추가

	    return "delivery/store_order_detail"; 
	}
	

	// 점주용 전체 주문 내역 관리 페이지
	@GetMapping("/store/order/history")
	public String storeOrderHistory(
	        @RequestParam(value = "r_no", required = false, defaultValue = "1") int r_no,
	        @RequestParam(value = "d_stats", required = false) String d_stats,
	        Model model) {

	    // 1. 전체 주문 목록 조회
	    List<deliveryDTO> orderHistoryList = deliveryDao.selectOrderList();

	    // 2. 상단 요약 카드를 위한 간단 통계 계산
	    int totalOrderCount = orderHistoryList.size();
	    int totalRevenue = 0;
	    int activeOrderCount = 0;
	    int rejectedOrderCount = 0;

	    for (deliveryDTO order : orderHistoryList) {
	        // 주문 거절 건수
	        if ("주문거절".equals(order.getD_stats())) {
	            rejectedOrderCount++;
	        } 
	        // 진행 중인 배달 (주문승인, 조리중, 배달중)
	        else if ("주문승인".equals(order.getD_stats()) || "조리중".equals(order.getD_stats()) || "배달중".equals(order.getD_stats())) {
	            activeOrderCount++;
	        }
	        
	        // 매출액 합산 (필요 시 메뉴 가격 반영)
	        // totalRevenue += order.getD_total_price(); 
	    }

	    // 3. JSP 요구 변수명에 맞춰 Model 등록
	    model.addAttribute("r_no", r_no);
	    model.addAttribute("orderHistoryList", orderHistoryList); // JSP의 ${orderHistoryList}와 일치
	    model.addAttribute("totalOrderCount", totalOrderCount);
	    model.addAttribute("totalRevenue", totalRevenue);
	    model.addAttribute("activeOrderCount", activeOrderCount);
	    model.addAttribute("rejectedOrderCount", rejectedOrderCount);

	    return "delivery/store_order_history"; // JSP 파일 경로
	}
	
	// 실시간 상태 확인 API
	@GetMapping("/delivery/api/status")
	@ResponseBody
	public deliveryDTO getDeliveryStatusApi(@RequestParam("d_no") int d_no) {
	    return deliveryDao.selectOrderById(d_no);
	}
	
	
	
	// 점주 주문 거절 처리
	@PostMapping("/store/order/reject")
	public String rejectOrder(@RequestParam("d_no") int d_no) {
	    deliveryDTO dto = new deliveryDTO();
	    dto.setD_no(d_no);
	    dto.setD_stats("주문거절");
	    
	    // DB의 d_stats를 '주문거절'로 업데이트
	    deliveryDao.updateOrderStatus(dto);
	    
	    return "redirect:/store/order/detail?d_no=" + d_no;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
		
}

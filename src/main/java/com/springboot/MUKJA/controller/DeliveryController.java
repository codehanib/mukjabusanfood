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

import com.springboot.MUKJA.dao.IcartMenuDAO;
import com.springboot.MUKJA.dao.IdeliveryDAO;
import com.springboot.MUKJA.dao.Idv_menuDAO;
import com.springboot.MUKJA.dto.cartMenuDTO;
import com.springboot.MUKJA.dto.deliveryDTO;
import com.springboot.MUKJA.dto.dv_menuDTO;
import com.springboot.MUKJA.service.DeliveryService;

import jakarta.servlet.http.HttpSession;

@Controller
public class DeliveryController {
	
	@Autowired
	private IdeliveryDAO deliveryDao;
	
	@Autowired
	private Idv_menuDAO dvMenuDao;
	
	@Autowired
	private DeliveryService deliveryService;
	
	@Autowired
	private IcartMenuDAO cartMenuDao;
	
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
	
	
	
	// ================= [관리자 배달 통합 관제 기능] =================
	
	// 1. 관리자 배달 관제 대시보드 페이지 이동
	@GetMapping("/delivery/admin_delivery_manage")
	public String adminDeliveryManage(
			@RequestParam(value = "restaurantKeyword", required = false) String restaurantKeyword,
			@RequestParam(value = "orderIdKeyword", required = false) String orderIdKeyword,
			@RequestParam(value = "d_stats", required = false) String d_stats,
			Model model) {
		
		//전체 배달 주문 목록 조회
		List<deliveryDTO> allDeliveryList = deliveryDao.selectOrderList();
		
		//관리자 KPI 카운트 집계
		int todayTotalCount = (allDeliveryList != null) ? allDeliveryList.size() : 0;
		int deliveringCount = 0;
		int todayTotalAmount = 0;
		
		if (allDeliveryList != null) {
			for (deliveryDTO delivery : allDeliveryList) {
				if("배달중".equals(delivery.getD_stats())) {
					deliveringCount++;
				}
			}
		}
		
		//model에 전달
		model.addAttribute("allDeliveryList",allDeliveryList);
		model.addAttribute("todayTotalCount",todayTotalCount);
		model.addAttribute("deliveringCount",deliveringCount);
		model.addAttribute("todayTotalAmount",todayTotalAmount);
		
		return "delivery/admin_delivery_manage";
	}
	
	// 2.관리자 강제 상태 변경 (강제 취소/ 강제 완료)
	@PostMapping("/delivery/forceUpdate")
	public String forceUpdateOrder(
			@RequestParam("d_no") int d_no,
			@RequestParam("actionType") String actionType) {
		
		deliveryDTO dto = new deliveryDTO();
		dto.setD_no(d_no);
		
		if ("CANCEL".equals(actionType)) {
			dto.setD_stats("주문거절");
		} else if ("COMPLETE".equals(actionType)) {
			dto.setD_stats("배달완료");
		}
		
	// DB 상태 업데이트
		deliveryDao.updateOrderStatus(dto);
		
	// 다시 관리자 페이지로 리다이렉트
		return "redirect:/delivery/admin_delivery_manage";
	}
		
	
	// ================= [고객 배달 주문 접수 처리] =================
	
	// 1. 고객 배달 주문 작성 페이지 이동 (GET)
	@GetMapping("/delivery/order")
	public String deliveryOrderForm(
	        @RequestParam(value = "r_no", defaultValue = "1") int r_no,
	        @RequestParam(value = "mc_no", defaultValue = "1") int mc_no,
	        @RequestParam(value="u_no", required = false) Integer reqUno,
	        HttpSession session, // 세션에서 정보가져오기
	        Model model) {
	    
	  
	    
	
	    //회원정보 결정하기
	    int finalUno = 1066; 
	    
	    if (reqUno != null) {
	    	finalUno = reqUno; // 1순위 :url 값
	    } else if (session.getAttribute("u_no") != null) {
	    	finalUno = (Integer) session.getAttribute("u_no"); // 2순위:세션값
	    }
	    
	    // 2.모델에 전달
	    
	    // db 에서 장바구니 정보 가져오기
	    List<cartMenuDTO> cartList = cartMenuDao.selectCartMenuList(mc_no);
	    
	    // 총 금액 계산 (단가*수량)
	    int totalPrice = 0;
	    for (cartMenuDTO item : cartList) {
	    	totalPrice += (item.getMcm_price() * item.getMcm_count());
	    }
	    
	    // 회원정보
	    model.addAttribute("u_no",finalUno);
	    // 식당 번호
	    model.addAttribute("r_no", r_no);
	    // 장바구니 번호
	    model.addAttribute("mc_no",mc_no);
	    //장바구니 정보
	    model.addAttribute("cartList",cartList);
	    // 메뉴 총가격
	    model.addAttribute("totalPrice",totalPrice);
	    //배달비
	    model.addAttribute("deliveryFee",3000);
	    
	    return "delivery/delivery_order"; // /WEB-INF/views/delivery/delivery_order.jsp
	}

	@PostMapping("/delivery/order/create")
	public String createOrder(deliveryDTO dto, @RequestParam(value="u_no", defaultValue="5") int u_no) {
	    
	    // 폼에서 u_no 바인딩이 실패해 0이 들어온 경우, 직접 전달받은 파라미터값(5)을 세팅
	    if (dto.getU_no() <= 0) {
	        dto.setU_no(u_no);
	    }

	    System.out.println("==========================================");
	    System.out.println("최종 DB에 저장될 DTO 정보: " + dto.toString());
	    System.out.println("==========================================");

	    // DB 저장
	    deliveryDao.insertDelivery(dto);
	    
	    return "redirect:/delivery/detail?d_no=" + dto.getD_no();
	}
	
	
	
	
	
	
	
	
	
	
	
		
}

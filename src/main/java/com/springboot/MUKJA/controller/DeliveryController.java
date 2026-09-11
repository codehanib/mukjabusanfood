package com.springboot.MUKJA.controller;

import java.util.Date;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.springboot.MUKJA.dao.IcartMenuDAO;
import com.springboot.MUKJA.dao.IdeliveryDAO;
import com.springboot.MUKJA.dao.Idv_menuDAO;
import com.springboot.MUKJA.dao.paymentDAO;
import com.springboot.MUKJA.dao.usersDAO;
import com.springboot.MUKJA.dto.cartMenuDTO;
import com.springboot.MUKJA.dto.deliveryDTO;
import com.springboot.MUKJA.dto.dv_menuDTO;
import com.springboot.MUKJA.dto.paymentDTO;
import com.springboot.MUKJA.dto.usersDTO;
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

    @Autowired
    private paymentDAO paymentDao;
    
    @Autowired
    private usersDAO usersDao;

    // =========================================================================
    // 1. 고객 관련 기능 (주문 작성, 배달 추적, 내 주문 내역, API)
    // =========================================================================

    // 1-1. 고객 배달 주문 작성 페이지 이동
    @GetMapping("/delivery/order")
    public String deliveryOrderForm(
            @RequestParam(value = "r_no", defaultValue = "1") int r_no,
            @RequestParam(value = "mc_no", defaultValue = "1") int mc_no,
            @RequestParam(value = "u_no", required = false) Integer reqUno,
            HttpSession session,
            Model model) {

        int finalUno = 1083; // 기본 회원 번호
        if (reqUno != null) {
            finalUno = reqUno; // 1순위: URL 파라미터
        } else if (session.getAttribute("u_no") != null) {
            finalUno = (Integer) session.getAttribute("u_no"); // 2순위: 세션값
        }

        // 장바구니 목록 및 총 금액 계산
        List<cartMenuDTO> cartList = cartMenuDao.selectCartMenuList(mc_no);
        int totalPrice = 0;
        if (cartList != null) {
            for (cartMenuDTO item : cartList) {
                totalPrice += (item.getMcm_price() * item.getMcm_count());
            }
        }

        model.addAttribute("u_no", finalUno);
        model.addAttribute("r_no", r_no);
        model.addAttribute("mc_no", mc_no);
        model.addAttribute("cartList", cartList);
        model.addAttribute("totalPrice", totalPrice);
        model.addAttribute("deliveryFee", 3000);

        return "delivery/delivery_order";
    }

    // 1-2. 고객 배달 주문 생성 처리
    @PostMapping("/delivery/order/create")
    public String createOrder(deliveryDTO dto, @RequestParam(value = "u_no", defaultValue = "5") int u_no) {
        if (dto.getU_no() <= 0) {
            dto.setU_no(u_no);
        }

        deliveryDao.insertDelivery(dto);
        return "redirect:/delivery/detail?d_no=" + dto.getD_no();
    }

    // 1-3. 고객 주문 상세 현황 및 실시간 위치 추적 페이지
    @GetMapping("/delivery/detail")
    public String deliveryDetail(@RequestParam("d_no") int d_no, Model model) {
        deliveryDTO delivery = deliveryDao.selectOrderById(d_no);
        List<dv_menuDTO> menuList = dvMenuDao.selectDeliveryMenusByOrder(d_no);

        // 테스트용 식당 좌표 (부산 기준)
        double storeLat = 35.1795588;
        double storeLng = 129.0756416;

        // 시간대별 배달 통계 데이터 조회
        List<Map<String, Object>> timeStats = deliveryDao.selectTimeStatistics();

        model.addAttribute("delivery", delivery);
        model.addAttribute("menuList", menuList);
        model.addAttribute("storeLat", storeLat);
        model.addAttribute("storeLng", storeLng);
        model.addAttribute("timeStats", timeStats);

        return "delivery/delivery_detail";
    }

    // 1-4. 고객 개인 배달 주문 내역 목록
    @GetMapping("/delivery/user/history")
    public String userDeliveryHistory(
            @RequestParam(value = "u_no", required = false) Integer reqUno,
            HttpSession session,
            Model model) {

        int u_no = 1083;
        if (reqUno != null) {
            u_no = reqUno;
        } else if (session.getAttribute("u_no") != null) {
            u_no = (Integer) session.getAttribute("u_no");
        }
        
        usersDTO user = usersDao.usersView(u_no);
        List<deliveryDTO> myOrderList = deliveryDao.selectOrdersByUser(u_no);

        model.addAttribute("u_no", u_no);
        model.addAttribute("userName",(user != null) ? user.getU_name() : "고객");
        model.addAttribute("myOrderList", myOrderList);

        return "delivery/user_delivery_history";
    }

    // 1-5. 실시간 상태 동기화 API (Ajax Polling 용)
    @GetMapping("/delivery/api/status")
    @ResponseBody
    public deliveryDTO getDeliveryStatusApi(@RequestParam("d_no") int d_no) {
        return deliveryDao.selectOrderById(d_no);
    }


    // =========================================================================
    // 2. 점주 관련 기능 (주문 내역, 주문 상세, 승인/거절, 상태 변경)
    // =========================================================================

    // 2-1. 점주 가게별 전체 주문 내역 관리 페이지
    @GetMapping("/store/order/history")
    public String storeOrderHistory(
            @RequestParam(value = "r_no", required = false, defaultValue = "1") int r_no,
            @RequestParam(value = "d_stats", required = false) String d_stats,
            @RequestParam(value = "startDate", required = false) String startDate,
            @RequestParam(value = "endDate", required = false) String endDate,
            Model model) {

        List<deliveryDTO> orderHistoryList = deliveryDao.selectOrderListByRno(r_no,d_stats, startDate, endDate);

        int totalOrderCount = orderHistoryList.size();
        int totalRevenue = 0;
        int activeOrderCount = 0;
        int rejectedOrderCount = 0;

        for (deliveryDTO order : orderHistoryList) {
            if ("주문거절".equals(order.getD_stats())) {
                rejectedOrderCount++;
            } else {
            	  // 매출금액 합산
            	totalRevenue += order.getD_total_price();
            	
            	if ("주문접수".equals(order.getD_stats()) || "주문승인".equals(order.getD_stats())
                    || "조리중".equals(order.getD_stats()) || "배달중".equals(order.getD_stats())) {
                activeOrderCount++;
               }
            }
        }

        model.addAttribute("r_no", r_no);
        model.addAttribute("orderHistoryList", orderHistoryList);
        model.addAttribute("totalOrderCount", totalOrderCount);
        model.addAttribute("totalRevenue", totalRevenue);
        model.addAttribute("activeOrderCount", activeOrderCount);
        model.addAttribute("rejectedOrderCount", rejectedOrderCount);

        return "delivery/store_order_history";
    }

    // 2-2. 점주 주문 상세 보기
    @GetMapping("/store/order/detail")
    public String storeOrderDetail(@RequestParam("d_no") int d_no, Model model) {
        deliveryDTO delivery = deliveryDao.selectOrderById(d_no);
        List<dv_menuDTO> orderMenuList = dvMenuDao.selectDeliveryMenusByOrder(d_no);

        model.addAttribute("delivery", delivery);
        model.addAttribute("orderMenuList", orderMenuList);

        return "delivery/store_order_detail";
    }

    // 2-3. 점주 주문 승인 처리 (조리시간 입력 및 거리/시간 계산)
    @PostMapping("/store/order/accept")
    public String acceptOrder(
            @RequestParam("d_no") int d_no,
            @RequestParam("d_cooking_time") int cookingTime) {

        deliveryDTO delivery = deliveryDao.selectOrderById(d_no);

        double storeLat = 35.1795588;
        double storeLng = 129.0756416;

        double distance = deliveryService.calculateDistance(storeLat, storeLng, delivery.getD_lat(), delivery.getD_lng());
        int deliveryTime = deliveryService.estimateDeliveryTimeMinutes(distance);
        Date arrivalTime = deliveryService.calculateArrivalTime(cookingTime, deliveryTime);

        delivery.setD_cooking_time(cookingTime);
        delivery.setD_delivery_time(deliveryTime);
        delivery.setD_arrival_time(arrivalTime);

        deliveryDao.updateOrderAccept(delivery);

        return "redirect:/store/order/detail?d_no=" + d_no;
    }

    // 2-4. 점주 주문 상태 변경 (조리중, 배달중, 배달완료)
    @PostMapping("/store/order/updateStatus")
    public String updateStatus(
            @RequestParam("d_no") int d_no,
            @RequestParam("nextStatus") String nextStatus) {

        deliveryDTO dto = new deliveryDTO();
        dto.setD_no(d_no);
        dto.setD_stats(nextStatus);

        deliveryDao.updateOrderStatus(dto);

        return "redirect:/store/order/detail?d_no=" + d_no;
    }

    // 2-5. 점주 주문 거절 처리
    @PostMapping("/store/order/reject")
    public String rejectOrder(@RequestParam("d_no") int d_no) {
        deliveryDTO dto = new deliveryDTO();
        dto.setD_no(d_no);
        dto.setD_stats("주문거절");

        deliveryDao.updateOrderStatus(dto);

        return "redirect:/store/order/detail?d_no=" + d_no;
    }


    // =========================================================================
    // 3. 관리자 관제 기능 (통합 관제 대시보드, 강제 상태 변경)
    // =========================================================================

    // 3-1. 관리자 배달 관제 대시보드
    @GetMapping("/delivery/admin_delivery_manage")
    public String adminDeliveryManage(
            @RequestParam(value = "restaurantKeyword", required = false) String restaurantKeyword,
            @RequestParam(value = "orderIdKeyword", required = false) String orderIdKeyword,
            @RequestParam(value = "d_stats", required = false) String d_stats,
            @RequestParam(value = "r_name", required = false) String r_name,
            @RequestParam(value = "u_name", required = false) String u_name,
            Model model) {

        List<deliveryDTO> allDeliveryList = deliveryDao.selectOrderList();

        int todayTotalCount = (allDeliveryList != null) ? allDeliveryList.size() : 0;
        int deliveringCount = 0;
        int todayTotalAmount = 0;

        if (allDeliveryList != null) {
            for (deliveryDTO delivery : allDeliveryList) {
                if ("배달중".equals(delivery.getD_stats())) {
                    deliveringCount++;
                }
            }
        }
        
        model.addAttribute("r_name", r_name);
        model.addAttribute("u_name",u_name);
        model.addAttribute("allDeliveryList", allDeliveryList);
        model.addAttribute("todayTotalCount", todayTotalCount);
        model.addAttribute("deliveringCount", deliveringCount);
        model.addAttribute("todayTotalAmount", todayTotalAmount);

        return "delivery/admin_delivery_manage";
    }

    // 3-2. 관리자 강제 상태 변경 (강제 취소/강제 완료)
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

        deliveryDao.updateOrderStatus(dto);

        return "redirect:/delivery/admin_delivery_manage";
    }


    // =========================================================================
    // 4. 결제 및 주문 승인 프로세스
    // =========================================================================

    // 4-1. 배달 주문 및 결제 트랜잭션 처리
    @PostMapping("/delivery/order")
    @Transactional
    public String processOrder(
            @RequestParam("u_no") int u_no,
            @RequestParam("r_no") int r_no,
            @RequestParam("mc_no") int mc_no,
            @RequestParam(value = "py_type", defaultValue = "배달") String py_type,
            @RequestParam("totalPrice") int totalPrice,
            @RequestParam("deliveryFee") int deliveryFee,
            @RequestParam("d_addr") String d_addr,
            @RequestParam("d_detail_addr") String d_detail_addr,
            @RequestParam(value = "d_lat", defaultValue = "35.1765") double d_lat,
            @RequestParam(value = "d_lng", defaultValue = "129.0785") double d_lng) {

        // 1. 배달 기본 정보 생성 및 DB 저장
        deliveryDTO delivery = new deliveryDTO();
        delivery.setU_no(u_no);
        delivery.setR_no(r_no);
        delivery.setD_addr(d_addr + " " + d_detail_addr);
        delivery.setD_stats("주문접수");
        delivery.setD_lat(d_lat);
        delivery.setD_lng(d_lng);

        deliveryDao.insertDelivery(delivery);
        int generatedDno = delivery.getD_no();

        // 2. 장바구니 메뉴를 배달 상세 메뉴(dv_menu) 테이블로 복사
        List<cartMenuDTO> cartList = cartMenuDao.selectCartMenuList(mc_no);
        if (cartList != null && !cartList.isEmpty()) {
            for (cartMenuDTO item : cartList) {
                dv_menuDTO dvMenu = new dv_menuDTO();
                dvMenu.setD_no(generatedDno);
                dvMenu.setMn_no(item.getMn_no());
                dvMenu.setDvm_count(item.getMcm_count());
                dvMenu.setDvm_price(item.getMcm_price());

                dvMenuDao.insertDeliveryMenu(dvMenu);
            }
        }

        // 3. 결제 내역 DB 저장
        paymentDTO pydto = new paymentDTO();
        pydto.setPy_type(py_type);
        pydto.setPy_price(totalPrice + deliveryFee);
        pydto.setD_no(generatedDno);

        paymentDao.paymentInsert(pydto);

        // 4. 장바구니 비우기
        cartMenuDao.clearCartMenu(mc_no);

        // 5. 실시간 배달 상세 페이지로 리다이렉트
        return "redirect:/delivery/detail?d_no=" + generatedDno;
    }
}
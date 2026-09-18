package com.springboot.MUKJA.controller;

import java.security.Principal;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.springboot.MUKJA.dao.IcartMenuDAO;
import com.springboot.MUKJA.dao.IdeliveryDAO;
import com.springboot.MUKJA.dao.Idv_menuDAO;
import com.springboot.MUKJA.dao.paymentDAO;
import com.springboot.MUKJA.dao.restaurantDAO;
import com.springboot.MUKJA.dao.usersDAO;
import com.springboot.MUKJA.dto.cartMenuDTO;
import com.springboot.MUKJA.dto.deliveryDTO;
import com.springboot.MUKJA.dto.dv_menuDTO;
import com.springboot.MUKJA.dto.menuDTO;
import com.springboot.MUKJA.dto.restaurantDTO;
import com.springboot.MUKJA.dto.usersDTO;
import com.springboot.MUKJA.exception.PriceMismatchException;
import com.springboot.MUKJA.service.DeliveryService;
import com.springboot.MUKJA.service.OrderTransactionService;

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
    
    @Autowired
    private restaurantDAO restaurantDao;
    
    @Autowired
    private OrderTransactionService orderTransactionService;

 // =========================================================================
    // 1. 고객 관련 기능 (주문 작성, 배달 추적, 내 주문 내역, API)
    // =========================================================================

    // 1-1-1. 결제창 띄우기 전 금액 사전 검증 API (Ajax 전용)
    @PostMapping("/delivery/order/validate")
    @ResponseBody
    public Map<String, Object> validateOrderPrice(
            @RequestParam("mc_no") int mc_no,
            @RequestParam("totalPrice") int totalPrice) {

        Map<String, Object> result = new HashMap<>();
        try {
            int serverPrice = orderTransactionService.validatePrice(mc_no, totalPrice);
            result.put("valid", true);
            result.put("serverPrice", serverPrice);
        } catch (PriceMismatchException e) {
            result.put("valid", false);
            result.put("message", "주문 금액이 변경되었습니다. 페이지를 새로고침해주세요.");
        } catch (IllegalStateException e) {
            result.put("valid", false);
            result.put("message", e.getMessage());
        }
        return result;
    }
    
    // 1-1. 고객 배달 주문 작성 페이지 이동 [ 주소입력창 (장바구니 이후 페이지)]
    @GetMapping("/delivery/order")
    public String deliveryOrderForm(
            @RequestParam(value = "r_no") int r_no,
            @RequestParam(value = "mc_no") int mc_no,
            @RequestParam(value = "u_no", required = false) Integer reqUno, // ★ required = false 추가로 400 방지
            Principal principal, // ★ 스프링 시큐리티 인증 객체 추가
            HttpSession session,
            Model model) {

        int finalUno = 0;

        // 1. 시큐리티 로그인 정보에서 u_no 조회
        if (principal != null) {
            usersDTO loginUser = usersDao.findById(principal.getName());
            if (loginUser != null) {
                finalUno = loginUser.getU_no();
            }
        } 
        // 2. 예비용 (파라미터나 세션)
        else if (reqUno != null) {
            finalUno = reqUno;
        } else if (session.getAttribute("u_no") != null) {
            finalUno = (Integer) session.getAttribute("u_no");
        }

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
    
    // 1-2. 고객 배달 주문 처리
    @PostMapping("/delivery/order")
    public String processOrder(
            @RequestParam("u_no") int u_no,
            @RequestParam("r_no") int r_no,
            @RequestParam("mc_no") int mc_no,
            @RequestParam(value = "py_type", defaultValue = "배달") String py_type,
            @RequestParam("totalPrice") int totalPrice,
            @RequestParam("d_addr") String d_addr,
            @RequestParam("d_detail_addr") String d_detail_addr,
            @RequestParam(value = "d_lat", defaultValue = "35.1765") double d_lat,
            @RequestParam(value = "d_lng", defaultValue = "129.0785") double d_lng,
            RedirectAttributes redirectAttributes) {

        try {
            int generatedDno = orderTransactionService.processDeliveryOrder(
                    u_no, r_no, mc_no, py_type, totalPrice,
                    d_addr, d_detail_addr, d_lat, d_lng);

            return "redirect:/delivery/detail?d_no=" + generatedDno;

        } catch (PriceMismatchException e) {
            redirectAttributes.addFlashAttribute("errorMsg", "주문 금액이 변경되었습니다. 다시 확인해주세요.");
            return "redirect:/delivery/order?r_no=" + r_no + "&mc_no=" + mc_no;

        } catch (IllegalStateException e) {
            redirectAttributes.addFlashAttribute("errorMsg", e.getMessage());
            return "redirect:/delivery/order?r_no=" + r_no + "&mc_no=" + mc_no;
        }
    }

    // 1-3. 고객 배달 주문 생성 처리
    @PostMapping("/delivery/order/create")
    public String createOrder(
            deliveryDTO dto, 
            @RequestParam(value = "mc_no", defaultValue = "1") int mc_no,
            Principal principal) { // ★ 시큐리티 반영

        if (principal != null && dto.getU_no() <= 0) {
            usersDTO loginUser = usersDao.findById(principal.getName());
            if (loginUser != null) {
                dto.setU_no(loginUser.getU_no());
            }
        }

        List<cartMenuDTO> cartList = cartMenuDao.selectCartMenuList(mc_no);
        int totalPrice = 0;
        if (cartList != null) {
            for (cartMenuDTO item : cartList) {
                totalPrice += (item.getMcm_price() * item.getMcm_count());
            }
        }
        
        int deliveryFee = 3000;
        dto.setD_total_price(totalPrice + deliveryFee);
        
        if (dto.getD_stats() == null || dto.getD_stats().isEmpty()) {
            dto.setD_stats("주문접수");
        }

        deliveryDao.insertDelivery(dto);

        return "redirect:/delivery/detail?d_no=" + dto.getD_no();
    }

    // 1-4. 고객 주문 상세 현황
    @GetMapping("/delivery/detail")
    public String deliveryDetail(@RequestParam("d_no") int d_no, Model model) {
        deliveryDTO delivery = deliveryDao.selectOrderById(d_no);
        List<dv_menuDTO> menuList = dvMenuDao.selectDeliveryMenusByOrder(d_no);

        double storeLat = 35.1795588;
        double storeLng = 129.0756416;

        List<Map<String, Object>> timeStats = deliveryDao.selectTimeStatistics();

        model.addAttribute("delivery", delivery);
        model.addAttribute("menuList", menuList);
        model.addAttribute("storeLat", storeLat);
        model.addAttribute("storeLng", storeLng);
        model.addAttribute("timeStats", timeStats);

        return "delivery/delivery_detail";
    }

    // 1-5. 고객 개인 배달 주문 내역 목록
    @GetMapping("/delivery/user/history")
    public String userDeliveryHistory(
            @RequestParam(value = "u_no", required = false) Integer reqUno, // ★ required = false 추가
            Principal principal, // ★ 시큐리티 정보 반영
            HttpSession session,
            Model model) {

        int u_no = 0;

        if (principal != null) {
            usersDTO loginUser = usersDao.findById(principal.getName());
            if (loginUser != null) {
                u_no = loginUser.getU_no();
            }
        } else if (reqUno != null) {
            u_no = reqUno;
        } else if (session.getAttribute("u_no") != null) {
            u_no = (Integer) session.getAttribute("u_no");
        }
        
        usersDTO user = usersDao.usersView(u_no);
        List<deliveryDTO> myOrderList = deliveryDao.selectOrdersByUser(u_no);

        model.addAttribute("u_no", u_no);
        model.addAttribute("userName", (user != null) ? user.getU_name() : "고객");
        model.addAttribute("myOrderList", myOrderList);

        return "delivery/user_delivery_history";
    }

    // 1-6. 실시간 상태 동기화 API
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
            @RequestParam(value = "r_no", required = false) int r_no,
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
            if ("주문거절".equals(order.getD_stats()) || "주문취소".equals(order.getD_stats())) {
                rejectedOrderCount++;
            } else {
                if ("주문접수".equals(order.getD_stats()) || "주문승인".equals(order.getD_stats())
                    || "조리중".equals(order.getD_stats()) || "배달중".equals(order.getD_stats())) {
                activeOrderCount++;
               }
                
                if(!"주문접수".equals(order.getD_stats())) {
                    totalRevenue += order.getD_total_price();
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
    @GetMapping({"/admin/deliveryManage", "/delivery/admin_delivery_manage"})
    public String adminDeliveryManage(
            @RequestParam(value = "restaurantKeyword", required = false) String restaurantKeyword,
            @RequestParam(value = "orderIdKeyword", required = false) String orderIdKeyword,
            @RequestParam(value = "d_stats", required = false) String d_stats,
            @RequestParam(value = "r_name", required = false) String r_name,
            @RequestParam(value = "u_name", required = false) String u_name,
            Model model) {

        List<deliveryDTO> allDeliveryList = deliveryDao.selectOrderList();
        
        if (allDeliveryList != null) {
            if (restaurantKeyword != null && !restaurantKeyword.trim().isEmpty()) {
                String kw = restaurantKeyword.trim().toLowerCase();
                allDeliveryList = allDeliveryList.stream()
                        .filter(d -> d.getR_name() != null && d.getR_name().toLowerCase().contains(kw))
                        .collect(Collectors.toList());
            }
         
            if (orderIdKeyword != null && !orderIdKeyword.trim().isEmpty()) {
                String kw = orderIdKeyword.trim();
                allDeliveryList = allDeliveryList.stream()
                        .filter(d -> String.valueOf(d.getD_no()).contains(kw))
                        .collect(Collectors.toList());
            }

            if (d_stats != null && !d_stats.trim().isEmpty()) {
                allDeliveryList = allDeliveryList.stream()
                        .filter(d -> d_stats.equals(d.getD_stats()))
                        .collect(Collectors.toList());
            }
        }
        
        int todayTotalCount = 0; 
        int deliveringCount = 0; 
        int todayTotalAmount = 0;

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        String todayStr = sdf.format(new Date());

        if (allDeliveryList != null) {
            for (deliveryDTO delivery : allDeliveryList) {
                boolean isToday = delivery.getD_reg_date() != null 
                        && todayStr.equals(sdf.format(delivery.getD_reg_date()));

                if (isToday) {
                    todayTotalCount++;
                }

                if ("배달중".equals(delivery.getD_stats())) {
                    deliveringCount++;
                }
                
                if (isToday 
                        && delivery.getD_stats() != null 
                        && !"주문접수".equals(delivery.getD_stats()) 
                        && !"주문거절".equals(delivery.getD_stats())) {
                    todayTotalAmount += delivery.getD_total_price();
                }
            }
        }

        model.addAttribute("r_name", r_name);
        model.addAttribute("u_name", u_name);
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

        return "redirect:/admin/deliveryManage";
    }

    // =========================================================================
    // 4. 배달 페이지로 이동
    // =========================================================================
    
	 // GET /delivery/menu
	    @GetMapping("/delivery/menu")
	    public String deliveryMenu(@RequestParam("r_no") int r_no, Principal principal, Model model) {
	
	        int u_no = 0;
	        if (principal != null) {
	            usersDTO loginUser = usersDao.findById(principal.getName());
	            if (loginUser != null) {
	                u_no = loginUser.getU_no();
	            }
	        }
	
	        List<menuDTO> menuList = restaurantDao.menuList(r_no);
	        restaurantDTO restaurant = restaurantDao.restaurantDetail(r_no);
	
	        model.addAttribute("menuList", menuList);
	        model.addAttribute("restaurant", restaurant);
	        model.addAttribute("r_no", r_no);
	        model.addAttribute("u_no", u_no);
	
	        return "delivery/delivery_menu";
	    }

    
}   
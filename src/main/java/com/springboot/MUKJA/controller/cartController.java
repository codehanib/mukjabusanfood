package com.springboot.MUKJA.controller;

import java.net.URLEncoder;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.springboot.MUKJA.dao.IcartMenuDAO;
import com.springboot.MUKJA.dao.restaurantDAO;
import com.springboot.MUKJA.dto.cartMenuDTO;
import com.springboot.MUKJA.dto.menuDTO;
import com.springboot.MUKJA.dto.restaurantDTO;

@Controller
@RequestMapping("/cart")
public class cartController {

    @Autowired
    private IcartMenuDAO cartMenuDao;
    
    @Autowired
    private restaurantDAO restaurantDao;
    
 

    // 1. 장바구니 목록 조회
    @GetMapping
    public String cartPage(@RequestParam(value = "mc_no", defaultValue = "1") int mc_no, 
    					   @RequestParam(value = "r_no", defaultValue = "1") int r_no,
    					   @RequestParam(value = "r_name", defaultValue = "야키토리숯") String r_name,
    						Model model) {
        List<cartMenuDTO> cartList = cartMenuDao.selectCartMenuList(mc_no);

        // 총 금액 계산 (단가 * 수량)
        int totalPrice = 0;
        for (cartMenuDTO item : cartList) {
            totalPrice += (item.getMcm_price() * item.getMcm_count());
        }
        
      

        model.addAttribute("cartList", cartList);
        model.addAttribute("totalPrice", totalPrice);
        model.addAttribute("mc_no", mc_no);
        model.addAttribute("r_name",r_name);
        model.addAttribute("r_no",r_no);

        return "cart/cart"; // /WEB-INF/views/cart/cart.jsp
    } // <--- 누락되었던 닫는 중괄호 추가

    // 2. 수량 수정
    @PostMapping("/update")
    public String updateCount(@RequestParam("mcm_no") int mcm_no,
                              @RequestParam("mcm_count") int mcm_count, // "mam_count" 오타 수정
                              @RequestParam("mc_no") int mc_no,
                              @RequestParam(value = "r_no", defaultValue = "1") int r_no,
                              @RequestParam(value = "r_name", defaultValue = "") String r_name) {
        cartMenuDao.updateCartMenuCount(mcm_no, mcm_count);
        
        String encodedRName = java.net.URLEncoder.encode(r_name, java.nio.charset.StandardCharsets.UTF_8);
        return "redirect:/cart?mc_no=" + mc_no + "&r_no=" + r_no + "&r_name=" + encodedRName;
    }

    // 3. 개별 메뉴 삭제
    @PostMapping("/delete")
    public String deleteItem(@RequestParam("mcm_no") int mcm_no,
                             @RequestParam("mc_no") int mc_no,
                             @RequestParam(value = "r_no", defaultValue = "1") int r_no,
                             @RequestParam(value = "r_name", defaultValue = "") String r_name) {
        cartMenuDao.deleteCartMenu(mcm_no);
        
        String encodedRName = java.net.URLEncoder.encode(r_name, java.nio.charset.StandardCharsets.UTF_8);
        return "redirect:/cart?mc_no=" + mc_no + "&r_no=" + r_no + "&r_name=" + encodedRName;
    }

    // 4. 장바구니 비우기
    @PostMapping("/clear")
    public String clearCart(@RequestParam("mc_no") int mc_no,
				    		@RequestParam(value = "r_no", defaultValue = "1") int r_no,
				            @RequestParam(value = "r_name", defaultValue = "") String r_name) {
        cartMenuDao.clearCartMenu(mc_no);
        
        String encodedRName = java.net.URLEncoder.encode(r_name, java.nio.charset.StandardCharsets.UTF_8);
        return "redirect:/cart?mc_no=" + mc_no + "&r_no=" + r_no + "&r_name=" + encodedRName;
    }
    
    // 5. 배달 메뉴페이지 이동
    @GetMapping("/delivery/menu")
    public String deliveryMenu(@RequestParam(value = "r_no", defaultValue ="1") int r_no, Model model) {
    	 List<menuDTO> menuList = restaurantDao.menuList(r_no);
    	 restaurantDTO restaurant = restaurantDao.restaurantDetail(r_no);
    	 
    	 model.addAttribute("menuList",menuList);
    	 model.addAttribute("restaurant",restaurant);
    	 model.addAttribute("r_no",r_no);
    	 
    	 return "delivery/delivery_menu";
    	 
    }
    
    // 6.장바구니에 주문 메뉴 전달
    @PostMapping("/insert")
    public String insertCart(cartMenuDTO dto,
                             @RequestParam(value = "r_no", defaultValue = "1") int r_no,
                             @RequestParam(value = "r_name", defaultValue = "") String r_name) {
        
        cartMenuDao.insertCartMenu(dto);
        
        // 한글 식당명 URL 인코딩 처리
        String encodedRName = java.net.URLEncoder.encode(r_name, java.nio.charset.StandardCharsets.UTF_8);
        
        return "redirect:/cart?mc_no=" + dto.getMc_no() + "&r_no=" + r_no + "&r_name=" + encodedRName;
    }
}
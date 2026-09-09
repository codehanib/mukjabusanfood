package com.springboot.MUKJA.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.springboot.MUKJA.dao.IcartMenuDAO;
import com.springboot.MUKJA.dto.cartMenuDTO;

@Controller
@RequestMapping("/cart")
public class cartController {

    @Autowired
    private IcartMenuDAO cartMenuDao;

    // 1. 장바구니 목록 조회
    @GetMapping
    public String cartPage(@RequestParam(value = "mc_no", defaultValue = "1") int mc_no, Model model) {
        List<cartMenuDTO> cartList = cartMenuDao.selectCartMenuList(mc_no);

        // 총 금액 계산 (단가 * 수량)
        int totalPrice = 0;
        for (cartMenuDTO item : cartList) {
            totalPrice += (item.getMcm_price() * item.getMcm_count());
        }

        model.addAttribute("cartList", cartList);
        model.addAttribute("totalPrice", totalPrice);
        model.addAttribute("mc_no", mc_no);

        return "cart/cart"; // /WEB-INF/views/cart/cart.jsp
    } // <--- 누락되었던 닫는 중괄호 추가

    // 2. 수량 수정
    @PostMapping("/update")
    public String updateCount(@RequestParam("mcm_no") int mcm_no,
                              @RequestParam("mcm_count") int mcm_count, // "mam_count" 오타 수정
                              @RequestParam("mc_no") int mc_no) {
        cartMenuDao.updateCartMenuCount(mcm_no, mcm_count);
        return "redirect:/cart?mc_no=" + mc_no;
    }

    // 3. 개별 메뉴 삭제
    @PostMapping("/delete")
    public String deleteItem(@RequestParam("mcm_no") int mcm_no,
                             @RequestParam("mc_no") int mc_no) {
        cartMenuDao.deleteCartMenu(mcm_no);
        return "redirect:/cart?mc_no=" + mc_no;
    }

    // 4. 장바구니 비우기
    @PostMapping("/clear")
    public String clearCart(@RequestParam("mc_no") int mc_no) {
        cartMenuDao.clearCartMenu(mc_no);
        return "redirect:/cart?mc_no=" + mc_no;
    }
}
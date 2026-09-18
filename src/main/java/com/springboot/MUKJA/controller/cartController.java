package com.springboot.MUKJA.controller;

import java.security.Principal;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.springboot.MUKJA.dao.IcartMenuDAO;
import com.springboot.MUKJA.dao.usersDAO;
import com.springboot.MUKJA.dto.cartMenuDTO;
import com.springboot.MUKJA.dto.usersDTO;

@Controller
@RequestMapping("/cart")
public class cartController {

    @Autowired
    private IcartMenuDAO cartMenuDao;
    
    @Autowired
    private usersDAO usersDao;

 // 1. 장바구니 페이지 이동 (GET /cart)
    @GetMapping
    public String cartPage(Principal principal, Model model) {
        if (principal == null) {
            return "redirect:/login";
        }

        usersDTO loginUser = usersDao.findById(principal.getName());
        int u_no = loginUser.getU_no();

        // 내 u_no 기반 mc_no 조회
        Integer mc_no = cartMenuDao.selectMcNoByUno(u_no);

        // ★ 장바구니 레코드가 아예 없으면 DB에 새로 생성!
        if (mc_no == null) {
            cartMenuDao.insertNewCartForUser(u_no);
            mc_no = cartMenuDao.selectMcNoByUno(u_no);
        }

        Map<String, Object> storeInfo = cartMenuDao.selectCartStoreInfo(u_no);
        int r_no = 0;
        String r_name = "식당 정보 없음";

        if (storeInfo != null) {
            Object rNoObj = storeInfo.get("R_NO") != null ? storeInfo.get("R_NO") : storeInfo.get("r_no");
            Object rNameObj = storeInfo.get("R_NAME") != null ? storeInfo.get("R_NAME") : storeInfo.get("r_name");
            if (rNoObj != null) r_no = ((Number) rNoObj).intValue();
            if (rNameObj != null) r_name = (String) rNameObj;
        }

        List<cartMenuDTO> cartList = cartMenuDao.selectCartMenuList(mc_no);

        int totalPrice = 0;
        if (cartList != null) {
            for (cartMenuDTO item : cartList) {
                totalPrice += (item.getMcm_price() * item.getMcm_count());
            }
        }

        model.addAttribute("cartList", cartList);
        model.addAttribute("totalPrice", totalPrice);
        model.addAttribute("mc_no", mc_no);
        model.addAttribute("r_no", r_no);
        model.addAttribute("r_name", r_name);
        model.addAttribute("u_no", u_no);

        return "cart/cart";
    }

    // 2. 장바구니 메뉴 담기 (POST /cart/insert)
    @PostMapping("/insert")
    public String insertCart(cartMenuDTO dto,
                             @RequestParam(value = "r_no", defaultValue = "1") int r_no,
                             @RequestParam(value = "r_name", defaultValue = "") String r_name,
                             @RequestParam(value = "forceReplace", defaultValue = "false") boolean forceReplace,
                             Principal principal) {

        if (principal == null) {
            return "redirect:/login";
        }

        usersDTO loginUser = usersDao.findById(principal.getName());
        int u_no = loginUser.getU_no();

        // ★ DB에 유저 장바구니(mc_no)가 없으면 1번으로 안 던지고 즉시 DB에 생성을 해줍니다.
        Integer realMcNo = cartMenuDao.selectMcNoByUno(u_no);
        if (realMcNo == null) {
            cartMenuDao.insertNewCartForUser(u_no);
            realMcNo = cartMenuDao.selectMcNoByUno(u_no);
        }
        dto.setMc_no(realMcNo);
        
        //  현재 장바구니에 실제로 담긴 메뉴 품목이 있는지 확인
        List<cartMenuDTO> currentCartList = cartMenuDao.selectCartMenuList(realMcNo);
        if (currentCartList == null || currentCartList.isEmpty()) {
            // 메뉴가 0개면 DB의 식당 번호를 0(초기 상태)으로 리셋
            cartMenuDao.updateCartRestaurant(realMcNo, 0);
        }

        Integer cartRno = cartMenuDao.selectCartRestaurant(realMcNo);
        String encodedRName = java.net.URLEncoder.encode(r_name, java.nio.charset.StandardCharsets.UTF_8);

        if (cartRno != null && cartRno != 0 && cartRno != r_no) {
            if (!forceReplace) {
                return "redirect:/delivery/menu?r_no=" + r_no
                     + "&r_name=" + encodedRName + "&restaurantConflict=true";
            } else {
                cartMenuDao.clearCartMenu(realMcNo);
            }
        }

        cartMenuDao.insertCartMenu(dto);
        cartMenuDao.updateCartRestaurant(realMcNo, r_no);

        return "redirect:/delivery/menu?r_no=" + r_no + "&r_name=" + encodedRName;
    }

    // 3. 수량 수정 (POST /cart/update)
    @PostMapping("/update")
    public String updateCount(@RequestParam("mcm_no") int mcm_no,
                              @RequestParam("mcm_count") int mcm_count) {
        cartMenuDao.updateCartMenuCount(mcm_no, mcm_count);
        return "redirect:/cart";
    }

    // 4. 개별 메뉴 삭제 (POST /cart/delete)
    @PostMapping("/delete")
    public String deleteItem(@RequestParam("mcm_no") int mcm_no) {
        cartMenuDao.deleteCartMenu(mcm_no);
        return "redirect:/cart";
    }

    // 5. 장바구니 비우기 (POST /cart/clear)
    @PostMapping("/clear")
    public String clearCart(@RequestParam("mc_no") int mc_no) {
        cartMenuDao.clearCartMenu(mc_no);
        return "redirect:/cart";
    }
}
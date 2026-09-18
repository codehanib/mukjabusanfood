package com.springboot.MUKJA.service;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.springboot.MUKJA.dao.IcartMenuDAO;
import com.springboot.MUKJA.dao.IdeliveryDAO;
import com.springboot.MUKJA.dao.Idv_menuDAO;
import com.springboot.MUKJA.dao.paymentDAO;
import com.springboot.MUKJA.dto.cartMenuDTO;
import com.springboot.MUKJA.dto.deliveryDTO;
import com.springboot.MUKJA.dto.dv_menuDTO;
import com.springboot.MUKJA.dto.paymentDTO;
import com.springboot.MUKJA.exception.PriceMismatchException;

@Service
public class OrderTransactionService {

    private static final int DELIVERY_FEE = 3000; // 배달팁 3,000원 고정

    @Autowired
    private IcartMenuDAO cartMenuDao;

    @Autowired
    private IdeliveryDAO deliveryDao;

    @Autowired
    private Idv_menuDAO dvMenuDao;

    @Autowired
    private paymentDAO paymentDao;

    /**
     * 서버 기준 금액 재계산 (장바구니 메뉴 총액 + 배달비)
     */
    private int calculateServerPrice(int mc_no) {
        List<cartMenuDTO> cartList = cartMenuDao.selectCartMenuList(mc_no);
        if (cartList == null || cartList.isEmpty()) {
            throw new IllegalStateException("장바구니가 비어 있습니다.");
        }

        int serverTotalPrice = 0;
        for (cartMenuDTO item : cartList) {
            serverTotalPrice += (item.getMcm_price() * item.getMcm_count());
        }
        return serverTotalPrice + DELIVERY_FEE;
    }

    /**
     * 결제창 띄우기 전, 금액만 검증 (INSERT 없음)
     * 검증 통과 시 서버 계산 금액을 반환
     */
    public int validatePrice(int mc_no, int clientTotalPrice) {
        int serverFinalPrice = calculateServerPrice(mc_no);

        if (serverFinalPrice != clientTotalPrice) {
            throw new PriceMismatchException("주문 금액이 일치하지 않습니다.");
        }
        return serverFinalPrice;
    }

    @Transactional
    public int processDeliveryOrder(
            int u_no, int r_no, int mc_no, String py_type,
            int clientTotalPrice, String d_addr, String d_detail_addr,
            double d_lat, double d_lng) {

        // 1~2. 금액 검증 (분리된 메서드 재사용)
        int serverFinalPrice = validatePrice(mc_no, clientTotalPrice);

        // 3. delivery 테이블에 배달 정보 Insert
        deliveryDTO delivery = new deliveryDTO();
        delivery.setU_no(u_no);
        delivery.setR_no(r_no);
        delivery.setD_addr(d_addr + " " + d_detail_addr);
        delivery.setD_stats("주문접수");
        delivery.setD_lat(d_lat);
        delivery.setD_lng(d_lng);

        deliveryDao.insertDelivery(delivery);
        int generatedDno = delivery.getD_no();

        // 4. dv_menu 테이블에 주문 상세 메뉴들 Insert
        List<cartMenuDTO> cartList = cartMenuDao.selectCartMenuList(mc_no);
        for (cartMenuDTO item : cartList) {
            dv_menuDTO dvMenu = new dv_menuDTO();
            dvMenu.setD_no(generatedDno);
            dvMenu.setMn_no(item.getMn_no());
            dvMenu.setDvm_count(item.getMcm_count());
            dvMenu.setDvm_price(item.getMcm_price());
            dvMenuDao.insertDeliveryMenu(dvMenu);
        }

        // 5. payment 테이블에 결제 정보 Insert
        paymentDTO pydto = new paymentDTO();
        pydto.setPy_type(py_type);
        pydto.setPy_price(serverFinalPrice);
        pydto.setD_no(generatedDno);
        paymentDao.paymentInsert(pydto);

        // 6. 주문 완료 후 장바구니 비우기
        cartMenuDao.clearCartMenu(mc_no);

        return generatedDno;
    }
}
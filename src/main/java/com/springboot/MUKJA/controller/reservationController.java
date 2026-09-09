package com.springboot.MUKJA.controller;

import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.springboot.MUKJA.dao.reservationDAO;
import com.springboot.MUKJA.dao.usersDAO;
import com.springboot.MUKJA.dto.reservationDTO;
import com.springboot.MUKJA.dto.usersDTO;

@Controller
@RequestMapping("/reservation")
public class reservationController {

    @Autowired
    private reservationDAO reservationDAO;
    
    @Autowired
    private usersDAO usersDAO;
    
    @GetMapping("/reservationInsert")
    public String resvationC(@RequestParam("r_no") int r_no,
            @RequestParam(value = "res_day", required = false) String res_day,
            @RequestParam(value = "res_count", required = false) String res_count,
            @RequestParam(value = "res_time", required = false) String res_time,
            Model model, Authentication authentication) throws Exception {

        List<Integer> paymentRequired = Arrays.asList(1704, 1699, 1692);
        boolean payment = paymentRequired.contains(r_no);

        model.addAttribute("r_no", r_no);
        model.addAttribute("res_day", res_day);
        model.addAttribute("res_count", res_count);
        model.addAttribute("res_time", res_time);
        model.addAttribute("payment", payment);
        
        if(res_day != null && !res_day.isEmpty()) {
        	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        	Date parsedDay = sdf.parse(res_day);
        	int waitCount = reservationDAO.reservationWaitCount(r_no, parsedDay);
        	model.addAttribute("waitCount",waitCount);
        }

        if (authentication != null && authentication.isAuthenticated()
                && !"anonymousUser".equals(authentication.getName())) {
            usersDTO loginUser = usersDAO.findById(authentication.getName());
            model.addAttribute("loginName", loginUser.getU_name());

            String u_tel = loginUser.getU_tel();
            if (u_tel != null) {
                String[] telParts = u_tel.split("-");
                if (telParts.length == 3) {
                    model.addAttribute("tel1", telParts[0]);
                    model.addAttribute("tel2", telParts[1]);
                    model.addAttribute("tel3", telParts[2]);
                }
            }
        }

        return "reservation/reservationInsert";
    }
    @PostMapping("/reservationInsert")
    public String reservationInsert(reservationDTO dto, @RequestParam("res_tel1") String tel1,
            @RequestParam("res_tel2") String tel2,
            @RequestParam("res_tel3") String tel3,
            Authentication authentication) {

        dto.setRes_tel(tel1 + "-" + tel2 + "-" + tel3);

        List<Integer> paymentRequired = Arrays.asList(1704, 1699, 1692);
        if (paymentRequired.contains(dto.getR_no())) {
            dto.setRes_price(1000);
        }

        if (authentication != null && authentication.isAuthenticated()
                && !"anonymousUser".equals(authentication.getName())) {
            String u_id = authentication.getName();
            usersDTO loginUser = usersDAO.findById(u_id);
            dto.setU_no(loginUser.getU_no());
        }

        dto.setRes_stats("대기중");
        reservationDAO.reservationInsert(dto);

        return "redirect:/reservation/reservationDetail?res_no=" + dto.getRes_no();
    }
    @GetMapping("/reservationDetail")
    public String reservationDetail(@RequestParam("res_no") int res_no, Model model) {
        reservationDTO dto = reservationDAO.reservationDetail(res_no);
        model.addAttribute("dto", dto);
        return "reservation/reservationDetail";
    }
    
    // 예약목록 확인
    @GetMapping("/myList")
    public String myResvationList(Model model, Authentication authentication) {

        if (authentication == null || !authentication.isAuthenticated()
                || "anonymousUser".equals(authentication.getName())) {
        	return "redirect:/login/login";
        }
          usersDTO loginUser = usersDAO.findById(authentication.getName());
          List<reservationDTO> myList = reservationDAO.myReservationList(loginUser.getU_no());
          
          
          model.addAttribute("myList",myList);
        

        return "reservation/myList";
    }
    
    //비회원 예약목록
    @GetMapping("/guestForm")
    public String guestForm() {
    	return "reservation/guestForm";
    }
    
    @PostMapping("/guestSearch")
    public String guestSearch(
    		@RequestParam("res_tel1") String tel1,
            @RequestParam("res_tel2") String tel2,
            @RequestParam("res_tel3") String tel3,
            Model model) {
    	String res_tel = tel1 + "-" + tel2 + "-" + tel3;
    	List<reservationDTO> guestList = reservationDAO.myReservationGuest(res_tel);
    	
    	if(guestList.isEmpty()) {
    		model.addAttribute("msg","일치하는 예약이 없습니다.");
    		return "reservation/guestForm";
    	}
    	model.addAttribute("myList",guestList);
    	return "reservation/myList";
    }
    
}
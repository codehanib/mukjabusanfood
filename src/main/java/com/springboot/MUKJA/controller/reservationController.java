package com.springboot.MUKJA.controller;

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
    public String resvationInsert(@RequestParam("r_no")int r_no,Model model) {
    	model.addAttribute("r_no",r_no);
    	return "reservation/reservationInsert";
    }
    @PostMapping("/reservationInsert")
    public String reservationInsert(reservationDTO dto,@RequestParam("res_tel1") String tel1,
            @RequestParam("res_tel2") String tel2,
            @RequestParam("res_tel3") String tel3,
            Authentication authentication) {
    	if(authentication != null && authentication.isAuthenticated()
    			&& !"anonymousUser".equals(authentication.getName())) {
    		String u_id = authentication.getName();
    		usersDTO loginUser = usersDAO.findById(u_id);
    		dto.setU_no(loginUser.getU_no());
    		dto.setRes_tel(tel1 + "-"+ tel2 + "-" + tel3);
    	}
    	dto.setRes_stats("대기중");
    	reservationDAO.reservationInsert(dto);
    	
    	return "redirect:/reservation/reservationDetail?res_no=" + dto.getRes_no();
    }
}
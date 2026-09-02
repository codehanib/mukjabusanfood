package com.springboot.MUKJA.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.springboot.MUKJA.dao.usersDAO;
import com.springboot.MUKJA.dto.usersDTO;

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class UsersController {

    @Autowired
    private usersDAO usersDAO;

    @Autowired
    private PasswordEncoder passwordEncoder;
    @GetMapping("/")
    public String index() {
        return "redirect:/login/login"; // 첫 화면 접속 시 /login/login 으로 리다이렉트
    }

    @PostMapping("/usersInsert")
    public String usersInsert(HttpServletRequest request, usersDTO dto) {
         
        String u_id = request.getParameter("u_id");
        String u_name = request.getParameter("u_name"); // 이름 추가
        String u_tel = request.getParameter("u_tel");
        String u_tel2 = request.getParameter("u_tel2");
	    String u_tel3 = request.getParameter("u_tel3");
        String u_addr = request.getParameter("u_addr");
        String u_zipno = request.getParameter("u_zipno");
        String u_email = request.getParameter("u_email");
        String u_passwd = request.getParameter("u_passwd");

        dto.setU_id(u_id);
        dto.setU_name(u_name); // DTO 바인딩
        dto.setU_tel(u_tel + "-" + u_tel2 + "-" + u_tel3);
        dto.setU_addr(u_addr);
        dto.setU_zipno(u_zipno);
        dto.setU_email(u_email);

        // 비밀번호 암호화
        if (u_passwd != null && !u_passwd.isEmpty()) {
            dto.setU_passwd(passwordEncoder.encode(u_passwd));
        }

        int result = usersDAO.usersInsert(dto);

        System.out.println("회원가입 INSERT 결과 = " + result);
        System.out.println("회원가입 DTO = " + dto);

        return "redirect:/login/login"; // LoginController 매핑 경로로 변경
    }

    @RequestMapping("/jusoPopup")
    public String jusoPopup() {
        return "login/jusoPopup";
    }
    @RequestMapping("/main")
    public String main() {
        return "main";
    }
}
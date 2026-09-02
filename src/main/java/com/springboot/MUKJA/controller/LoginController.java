package com.springboot.MUKJA.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/login")
public class LoginController {
	
	

    @GetMapping("/login")
    public String loginForm() {
        return "login/login";
    }

    @RequestMapping("/writeForm")
    public String writeForm() {
        return "login/writeForm";
    }

    @RequestMapping("/loginsuccess")
    public String loginSuccess() {
        return "login/loginsuccess"; // WEB-INF/views/login/loginsuccess.jsp 호출
    }
    @RequestMapping("/loginError")
	public String loginError() {
		return "login/loginError";
	}
}
package com.springboot.MUKJA.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.springboot.MUKJA.dao.usersDAO;
import com.springboot.MUKJA.dto.usersDTO;

@Controller
@RequestMapping("/login")
public class LoginController {
	
	@Autowired
	private usersDAO usersDAO;

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
        return "login/loginsuccess";
    }
    @RequestMapping("/loginError")
	public String loginError() {
		return "login/loginError";
	}
}
package com.springboot.MUKJA.controller;

import com.springboot.MUKJA.dao.usersDAO;
import com.springboot.MUKJA.dto.usersDTO;
import com.springboot.MUKJA.service.EmailVerificationService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
public class EmailController {

    @Autowired
    private EmailVerificationService emailVerificationService;

    @Autowired
    private usersDAO usersDAO;

    @PostMapping("/email/sendCode")
    public Map<String, Object> sendCode(@RequestParam("email") String email,
                                         @RequestParam(value = "u_id", required = false) String u_id,
                                         HttpSession session) {
        Map<String, Object> result = new HashMap<>();

        if (u_id != null) {
            usersDTO dto = usersDAO.findById(u_id);
            if (dto == null || !email.equals(dto.getU_email())) {
                result.put("success", false);
                result.put("message", "아이디와 이메일이 일치하는 회원이 없습니다.");
                return result;
            }
        }

        try {
            emailVerificationService.sendCode(email, session);
            result.put("success", true);
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "이메일 발송에 실패했습니다.");
        }
        return result;
    }

    @PostMapping("/email/verifyCode")
    public Map<String, Object> verifyCode(@RequestParam("email") String email, @RequestParam("code") String code) {
        Map<String, Object> result = new HashMap<>();
        String token = emailVerificationService.verifyCode(email, code);
        if (token != null) {
            result.put("verified", true);
            result.put("token", token);
        } else {
            result.put("verified", false);
        }
        return result;
    }
}
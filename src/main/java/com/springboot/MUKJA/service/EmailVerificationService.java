package com.springboot.MUKJA.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import jakarta.servlet.http.HttpSession;

import java.util.Random;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;

@Service
public class EmailVerificationService {

    @Autowired
    private EmailService emailService;

    private static final long CODE_TTL_MILLIS = 5 * 60 * 1000; // 5분

    // 인증번호 저장소 (email -> code / 발급시간)
    private final ConcurrentHashMap<String, String> codeMap = new ConcurrentHashMap<>();
    private final ConcurrentHashMap<String, Long> codeTimeMap = new ConcurrentHashMap<>();

    // 인증완료 토큰 저장소 (token -> email)
    private final ConcurrentHashMap<String, String> verifiedTokenMap = new ConcurrentHashMap<>();

    public void sendCode(String email, HttpSession session) {
        String code = String.valueOf(100000 + new Random().nextInt(900000));
        codeMap.put(email, code);
        codeTimeMap.put(email, System.currentTimeMillis());
        emailService.sendVerificationCode(email, code);
    }

    public String verifyCode(String email, String inputCode) {
        String savedCode = codeMap.get(email);
        Long savedTime = codeTimeMap.get(email);

        boolean expired = savedTime == null || (System.currentTimeMillis() - savedTime > CODE_TTL_MILLIS);
        boolean match = savedCode != null && savedCode.equals(inputCode) && !expired;

        if (match) {
            String token = UUID.randomUUID().toString();
            verifiedTokenMap.put(token, email);
            codeMap.remove(email);
            codeTimeMap.remove(email);
            return token;
        }
        return null;
    }

    public boolean isVerifiedByToken(String email, String token) {
        if (token == null) return false;
        String verifiedEmail = verifiedTokenMap.get(token);
        return verifiedEmail != null && verifiedEmail.equals(email);
    }

    public void clearToken(String token) {
        verifiedTokenMap.remove(token);
    }
}
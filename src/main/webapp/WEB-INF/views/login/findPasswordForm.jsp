<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>비밀번호 찾기</title>
<script src="/js/writeForm.js"></script>
<link rel="stylesheet" href="/css/login.css">
</head>
<body class="login-body" onload="checkFindPasswordError();">
    <div class="login-wrapper">
        <div class="login-card">

            <div class="login-title">
                <h2>비밀번호 찾기</h2>
                <div class="title-line"></div>
            </div>

            

            <div class="input-box">
                <input type="text" id="u_id" placeholder="아이디">
                <input type="button" value="인증번호 발송" onclick="sendResetCode();" class="btn-join">
            </div>

            <div id="codeArea" style="display:none;">
                <div class="input-box">
                    <input type="text" id="code" placeholder="인증번호 6자리">
                    <input type="button" value="인증확인" onclick="verifyResetCode();" class="btn-login">
                </div>
            </div>
            
            <div class="input-box">
                <input type="text" id="email" placeholder="이메일">
            </div>

        </div>

        <p class="copyright">© 2026 MUKJA. All rights reserved.</p>
    </div>
</body>
</html>
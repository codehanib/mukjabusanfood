<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>새 비밀번호 설정</title>
<script src="/js/writeForm.js"></script>
<link rel="stylesheet" href="/css/mypage.css">
</head>
<body class="login-body">
    <div class="login-wrapper">
        <div class="login-card">

            <div class="login-title">
                <h2>새 비밀번호 설정</h2>
                <div class="title-line"></div>
            </div>

            <form action="/password/reset" method="post" name="pwForm" onsubmit="return checkPasswd();">
                <input type="hidden" name="u_id" value="${u_id}">
                <input type="hidden" name="email" value="${email}">
                <input type="hidden" name="token" value="${token}">

                <div class="input-box">
                    <input type="password" name="u_passwd" placeholder="새 비밀번호 (영문, 숫자, 특수문자 포함 8~16자리)">
                </div>
                <div class="input-box">
                    <input type="password" name="u_passwd2" placeholder="새 비밀번호 확인">
                </div>

                <button type="submit" class="btn-login">변경하기</button>
            </form>

        </div>

        <p class="copyright">© 2026 MUKJA. All rights reserved.</p>
    </div>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>비밀번호 확인</title>
<link rel="stylesheet" href="/css/login.css">
</head>

<body class="login-body">

<div class="login-wrapper">

    <div class="login-card">

        <div class="login-title">
            <h2>비밀번호 확인</h2>
            <div class="title-line"></div>
        </div>

        <div class="login-guide">
            회원정보 수정과 회원 탈퇴를 위해<br>
            비밀번호를 입력하세요.
        </div>

        <form name="passwordCheckForm"
              method="post"
              action="/users/passwordCheck">

            <input type="hidden"
                   name="mode"
                   value="${mode}">

            <div class="input-box">
                <input type="password"
                       name="u_passwd"
                       placeholder="PASSWORD">
            </div>

            <input type="submit" value="확인" class="btn-login">

        </form>

        <c:if test="${not empty msg}">
            <p class="pwcheck-msg">${msg}</p>
        </c:if>

    </div>

</div>

</body>
</html>
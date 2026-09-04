<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>새 비밀번호 설정</title>
<script src="/js/writeForm.js"></script>
</head>
<body>
    <div class="title">새 비밀번호 설정</div>

    <form action="/password/reset" method="post" name="pwForm" onsubmit="return checkPasswd();">
        <input type="hidden" name="u_id" value="${u_id}">
        <input type="hidden" name="email" value="${email}">
        <input type="hidden" name="token" value="${token}">

        <p>새 비밀번호</p>
        <input type="password" name="u_passwd" placeholder="영문, 숫자, 특수문자를 포함하여 8~16자리">
        <p>새 비밀번호 확인</p>
        <input type="password" name="u_passwd2" placeholder="영문, 숫자, 특수문자를 포함하여 8~16자리">
        <button type="submit">변경하기</button>
    </form>
</body>
</html>
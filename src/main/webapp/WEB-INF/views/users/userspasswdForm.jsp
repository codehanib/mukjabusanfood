<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>비밀번호 변경</title>
<script src="/js/writeForm.js"></script>
</head>
<body>
    <div class="title">비밀번호 변경</div>

    <form action="/users/userspasswd" method="post" name="pwForm" onsubmit="return checkPasswd();">
        <p>새 비밀번호</p>
        <input type="password" name="u_passwd" placeholder="영문, 숫자, 특수문자를 포함하여 8~16자리">
        <p>새 비밀번호 확인</p>
        <input type="password" name="u_passwd2" placeholder="영문, 숫자, 특수문자를 포함하여 8~16자리">
        <button type="submit">변경하기</button>
    </form>
</body>
</html>
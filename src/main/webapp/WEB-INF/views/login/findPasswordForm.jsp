<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>비밀번호 찾기</title>
<script src="/js/writeForm.js"></script>
</head>
<body onload="checkFindPasswordError();">
    <div class="title">비밀번호 찾기</div>

    <p>아이디</p>
    <input type="text" id="u_id">

    <p>이메일</p>
    <input type="text" id="email">
    <input type="button" value="인증번호 발송" onclick="sendResetCode();">

    <div id="codeArea" style="display:none;">
        <p>인증번호</p>
        <input type="text" id="code">
        <input type="button" value="인증확인" onclick="verifyResetCode();">
    </div>
</body>
</html>
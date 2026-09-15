<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>예약 완료</title>
<link rel="stylesheet" href="/css/mypage.css">
</head>
<body>
<%@ include file="/WEB-INF/views/header.jsp" %>

<div class="mypage-container">

    <div class="mypage-title">예약이 접수되었습니다</div>

    <table class="info-table">
        <tr><th>대기번호</th><td>${dto.res_num}번</td></tr>
        <tr><th>예약자 이름</th><td>${dto.res_name}</td></tr>
        <tr><th>연락처</th><td>${dto.res_tel}</td></tr>
        <tr><th>예약날짜</th><td><fmt:formatDate value="${dto.res_day}" pattern="yyyy년 MM월 dd일" /></td></tr>
        <tr><th>예약시간</th><td>${dto.res_time}</td></tr>
        <tr><th>인원수</th><td>${dto.res_count}명</td></tr>
        <tr><th>예약상태</th><td>${dto.res_stats}</td></tr>
        <tr><th>대기현황</th><td>내 앞에 ${dto.res_wait}팀 대기중</td></tr>
    </table>

    <div class="info-actions">
        <a href="/main" class="primary">홈으로</a>
    </div>

</div>

</body>
</html>
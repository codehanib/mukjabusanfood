<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>예약 수정</title>
<link rel="stylesheet" href="/css/mypage.css">
</head>
<body>
<%@ include file="/WEB-INF/views/header.jsp" %>
<div class="mypage-container">
    <div class="mypage-title">예약 수정</div>

    <form action="/reservation/reservationUpdateForm" method="post">
        <input type="hidden" name="res_no" value="${dto.res_no}">

        <table class="info-table">
            <tr>
                <th>예약자 이름</th>
                <td><input type="text" name="res_name" value="${dto.res_name}"></td>
            </tr>
            <tr>
                <th>연락처</th>
                <td><input type="text" name="res_tel" value="${dto.res_tel}"></td>
            </tr>
            <tr>
                <th>예약날짜</th>
                <td><input type="date" name="res_day" value="<fmt:formatDate value='${dto.res_day}' pattern='yyyy-MM-dd'/>"></td>
            </tr>
            <tr>
                <th>예약시간</th>
                <td><input type="text" name="res_time" value="${dto.res_time}"></td>
            </tr>
            <tr>
                <th>인원수</th>
                <td><input type="number" name="res_count" value="${dto.res_count}" min="1"></td>
            </tr>
        </table>

        <button type="submit" class="btn">수정하기</button>
    </form>
</div>
<%@ include file="/WEB-INF/views/footer.jsp" %>
</body>
</html>
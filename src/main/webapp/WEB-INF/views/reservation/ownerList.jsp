<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>


<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>예약관리</title>
<link rel="stylesheet" href="/css/mypage.css">
</head>
<body>
<%@ include file="/WEB-INF/views/header.jsp" %>
<div class="mypage-container">

    <div class="mypage-title">대기 목록</div>

    <table class="list-table">
        <tr>
            <th>대기번호</th>
            <th>예약자</th>
            <th>연락처</th>
            <th>날짜</th>
            <th>시간</th>
            <th>인원</th>
            <th>처리</th>
        </tr>
        <c:forEach var="res" items="${list}">
            <tr>
                <td>${res.res_num}</td>
                <td>${res.res_name}</td>
                <td>${res.res_tel}</td>
                <td><fmt:formatDate value="${res.res_day}" pattern="yyyy-MM-dd" /></td>
                <td>${res.res_time}</td>
                <td>${res.res_count}명</td>
                <td>
                    <form action="/reservation/ownerStatusUpdate" method="post" style="display:inline">
                        <input type="hidden" name="res_no" value="${res.res_no}">
                        <input type="hidden" name="res_stats" value="완료">
                        <input type="hidden" name="r_no" value="${res.r_no}">
                        <input type="hidden" name="res_day" value="<fmt:formatDate value="${res.res_day}" pattern="yyyy-MM-dd"/>">
                        <button type="submit" class="btn">완료</button>
                    </form>
                    <form action="/reservation/ownerStatusUpdate" method="post" style="display:inline">
                        <input type="hidden" name="res_no" value="${res.res_no}">
                        <input type="hidden" name="res_stats" value="취소">
                        <input type="hidden" name="r_no" value="${res.r_no}">
                        <input type="hidden" name="res_day" value="<fmt:formatDate value="${res.res_day}" pattern="yyyy-MM-dd"/>">
                        <button type="submit" class="btn-outline">취소</button>
                    </form>
                </td>
            </tr>
        </c:forEach>
    </table>

    <c:if test="${empty list}">
        <p>대기가 없습니다.</p>
    </c:if>

    <div class="mypage-title">전체 예약 현황</div>

    <table class="list-table">
        <tr>
            <th>예약자</th>
            <th>연락처</th>
            <th>날짜</th>
            <th>시간</th>
            <th>인원</th>
            <th>상태</th>
        </tr>
        <c:forEach var="res" items="${allList}">
            <tr>
                <td>${res.res_name}</td>
                <td>${res.res_tel}</td>
                <td><fmt:formatDate value="${res.res_day}" pattern="yyyy-MM-dd" /></td>
                <td>${res.res_time}</td>
                <td>${res.res_count}명</td>
                <td>${res.res_stats}</td>
            </tr>
        </c:forEach>
    </table>

    <c:if test="${empty allList}">
        <p>예약 현황이 없습니다.</p>
    </c:if>

</div>
<%@ include file="/WEB-INF/views/footer.jsp" %>
</body>
</html>
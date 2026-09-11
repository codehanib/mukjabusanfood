<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>


<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>예약목록</title>
<link rel="stylesheet" href="/css/main.css">
<link rel="stylesheet" href="/css/mypage.css">
</head>
<body>
<%@ include file="/WEB-INF/views/header.jsp" %>
	<main class="mypage-container">

		<div class="mypage-title">
			예약목록
		</div>

		<!-- 예약 확인 -->
		<c:choose>
			<c:when test="${not empty myList}">
				<table class="info-table reservation-table" width="700">
					<tr>
						<th>대기번호</th>
						<th>식당</th>
						<th>예약날짜</th>
						<th>예약시간</th>
						<th>인원</th>
						<th>상태</th>
						<th>상세</th>
					</tr>
					<c:forEach var="res" items="${myList}">
						<tr>
							<td>${res.res_num}</td>
							<td>${res.r_name}</td>
							<td><fmt:formatDate value="${res.res_day}"
									pattern="yyyy-MM-dd" /></td>
							<td>${res.res_time}</td>
							<td>${res.res_count}</td>
							<td>${res.res_stats}</td>
							<td>
								<a href="/reservation/reservationDetail?res_no=${res.res_no}" class="btn-outline">보기</a>
								<form action="/reservation/cancel" method="post" style="display: inline">
									<input type="hidden" name="res_no" value="${res.res_no}">
									<button type="submit" onclick="return confirm('예약을 취소하시겠습니까?')" class="btn">취소</button>
								</form>
							</td>
						</tr>
					</c:forEach>
				</table>
			</c:when>
			<c:otherwise>
				<p class="info-box" style="text-align:center; color:#777;">대기중인 예약이 없습니다.</p>
			</c:otherwise>
		</c:choose>

		<c:if test="${not empty history}">
			<div class="mypage-title">지난 예약 기록</div>
			<table class="info-table reservation-table" width="700">
				<tr>
					<th>식당</th>
					<th>예약날짜</th>
					<th>인원</th>
				</tr>
				<c:forEach var="res" items="${history}">
					<tr>
						<td>${res.r_name}</td>
						<td><fmt:formatDate value="${res.res_day}"
								pattern="yyyy-MM-dd" /></td>
						<td>${res.res_count}</td>
					</tr>
				</c:forEach>
			</table>
		</c:if>

	</main>

</body>
</html>
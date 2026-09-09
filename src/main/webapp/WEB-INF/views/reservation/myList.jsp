<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
	
	
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>예약목록</title>
</head>
<body>

	<main>

		<div>
			<h2>예약목록</h2>
			<p>MUKJA에 오신 것을 환영합니다.</p>
		</div>

		<!-- 예약 확인 -->
		<c:choose>
			<c:when test = "${not empty myList}">
			<table width="700" border="1">
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
						<td><fmt:formatDate value="${res.res_day}" pattern="yyyy-MM-dd"/></td>
						<td>${res.res_time}</td>
						<td>${res.res_count}</td>
						<td>${res.res_stats}</td>
						<td><a href="/reservation/reservationDetail?res_no=${res.res_no}">보기</a></td>
					</tr>
				</c:forEach>
			</table>	
		</c:when>
			<c:otherwise>
				<p>예약 내역이 없습니다.</p>
			</c:otherwise>
		</c:choose>
	</main>

</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>


<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>예약목록</title>
<link rel="stylesheet" href="/css/mypage.css">
</head>
<body>
	<%@ include file="/WEB-INF/views/header.jsp"%>
	<main>

		<div class="mypage-container">
			<h2 class="mypage-title">예약목록</h2>
			<p class="mypage-subtext">MUKJA에 오신 것을 환영합니다.</p>

			<!-- 예약 확인 -->
			<c:choose>
				<c:when test="${not empty myList}">
					<table class="list-table reservation-table">
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
								<td>${res.r_no}</td>
								<td><fmt:formatDate value="${res.res_day}"
										pattern="yyyy-MM-dd" /></td>
								<td>${res.res_time}</td>
								<td>${res.res_count}</td>
								<td>${res.res_stats}</td>
								<td>
									<div
										style="display: flex; justify-content: center; align-items: center; gap: 8px;">
										<a href="/reservation/reservationDetail?res_no=${res.res_no}"
											class="btn-outline">보기</a>
										<form action="/reservation/guestCancel" method="post"
											style="display: inline-flex; margin: 0;">
											<input type="hidden" name="res_no" value="${res.res_no}">
											<input type="hidden" name="res_name" value="${res.res_name}">
											<input type="hidden" name="res_tel" value="${res.res_tel}">
											<button type="submit" class="btn"
												onclick="return confirm('예약을 취소하시겠습니까?')">취소</button>
										</form>
									</div>
								</td>
							</tr>
						</c:forEach>
					</table>
				</c:when>
				<c:otherwise>
					<div class="empty-state">
						<p>예약 내역이 없습니다.</p>
					</div>
				</c:otherwise>
			</c:choose>
		</div>
	</main>
<%@ include file="/WEB-INF/views/footer.jsp" %>
</body>
</html>
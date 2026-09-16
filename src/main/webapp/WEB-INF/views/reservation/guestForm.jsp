<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>


<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>예약조회</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/mypage.css">
</head>
<body>
	<%@ include file="/WEB-INF/views/header.jsp"%>
	<main>

		<div class="mypage-container">
			<h2 class="mypage-title">예약조회</h2>
			<p>예약자 이름과 연락처를 입력해주세요.</p>

			<c:if test="${not empty msg}">
				<p>${msg}</p>
			</c:if>

			<!-- 예약 조회 -->
			<form action="/reservation/guestSearch" method="post">
				<table class="info-table" width="500">
					<tr>
						<th><label for="res_name">예약자 이름</label></th>
						<td><input type="text" name="res_name" id="res_name"
							placeholder="이름을 입력해주세요"></td>
					</tr>
					<tr>
						<th><label for="res_tel">휴대전화</label></th>
						<td><input type="text" name="res_tel1" id="res_tel1"
							value="010" maxlength="3"> - <input type="text"
							name="res_tel2" id="res_tel2" size="4" maxlength="4"
							placeholder="0000"> - <input type="text" name="res_tel3"
							id="res_tel3" size="4" maxlength="4" placeholder="0000"></td>
					</tr>
				</table>
				<div class="info-actions">
					<input type="submit" value="조회하기" class="btn">
				</div>
			</form>
	</main>
	<%@ include file="/WEB-INF/views/footer.jsp"%>
</body>
</html>
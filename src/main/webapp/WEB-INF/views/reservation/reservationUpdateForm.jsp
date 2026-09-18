
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html lang="ko">

<head>
<meta charset="UTF-8">
<title>예약 수정</title>

<link rel="stylesheet" href="/css/mypage.css">
<script src="${pageContext.request.contextPath}/js/payment.js"></script>

</head>

<body>

	<%@ include file="/WEB-INF/views/header.jsp"%>

	<div class="mypage-container">

		<div class="mypage-title">예약 수정</div>

		<p style="color: #777; margin-bottom: 20px;">예약 정보를 수정해주세요.</p>

		<form action="/reservation/reservationUpdateForm" method="post"
			name="reservationUpdate" onsubmit="return checkUpdate();">

			<input type="hidden" name="res_no" value="${dto.res_no}">

			<table class="info-table">

				<!-- 예약자 이름 -->
				<tr>
					<th><label for="res_name">예약자 이름</label></th>
					<td><input type="text" name="res_name" id="res_name"
						value="${dto.res_name}"></td>
				</tr>

				<!-- 연락처 -->
				<tr>
					<th><label for="res_tel">연락처</label></th>
					<td><input type="text" name="res_tel" id="res_tel"
						value="${dto.res_tel}"></td>
				</tr>

				<!-- 예약날짜 -->
				<tr>
					<th><label for="res_day">예약날짜</label></th>
					<td><input type="date" name="res_day" id="res_day"
						class="form-control"
						value="<fmt:formatDate value='${dto.res_day}' pattern='yyyy-MM-dd'/>">
					</td>
				</tr>

				<!-- 예약시간 -->
				<tr>
					<th><label for="res_time">예약시간</label></th>
					<td><select name="res_time" id="res_time" class="form-control">

							<option value="">선택</option>

							<option value="11:00"
								${dto.res_time == '11:00' ? 'selected' : ''}>11:00</option>
							<option value="11:30"
								${dto.res_time == '11:30' ? 'selected' : ''}>11:30</option>
							<option value="12:00"
								${dto.res_time == '12:00' ? 'selected' : ''}>12:00</option>
							<option value="12:30"
								${dto.res_time == '12:30' ? 'selected' : ''}>12:30</option>
							<option value="13:00"
								${dto.res_time == '13:00' ? 'selected' : ''}>13:00</option>
							<option value="13:30"
								${dto.res_time == '13:30' ? 'selected' : ''}>13:30</option>
							<option value="14:00"
								${dto.res_time == '14:00' ? 'selected' : ''}>14:00</option>

							<option value="17:00"
								${dto.res_time == '17:00' ? 'selected' : ''}>17:00</option>
							<option value="17:30"
								${dto.res_time == '17:30' ? 'selected' : ''}>17:30</option>
							<option value="18:00"
								${dto.res_time == '18:00' ? 'selected' : ''}>18:00</option>
							<option value="18:30"
								${dto.res_time == '18:30' ? 'selected' : ''}>18:30</option>
							<option value="19:00"
								${dto.res_time == '19:00' ? 'selected' : ''}>19:00</option>
							<option value="19:30"
								${dto.res_time == '19:30' ? 'selected' : ''}>19:30</option>
							<option value="20:00"
								${dto.res_time == '20:00' ? 'selected' : ''}>20:00</option>
							<option value="20:30"
								${dto.res_time == '20:30' ? 'selected' : ''}>20:30</option>
							<option value="21:00"
								${dto.res_time == '21:00' ? 'selected' : ''}>21:00</option>

					</select></td>
				</tr>

				<!-- 인원수 -->
				<tr>
					<th><label for="res_count">인원수</label></th>
					<td><input type="number" name="res_count" id="res_count"
						class="form-control" value="${dto.res_count}" min="1"></td>
				</tr>

			</table>

			<!-- 수정 버튼 -->
			<button type="submit" class="btn">수정하기</button>

		</form>

	</div>

	<%@ include file="/WEB-INF/views/footer.jsp"%>

	<script>
		document.getElementById('res_day').min = new Date().toISOString()
				.split('T')[0];
	</script>

</body>
</html>
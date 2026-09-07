<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>예약하기</title>
</head>
<body>

	<main>
		<div>
			<div>
				<h2>예약하기</h2>
				<p>방문 예약 정보를 입력해주세요.</p>
			</div>
			<form action="/reservation/reservationInsert" method="post"
				name="reservation" onsubmit="return check1();">

				<input type="hidden" name="r_no" value="${r_no}">

				<table width="500">
					<tr>
						<th><label for="res_name">예약자 이름</label></th>
						<td><input type="text" name="res_name" id="res_name"
							value="${loginName}" placeholder="이름을 입력해주세요"></td>
					</tr>
					<tr>
	<th><label for="res_tel">연락처</label></th>
	<td><input type="text" name="res_tel1" id="res_tel1"
		value="${empty tel1 ? '010' : tel1}" maxlength="3"> - <input type="text"
		name="res_tel2" id="res_tel2" size="4" maxlength="4"
		value="${tel2}" placeholder="0000"> - <input type="text" name="res_tel3"
		id="res_tel3" size="4" maxlength="4"
		value="${tel3}" placeholder="0000"></td>
</tr>
					<tr>
						<th><label for="res_day">예약날짜</label></th>
						<td><input type="date" name="res_day" id="res_day"
							value="${res_day}"></td>
					</tr>
					<tr>
						<th><label for="res_time">예약시간</label></th>

						<td><select name="res_time" id="res_time">
								<option value="">선택</option>
								<option value="11:00" ${res_time == '11:00' ? 'selected' : ''}>11:00</option>
								<option value="11:30" ${res_time == '11:30' ? 'selected' : ''}>11:30</option>
								<option value="12:00" ${res_time == '12:00' ? 'selected' : ''}>12:00</option>
								<option value="12:30" ${res_time == '12:30' ? 'selected' : ''}>12:30</option>
								<option value="13:00" ${res_time == '13:00' ? 'selected' : ''}>13:00</option>
								<option value="13:30" ${res_time == '13:30' ? 'selected' : ''}>13:30</option>
								<option value="14:00" ${res_time == '14:00' ? 'selected' : ''}>14:00</option>
								<option value="17:00" ${res_time == '17:00' ? 'selected' : ''}>17:00</option>
								<option value="17:30" ${res_time == '17:30' ? 'selected' : ''}>17:30</option>
								<option value="18:00" ${res_time == '18:00' ? 'selected' : ''}>18:00</option>
								<option value="18:30" ${res_time == '18:30' ? 'selected' : ''}>18:30</option>
								<option value="19:00" ${res_time == '19:00' ? 'selected' : ''}>19:00</option>
								<option value="19:30" ${res_time == '19:30' ? 'selected' : ''}>19:30</option>
								<option value="20:00" ${res_time == '20:00' ? 'selected' : ''}>20:00</option>
								<option value="20:30" ${res_time == '20:30' ? 'selected' : ''}>20:30</option>
								<option value="21:00" ${res_time == '21:00' ? 'selected' : ''}>21:00</option>
						</select></td>
					</tr>
					<tr>
						<th><label for="res_count">인원수</label></th>
						<td><input type="number" name="res_count" id="res_count"
							min="1" placeholder="인원수를 입력해주세요" value="${res_count}"></td>
					</tr>
					<c:if test="${payment}">
    <tr>
        <th>결제금액</th>
        <td>1,000원</td>
    </tr>
</c:if>
				</table>

				<div>
					<c:choose>
						<c:when test="${payment}">
							<button type="submit" formaction="/결제경로">결제하기</button>
						</c:when>
						<c:otherwise>
							<button type="submit" formaction="/reservation/reservationInsert">예약하기</button>
						</c:otherwise>
					</c:choose>
					<input type="reset" value="✕ 취소">
				</div>
			</form>
		</div>
	</main>

</body>
</html>
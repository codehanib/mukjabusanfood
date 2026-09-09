<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>예약 완료</title>
</head>
<body>

	<main>
		<div>
			<h2>예약이 접수되었습니다</h2>
			<p>
				대기번호는 <strong>${dto.res_num}</strong>번입니다.
			</p>

			<table width="500">
				<tr>
					<th>예약자 이름</th>
					<td>${dto.res_name}</td>
				</tr>
				<tr>
					<th>연락처</th>
					<td>${dto.res_tel}</td>
				</tr>
				<tr>
					<th>예약날짜</th>
					<td><fmt:formatDate value="${dto.res_day}"
							pattern="yyyy년 MM월 dd일" /></td>
				</tr>
				<tr>
					<th>예약시간</th>
					<td>${dto.res_time}</td>
				</tr>
				<tr>
					<th>인원수</th>
					<td>${dto.res_count}명</td>
				</tr>
				<tr>
					<th>예약상태</th>
					<td>${dto.res_stats}</td>
				</tr>
				<tr>
    <th>대기현황</th>
    <td>대기번호 ${dto.res_num}번 · 내 앞에 ${dto.res_wait}팀 대기중</td>
</tr>
			</table>

			<button type="button" onclick="location.href='/main'">홈으로</button>
		</div>
	</main>

</body>
</html>
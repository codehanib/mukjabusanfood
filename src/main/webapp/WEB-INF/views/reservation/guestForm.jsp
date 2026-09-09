<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
	
	
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>예약조회</title>
</head>
<body>

	<main>

		<div>
			<h2>예약조회</h2>
			<p>예약확인번호와 예약자 연락처를 입력해주세요.</p>
		</div>
		<c:if test = "${not empty msg}">
			<p style="color:red;">${msg}</p>
		</c:if>
		<!-- 예약 조회 -->
		<form action="/reservation/guestSearch" method="post">
			<table width="500" border="1">
				<tr>
					<th><label for="res_tel">휴대전화</label></th>
					<td><input type="text" name="res_tel1" id="res_tel1" value="010" maxlength="3"> - <input type="text" name="res_tel2" id="res_tel2" size="4"
						maxlength="4" placeholder="0000"> - <input type="text"
						name="res_tel3" id="res_tel3" size="4" maxlength="4"
						placeholder="0000"></td>
				</tr>
			</table>	
			<div>
				<input type="submit" value="조회하기">
			</div>
		</form>
	</main>

</body>
</html>
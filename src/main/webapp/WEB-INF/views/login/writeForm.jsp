<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>회원가입</title>
<!-- 회원가입 스크립트 -->
<script src="/js/writeForm.js"></script>
</head>
<body onload="checkSignupError()">

	<main>

		<div>
			<h2>회원가입</h2>
			<p>MUKJA에 오신 것을 환영합니다.</p>
		</div>

		<!-- 회원가입 폼 -->
		<form action="/usersInsert" method="post" name="users"
			onsubmit="return check1();">
			<table width="500">
				<tr>
					<th><label for="u_id">아이디</label></th>
					<td><input type="text" name="u_id" id="u_id"
						placeholder="영문, 숫자 조합 4~16자리" onkeyup="idChecked = false;">
						<input type="button" value="중복확인" onclick="checkId();"></td>
				</tr>
				<tr>
					<th><label for="u_passwd">비밀번호</label></th>
					<td><input type="password" name="u_passwd" id="u_passwd"
						placeholder="영문, 숫자, 특수문자 포함 8~16자리"></td>
				</tr>
				<tr>
					<th><label for="u_passwd2">비밀번호 확인</label></th>
					<td><input type="password" name="u_passwd2" id="u_passwd2"
						placeholder="비밀번호 재입력"></td>
				</tr>
				<tr>
					<th><label for="u_name">이름</label></th>
					<td><input type="text" name="u_name" id="u_name"
						placeholder="이름을 입력해주세요"></td>
				</tr>
				<tr>
					<th><label for="u_zipno">주소</label></th>
					<td><input type="text" name="u_zipno" id="u_zipno" readonly>
						<input type="button" value="우편번호 검색" onclick="goPopup();">
					</td>
				</tr>
				<tr>
					<th></th>
					<td><input type="text" name="u_addr" id="u_addr"
						placeholder="기본주소" readonly></td>
				</tr>
				<tr>
					<th></th>
					<td><input type="text" name="u_addr2" id="u_addr2"
						placeholder="상세주소를 입력해주세요"></td>
				</tr>
				<tr>
					<th><label for="u_tel">휴대전화</label></th>
					<td><input type="text" name="u_tel1" id="u_tel1" value="010" maxlength="3"> - <input type="text" name="u_tel2" id="u_tel2" size="4"
						maxlength="4" placeholder="0000"> - <input type="text"
						name="u_tel3" id="u_tel3" size="4" maxlength="4"
						placeholder="0000"></td>
				</tr>
				<tr>
					<th><label for="u_email">이메일</label></th>
					<td><input type="text" name="u_email" id="u_email"
						placeholder="이메일 입력"> @ <select name="u_email2"
						id="u_email2">
							<option value="">선택</option>
							<option value="naver.com">naver.com</option>
							<option value="gmail.com">gmail.com</option>
							<option value="daum.com">daum.com</option>
							<option value="nate.com">nate.com</option>
					</select> <input type="button" value="인증번호 발송" onclick="sendEmailCode();">
					</td>
				</tr>
				<tr id="emailCodeArea" style="display: none;">
					<th><label for="emailCode">인증번호</label></th>
					<td><input type="text" id="emailCode" placeholder="인증번호 6자리">
						<input type="button" value="인증확인" onclick="verifyEmailCode();">
						<input type="hidden" name="emailVerifyToken" id="emailVerifyToken">
					</td>
				</tr>
			</table>

			<div>
				<input type="submit" value="✓ 회원가입"> <input type="reset"
					value="✕ 취소" onclick="history.back()">
			</div>
		</form>
	</main>

</body>
</html>
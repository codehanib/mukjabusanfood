<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>비밀번호 변경</title>
<script src="/js/writeForm.js"></script>
<link rel="stylesheet" href="/css/login.css">
</head>
<body class="login-body">

	<div class="login-wrapper">
		<div class="login-card">

			<div class="login-title">
				<h2>비밀번호 변경</h2>
				<div class="title-line"></div>
			</div>

			<form action="/users/userspasswd" method="post" name="pwForm"
				onsubmit="return checkPasswd();">

				<div class="input-box stack">
					<p>새 비밀번호</p>
					<input type="password" name="u_passwd"
						placeholder="영문, 숫자, 특수문자를 포함하여 8~16자리">
				</div>

				<div class="input-box stack">
					<p>새 비밀번호 확인</p>
					<input type="password" name="u_passwd2"
						placeholder="영문, 숫자, 특수문자를 포함하여 8~16자리">
				</div>

				<button type="submit" class="btn-login">변경하기</button>

			</form>

		</div>
	</div>

</body>
</html>
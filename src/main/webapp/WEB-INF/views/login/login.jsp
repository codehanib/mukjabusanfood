<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>LOGIN</title>
<script src="/js/writeForm.js"></script>
</head>
<body class="login-body" onload="checkLoginError();">

    <div class="login-wrapper">

        <form action="/j_spring_security_check" method="post" name="loginForm" class="login-card" onsubmit="return saveIdCookie();">



            <div class="login-title">
                <h2>LOGIN</h2>
                <div class="title-line"></div>
            </div>

            <!-- 아이디 -->
            <div class="input-box id-box">
                <input type="text" name="u_id" id="u_id" placeholder="아이디">
            </div>

            <!-- 비밀번호 -->
            <div class="input-box pw-box">
                <input type="password" name="u_passwd" placeholder="비밀번호">
            </div>

            <!-- 부가 메뉴 -->
            <div class="login-sub">
                <label class="save-id">
                    <input type="checkbox" name="saveId" id="saveId">
                    아이디 저장
                </label>

                <a href="/login/findPasswordForm">비밀번호 찾기</a>
            </div>

            <!-- 버튼 -->
            <input type="submit" value="로그인" class="btn-login">

            <a href="/login/writeForm" class="btn-join">회원가입</a>
            <a href="/main" class="btn-join">비회원 메인</a>
			<a href="/reservation/guestForm">임시로비회원 예약목록확인</a>
            <!-- 하단 안내 -->
            <p class="login-guide">
                회원이 아니신가요?
                <a href="/login/writeForm">회원가입</a>
                후 다양한 서비스를 이용해 보세요.
            </p>

        </form>

        <p class="copyright">© 2026 MUKJA. All rights reserved.</p>

    </div>

</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>

<html lang="ko">

<head>
<meta charset="UTF-8">

<title>로그인 실패</title>

<link rel="stylesheet" href="/css/loginError_LDH.css">

</head>

<body class="login-error-body">

    <div class="error-wrapper">

        <div class="error-card">

            <!-- 에러 아이콘 -->
            <div class="error-icon">
                !
            </div>


            <!-- 제목 -->
            <h1>
                로그인에 실패했습니다
            </h1>


            <!-- 안내 -->
            <p class="error-message">
                아이디 또는 비밀번호가 일치하지 않습니다.
            </p>

            <p class="error-sub-message">
                입력하신 정보를 다시 확인한 후 로그인해 주세요.
            </p>


            <!-- 버튼 -->
            <div class="error-buttons">

                <a href="/login/login"
                   class="retry-button">
                    다시 로그인
                </a>

                <a href="/"
                   class="home-button">
                    메인으로
                </a>

            </div>

        </div>


        <p class="error-copyright">
            © 2026 MUKJA. All rights reserved.
        </p>

    </div>

</body>

</html>
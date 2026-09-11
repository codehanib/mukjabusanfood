<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>마이페이지</title>
<link rel="stylesheet" href="/css/mypage.css">
</head>
<body>
<%@ include file="/WEB-INF/views/header.jsp" %>
<div class="mypage-container">

    <div class="mypage-title">
        마이페이지
    </div>

    <div class="member-info">
        <div class="mypage-logo">
            MY<span> MUKJA</span>
            <div class="mypage-text">
                마이페이지에서는 회원정보와<br>
                예약, 찜한 식당, 문의내역을<br>
                확인하고 관리하실 수 있습니다.
            </div>
        </div>
    </div>

    <div class="mypage-menu">

        <!-- 회원정보보기 -->
        <a href="/users/userviewForm" class="mypage-menu-item">
            <div class="mypage-menu-title">
                profile
                <span>회원정보보기</span>
            </div>
            <div class="mypage-menu-desc">
                회원 정보를 확인하고<br>
                수정, 비밀번호 변경, 탈퇴를 하실 수 있습니다.
            </div>
        </a>

        <!-- 예약확인 -->
        <a href="/reservation/myList" class="mypage-menu-item">
            <div class="mypage-menu-title">
                reservation
                <span>예약확인</span>
            </div>
            <div class="mypage-menu-desc">
                대기중인 예약과<br>
                지난 예약 기록을 확인하실 수 있습니다.
            </div>
        </a>

        <!-- 찜 목록 -->
        <a href="/users/bookmarkList" class="mypage-menu-item">
            <div class="mypage-menu-title">
                wishlist
                <span>찜 목록</span>
            </div>
            <div class="mypage-menu-desc">
                찜한 식당 목록을<br>
                확인하실 수 있습니다.
            </div>
        </a>

        <!-- 1:1문의 -->
        <a href="/users/inquiryList" class="mypage-menu-item">
            <div class="mypage-menu-title">
                inquiry
                <span>1:1 문의</span>
            </div>
            <div class="mypage-menu-desc">
                문의 내역을 확인하실 수 있습니다.<br>
            </div>
        </a>

    </div>

</div>

</body>
</html>
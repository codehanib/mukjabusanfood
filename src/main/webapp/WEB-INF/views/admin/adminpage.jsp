<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 관리</title>
<link rel="stylesheet" href="/css/mypage.css">
</head>
<body>
<%@ include file="/WEB-INF/views/header.jsp" %>
<div class="mypage-container">

    <div class="mypage-title">
    <span>관리자페이지</span>
</div>
    

    <div class="member-info">
        <div class="mypage-logo">
            MY<span> MUKJA</span>
            <div class="mypage-text">
                관리페이지에서는 관리자 정보와<br>
                예약, 주문 내역을<br>
                확인하고 관리하실 수 있습니다.
            </div>
        </div>
    </div>
    

    <div class="mypage-menu">

        

        <!-- 관리자 정보 수정 -->
        <a href="/admin/usersList" class="mypage-menu-item">
            <div class="mypage-menu-title">
                users
                <span>회원 멤버 수정</span>
            </div>
            <div class="mypage-menu-desc">
                등록한 관리자 정보를<br>
                수정하실 수 있습니다.
            </div>
        </a>

        <!-- 예약 목록 -->
        <a href="/admin/restaurantLis" class="mypage-menu-item">
            <div class="mypage-menu-title">
                restaurantList
                <span>식당 관리</span>
            </div>
            <div class="mypage-menu-desc">
                들어온 예약을 확인하고<br>
                승인/취소 처리하실 수 있습니다.
            </div>
        </a>

        <!-- 주문 목록 -->
        <a href="/admin/noticeWrite" class="mypage-menu-item">
            <div class="mypage-menu-title">
                notice
                <span>공지 작성</span>
            </div>
            <div class="mypage-menu-desc">
                배달 주문 내역을<br>
                확인하고 관리하실 수 있습니다.
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
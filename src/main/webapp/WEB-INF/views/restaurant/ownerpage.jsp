<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>식당 관리</title>
<link rel="stylesheet" href="/css/mypage.css">
</head>
<body>
<%@ include file="/WEB-INF/views/header.jsp" %>
<div class="mypage-container">

    <div class="mypage-title">
        식당페이지
    </div>

    <div class="member-info">
        <div class="mypage-logo">
            MY<span> MUKJA</span>
            <div class="mypage-text">
                오너페이지에서는 식당 정보와<br>
                예약, 주문 내역을<br>
                확인하고 관리하실 수 있습니다.
            </div>
        </div>
    </div>

    <div class="mypage-menu">

        <!-- 식당 등록 -->
        <a href="/restaurant/restaurantWriteForm" class="mypage-menu-item">
            <div class="mypage-menu-title">
                restaurant
                <span>식당 등록</span>
            </div>
            <div class="mypage-menu-desc">
                새로운 식당 정보를<br>
                등록하실 수 있습니다.
            </div>
        </a>

        <!-- 식당 정보 수정 -->
        <a href="/restaurant/updateForm?r_no=${user.r_no}" class="mypage-menu-item">
            <div class="mypage-menu-title">
                update
                <span>식당 정보 수정</span>
            </div>
            <div class="mypage-menu-desc">
                등록한 식당 정보를<br>
                수정하실 수 있습니다.
            </div>
        </a>

        <!-- 예약 목록 -->
        <a href="/reservation/ownerList" class="mypage-menu-item">
            <div class="mypage-menu-title">
                reservation
                <span>예약 목록</span>
            </div>
            <div class="mypage-menu-desc">
                들어온 예약을 확인하고<br>
                승인/취소 처리하실 수 있습니다.
            </div>
        </a>

        <!-- 주문 목록 -->
        <a href="/store/order/history?r_no=${user.r_no}" class="mypage-menu-item">
            <div class="mypage-menu-title">
                order
                <span>주문 목록</span>
            </div>
            <div class="mypage-menu-desc">
                배달 주문 내역을<br>
                확인하고 관리하실 수 있습니다.
            </div>
        </a>

    </div>

</div>

</body>
</html>
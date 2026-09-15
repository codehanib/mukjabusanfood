<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
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
        <span>식당 페이지</span>
        <c:if test="${not empty user && empty user.r_no}">
            <a href="/restaurant/restaurantWriteForm" class="btn-outline title-action">
                식당 등록
            </a>
        </c:if>
    </div>

    <div class="member-info">
        <div class="mypage-logo">
            MY<span> MUKJA</span>
            <div class="mypage-text">
                오너 페이지에서는 식당 정보와<br>
                예약, 주문 내역을<br>
                확인하고 관리하실 수 있습니다.
            </div>
        </div>
    </div>

    <div class="mypage-menu">

        <!-- 식당 정보 수정 -->
        <a href="/restaurant/updateForm?r_no=${user.r_no}" class="mypage-menu-item">
            <div class="mypage-menu-title">
                식당 정보 수정
                <span>update</span>
            </div>
            <div class="mypage-menu-desc">
                등록한 식당 정보를<br>
                수정하실 수 있습니다.
            </div>
        </a>

        <!-- 예약 목록 -->
        <a href="/reservation/ownerList" class="mypage-menu-item">
            <div class="mypage-menu-title">
                예약 목록
                <span>reservation</span>
            </div>
            <div class="mypage-menu-desc">
                들어온 예약을 확인하고<br>
                승인/취소 처리하실 수 있습니다.
            </div>
        </a>

        <!-- 주문 목록 -->
        <a href="/store/order/history?r_no=${user.r_no}" class="mypage-menu-item">
            <div class="mypage-menu-title">
                주문 목록
                <span>order</span>
            </div>
            <div class="mypage-menu-desc">
                배달 주문 내역을<br>
                확인하고 관리하실 수 있습니다.
            </div>
        </a>

        <!-- 1:1문의 -->
        <a href="/users/inquiryList" class="mypage-menu-item">
            <div class="mypage-menu-title">
                1:1 문의
                <span>inquiry</span>
            </div>
            <div class="mypage-menu-desc">
                문의 내역을 확인하실 수 있습니다.<br>
            </div>
        </a>

    </div>

</div>

</body>
</html>
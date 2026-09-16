<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
        <span>관리자 페이지</span>
    </div>

    <div class="member-info">
        <div class="mypage-logo">
            MY<span> MUKJA</span>
            <div class="mypage-text">
                관리자 페이지에서는 회원, 식당, 공지사항, 문의 내역 및<br>
                시각화 데이터와 주문 현황을 확인하고 관리하실 수 있습니다.
            </div>
        </div>
    </div>

    <div class="mypage-menu">

        <!-- 회원 관리 -->
        <a href="/admin/usersList" class="mypage-menu-item">
            <div class="mypage-menu-title">
                회원 관리
                <span>users</span>
            </div>
            <div class="mypage-menu-desc">
                등록된 회원 정보를<br>
                조회하고 관리하실 수 있습니다.
            </div>
        </a>

        <!-- 식당 관리 -->
        <a href="/admin/restaurantList" class="mypage-menu-item">
            <div class="mypage-menu-title">
                식당 관리
                <span>restaurants</span>
            </div>
            <div class="mypage-menu-desc">
                등록된 식당 정보를<br>
                확인하고 관리하실 수 있습니다.
            </div>
        </a>

        <!-- 공지 작성 -->
        <a href="/admin/noticeWrite" class="mypage-menu-item">
            <div class="mypage-menu-title">
                공지 작성
                <span>notice</span>
            </div>
            <div class="mypage-menu-desc">
                회원들에게 안내할<br>
                공지사항을 작성하실 수 있습니다.
            </div>
        </a>

        <!-- 1:1 문의 -->
        <a href="/users/inquiryList" class="mypage-menu-item">
            <div class="mypage-menu-title">
                1:1 문의
                <span>inquiry</span>
            </div>
            <div class="mypage-menu-desc">
                회원들이 남긴 문의 내역을<br>
                확인하고 답변하실 수 있습니다.
            </div>
        </a>

        <!-- 시각화 분석 대시보드 -->
        <a href="/admin/visual/dashboard" class="mypage-menu-item">
            <div class="mypage-menu-title">
                시각화 분석
                <span>visualization</span>
            </div>
            <div class="mypage-menu-desc">
                외식 물가 및 식당 분포<br>
                시각화 자료를 확인하실 수 있습니다.
            </div>
        </a>

        <!-- 주문현황 관리 -->
        <a href="/admin/deliveryManage" class="mypage-menu-item">
            <div class="mypage-menu-title">
                주문현황 관리
                <span>orders</span>
            </div>
            <div class="mypage-menu-desc">
                실시간 주문 내역을<br>
                확인하고 관리하실 수 있습니다.
            </div>
        </a>

    </div> 

</div> 

<%@ include file="/WEB-INF/views/footer.jsp" %>
</body>
</html>
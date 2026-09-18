<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
    
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
        <span>마이페이지</span>
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
                회원정보보기
                <span>profile</span>
            </div>
            <div class="mypage-menu-desc">
                회원 정보를 확인하고<br>
                수정, 비밀번호 변경, 탈퇴를 하실 수 있습니다.
            </div>
        </a>

        <!-- 예약확인 -->
        <a href="/reservation/myList" class="mypage-menu-item">
            <div class="mypage-menu-title">
                예약확인
                <span>reservation</span>
            </div>
            <div class="mypage-menu-desc">
                대기중인 예약과<br>
                예약 기록을 확인하실 수 있습니다.
            </div>
        </a>

        <!-- 찜 목록 -->
        <a href="/users/bookmarkList" class="mypage-menu-item">
            <div class="mypage-menu-title">
                찜 목록
                <span>wishlist</span>
            </div>
            <div class="mypage-menu-desc">
                찜한 식당 목록을<br>
                확인하실 수 있습니다.
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
        
        <a href="/delivery/user/history?u_no =${users.u_no}" class="mypage-menu-item">
            <div class="mypage-menu-title">
                배달 주문 확인
                <span>delivery</span>
            </div>
            <div class="mypage-menu-desc">
                배달 내역을 확인하실 수 있습니다.<br>
            </div>
        </a>

    </div>

</div>
<%@ include file="/WEB-INF/views/footer.jsp" %>
<%@ include file="/WEB-INF/views/clickbutton.jsp" %>
</body>
</html>
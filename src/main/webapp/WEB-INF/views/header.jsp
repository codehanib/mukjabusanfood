<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<link rel="stylesheet" href="/css/header.css">

<header class="site-header">
			<div class="top-menu">
				<sec:authorize access="isAnonymous()">
					<a href="/login/login">
				    	로그인
					</a>
					|
					<a href="/login/writeForm">
				    	회원가입
					</a>
					
				|
					<a href="/reservation/guestForm">
		    비회원 예약확인
		</a>
				</sec:authorize>
				<sec:authorize access="hasAnyRole('USER','ADMIN','OWNER')">
					<a href="/logout">
				    	로그아웃
				    	|
					</a>
					
				</sec:authorize>
				 <sec:authorize access="hasRole('USER')">
					<a href="/users/mypage">
		   마이페이지
		</a>
				</sec:authorize>
				

				<sec:authorize access="hasRole('ADMIN')">
					<a href="/admin/usersList">
					    회원관리
					</a>
				</sec:authorize>
				<sec:authorize access="hasRole('OWNER')">
					
					<a href="/restaurant/ownerpage?r_no=${restaurant.r_no}">
					    오너페이지
					    
					</a>
					
				</sec:authorize>
				|
				<a href="/noticeList">공지사항</a>
            

		
			</div>
	    <div class="header-inner">
	        <!-- 로고 -->
	        <a href="/main" class="logo">
	            <img src="/images/logo.png" alt="mukja 로고">
	        </a>
	        <!-- 검색창 영역 -->
	        <div class="search-area">
	            <!-- 사이트 설명 -->
	            <p class="header-description">부산 식당 예약 & 배달주문</p>
	            <!-- 검색창 -->
	            <form action="/restaurant/search"
				      method="get"
				      class="search-form"
				      style="position:relative;">
				
				    <input type="text"
				           name="keyword"
				           id="keyword"
				           placeholder="식당, 메뉴, 지역 검색"
				           autocomplete="off">
				
				    <button type="submit">검색</button>
				
				    <!-- 자동완성 목록 -->
				    <div id="suggestions"
				         style="
				            display:none;
				            position:absolute;
				            top:100%;
				            left:0;
				            background:white;
				            border:1px solid #cccccc;
				            width:170px;
				            z-index:10;
				         ">
				    </div>
				
				</form>
	            
	            <div class="popular-box">

				    <div class="popular-top" id="popularToggle">
				        <span class="popular-title">인기검색어</span>
				
				        <c:if test="${not empty popularSearchList}">
				            <span class="popular-first">
				                1. ${popularSearchList[0].ms_word}
				            </span>
				        </c:if>
				
				        <span class="popular-arrow">▼</span>
				    </div>
				
				    <div class="popular-list" id="popularList">
				
				        <c:forEach var="search"
				                   items="${popularSearchList}"
				                   varStatus="status">
				
				            <a href="/restaurant/search?keyword=${search.ms_word}">
				                ${status.index + 1}. ${search.ms_word}
				            </a>
				
				        </c:forEach>
				
				    </div>
				
				</div>
	            
	            
	        </div>
	    </div>
	    
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script src="${pageContext.request.contextPath}/js/main.js"></script>
	
	</header>
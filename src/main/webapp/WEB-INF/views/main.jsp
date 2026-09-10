<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>메인페이지</title>
</head>
<style>
	.header {
	    width: 100%;
	    padding: 25px 0;
	    background-color: #fff;
	}
	.header-inner {
	    display: flex;
	    align-items: center;
	    justify-content: center;
	    gap: 20px;
	}
	/* 로고 */
	.logo img {
	    width: 150px;
	    height: auto;
	    display: block;
	    margin-right: 10px;
	}
	/* 검색창 + 문구 영역 */
	.search-area {
	    display: flex;
	    flex-direction: column;
	}
	/* 사이트 설명 */
	.header-description {
	    margin: 0 0 5px 0;
	    color: #ff6644;
	    font-size: 14px;
	    line-height: 1.2;
	    text-align: left;
	}
	/* 검색 영역 */
	.search-form {
	    display: flex;
	    align-items: center;
	}
	.search-form input {
	    width: 550px;
	    height: 42px;
	    padding: 0 15px;
	    border: 2px solid #ff6644;
	    border-right: none;
	    border-radius: 8px 0 0 8px;
	    box-sizing: border-box;
	    font-size: 14px;
	    outline: none;
	}
	.search-form input:focus {
	    border-color: #ff6644;
	}
	.search-form button {
	    height: 42px;
	    padding: 0 20px;
	    border: none;
	    border-radius: 0 8px 8px 0;
	    background-color: #ff6644;
	    color: #fff;
	    font-size: 14px;
	    font-weight: bold;
	    cursor: pointer;
	}
	.search-form button:hover {
	    background-color: #ff3333;
	}
	
	.top-menu {
    position: absolute;
    top: 10px;
    right: 100px;
	}
</style>
<body>
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
				</sec:authorize>
				 <sec:authorize access="hasRole('USER')">
					<a href="/users/userviewForm">
				    	회원 자세히보기
					</a>
				</sec:authorize>
				<sec:authorize access="hasAnyRole('USER','ADMIN','OWNER')">
					<a href="/logout">
				    	로그아웃
					</a>
				</sec:authorize>
				
				<sec:authorize access="hasRole('ADMIN')">
					<a href="/admin/usersList">
					    회원목록
					</a>
				</sec:authorize>
				<sec:authorize access="hasRole('OWNER')">
					<a href="/restaurant/restaurantWriteForm">
					    식당 등록
					</a>
					|
					<a href="/restaurant/updateForm?r_no=${user.r_no}">
			    		식당 수정
					</a>
					|
					<a href="/reservation/ownerList">
			    		주문 목록
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
	            <form action="/restaurant/search" method="get" class="search-form">
	                <input type="text"
	                       name="keyword"
	                       placeholder="식당, 메뉴, 지역 검색">
	                <button type="submit">검색</button>
	            </form>
	        </div>
	    </div>
	</header>

	<!-- 음식종류 -->
	<form action="/restaurant/category" method="get">
	    <select name="mukja_c_no" onchange="this.form.submit()">
	        <option value="">음식종류 선택</option>
	        <c:forEach var="category" items="${categoryList}">
	            <option value="${category.mukja_c_no}">
	                ${category.mukja_c_name}
	            </option>
	        </c:forEach>
	    </select>
	</form>
	
    
    <!-- 지역 -->
	<form action="/restaurant/region" method="get">
	    <select name="r_region" onchange="this.form.submit()">
	        <option value="">지역 선택</option>
		        <c:forEach var="region" items="${regionList}">
		            <option value="${region}">
		                ${region}
		            </option>
		        </c:forEach>
	    </select>
	</form>
	
	
	<table>
	    <c:forEach var="restaurant" items="${restaurantList}" varStatus="status">
	
	        <!-- 4개마다 새로운 줄 시작 -->
	        <c:if test="${status.index % 4 == 0}">
	            <tr>
	        </c:if>
	
	        <td>
	            <!-- 대표 이미지 -->
	            <c:choose>
	                <c:when test="${fn:startsWith(restaurant.r_img, 'http')}">
		                <a href="/restaurant/detail?r_no=${restaurant.r_no}">
		                    <img src="${restaurant.r_img}" width="150" height="150">
		                </a>
	                </c:when>
	
	                <c:otherwise>
		                <a href="/restaurant/detail?r_no=${restaurant.r_no}">
		                    <img src="/upload/${restaurant.r_img}" width="150" height="150">
		                 </a>
	                </c:otherwise>
	            </c:choose>
	
	            <br>
	
	            <!-- 식당명 -->
	            <a href="/restaurant/detail?r_no=${restaurant.r_no}">
	                ${restaurant.r_name}
	            </a>
	
	            <br>
	
	            <!-- 예약하기 -->
	            <a href="/reservation/reservationInsert?r_no=${restaurant.r_no}">
	               [예약하기]
	            </a>
	        </td>
	
	        <!-- 4개마다 줄 종료 -->
	        <c:if test="${status.index % 4 == 3 || status.last}">
	            </tr>
	        </c:if>
	
	    </c:forEach>
	    
	</table>
	<br>
	
	<div>
	
	    <!-- 이전 -->
	    <c:if test="${startPage > 1}">
	        <a href="/main?page=${startPage - 1}">
	            이전
	        </a>
	    </c:if>
	
	    <!-- 페이지 번호 -->
	    <c:forEach var="i"
	               begin="${startPage}"
	               end="${endPage}">
	
	        <a href="/main?page=${i}">
	            ${i}
	        </a>
	
	    </c:forEach>
	
	    <!-- 다음 -->
	    <c:if test="${endPage < totalPage}">
	        <a href="/main?page=${endPage + 1}">
	            다음 >
	        </a>
	    </c:if>
	
	</div>
</body>
</html>
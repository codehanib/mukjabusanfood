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
<body>
	<h1>메인페이지</h1>
	<a href="/main">
		<img src="/images/logo.png" alt="mukja 로고">
    </a>
	<p> 부산 식당 예약 & 배달주문</p>
	<form action="/restaurant/search" method="get">
	    <input type="text" name="keyword" placeholder="식당, 메뉴, 지역 검색">
	    <button type="submit">검색</button>
	</form>
	<br>
	<sec:authorize access="hasRole('USER')">
		<a href="/users/userviewForm">
	    	회원 자세히보기
		</a>
	</sec:authorize>
	<br>
	<a href="/logout">
    	로그아웃
	</a>
	<br>
	
	<sec:authorize access="hasRole('ADMIN')">
		<a href="/admin/usersList">
		    회원목록
		</a>
	</sec:authorize>
	
	<br>
	
	<sec:authorize access="hasRole('OWNER')">
		<a href="/restaurant/restaurantWriteForm">
		    식당 등록
		</a>
		<br>
		<a href="/restaurant/updateForm?r_no=${user.r_no}">
    		식당 수정
		</a>
	</sec:authorize>

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
	                    <img src="/upload/${restaurant.r_img}"
	                         width="150" height="150">
	                </c:otherwise>
	            </c:choose>
	
	            <br>
	
	            <!-- 식당명 -->
	            <a href="/restaurant/detail?r_no=${restaurant.r_no}">
	                ${restaurant.r_name}
	            </a>
	
	            <br>
	
	            <!-- 예약하기 -->
	            <a href="/">
	                <button type="button">예약하기</button>
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
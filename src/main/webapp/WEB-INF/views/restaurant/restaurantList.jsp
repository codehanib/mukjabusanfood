<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>식당 목록</title>
</head>
<body>
	<form action="/restaurant/search" method="get">
	    <input type="text" name="keyword" placeholder="식당, 메뉴, 지역 검색">
	    <button type="submit">검색</button>
	</form>	
	
	<!-- 음식종류 -->
    <div>
        <c:forEach var="category" items="${categoryList}">
            <a href="/restaurant/category?mukja_c_no=${category.mukja_c_no}">
                ${category.mukja_c_name}
            </a>
            &nbsp;
        </c:forEach>
    </div>
    
    <!-- 지역 -->
    <div>
        <c:forEach var="category" items="${categoryList}">
            <a href="/restaurant/category?mukja_c_no=${category.mukja_c_no}">
                ${category.mukja_c_name}
            </a>
            &nbsp;
        </c:forEach>
    </div>

    <hr>
    
	<!-- 식당 목록 -->
	<c:forEach var="restaurant" items="${restaurantList}">
	
		<a href="/restaurant/detail?r_no=${restaurant.r_no}">
            <h2>${restaurant.r_name}</h2>
        </a>
		<div>★${restaurant.r_point}(${reviewCount})> &nbsp; ${restaurant.r_region} · ${restaurant.mukja_c_name}</div>
			<br>
		<a href="/restaurant/detail?r_no=${restaurant.r_no}">
			<img src="${restaurant.r_img}" alt="${restaurant.r_name}" width="300">
		</a>
		<br><br>
		
		<div>${restaurant.r_time}</div>
			<br>
		<div>(휴무)${restaurant.r_rest}</div>
		
	<hr>
	 </c:forEach>
	
	<!-- 예약 -->
	<!-- 날짜 · 인원 · 시간 선택 -->
		<form action="/reservation/writeForm" method="get">
	        <input type="hidden" name="r_no" value="${restaurant.r_no}">
	        <button type="submit">날짜 · 인원 · 시간</button>
	    </form>
</body>
</html>
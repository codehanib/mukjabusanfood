<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>식당 목록</title>
</head>
<body>
	<button type="button" onclick="history.back()">←</button>
	<button type="button" onclick="location.href='/main'">home</button>
	<br><br>
	

    
	<!-- 식당 목록 -->
	<c:forEach var="restaurant" items="${restaurantList}">
	
		<a href="/restaurant/detail?r_no=${restaurant.r_no}&keyword=${keyword}">
            <h2>${restaurant.r_name}</h2>
        </a>
        
        <!-- 관리자만 식당 삭제 -->
	    <sec:authorize access="hasRole('ADMIN')">
	        <a href="/restaurant/delete?r_no=${restaurant.r_no}&keyword=${keyword}">식당 삭제</a>
	    </sec:authorize>

		<div>
	    ★<fmt:formatNumber value="${restaurant.reviewAvg}" pattern="0.0"/>
	    (${restaurant.reviewCount}) >
	    &nbsp;
	    ${restaurant.r_region} · ${restaurant.mukja_c_name}
		</div>
			<br>
		<a href="/restaurant/detail?r_no=${restaurant.r_no}">
			<c:choose>

			    <c:when test="${fn:startsWith(restaurant.r_img, 'http')}">
			        <img src="${restaurant.r_img}"
			             alt="${restaurant.r_name}"
			             width="300">
			    </c:when>
			
			    <c:otherwise>
			        <img src="/upload/${restaurant.r_img}"
			             alt="${restaurant.r_name}"
			             width="300">
			    </c:otherwise>

			</c:choose>
		</a>
		
		
		<div>영업시간 · ${restaurant.simple_time}</div>
		<div>휴무일 · ${restaurant.r_rest}</div>
		 <a href="/reservation/reservationInsert?r_no=${restaurant.r_no}">
	               [예약하기]
	     </a>
		
	<hr>
	
	    
	 </c:forEach>
	
</body>
</html>
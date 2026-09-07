<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>식당 상세</title>
</head>

<body>
	<button type="button" onclick="history.back()">←</button>
	<button type="button" onclick="location.href='/main'">home</button>
	<br><br>
	
	<!-- 식당 이미지 -->
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
	
	<h2>${restaurant.r_name}</h2>
	
	<div>★${restaurant.r_point} · 리뷰 ${reviewCount}개 > &nbsp; ${restaurant.r_region} · ${restaurant.mukja_c_name}</div>
		<br>
	
	<div>${restaurant.r_info}</div>
		<br><hr>
	<div>${restaurant.r_addr}</div>	
		<br>
	<div>${restaurant.r_time}</div>
		<br>
	<div>(휴무)${restaurant.r_rest}</div>
	
	<hr>
	
	<!-- 예약 -->
	<h3 id="reservation">예약</h3>
	<form action="/reservation/writeForm" method="get">
	
		<input type="hidden" name="r_no"  value="${restaurant.r_no}">
		
		<!-- 날짜 -->
    	<input type="date" name="res_day" required>
		
		<!-- 인원 -->
	    <select name="res_count" required>
	        <option value="">인원 선택</option>
	        <option value="1">1명</option>
	        <option value="2">2명</option>
	        <option value="3">3명</option>
	        <option value="4">4명</option>
	    </select>
	
	    <!-- 시간 -->
	    <select name="res_time" required>
	        <option value="">시간 선택</option>
	        <option value="12:00">12:00</option>
	        <option value="13:00">13:00</option>
	        <option value="18:00">18:00</option>
	        <option value="19:00">19:00</option>
	    </select>
	
	    <button type="submit">예약하기</button>
	
	</form>

	<hr>
	
	<!-- 메뉴 -->
    <h3>메뉴</h3>
    
    <c:forEach var="menu" items="${menuList}">
    
	<table border="1">
		<tr>
           <td>${menu.mn_name}<br>
                    <c:if test="${not empty menu.mn_content}">
                        ${menu.mn_content}<br>
                    </c:if>

                    ${menu.mn_price}원
                </td>
                <td>
                    <c:if test="${not empty menu.mn_img}">
                        <img src="${menu.mn_img}" alt="${menu.mn_name}" width="100">
                    </c:if>
                </td>
            </tr>
	</table>
	<br>
	</c:forEach>
	<hr>
    
	<!-- 추천 리뷰 -->
    <h3>추천 리뷰</h3>

    <div>★ ${restaurant.r_point} (${reviewCount})</div>
    <br>


    
	<form action="/" method="get">
		<input type="hidden" name="r_no" value="${restaurant.r_no}">
		<button type="submit">리뷰 전체보기</button>
	</form>
	
	<hr>
	
	<!-- 편의시설 -->
    <h3>편의시설</h3>
    
	<!-- 위치 -->
    <h3>위치</h3>

	<!-- 상세정보 -->
    <h3>상세정보</h3>
	
	<hr>
	
	<form action="bookmark/insert" method="get">
		<input type="hidden" name="r_no" value="${restaurant.r_no}">
		<button type="submit">북마크추가(나중에 아이콘)</button>
	</form>
		<br>
		
            
 	<!-- 페이징 -->
    <c:forEach begin="1" end="${totalPage}" var="i">

        <a href="/restaurant/category?mukja_c_no=${mukja_c_no}&page=${i}">
            ${i}
        </a>
	
	
	
	<!-- 하단 고정 예약 바 -->
	<div class="bottom-reservation">
	
	    <!-- 북마크 -->
	    <form action="/" method="get">
	        <input type="hidden" name="r_no" value="${restaurant.r_no}">
	        <button type="submit" class="bookmark-btn">
	            ♡<br>
	            북마크
	        </button>
	    </form>
	
	
	    <!-- 예약하기 -->
	    <a href="/" class="reservation-btn">
	        예약하기
	    </a>
	</div>
	
    </c:forEach>
    </div>
</body>
</html>
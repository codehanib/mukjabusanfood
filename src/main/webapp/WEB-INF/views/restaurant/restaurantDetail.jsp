<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
	<img src="${restaurant.r_img}" alt="${restaurant.r_name}" width="300">
	<br><br>
	
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
	<!-- 날짜 · 인원 · 시간 선택 -->
	<h3>예약</h3>
		<form action="/reservation/writeForm" method="get">
	        <input type="hidden" name="r_no" value="${restaurant.r_no}">
	        <button type="submit">날짜 · 인원 · 시간</button>
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
    
		<!-- 추천 리뷰 -->
    <h3>추천 리뷰</h3>

    <div>★ ${restaurant.r_point} (${reviewCount})</div>
    <br>
    
    <c:forEach var="review" items="${restaurantESList}">
        <div>
            <c:if test="${not empty review.rvimg_img}">
                <img src="${review.rvimg_img}" width="120">
                <br>
            </c:if>
            
            ★ ${review.rv_point} &nbsp; ${review.u_name}
            <br>
            ${review.rv_content}
            
        </div>
        <br>

    </c:forEach>
    
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
		
	 <!-- 예약 -->
	<div>
       <c:forEach var="date" items="${dateList}">
          <form action="/reservation/writeForm" method="get" style="display:inline;">
	          <input type="hidden" name="r_no" value="${restaurant.r_no}">
	          <input type="hidden" name="res_day" value="${date}">
	          <button type="submit">${date}<br>예약 가능</button>
          </form>
       </c:forEach>
            
 	<!-- 페이징 -->
    <c:forEach begin="1" end="${totalPage}" var="i">

        <a href="/restaurant/category?mukja_c_no=${mukja_c_no}&page=${i}">
            ${i}
        </a>

    </c:forEach>
        </div>
</body>
</html>
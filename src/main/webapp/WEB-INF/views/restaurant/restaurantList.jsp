<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html>

<head>
<meta charset="UTF-8">
<title>식당 목록</title>
<link rel="stylesheet" href="/css/restaurantList.css">
</head>
<body>
<%@ include file="/WEB-INF/views/header.jsp" %>

<div class="page-wrapper">

    <!-- 왼쪽 음식 카테고리 -->
    <aside class="sidebar-category">

        <h3>🍽️ 음식 카테고리</h3>

		<ul class="category-list">
		
		    <li>
		        <a href="${pageContext.request.contextPath}/category?cate=0">
		            전체 메뉴
		        </a>
		    </li>
		
		    <li>
		        <a href="${pageContext.request.contextPath}/category?cate=1">
		            🍚 한식
		        </a>
		    </li>
		
		    <li>
		        <a href="${pageContext.request.contextPath}/category?cate=2">
		            🥟 중식
		        </a>
		    </li>
		
		    <li>
		        <a href="${pageContext.request.contextPath}/category?cate=3">
		            🍣 일식
		        </a>
		    </li>
		
		    <li>
		        <a href="${pageContext.request.contextPath}/category?cate=4">
		            🍕 양식 / 세계음식
		        </a>
		    </li>
		
		    <li>
		        <a href="${pageContext.request.contextPath}/category?cate=5">
		            🍗 육류
		        </a>
		    </li>
		
		    <li>
		        <a href="${pageContext.request.contextPath}/category?cate=6">
		            🦞 해산물
		        </a>
		    </li>
		
		    <li>
		        <a href="${pageContext.request.contextPath}/category?cate=7">
		            ☕ 디저트 / 카페
		        </a>
		    </li>
		
		    <li>
		        <a href="${pageContext.request.contextPath}/category?cate=8">
		            🍺 주점
		        </a>
		    </li>
		
		    <li>
		        <a href="${pageContext.request.contextPath}/category?cate=9">
		            🌙 기타
		        </a>
		    </li>
		
		</ul>
    </aside>


<!-- 오른쪽 검색 결과 -->
<div class="restaurant-list-container">

    <!-- 검색 결과 없음 -->
    <c:if test="${empty restaurantList}">
        <div class="empty-message">검색 결과가 없습니다.</div>
    </c:if>

    <!-- 식당 목록 -->
    <c:forEach var="restaurant" items="${restaurantList}">
        <div class="restaurant-card" onclick="location.href='/restaurant/detail?r_no=${restaurant.r_no}&keyword=${keyword}'">

            <!-- 식당 이미지 -->
            <a class="restaurant-image-link" href="/restaurant/detail?r_no=${restaurant.r_no}">
                <c:choose>
                    <c:when test="${fn:startsWith(restaurant.r_img, 'http')}">
                        <img class="restaurant-image" src="${restaurant.r_img}" alt="${restaurant.r_name}">

                    </c:when>
                    <c:otherwise>
                        <img class="restaurant-image" src="/upload/${restaurant.r_img}" alt="${restaurant.r_name}">
                    </c:otherwise>
                </c:choose>

            </a>

            <!-- 오른쪽 정보 -->
            <div class="restaurant-content">

                <!-- 식당 이름 -->
                <div class="restaurant-title-row">

				    <a class="restaurant-name-link" href="/restaurant/detail?r_no=${restaurant.r_no}&keyword=${keyword}">
				        <h2 class="restaurant-name">${restaurant.r_name}</h2>
				    </a>
				
				<sec:authorize access="hasRole('ADMIN')">
				    <a class="restaurant-delete-btn" href="/restaurant/delete?r_no=${restaurant.r_no}&keyword=${keyword}" onclick="event.stopPropagation(); return confirm('식당을 삭제하시겠습니까?');">
				        식당 삭제
				    </a>
				</sec:authorize>
				</div>

                <!-- 별점 / 리뷰 / 지역 -->
                <div class="restaurant-summary">
                    <span class="star">
                        ★
                    </span>
                    <span class="rating">
                        <fmt:formatNumber value="${restaurant.reviewAvg}" pattern="0.0"/>
                    </span>
                    <span class="review-count">(${restaurant.reviewCount}) &gt;</span>
                    <span class="restaurant-category">
                        ${restaurant.r_region}
                        ·
                        ${restaurant.mukja_c_name}

                    </span>
                </div>

                <!-- 영업 정보 -->
				<div class="restaurant-info">
				
				    <div class="info-line">
				        영업시간 ·
				        <c:choose>
				            <c:when test="${not empty restaurant.simple_time}">
				                ${restaurant.simple_time}
				            </c:when>
				            <c:otherwise>
				                영업시간 정보 없음
				            </c:otherwise>
				        </c:choose>
				    </div>
					
					<div class="info-line">
					    휴무일 · ${restaurant.rest_day}
					</div>

				</div>


				<!-- 예약 -->
				<a class="reservation-btn" href="${pageContext.request.contextPath}/reservation/reservationInsert?r_no=${restaurant.r_no}" onclick="event.stopPropagation();">
				    예약하기
				</a>
				
				<!-- 배달 -->
				<a class="delivery-btn" href="${pageContext.request.contextPath}/delivery/menu?r_no=${restaurant.r_no}" onclick="event.stopPropagation();">
				    배달주문
				</a>

            </div>

        </div>

    </c:forEach>

</div>

</div>
<%@ include file="/WEB-INF/views/clickbutton.jsp" %>
<%@ include file="/WEB-INF/views/footer.jsp" %>

</body>
</html>
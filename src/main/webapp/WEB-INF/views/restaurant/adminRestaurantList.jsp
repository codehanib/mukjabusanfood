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

<title>관리자 식당 관리</title>

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/adminRestaurantList.css">

</head>

<body>

<%@ include file="/WEB-INF/views/header.jsp" %>

<div class="restaurant-list-container">

    <!-- 관리자 제목 -->
    <div class="admin-title-area">
        <h2>식당 관리</h2>
        <span>식당번호 순</span>
    </div>


    <!-- 식당이 없는 경우 -->
    <c:if test="${empty restaurantList}">
        <div class="empty-message">
            등록된 식당이 없습니다.
        </div>
    </c:if>


    <!-- 식당 목록 -->
    <c:forEach var="restaurant" items="${restaurantList}">

        <!-- 카드 전체 클릭 -->
        <div class="restaurant-card"
             onclick="location.href='/restaurant/detail?r_no=${restaurant.r_no}'">


            <!-- 식당 번호 -->
            <div class="restaurant-number">
                No. ${restaurant.r_no}
            </div>


            <!-- 식당 이미지 -->
            <div class="restaurant-image-link">

                <c:choose>

                    <c:when test="${fn:startsWith(restaurant.r_img, 'http')}">
                        <img class="restaurant-image"
                             src="${restaurant.r_img}"
                             alt="${restaurant.r_name}">
                    </c:when>

                    <c:otherwise>
                        <img class="restaurant-image"
                             src="/upload/${restaurant.r_img}"
                             alt="${restaurant.r_name}">
                    </c:otherwise>

                </c:choose>

            </div>


			<!-- 식당 내용 -->
			<div class="restaurant-content">
			
			    <!-- 식당명 + 삭제 버튼 -->
			    <div class="restaurant-title-row">
			
			        <h2 class="restaurant-name">
			            ${restaurant.r_name}
			        </h2>
			
			        <a class="restaurant-delete-btn" href="/admin/restaurant/delete?r_no=${restaurant.r_no}" onclick="event.stopPropagation(); return confirm('이 식당을 삭제하시겠습니까?');">
			            식당 삭제
			        </a>
			
			    </div>
			
			
			    <!-- 별점 / 리뷰 / 지역 -->
			    <div class="restaurant-summary">
			
			        <span class="star">
			            ★
			        </span>
			
			        <span class="rating">
			            <fmt:formatNumber value="${restaurant.reviewAvg}" pattern="0.0"/>
			        </span>
			
			        <span class="review-count">
			            (${restaurant.reviewCount}) &gt;
			        </span>
			
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
		</div>
	</div>

    </c:forEach>
    
    <!-- 페이징 -->
	<c:if test="${totalPage > 1}">
	
	    <div class="pagination">
	
	        <!-- 이전 10페이지 -->
	        <c:if test="${startPage > 1}">
	            <a href="/admin/restaurantList?page=${startPage - 1}">
	                &lt;
	            </a>
	        </c:if>
	
	
	        <!-- 페이지 번호 10개씩 -->
	        <c:forEach begin="${startPage}"
	                   end="${endPage}"
	                   var="p">
	
	            <c:choose>
	
	                <!-- 현재 페이지 -->
	                <c:when test="${p == page}">
	                    <span class="active">${p}</span>
	                </c:when>
	
	                <!-- 다른 페이지 -->
	                <c:otherwise>
	                    <a href="/admin/restaurantList?page=${p}">
	                        ${p}
	                    </a>
	                </c:otherwise>
	
	            </c:choose>
	
	        </c:forEach>
	
	
	        <!-- 다음 10페이지 -->
	        <c:if test="${endPage < totalPage}">
	            <a href="/admin/restaurantList?page=${endPage + 1}">
	                &gt;
	            </a>
	        </c:if>
	
	    </div>
	
	</c:if>

</div>

</body>
</html>
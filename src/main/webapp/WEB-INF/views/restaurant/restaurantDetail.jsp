<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>식당 상세</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css">
</head>
<style>
.restaurant-info {
    margin-top: 30px;
}

.info-item {
    padding: 5px 0;
    border-bottom: 1px solid #eee;
    margin-bottom: 20px;
}

.info-title {
    font-size: 17px;
    font-weight: 500;
    margin-bottom: 10px;
}

.info-content {
    font-size: 15px;
    line-height: 1.7;
    white-space: normal;
}
.info-content a {
    color: #333;
    text-decoration: underline;
}
.business-time {
    line-height: 1.8;
    font-size: 15px;
}
.business-hours-summary {
    display: flex;
    align-items: center;
    cursor: pointer;
}

#hoursArrow {
    margin-left: 8px;
}

.business-hours-all {
    display: none;
    margin-top: 10px;
    line-height: 1.8;
}

</style>
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
	<br>
		<!-- 관리자만 식당 삭제 -->
	    <sec:authorize access="hasRole('ADMIN')">
	        <a href="/restaurant/delete?r_no=${restaurant.r_no}&keyword=${keyword}">식당 삭제</a>
	    </sec:authorize>
	<h2>${restaurant.r_name}</h2>
	
	<div>★${restaurant.r_point} · 리뷰 ${reviewCount}개 > &nbsp; ${restaurant.r_region} · ${restaurant.mukja_c_name}</div>
		<br>
	
	<div>${restaurant.r_info}</div>
		<br><hr>
	<div>${restaurant.r_addr}</div>	
		<br>
	<div id="businessHoursSource" style="display:none;">
		    ${restaurant.display_time}
	</div>
		
	<div class="business-hours-summary" onclick="toggleBusinessHours()">
		    <span id="todayBusinessHours"></span>
		    <span id="hoursArrow">⌄</span>
	</div>
		
	<div id="businessHoursAll" class="business-hours-all"></div>
	
	<hr>
	
	<!-- 예약 -->
	<h3 id="reservation">예약</h3>
	<form action="/reservation/reservationInsert" method="get">
	
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
	    <select name="res_time" id="res_time">
								<option value="">선택</option>
								<option value="11:00">11:00</option>
								<option value="11:30">11:30</option>
								<option value="12:00">12:00</option>
								<option value="12:30">12:30</option>
								<option value="13:00">13:00</option>
								<option value="13:30">13:30</option>
								<option value="14:00">14:00</option>
								<option value="17:00">17:00</option>
								<option value="17:30">17:30</option>
								<option value="18:00">18:00</option>
								<option value="18:30">18:30</option>
								<option value="19:00">19:00</option>
								<option value="19:30">19:30</option>
								<option value="20:00">20:00</option>
								<option value="20:30">20:30</option>
								<option value="21:00">21:00</option>
						</select>
	
		<c:choose>
			<c:when test="${payment}">
				<button type="submit">결제하기</button>
			</c:when>
			<c:otherwise>
				<button type="submit">예약하기</button>
			</c:otherwise>
		</c:choose>
	
	</form>

	<hr>
	
	<!-- 메뉴 -->
    <h3>메뉴</h3>
    
    <c:forEach var="menu" items="${menuList}">
    	<input type="hidden" name="r_no" value="${restaurant.r_no}">
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

    <c:choose>
       <c:when test="${not empty rvPList}">
          <c:forEach var="rv" items="${rvPList}">
             <table border="1">
                <tr>
                   <td colspan="2">${rv.u_name}</td>
                </tr>
                <tr>
                   <td>${rv.rv_point}</td>
                   <td>${rv.rv_reg_date}</td>
                </tr>
                <tr>
                   <td colspan="2">
                      <c:forEach var="rg" items="${rv.reviewImages}">
                      <c:choose>
                      	<c:when test="${rg.rvimg_img == null || rg.rvimg_img == ''}">
                                <!-- 이미지 없음 -->
                        </c:when>
                         
                        <c:when test="${fn:startsWith(rg.rvimg_img, 'http://')
                                            or fn:startsWith(rg.rvimg_img, 'https://')}">
                            <img src="${rg.rvimg_img}" width="100" height="100">
                        </c:when>
                        <c:otherwise>
                           <img src="/upload/${rg.rvimg_img}" width="100" height="100">
                        </c:otherwise>
                     </c:choose>
                     </c:forEach>
                   </td>
                   <td colspan="2">${rv.rv_content}</td>
                </tr>
             </table>
          </c:forEach>
       </c:when>
       <c:otherwise>
          <p>리뷰가 없습니다.</p>
       </c:otherwise>
    </c:choose>
    <br>

    
	<form action="/restaurant/review" method="get">
		<input type="hidden" name="r_no" value="${restaurant.r_no}">
		<button type="submit">리뷰 전체보기</button>
	</form>
	<sec:authorize access="hasRole('USER')">
		<form action="/users/reviewWrite" method="post" enctype="multipart/form-data">
		    <input type="hidden" name="r_no" value="${restaurant.r_no}">
		    <button type="submit">리뷰 쓰기</button>
		</form>
	</sec:authorize>

	<hr>

	<!-- 위치 -->
	<h3>위치</h3>
	
	<div>${restaurant.r_addr}</div>
	<div id="map" style="width:500px; height:350px;"></div>
	
	<hr>
	<!-- 상세정보 -->
    <h3>상세정보</h3>
	<div class="restaurant-info">
	    <div id="restaurantDesc"></div>
	</div>
	
	<!-- DB의 r_desc 원본 -->
	<textarea id="rawRestaurantDesc" style="display:none;"><c:out value="${restaurant.r_desc}" /></textarea>
	
	<hr>
	
	<form action="/users/bookmarkInsert" method="get">
		<input type="hidden" name="r_no" value="${restaurant.r_no}">
		<button type="submit" style="border:none; background:none; cursor:pointer;">
		    <i class="fa-regular fa-bookmark" style="color:black; font-size:24px;"></i>
		</button>
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
	    <form action="/users/bookmarkInsert" method="get">
			<input type="hidden" name="r_no" value="${restaurant.r_no}">
			<button type="submit" style="border:none; background:none; cursor:pointer;">
			    <i class="fa-regular fa-bookmark" style="color:black; font-size:24px;"></i>
			</button>
		</form>
	
	
	    <!-- 예약하기 -->
	    <form action="/reservation/reservationInsert" method="get">
	
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
	    <select name="res_time" id="res_time">
								<option value="">선택</option>
								<option value="11:00">11:00</option>
								<option value="11:30">11:30</option>
								<option value="12:00">12:00</option>
								<option value="12:30">12:30</option>
								<option value="13:00">13:00</option>
								<option value="13:30">13:30</option>
								<option value="14:00">14:00</option>
								<option value="17:00">17:00</option>
								<option value="17:30">17:30</option>
								<option value="18:00">18:00</option>
								<option value="18:30">18:30</option>
								<option value="19:00">19:00</option>
								<option value="19:30">19:30</option>
								<option value="20:00">20:00</option>
								<option value="20:30">20:30</option>
								<option value="21:00">21:00</option>
						</select>
	
		<c:choose>
			<c:when test="${payment}">
				<button type="submit">결제하기</button>
			</c:when>
			<c:otherwise>
				<button type="submit">예약하기</button>
			</c:otherwise>
		</c:choose>
	
	</form>
	</div>
	
    </c:forEach>
    </div>
    
    
	<script type="text/javascript"
	    src="//dapi.kakao.com/v2/maps/sdk.js?appkey=725ccfecc146dd521381871e82fd928b&libraries=services&autoload=false">
	</script>
	
	<script src="${pageContext.request.contextPath}/js/delivery_map.js"></script>
	
	<script>
	initRestaurantMap(
	    "${restaurant.r_lat}",
	    "${restaurant.r_lon}"
	);
	</script>
	<script src="/js/restaurantDetail.js"></script>

</body>
</html>
</body>
</html>
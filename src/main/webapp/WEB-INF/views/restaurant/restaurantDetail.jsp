<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>식당 상세</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css">
<link rel="stylesheet" href="/css/restaurantDetail.css">
</head>

<body>

	<button type="button" onclick="history.back()">
	    <i class="fa-solid fa-chevron-left"></i>
	</button>
	<button type="button" onclick="location.href='/main'">home</button>
	<br><br>
	
	<!-- 식당 이미지 -->
	<c:choose>

	    <c:when test="${fn:startsWith(restaurant.r_img, 'http')}">
	        <img src="${restaurant.r_img}" alt="${restaurant.r_name}" class="restaurant-main-img">
	    </c:when>
	
	    <c:otherwise>
	        <img src="/upload/${restaurant.r_img}" alt="${restaurant.r_name}" class="restaurant-main-img">
	    </c:otherwise>

	</c:choose>
	<br>

	<div class="restaurant-title-row">
	
	    <h2>${restaurant.r_name}</h2>
	
	    <!-- 관리자만 식당 삭제 -->
	    <sec:authorize access="hasRole('ADMIN')">
	        <a class="restaurant-delete-btn"
	           href="/restaurant/delete?r_no=${restaurant.r_no}&keyword=${keyword}"
	           onclick="return confirm('이 식당을 삭제하시겠습니까?');">
	            식당 삭제
	        </a>
	    </sec:authorize>
	
	</div>
	<c:choose>
	    <c:when test="${reviewCount > 0}">
	        <div class="restaurant-summary">
			    <span class="summary-star">★</span>
			    <span class="summary-rating">
			        <fmt:formatNumber value="${reviewAvg}" pattern="0.0"/>
			    </span>
			
			    · 리뷰 ${reviewCount}개 >
			    &nbsp; ${restaurant.r_region} · ${restaurant.mukja_c_name}
			</div>
	    </c:when>
	
	    <c:otherwise>
	        <div>
	            리뷰 없음 > &nbsp; ${restaurant.r_region} · ${restaurant.mukja_c_name}
	        </div>
	    </c:otherwise>
	</c:choose>

		<br>
	
	<div class="restaurant-description">${restaurant.r_info}</div>
		<br><hr>
	<div>${restaurant.r_addr}</div>	
		<br>
	<div id="businessHoursSource" style="display:none;">
	    <c:out value="${restaurant.r_time}" />
	</div>
		
	<div class="business-hours-summary" onclick="toggleBusinessHours()">
		    <span id="todayBusinessHours"></span>
		    <span id="hoursArrow">⌄</span>
	</div>
		
	<div id="businessHoursAll" class="business-hours-all"></div>
	
	<hr>
	
	<!-- 메뉴 데이터가 하나라도 있을 때만 메뉴 영역 표시 -->
	<c:if test="${not empty menuList or not empty menuBoardImageList}">

    <!-- 메뉴 -->
    <h3>메뉴</h3>

    <!-- 메뉴판 이미지가 있을 때만 '메뉴판' 표시 -->
    <c:if test="${not empty menuBoardImageList}">
        <div>메뉴판</div>
	
	       <c:forEach var="img" items="${menuBoardImageList}">
			    <c:choose>
			        <c:when test="${fn:startsWith(img.mbi_img, 'http')}">
			            <img src="${img.mbi_img}" class="menu-board-img" onclick="openImage(this.src)">
			        </c:when>
			
			        <c:otherwise>
			            <img src="/upload/${img.mbi_img}" class="menu-board-img" onclick="openImage(this.src)">
			        </c:otherwise>
			    </c:choose>
			</c:forEach>
	
	        <hr>
	    </c:if>
	
	    <!-- 메뉴 목록 -->
	    <c:forEach var="menu" items="${menuList}" varStatus="status">
	        <table border="1">
	            <tr>
	                <td>
	                    <div class="menu-name">
						    <c:if test="${status.index < 2}">
						        <span class="representative-badge">대표</span>
						    </c:if>
						
						    ${menu.mn_name}
						</div>
						
						<c:if test="${not empty menu.mn_content}">
						    <div class="menu-content">
						        ${menu.mn_content}
						    </div>
						</c:if>
						
						<div class="menu-price">
						    <fmt:formatNumber value="${menu.mn_price}" pattern="#,###"/>원
						</div>
	                </td>
	
	                <td>
	                   <c:if test="${not empty menu.mn_img}">
						
						    <c:choose>
						        <c:when test="${fn:startsWith(menu.mn_img, 'http')}">
						            <img src="${menu.mn_img}" alt="${menu.mn_name}" class="menu-img" onclick="openImage(this.src)">
						        </c:when>
						
						        <c:otherwise>
						            <img src="/upload/${menu.mn_img}" alt="${menu.mn_name}" class="menu-img" onclick="openImage(this.src)">
						        </c:otherwise>
						    </c:choose>
						
						</c:if>
	                </td>
	            </tr>
	        </table>
	    </c:forEach>
	
	    <hr>
	
	</c:if>
    
	<!-- 추천 리뷰 -->
	<div class="review-section-header">
	    <h3>추천 리뷰</h3>
	    <div class="review-header-buttons">
	
	        <!-- 리뷰 전체보기 -->
	        <form action="/restaurant/review" method="get">
	            <input type="hidden" name="r_no" value="${restaurant.r_no}">
	            <button type="submit" class="review-all-btn">
	                리뷰 전체보기 <span>›</span>
	            </button>
	        </form>
	        
	        <!-- 리뷰 쓰기 : USER만 -->
	        <sec:authorize access="hasRole('USER')">
	            <form action="/users/reviewWrite" method="post" enctype="multipart/form-data">
	
	                <input type="hidden" name="r_no" value="${restaurant.r_no}">
	
	                <button type="submit" class="review-write-btn">리뷰 쓰기</button>
	
	            </form>
	        </sec:authorize>
	    </div>
	</div>
	
	    <c:choose>
	        <c:when test="${not empty rvPList}">
	            <div class="review-list">
	                <c:forEach var="rv" items="${rvPList}">
	                    <div class="review-card">
	                        <!-- 상단 -->
	                        <div class="review-card-top">
	                            <div class="review-rating">
	                                <span class="review-star">★</span>
	                                <span>${rv.rv_point}</span>
	                            </div>
	                            <div class="review-date">
	                                <fmt:formatDate value="${rv.rv_reg_date}" pattern="yyyy/MM/dd"/>
	                            </div>
	                        </div>
	
	                        <!-- 작성자 -->
	                        <div class="review-user">
	
	                            <span>${rv.u_name}</span>
	
	                            <c:if test="${loginUserNo == rv.u_no}">
	                                <span class="review-manage">
	                                    <a href="/restaurant/reviewUpdate?r_no=${rv.r_no}">수정</a>
	                                    <a href="/restaurant/reviewDelete?r_no${rv.r_no}">삭제</a>
	                                </span>
	                            </c:if>
	                        </div>
	
	                        <!-- 리뷰 이미지 -->
	                        <c:if test="${not empty rv.reviewImages}">
	                            <div class="review-images">
	                                <c:forEach var="rg" items="${rv.reviewImages}">
	
	                                    <c:choose>
	
	                                        <c:when test="${rg.rvimg_img == null || rg.rvimg_img == ''}">
	                                        </c:when>
	
	                                        <c:when test="${fn:startsWith(rg.rvimg_img, 'http://')
	                                            or fn:startsWith(rg.rvimg_img, 'https://')}">
	
	                                            <img src="${rg.rvimg_img}" class="review-img">
	
	                                        </c:when>
	
	                                        <c:otherwise>
	                                            <img src="/upload/${rg.rvimg_img}" class="review-img">
	                                        </c:otherwise>
	                                    </c:choose>
	                                </c:forEach>
	                            </div>
	                        </c:if>
	
	                        <!-- 리뷰 내용 -->
	                        <div class="review-content">${rv.rv_content}</div>
	                     </div>
	                </c:forEach>
	            </div>
	        </c:when>
	        <c:otherwise>
	            <div class="review-empty">리뷰가 없습니다.</div>
	        </c:otherwise>
	    </c:choose>
	<hr>

	<!-- 위치 -->
	<h3>위치</h3>
	
	<div>${restaurant.r_addr}</div>
	<div id="map" class="restaurant-main-img"></div>
	
	<hr>
	
	<!-- 상세정보 -->
	<div id="detailInfoSection" style="display:none;">
	
	    <h3>상세정보</h3>
	
	    <div class="restaurant-info">
	        <div id="restaurantDesc"></div>
	    </div>
	
	</div>
	
	<textarea id="rawRestaurantDesc" style="display:none;"><c:out value="${restaurant.r_desc}" /></textarea>
		<br>
		
            
 	<!-- 페이징 -->
    <c:forEach begin="1" end="${totalPage}" var="i">

        <a href="/restaurant/category?mukja_c_no=${mukja_c_no}&page=${i}">
            ${i}
        </a>
	</c:forEach>
	 
	<!-- 하단 고정 예약 바 -->
	<div class="bottom-reservation">
	
	    <!-- 회원 -->
	    <sec:authorize access="isAuthenticated()">
	
	        <!-- 북마크 -->
	        <button type="button" class="bookmark-btn" onclick="toggleBookmark(${restaurant.r_no}, this)">
			    <c:choose>
			        <c:when test="${bookmarkCheck > 0}">
			            <i class="fa-solid fa-bookmark"></i>
			        </c:when>
			        <c:otherwise>
			            <i class="fa-regular fa-bookmark"></i>
			        </c:otherwise>
			    </c:choose>
			</button>
	
	        <!-- 예약하기 -->
	        <button type="button" class="reservation-btn" onclick="location.href='/reservation/reservationInsert?r_no=${restaurant.r_no}'">
	            예약하기
	        </button>
	
	        <!-- 배달 주문 -->
	        <form action="${pageContext.request.contextPath}/delivery/menu" method="get">
	            <input type="hidden" name="r_no" value="${restaurant.r_no}">
	            <button type="submit" class="delivery-btn">배달주문</button>
	        </form>
	
	    </sec:authorize>
	
	    <!-- 비회원 -->
		<sec:authorize access="isAnonymous()">
		
		    <!-- 북마크 -->
		    <form action="/users/bookmarkToggle" method="get">
		        <input type="hidden" name="r_no" value="${restaurant.r_no}">
		
		        <button type="submit" class="bookmark-btn">
		            <i class="fa-regular fa-bookmark"></i>
		        </button>
		    </form>
		
		    <!-- 예약 -->
		    <button type="button" class="reservation-btn" onclick="location.href='/reservation/reservationInsert?r_no=${restaurant.r_no}'">
		        예약하기
		    </button>
		
		    <!-- 배달 주문 -->
		    <form action="${pageContext.request.contextPath}/delivery/menu"
		          method="get">
		
		        <input type="hidden" name="r_no" value="${restaurant.r_no}">
		
		        <button type="submit" class="delivery-btn">
		            배달주문
		        </button>
		    </form>
		</sec:authorize>
	</div>
    
    <!-- 이미지 크게 보기 -->
	<div id="imageModal" class="image-modal" onclick="closeImage()">
	    <span class="image-modal-close">&times;</span>
	
	    <img id="imageModalImg"
	         class="image-modal-content"
	         onclick="event.stopPropagation()">
	</div>
    
    <%@ include file="/WEB-INF/views/footer.jsp" %>
    <%@ include file="/WEB-INF/views/clickbutton.jsp" %>
    
	<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=725ccfecc146dd521381871e82fd928b&libraries=services&autoload=false">
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

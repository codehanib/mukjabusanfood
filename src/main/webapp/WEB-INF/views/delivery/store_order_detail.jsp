<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>점주 - 배달 주문 상세 정보 [#${delivery.d_no}]</title>
<style>
    body { font-family: '맑은 고딕', sans-serif; margin: 20px; background-color: #f8f9fa; color: #333; }
    .container { max-width: 900px; margin: 0 auto; background: white; padding: 30px; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.08); }
    
    /* 헤더 및 상태 */
    .detail-header { display: flex; justify-content: space-between; align-items: center; border-bottom: 2px solid #222; padding-bottom: 15px; margin-bottom: 25px; }
    .order-title { font-size: 1.5em; font-weight: bold; }
    .status-tag { background: #FF5722; color: white; padding: 6px 14px; border-radius: 20px; font-weight: bold; }

    /* 섹션 제목 */
    .section-title { font-size: 1.15em; font-weight: bold; color: #222; margin-top: 25px; margin-bottom: 12px; border-left: 4px solid #FF5722; padding-left: 10px; }

    /* 테이블 공통 */
    .info-table, .menu-table { width: 100%; border-collapse: collapse; margin-bottom: 20px; }
    .info-table th { width: 25%; background: #f1f3f5; text-align: left; padding: 10px 12px; border: 1px solid #dee2e6; }
    .info-table td { padding: 10px 12px; border: 1px solid #dee2e6; }

    .menu-table th { background: #e9ecef; padding: 12px; text-align: center; border: 1px solid #dee2e6; }
    .menu-table td { padding: 12px; text-align: center; border: 1px solid #dee2e6; }

    /* 메뉴 이미지 */
    .menu-img { width: 60px; height: 60px; object-fit: cover; border-radius: 6px; }

    /* 최종 금액 계산 박스 */
    .total-box { background: #fff3e0; padding: 20px; border-radius: 6px; text-align: right; font-size: 1.2em; font-weight: bold; color: #e65100; margin-top: 20px; }

    /* 하단 버튼 바 */
    .btn-bar { display: flex; justify-content: space-between; margin-top: 30px; }
    .btn { padding: 10px 20px; border: none; border-radius: 4px; cursor: pointer; font-weight: bold; text-decoration: none; }
    .btn-back { background: #6c757d; color: white; }
    .btn-print { background: #343a40; color: white; }
</style>
</head>
<body>

<div class="container">
    
    <!-- 1. 주문 상세 상단 헤더 -->
    <div class="detail-header">
        <div class="order-title">📌 배달 주문 상세 정보 (#${delivery.d_no})</div>
        <div class="status-tag">${delivery.d_stats}</div>
    </div>

    <!-- 2. 매장(restaurant) 및 고객 기본 정보 -->
    <div class="section-title">🏪 매장 및 주문 접수 정보</div>
    <table class="info-table">
        <tr>
            <th>가게 이름</th>
            <td>${restaurant.r_name} (#${restaurant.r_no})</td>
            <th>가게 주소</th>
            <td>${restaurant.r_addr}</td>
        </tr>
        <tr>
            <th>주문 일시</th>
            <td><fmt:formatDate value="${delivery.d_reg_date}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
            <th>회원 번호</th>
            <td>회원 #${delivery.u_no}</td>
        </tr>
    </table>

    <!-- 3. 배달 및 예상 시간 산출 정보 -->
    <div class="section-title">🚚 배달 및 시간 계산 상세</div>
    <table class="info-table">
        <tr>
            <th>배달 도착 주소</th>
            <td colspan="3"><strong>${delivery.d_addr}</strong></td>
        </tr>
        <tr>
            <th>배송지 위도/경도</th>
            <td>위도: ${delivery.d_lat} / 경도: ${delivery.d_lng}</td>
            <th>산출 거리 정보</th>
            <td>하버사인 위경도 거리 반영 완료</td>
        </tr>
        <tr>
            <th>점주 설정 조리시간</th>
            <td>${delivery.d_cooking_time != null ? delivery.d_cooking_time : 0} 분</td>
            <th>거리 계산 배달시간</th>
            <td>${delivery.d_delivery_time != null ? delivery.d_delivery_time : 0} 분</td>
        </tr>
        <tr>
            <th>최종 도착 예정 시각</th>
            <td colspan="3" style="color: #d84315; font-weight: bold;">
                <c:choose>
                    <c:when test="${not empty delivery.d_arrival_time}">
                        <fmt:formatDate value="${delivery.d_arrival_time}" pattern="yyyy-MM-dd HH:mm:ss"/> 도착 예정
                    </c:when>
                    <c:otherwise>주문 수락 전 (미정)</c:otherwise>
                </c:choose>
            </td>
        </tr>
    </table>

    <!-- 4. 주문한 음식 메뉴 상세 목록 (menu + dv_menu JOIN) -->
    <div class="section-title">🍽️ 주문 메뉴 상품 내역</div>
    <table class="menu-table">
        <thead>
            <tr>
                <th>메뉴 이미지</th>
                <th>메뉴 번호</th>
                <th>메뉴명</th>
                <th>단가</th>
                <th>수량</th>
                <th>소계 금액</th>
            </tr>
        </thead>
        <tbody>
            <c:set var="grandTotal" value="0" />
            <c:forEach var="item" items="${orderMenuList}">
                <c:set var="itemTotal" value="${item.dvm_price * item.dvm_count}" />
                <c:set var="grandTotal" value="${grandTotal + itemTotal}" />
                <tr>
                    <td>
                        <c:choose>
                            <c:when test="${not empty item.mn_img}">
                                <img src="${pageContext.request.contextPath}/upload/${item.mn_img}" class="menu-img" alt="메뉴">
                            </c:when>
                            <c:otherwise>
                                <div style="width:50px; height:50px; background:#eee; line-height:50px; margin:0 auto; font-size:0.8em; color:#888;">No Img</div>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>#${item.mn_no}</td>
                    <td style="text-align: left; font-weight: bold;">
                        ${item.mn_name != null ? item.mn_name : '메뉴명조회'}
                        <c:if test="${not empty item.mn_content}">
                            <br><small style="color:#777; font-weight:normal;">${item.mn_content}</small>
                        </c:if>
                    </td>
                    <td><fmt:formatNumber value="${item.dvm_price}" type="currency"/></td>
                    <td><strong>${item.dvm_count}</strong> 개</td>
                    <td style="font-weight: bold;"><fmt:formatNumber value="${itemTotal}" type="currency"/></td>
                </tr>
            </c:forEach>

            <c:if test="${empty orderMenuList}">
                <tr>
                    <td colspan="6" style="color: #999;">주문된 상세 메뉴 항목이 없습니다.</td>
                </tr>
            </c:if>
        </tbody>
    </table>

    <!-- 5. 최종 결제 총액 -->
    <div class="total-box">
        총 주문 합계 금액: <fmt:formatNumber value="${grandTotal}" type="currency"/>
    </div>

    <!-- 6. 하단 버튼 영역 -->
    <div class="btn-bar">
        <a href="${pageContext.request.contextPath}/store/order/history?r_no=${delivery.r_no}" class="btn btn-back">← 목록으로 돌아가기</a>
        <button type="button" class="btn btn-print" onclick="window.print();">🖨️ 주문 영수증 출력</button>
    </div>

</div>

</body>
</html>
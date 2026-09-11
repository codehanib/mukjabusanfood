<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="referrer" content="no-referrer">
<title>점주 - 배달 주문 상세 정보 [#${delivery.d_no}]</title>
<style>
    body { font-family: '맑은 고딕', sans-serif; margin: 20px; background-color: #f8f9fa; color: #333; }
    .container { max-width: 900px; margin: 0 auto; background: white; padding: 30px; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.08); }
    
    .detail-header { display: flex; justify-content: space-between; align-items: center; border-bottom: 2px solid #222; padding-bottom: 15px; margin-bottom: 25px; }
    .order-title { font-size: 1.5em; font-weight: bold; }
    .status-tag { background: #FF5722; color: white; padding: 6px 14px; border-radius: 20px; font-weight: bold; }

    .section-title { font-size: 1.15em; font-weight: bold; color: #222; margin-top: 25px; margin-bottom: 12px; border-left: 4px solid #FF5722; padding-left: 10px; }

    .info-table, .menu-table { width: 100%; border-collapse: collapse; margin-bottom: 20px; }
    .info-table th { width: 25%; background: #f1f3f5; text-align: left; padding: 10px 12px; border: 1px solid #dee2e6; }
    .info-table td { padding: 10px 12px; border: 1px solid #dee2e6; }

    .menu-table th { background: #e9ecef; padding: 12px; text-align: center; border: 1px solid #dee2e6; }
    .menu-table td { padding: 12px; text-align: center; border: 1px solid #dee2e6; }

    .menu-img { width: 60px; height: 60px; object-fit: cover; border-radius: 6px; }

    .total-box { background: #fff3e0; padding: 20px; border-radius: 6px; text-align: right; font-size: 1.2em; font-weight: bold; color: #e65100; margin-top: 20px; }

    .btn-bar { display: flex; justify-content: space-between; margin-top: 30px; }
    .btn { padding: 10px 20px; border: none; border-radius: 4px; cursor: pointer; font-weight: bold; text-decoration: none; }
    .btn-back { background: #6c757d; color: white; }
    .btn-print { background: #343a40; color: white; }
    .btn-action { background: #28a745; color: white; font-size: 1em; padding: 8px 16px; border-radius: 4px; border: none; cursor: pointer; font-weight: bold; }
    .btn-reject { background: #dc3545; color: white; font-size: 1em; padding: 8px 16px; border-radius: 4px; border: none; cursor: pointer; font-weight: bold; }
</style>
</head>
<body>

<div class="container">
    
    <!-- 1. 주문 상세 상단 헤더 -->
    <div class="detail-header">
        <div class="order-title">📌 배달 주문 상세 정보 (#${delivery.d_no})</div>
        <div class="status-tag">${delivery.d_stats}</div>
    </div>

    <!-- 2. 매장 및 주문 접수 정보 -->
    <div class="section-title">🏪 매장 및 주문 접수 정보</div>
    <table class="info-table">
        <tr>
            <th>가게 번호</th>
            <td>식당 #${delivery.r_no}</td>
            <th>주문 접수 시간</th>
            <td><fmt:formatDate value="${delivery.d_reg_date}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
        </tr>
        <tr>
            <th>회원 번호</th>
            <td colspan="3">회원 #${delivery.u_no}</td>
        </tr>
    </table>

    <!-- 3. 배달 및 시간 계산 상세 -->
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
                    <c:when test="${delivery.d_stats == '주문거절'}">
                        <span style="color:#dc3545;">❌ 주문이 거절되었습니다.</span>
                    </c:when>
                    <c:when test="${not empty delivery.d_arrival_time}">
                        <fmt:formatDate value="${delivery.d_arrival_time}" pattern="yyyy-MM-dd HH:mm:ss"/> 도착 예정
                    </c:when>
                    <c:otherwise>주문 수락 전 (미정)</c:otherwise>
                </c:choose>
            </td>
        </tr>
    </table>
	
	<!-- 3-1. 점주 주문 승인 및 거절 처리 폼 (주문접수 / 주문확인 상태) -->
    <c:if test="${delivery.d_stats == '주문접수' || delivery.d_stats == '주문확인'}">
        <div class="section-title">⚡ 주문 수락 및 거절 처리</div>
        <div style="background: #fff3e0; padding: 20px; border-radius: 6px; margin-bottom: 20px; display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 15px;">
            <!-- 주문 승인 폼 -->
            <form action="${pageContext.request.contextPath}/store/order/accept" method="post" style="display: flex; align-items: center; gap: 15px;">
                <input type="hidden" name="d_no" value="${delivery.d_no}">
                <label style="font-weight: bold;">조리 예상 시간 선택:</label>
                <select name="d_cooking_time" style="padding: 8px 12px; font-size: 1em; border-radius: 4px; border: 1px solid #ccc;">
                    <option value="15">15분</option>
                    <option value="20" selected>20분</option>
                    <option value="30">30분</option>
                    <option value="40">40분</option>
                </select>
                <button type="submit" class="btn btn-action">주문 승인 및 거리시간 자동계산</button>
            </form>

            <!-- 주문 거절 폼 -->
            <form action="${pageContext.request.contextPath}/store/order/reject" method="post" style="display: inline;" onsubmit="return confirm('정말 이 주문을 거절하시겠습니까?');">
                <input type="hidden" name="d_no" value="${delivery.d_no}">
                <button type="submit" class="btn btn-reject">❌ 주문 거절</button>
            </form>
        </div>
    </c:if>

    <!-- 3-2. 배달 진행 상태 변경 폼 (주문승인 / 조리중 / 배달중 상태) -->
    <c:if test="${delivery.d_stats == '주문승인' || delivery.d_stats == '조리중' || delivery.d_stats == '배달중'}">
        <div class="section-title">🚚 배달 진행 상태 변경</div>
        <div style="background: #e8f4f8; padding: 20px; border-radius: 6px; margin-bottom: 20px;">
            <form action="${pageContext.request.contextPath}/store/order/updateStatus" method="post" style="display: flex; align-items: center; gap: 15px;">
                <input type="hidden" name="d_no" value="${delivery.d_no}">
                
                <c:if test="${delivery.d_stats == '주문승인'}">
                    <input type="hidden" name="nextStatus" value="조리중">
                    <button type="submit" class="btn btn-action" style="background: #007bff;">🍳 조리 시작 (조리중)</button>
                </c:if>
                <c:if test="${delivery.d_stats == '조리중'}">
                    <input type="hidden" name="nextStatus" value="배달중">
                    <button type="submit" class="btn btn-action" style="background: #007bff;">🛵 라이더 출발 (배달중)</button>
                </c:if>
                <c:if test="${delivery.d_stats == '배달중'}">
                    <input type="hidden" name="nextStatus" value="배달완료">
                    <button type="submit" class="btn btn-action" style="background: #28a745;">✅ 배달 완료 처리</button>
                </c:if>
            </form>
        </div>
    </c:if>
   

    <!-- 4. 주문한 음식 메뉴 상세 목록 -->
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
                                <c:choose>
                                    <%-- DB 값이 인터넷 URL(http/https)인 경우 --%>
                                    <c:when test="${item.mn_img.startsWith('http')}">
                                        <img src="${item.mn_img}"
                                             class="menu-img"
                                             alt="${item.mn_name}"
                                             onerror="this.onerror=null; this.src='https://via.placeholder.com/60?text=No+Img';">
                                    </c:when>
                                    <%-- DB 값이 서버 내부 경로인 경우 --%>
                                    <c:otherwise>
                                        <img src="${pageContext.request.contextPath}/${item.mn_img}"
                                             class="menu-img"
                                             alt="${item.mn_name}"
                                             onerror="this.onerror=null; this.src='https://via.placeholder.com/60?text=No+Img';">
                                    </c:otherwise>
                                </c:choose>
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

<!-- 실시간 Ajax Polling (3초 간격 상태 동기화) -->
<script>
(function() {
    var dNo = "${delivery.d_no}";
    var currentStats = "${delivery.d_stats}";

    function checkStatusChange() {
        if (!dNo || currentStats === '배달완료' || currentStats === '주문거절') return;
        
        fetch("${pageContext.request.contextPath}/delivery/api/status?d_no=" + dNo)
            .then(function(response) { return response.json(); })
            .then(function(data) {
                if (data && data.d_stats && data.d_stats !== currentStats) {
                    location.reload();
                }
            })
            .catch(function(err) { console.error("상태 변경 확인 중 오류:", err); });
    }

    setInterval(checkStatusChange, 3000);
})();
</script>

</body>
</html>
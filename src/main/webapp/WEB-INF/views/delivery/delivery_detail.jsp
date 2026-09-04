<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>배달 상세 현황 - Mukja</title>
<style>
    body { font-family: '맑은 고딕', sans-serif; margin: 20px; line-height: 1.6; }
    .container { max-width: 800px; margin: 0 auto; border: 1px solid #ccc; padding: 20px; border-radius: 8px; }
    
    /* 주문 상태 스텝 바 */
    .status-bar { display: flex; justify-content: space-between; background: #f4f4f4; padding: 15px; border-radius: 5px; margin-bottom: 20px; }
    .step { font-weight: bold; color: #888; }
    .step.active { color: #e64a19; font-size: 1.1em; text-decoration: underline; }
    
    /* 지도 영역 */
    #map { width: 100%; height: 350px; background: #eee; margin-bottom: 20px; border-radius: 5px; }
    
    /* 정보 테이블 */
    table { width: 100%; border-collapse: collapse; margin-top: 10px; }
    th, td { border: 1px solid #ddd; padding: 10px; text-align: left; }
    th { background-color: #f8f8f8; width: 30%; }
    
    .timer-box { background: #fff3e0; border: 1px solid #ffe0b2; padding: 15px; text-align: center; font-size: 1.2em; font-weight: bold; color: #d84315; margin-bottom: 20px; }
</style>

<!-- 카카오 지도 API (발급받은 appkey 연결 필요) -->
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=725ccfecc146dd521381871e82fd928b&libraries=services"></script>
<!-- js 파일가져오기(시각화) -->
<script src="${pageContext.request.contextPath}/js/delivery_map.js"></script>
<!-- 외부 함수를 호출 -->
<script>
	// 페이지 로드 완료시 외부함수 호출
	window.onload = function(){
		var storeLat = ${not empty storeLat ? storeLat : 35.1795588};
		var storeLng = ${not empty storeLng ? storeLng : 129.0756416};
		var destLat = ${delivery.d_lat};
        var destLng = ${delivery.d_lng};
        var status = "${delivery.d_stats}";
    // 외부 js파일 함수호출
        initDeliveryMap(storeLat, storeLng, destLat, destLng, status);
	};
</script>

</head>
<body>

<div class="container">
    <h2>🚚 배달 주문 상세 현황</h2>
    
    <!-- 1. 주문 상태 표시 바 -->
    <div class="status-bar">
        <div class="step ${delivery.d_stats == '주문확인' ? 'active' : ''}">1. 접수대기</div>
        <div class="step ${delivery.d_stats == '주문승인' ? 'active' : ''}">2. 주문수락</div>
        <div class="step ${delivery.d_stats == '조리중' ? 'active' : ''}">3. 조리중</div>
        <div class="step ${delivery.d_stats == '배달중' ? 'active' : ''}">4. 배달중</div>
        <div class="step ${delivery.d_stats == '배달완료' ? 'active' : ''}">5. 배달완료</div>
    </div>

    <!-- 도착 예정 시간 및 카운트다운 -->
    <div class="timer-box">
        <c:choose>
            <c:when test="${not empty delivery.d_arrival_time}">
                남은 예상 시간: <span id="remainingTime">계산 중...</span>
                <br><small style="font-size: 0.7em; color: #666;">(조리시간 ${delivery.d_cooking_time}분 + 배달시간 ${delivery.d_delivery_time}분 반영)</small>
            </c:when>
            <c:otherwise>
                점주님이 주문 확인 및 조리 시간을 입력 중입니다.
            </c:otherwise>
        </c:choose>
    </div>

    <!-- 2. 위도/경도 기반 지도 및 이동 시뮬레이션 -->
    <h3>📍 실시간 배달 위치 추적 (시뮬레이션)</h3>
    <div id="map"></div>

    <!-- 3. 기본적인 주문 상세 정보 -->
    <h3>📝 주문 상세 정보</h3>
    <table>
        <tr>
            <th>주문 번호</th>
            <td>${delivery.d_no}</td>
        </tr>
        <tr>
            <th>배달 주소</th>
            <td>${delivery.d_addr}</td>
        </tr>
        <tr>
            <th>주문 시각</th>
            <td><fmt:formatDate value="${delivery.d_reg_date}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
        </tr>
        <tr>
            <th>도착 예정 시각</th>
            <td>
                <c:choose>
                    <c:when test="${not empty delivery.d_arrival_time}">
                        <fmt:formatDate value="${delivery.d_arrival_time}" pattern="HH:mm"/> 도착 예정
                    </c:when>
                    <c:otherwise>미확정</c:otherwise>
                </c:choose>
            </td>
        </tr>
    </table>

    <h3 style="margin-top: 20px;">🍽️ 주문 메뉴 내역</h3>
    <table>
        <thead>
            <tr>
                <th>메뉴 번호</th>
                <th>수량</th>
                <th>가격</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="menu" items="${menuList}">
                <tr>
                    <td>${menu.mn_no}</td>
                    <td>${menu.dvm_count}개</td>
                    <td><fmt:formatNumber value="${menu.dvm_price}" type="currency"/></td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</div>

<!-- 도착 예정 시간 실시간 카운트다운 스크립트 -->
<script>
    <c:if test="${not empty delivery.d_arrival_time}">
        var arrivalTime = new Date("${delivery.d_arrival_time}").getTime();

        function updateTimer() {
            var now = new Date().getTime();
            var diff = arrivalTime - now;

            if (diff <= 0) {
                document.getElementById("remainingTime").innerText = "곧 도착 또는 배달 완료!";
                return;
            }

            var minutes = Math.floor((diff % (1000 * 60 * 60)) / (1000 * 60));
            var seconds = Math.floor((diff % (1000 * 60)) / 1000);
            document.getElementById("remainingTime").innerText = minutes + "분 " + seconds + "초";
        }

        setInterval(updateTimer, 1000);
        updateTimer();
    </c:if>
</script>

</body>
</html>
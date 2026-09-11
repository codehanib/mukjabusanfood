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

<%-- 도착 예정 시각 ISO 날짜 포맷 변환 --%>
<c:if test="${not empty delivery.d_arrival_time}">
    <fmt:formatDate value="${delivery.d_arrival_time}" pattern="yyyy-MM-dd'T'HH:mm:ss" var="isoArrivalTime"/>
</c:if>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

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
            <c:when test="${delivery.d_stats == '주문거절'}">
                <span style="color: #d32f2f;">❌ 점주님의 사정으로 주문이 거절되었습니다.</span>
            </c:when>
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
    
    <!-- 차트 -->
    <div style="width: 100%; max-width: 800px; margin: 30px auto; padding: 20px; background: #ffffff; border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.08); box-sizing: border-box;">
    <h3 style="font-size: 16px; color: #333; margin-bottom: 15px; font-weight: bold;">
        📊 요일/시간대별 실시간 평균 배달 소요 시간
    </h3>
    
    <!-- 💡 높이를 명시적으로 280px로 지정 -->
    <div style="height: 280px; position: relative;">
        <canvas id="deliveryTimeChart"></canvas>
    </div>
</div>
 
</div>

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
            <c:forEach var="menu" items="${not empty menuList ? menuList : orderMenuList}">
                <tr>
                    <td>${menu.mn_no}</td>
                    <td>${menu.dvm_count}개</td>
                    <td><fmt:formatNumber value="${menu.dvm_price}" type="currency"/></td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
    
    <!-- 4. 나의 주문 내역 목록 돌아가기 버튼 -->
	<div style="text-align: center; margin-top: 30px; margin-bottom: 10px;">
	    <a href="${pageContext.request.contextPath}/delivery/user/history?u_no=${delivery.u_no}" 
	       style="display: inline-block; padding: 12px 28px; background-color: #333; color: #ffffff; text-decoration: none; border-radius: 6px; font-weight: bold; font-size: 1em; transition: background 0.2s;"
	       onmouseover="this.style.backgroundColor='#555';"
	       onmouseout="this.style.backgroundColor='#333';">
	        📋 나의 배달 주문 내역으로 돌아가기
	    </a>
	</div>
</div>

<!-- 1. 실시간 타이머 스크립트 -->
<script>
(function() {
    var arrivalTimeString = "${isoArrivalTime}";
    var arrivalTimeMillis = arrivalTimeString ? new Date(arrivalTimeString).getTime() : 0;
    var currentStatus = "${delivery.d_stats}";

    function updateTimer() {
        var timerElement = document.getElementById("remainingTime");
        if (!timerElement) return;

        if (currentStatus === '배달완료') {
            timerElement.innerHTML = "<span style='color:#28a745; font-weight:bold;'>🎉 배달이 완료되었습니다!</span>";
            return;
        }

        if (!arrivalTimeMillis || isNaN(arrivalTimeMillis)) {
            timerElement.innerText = "주문 확인 중입니다.";
            return;
        }

        var now = new Date().getTime();
        var distance = arrivalTimeMillis - now;

        if (distance <= 0) {
            timerElement.innerText = "곧 도착 예정입니다.";
            return;
        }

        var hours = Math.floor(distance / (1000 * 60 * 60));
        var minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
        var seconds = Math.floor((distance % (1000 * 60)) / 1000);

        if (hours > 0) {
            timerElement.innerText = hours + "시간 " + minutes + "분 " + seconds + "초";
        } else {
            timerElement.innerText = minutes + "분 " + seconds + "초";
        }
    }

    setInterval(updateTimer, 1000);
    updateTimer();
})();
</script>

<!-- 2. 카카오 지도 SDK & 외부 delivery_map.js 불러오기 -->
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=725ccfecc146dd521381871e82fd928b&libraries=services&autoload=false"></script>
<script src="${pageContext.request.contextPath}/js/delivery_map.js"></script>

<!-- 3. 외부 JS의 initDeliveryMap 함수 호출 -->
<script>
initDeliveryMap(
    35.1795588,             // 식당 위도
    129.0756416,            // 식당 경도
    "${delivery.d_lat}",    // 배송지 위도
    "${delivery.d_lng}",    // 배송지 경도
    "${delivery.d_stats}"   // 배달 상태
);
</script>

<!-- 4. 실시간 Ajax Polling (3초 간격 상태 동기화) -->
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

<script>
    // 1. 서버에서 넘어온 List<Map> 데이터를 안전하게 JS 배열로 매핑
    var hours = [];
    var minutes = [];

    <c:forEach var="stat" items="${timeStats}">
        hours.push("${stat.DELIVERY_HOUR}");
        minutes.push(parseInt("${stat.AVG_MINUTES}"));
    </c:forEach>

    // 2. 만약 데이터가 비어있을 경우 대비한 안전장치 (기본값 세팅)
    /*
    if (hours.length === 0) {
        hours = ['11시', '12시', '13시', '17시', '18시', '19시', '20시'];
        minutes = [25, 42, 32, 30, 48, 52, 38];
    }
    */

    var ctx = document.getElementById('deliveryTimeChart').getContext('2d');
    
    var deliveryTimeChart = new Chart(ctx, {
        type: 'line',
        data: {
            labels: hours, 
            datasets: [{
                label: '평균 소요시간 (분)',
                data: minutes, 
                borderColor: '#FF5722',
                backgroundColor: 'rgba(255, 87, 34, 0.08)',
                borderWidth: 3,
                pointBackgroundColor: '#FF5722',
                pointRadius: 4,
                tension: 0.3,
                fill: true
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: { display: false }
            },
            scales: {
                y: {
                    beginAtZero: true,
                    max: 70,
                    grid: { color: '#f0f0f0' }
                },
                x: {
                    grid: { display: false }
                }
            }
        }
    });
</script>

</body>
</html>
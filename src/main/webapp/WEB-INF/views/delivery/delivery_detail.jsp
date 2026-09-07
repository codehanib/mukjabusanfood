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
            <c:forEach var="menu" items="${not empty menuList ? menuList : orderMenuList}">
                <tr>
                    <td>${menu.mn_no}</td>
                    <td>${menu.dvm_count}개</td>
                    <td><fmt:formatNumber value="${menu.dvm_price}" type="currency"/></td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
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

<!-- 2. 카카오 지도 SDK 단일 호출 및 마커 시뮬레이션 -->
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=725ccfecc146dd521381871e82fd928b&libraries=services&autoload=false"></script>
<script>
kakao.maps.load(function() {
    var mapContainer = document.getElementById('map');
    if (!mapContainer) return;

    // 식당 위치 (부산 연제구 연산동)
    var storeLat = 35.1795588;
    var storeLng = 129.0756416;

    // DB 데이터 파싱
    var rawLat = parseFloat("${delivery.d_lat}");
    var rawLng = parseFloat("${delivery.d_lng}");

    // [정수 잘림 및 위경도 바뀜 자동 방어 로직]
    var destLat = rawLat;
    var destLng = rawLng;

    // 1. 위경도가 반대로 들어왔을 경우 교정
    if (rawLat > 100) {
        destLat = rawLng;
        destLng = rawLat;
    }

    // 2. 소수점이 잘려서 35.0 또는 129.0 (바다 좌표)으로 들어온 경우 예외 처리
    if (isNaN(destLat) || Math.floor(destLat) === 35 && destLat < 35.1) {
        destLat = 35.1765; // 기본 배송지 위도
    }
    if (isNaN(destLng) || Math.floor(destLng) === 129 && destLng < 129.05) {
        destLng = 129.0785; // 기본 배송지 경도
    }

    var storePos = new kakao.maps.LatLng(storeLat, storeLng);
    var destPos = new kakao.maps.LatLng(destLat, destLng);
    var status = "${delivery.d_stats}";

    var map = new kakao.maps.Map(mapContainer, {
        center: new kakao.maps.LatLng((storeLat + destLat) / 2, (storeLng + destLng) / 2),
        level: 5
    });

    // 1. 가게 마커
    var storeMarker = new kakao.maps.Marker({ position: storePos, map: map });
    new kakao.maps.InfoWindow({
        content: '<div style="padding:5px;font-size:12px;font-weight:bold;">🏪 가게 위치</div>'
    }).open(map, storeMarker);

    // 2. 배송지 마커
    var destMarker = new kakao.maps.Marker({ position: destPos, map: map });
    new kakao.maps.InfoWindow({
        content: '<div style="padding:5px;font-size:12px;font-weight:bold;">🏠 배송지</div>'
    }).open(map, destMarker);

    // 3. 점선 경로 (Polyline)
    new kakao.maps.Polyline({
        path: [storePos, destPos],
        strokeWeight: 4,
        strokeColor: '#FF5722',
        strokeOpacity: 0.8,
        strokeStyle: 'shortdash',
        map: map
    });

    // 4. 라이더 위치
    if (status === '조리중' || status === '배달중' || status === '배달완료') {
        var ratio = 0.15;
        if (status === '배달중') ratio = 0.65;
        if (status === '배달완료') ratio = 1.0;

        var riderLat = storeLat + (destLat - storeLat) * ratio;
        var riderLng = storeLng + (destLng - storeLng) * ratio;
        var riderPos = new kakao.maps.LatLng(riderLat, riderLng);

        var riderMarker = new kakao.maps.Marker({ position: riderPos, map: map });
        new kakao.maps.InfoWindow({
            content: '<div style="padding:5px;font-size:12px;color:#007bff;font-weight:bold;">🛵 라이더 (' + status + ')</div>'
        }).open(map, riderMarker);
    }

    // 5. 화면 영역 맞춤
    var bounds = new kakao.maps.LatLngBounds();
    bounds.extend(storePos);
    bounds.extend(destPos);
    map.setBounds(bounds);
});
</script>
</body>
</html>
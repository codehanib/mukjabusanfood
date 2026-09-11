/**
 * 카카오 지도 실시간 배달 추적 및 마커 표출 공통 함수
 * @param {number|string} rawStoreLat - 식당 위도
 * @param {number|string} rawStoreLng - 식당 경도
 * @param {number|string} rawDestLat - 고객 배송지 위도
 * @param {number|string} rawDestLng - 고객 배송지 경도
 * @param {string} status - 배달 상태 ('주문접수', '주문확인', '주문승인', '조리중', '배달중', '배달완료' 등)
 * @param {string} [containerId='map'] - (선택) 지도를 표출할 div ID (기본값: 'map')
 */
function initDeliveryMap(rawStoreLat, rawStoreLng, rawDestLat, rawDestLng, status, containerId) {
    // containerId 인자가 넘어오지 않은 경우 기본값 'map' 사용
    containerId = containerId || 'map';

    // autoload=false 환경 대응
    kakao.maps.load(function() {
        var container = document.getElementById(containerId);
        if (!container) {
            console.error("지도를 표출할 요소를 찾을 수 없습니다. ID: #" + containerId);
            return;
        }

        // 1. 위/경도 수신 및 예외/바뀜 자동 교정 로직
        var storeLat = parseFloat(rawStoreLat) || 35.1795588; // 기본값: 연산동 식당 위도
        var storeLng = parseFloat(rawStoreLng) || 129.0756416; // 기본값: 연산동 식당 경도

        var destLat = parseFloat(rawDestLat);
        var destLng = parseFloat(rawDestLng);

        // 위경도가 서로 반대로 들어왔을 경우 (위도가 100 초과일 수 없음)
        if (destLat > 100) {
            var temp = destLat;
            destLat = destLng;
            destLng = temp;
        }

        // DB 소수점 잘림(35.0, 129.0 바다 좌표) 및 NaN 방어
        if (isNaN(destLat) || (Math.floor(destLat) === 35 && destLat < 35.1)) {
            destLat = 35.1765;
        }
        if (isNaN(destLng) || (Math.floor(destLng) === 129 && destLng < 129.05)) {
            destLng = 129.0785;
        }

        var storePosition = new kakao.maps.LatLng(storeLat, storeLng);
        var destPosition = new kakao.maps.LatLng(destLat, destLng);

        // 2. 지도 생성
        var options = {
            center: new kakao.maps.LatLng((storeLat + destLat) / 2, (storeLng + destLng) / 2),
            level: 5
        };
        var map = new kakao.maps.Map(container, options);

        // 3. 식당 마커 및 인포윈도우
        var storeMarker = new kakao.maps.Marker({
            position: storePosition,
            map: map,
            title: '식당'
        });
        new kakao.maps.InfoWindow({
            content: '<div style="padding:5px;font-size:12px;font-weight:bold;">🏪 식당</div>'
        }).open(map, storeMarker);

        // 4. 고객 배송지 마커 및 인포윈도우
        var destMarker = new kakao.maps.Marker({
            position: destPosition,
            map: map,
            title: '우리집'
        });
        new kakao.maps.InfoWindow({
            content: '<div style="padding:5px;font-size:12px;font-weight:bold;">🏠 배송지</div>'
        }).open(map, destMarker);

        // 5. 식당 - 배송지 간 경로 점선(Polyline)
        new kakao.maps.Polyline({
            path: [storePosition, destPosition],
            strokeWeight: 4,
            strokeColor: '#FF5722',
            strokeOpacity: 0.8,
            strokeStyle: 'shortdash',
            map: map
        });

        // 6. 배달 상태별 라이더 마커 및 이동 애니메이션
        if (status === '조리중' || status === '주문승인') {
            // 조리중: 식당 인근(15% 지점)에 고정 표출
            var cookLat = storeLat + (destLat - storeLat) * 0.15;
            var cookLng = storeLng + (destLng - storeLng) * 0.15;
            var cookPos = new kakao.maps.LatLng(cookLat, cookLng);

            var riderMarker = new kakao.maps.Marker({ position: cookPos, map: map });
            new kakao.maps.InfoWindow({
                content: '<div style="padding:5px;font-size:12px;color:#007bff;font-weight:bold;">🛵 조리 중</div>'
            }).open(map, riderMarker);

        } else if (status === '배달중') {
            // 배달중: CustomOverlay 사용 부드러운 실시간 이동 시뮬레이션
            var riderOverlay = new kakao.maps.CustomOverlay({
                position: storePosition,
                content: '<div style="padding:4px 8px; background:#FF3D00; color:white; border-radius:12px; font-size:11px; font-weight:bold; border:2px solid white; box-shadow:0 2px 5px rgba(0,0,0,0.3);">🛵 배달중</div>',
                map: map,
                yAnchor: 1.5
            });

            // 💡 애니메이션 설정 (자연스러운 이동 제어)
            var progress = 0.05; // 시작 위치 (식당 인근)
            var intervalMs = 100; // 0.1초(100ms)마다 위치 업데이트 (기존 200ms에서 단축하여 끊김 제거)
            var step = 0.0015; // 약 60초에 걸쳐 도착지까지 슬로우 이동 (기존 0.008에서 5배 이상 감속)

            setInterval(function() {
                progress += step;
                if (progress > 0.95) {
                    progress = 0.05; // 목적지 근처 도착 시 식당 부근에서 재출발
                }

                // 💡 출발 시 가속, 도착 시 감속하는 이징 곡선 공식 적용 (실제 오토바이 운전처럼 부드러움)
                var easedProgress = progress < 0.5 
                    ? 2 * progress * progress 
                    : 1 - Math.pow(-2 * progress + 2, 2) / 2;

                var currentLat = storeLat + (destLat - storeLat) * easedProgress;
                var currentLng = storeLng + (destLng - storeLng) * easedProgress;

                riderOverlay.setPosition(new kakao.maps.LatLng(currentLat, currentLng));
            }, intervalMs);

        } else if (status === '배달완료') {
            // 배달완료: 도착 지점에 표시
            var arriveMarker = new kakao.maps.Marker({ position: destPosition, map: map });
            new kakao.maps.InfoWindow({
                content: '<div style="padding:5px;font-size:12px;color:#28a745;font-weight:bold;">🎉 배달 완료</div>'
            }).open(map, arriveMarker);
        }

        // 7. 가게와 배송지가 한 화면에 모두 들어오도록 화면 영역 맞춤
        var bounds = new kakao.maps.LatLngBounds();
        bounds.extend(storePosition);
        bounds.extend(destPosition);
        map.setBounds(bounds);
    });
}

function initRestaurantMap(rawLat, rawLng, containerId) {

    containerId = containerId || 'map';

    kakao.maps.load(function() {

        var container = document.getElementById(containerId);

        if (!container) {
            console.error("지도 영역을 찾을 수 없습니다.");
            return;
        }

        var lat = parseFloat(rawLat);
        var lng = parseFloat(rawLng);

        if (isNaN(lat) || isNaN(lng)) {
            console.error("식당 위도 또는 경도가 없습니다.");
            return;
        }

        var position = new kakao.maps.LatLng(lat, lng);

        var map = new kakao.maps.Map(container, {
            center: position,
            level: 3
        });

        var marker = new kakao.maps.Marker({
            position: position,
            map: map
        });

        new kakao.maps.InfoWindow({
            content: '<div style="padding:5px;font-size:12px;">🏪 식당 위치</div>'
        }).open(map, marker);
    });
}
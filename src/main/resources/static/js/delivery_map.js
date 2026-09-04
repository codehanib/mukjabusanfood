/*
 * 
 */
//함수로 필요데이터 받기
function initDeliveryMap(storeLat, storeLng, destLat, destLng, status){
	var container = document.getElementById('map');
	var options ={
		center: new kakao.maps.LatLng((storeLat + destLat) / 2, (storeLng + destLng)/2),
		level: 6
	};
	
	var map = new kakao.maps.Map(container, options);
	
	// 식당 마커
	var storePosition = new kakao.maps.LatLng(storeLat, storeLng);
	new kakao.maps.Marker({position: storePosition, map:map, title:'식당'});
	
	// 고객 배송지 마커
	var destPosition = new kakao.maps.LatLng(destLat, destLng);
	new kakao.maps.Marker({position: destPosition, map:map, title:'우리집'});
	
	//이동 점 애니메이션 (배달중일 때)
	if (status === '배달중' || status === '주문승인') {
		var riderOverlay = new kakao.maps.CustomOverlay({
			position : storePosition,
			content : '<div style="width:16px; height:16px; background:red; border-radius:50%; border:2px solid white;"></div>',
			map: map
		});
		
		var progress = 0;
		setInterval(function() {
			progress += 0.01;
			if(progress >1)progress = 0;
			var currentLat = storeLat + (destLat - storeLat) * progress;
			var currentLng = storeLng + (destLng - storeLng) * progress;
			riderOverlay.setPosition(new kakao.maps.LatLng(currentLat, currentLng));
		},300);
	}
}
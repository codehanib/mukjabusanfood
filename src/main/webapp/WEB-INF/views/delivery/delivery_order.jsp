<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>배달 주문하기 - Mukja</title>
<style>
    body { font-family: '맑은 고딕', sans-serif; margin: 20px; }
    .form-container { max-width: 600px; margin: 0 auto; border: 1px solid #ddd; padding: 20px; border-radius: 8px; }
    .form-group { margin-bottom: 15px; }
    label { display: block; font-weight: bold; margin-bottom: 5px; }
    input[type="text"] { width: 70%; padding: 8px; }
    button { padding: 8px 15px; background: #FF5722; color: white; border: none; cursor: pointer; border-radius: 4px; }
    button:hover { background: #e64a19; }
</style>

<!-- 카카오 주소검색 및 좌표변환 API -->
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=YOUR_KAKAO_MAP_APPKEY&libraries=services"></script>
</head>
<body>

<div class="form-container">
    <h2>🛒 배달 주문 작성</h2>
    
    <form action="${pageContext.request.contextPath}/delivery/order/create" method="POST">
        <!-- 식당번호 및 회원번호 (테스트용 hidden) -->
        <input type="hidden" name="r_no" value="1">
        <input type="hidden" name="u_no" value="1">
        
        <!-- 자동 추출될 위도/경도 값 -->
        <input type="hidden" name="d_lat" id="d_lat">
        <input type="hidden" name="d_lng" id="d_lng">

        <div class="form-group">
            <label for="d_addr">배달 주소</label>
            <input type="text" id="d_addr" name="d_addr" readonly required placeholder="주소 검색 버튼을 눌러주세요">
            <button type="button" onclick="execDaumPostcode()">주소 검색</button>
        </div>

        <div class="form-group">
            <label for="d_addr_detail">상세 주소</label>
            <input type="text" id="d_addr_detail" placeholder="예: 101동 202호">
        </div>

        <button type="submit" style="width: 100%; padding: 12px; font-size: 1.1em; margin-top: 10px;">주문 결제하기</button>
    </form>
</div>

<script>
    // 주소 검색 및 위경도 추출 함수
    function execDaumPostcode() {
        new daum.Postcode({
            oncomplete: function(data) {
                var addr = data.address; // 최종 주소 변수
                document.getElementById("d_addr").value = addr;

                // 주소-좌표 변환 객체 생성
                var geocoder = new kakao.maps.services.Geocoder();

                // 주소로 상세 좌표(위도, 경도)를 검색
                geocoder.addressSearch(addr, function(result, status) {
                    if (status === kakao.maps.services.Status.OK) {
                        // 위도(d_lat) 및 경도(d_lng) 입력
                        document.getElementById("d_lat").value = result[0].y;
                        document.getElementById("d_lng").value = result[0].x;
                        console.log("추출된 좌표 -> 위도: " + result[0].y + ", 경도: " + result[0].x);
                    }
                });
            }
        }).open();
    }
</script>
</body>
</html>
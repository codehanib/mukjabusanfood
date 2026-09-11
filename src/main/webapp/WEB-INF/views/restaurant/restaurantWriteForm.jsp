<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>식당 등록</title>
</head>
<body>
	<h2>식당 등록</h2>
	<form action="/restaurant/insert" method="post" name="restaurantWriteForm" enctype="multipart/form-data">
		<!-- 화면에는 안 보이지만 등록할 때 같이 전송 -->
	    <input type="hidden" id="r_region" name="r_region">
	    <input type="hidden" id="r_lat" name="r_lat">
	    <input type="hidden" id="r_lon" name="r_lon">
	<table border="1">
		<tr>
			<td>식당 이름</td>
			<td><input type="text" name="r_name"></td>
		</tr>
		<tr>
			<td>식당 주소</td>
			<td>
				<input type="text" id="r_addr" name="r_addr" readonly>
    			<input type="button" value="주소 검색" onclick="goPopup();">
    		</td>
		</tr>
		<tr>
		    <td>식당 이미지</td>
		    <td>
		        <input type="file" name="r_upload" accept="image/*">
		    </td>
		</tr>
		<tr>
			<td>매장 소개</td>
			<td><textarea name="r_info" rows="5" cols="60"></textarea></td>
		</tr>
		<tr>
		    <td>상세 정보</td>
		    <td>
			 <textarea name="r_desc" rows="15" cols="60"
placeholder="전화번호: 051-000-0000
주차안내: 제휴주차장 1시간 무료주차 제공
편의시설: 웰컴키즈존, 아기의자, 자동결제
콜키지: 콜키지 가능(유료)
단체 이용 안내: 10명 이하
안내 및 유의사항: 예약시간 10분 이상 지각 시 예약이 취소될 수 있습니다.
홈페이지: https://www.mukja.com"></textarea>
		    </td>
		</tr>
		<tr>
			<td>영업시간</td>
			<td><textarea name="r_time" rows="7" cols="60"
placeholder="월 휴무
화 15:00~21:00  브레이크 타임 17:00~17:30
수 15:00~21:00  브레이크 타임 17:00~17:30
목 16:00~21:00  브레이크 타임 17:00~17:30
금 16:00~21:00  브레이크 타임 17:00~17:30
토 16:00~21:00
금 16:00~21:00"></textarea></td>
		</tr>
		<tr>
			<td>휴무일</td>
			<td><input type="text" name="r_rest"></td>
		</tr>
		<tr>
		    <td>음식종류</td>
		    <td>
		        <select name="mukja_c_no" required>
		            <option value="">음식종류 선택</option>
		
		            <c:forEach var="category" items="${categoryList}">
		                <option value="${category.mukja_c_no}">
		                    ${category.mukja_c_name}
		                </option>
		            </c:forEach>
		        </select>
		    </td>
		</tr>
		
		<tr>
		    <td>메뉴</td>
		    <td>
		        <div id="menuArea">
		
		            <div class="menu-item">
		                메뉴명
		                <input type="text" name="mn_name">
		                <br>
		
		                메뉴설명
		                <textarea name="mn_content"></textarea>
		                <br>
		
		                가격
		                <input type="number" name="mn_price" placeholder="10000">
		                <br>
		
		                메뉴이미지
		                <input type="file" name="mn_upload" accept="image/*">
		
		                <br><br>
		            </div>
		
		        </div>
		
		        <button type="button" onclick="addMenu()">메뉴 추가</button>
		    </td>
		</tr>
		
		<tr>
		    <td>메뉴판 이미지</td>
		    <td>
		        <input type="file"
		               name="mbi_upload"
		               accept="image/*"
		               multiple>
		    </td>
		</tr>
		
        <tr>
            <td colspan="2"><button type="submit">식당 등록</button></td>
        </tr>
        
    </table>
	</form>
	
	<script type="text/javascript"
	    src="//dapi.kakao.com/v2/maps/sdk.js?appkey=725ccfecc146dd521381871e82fd928b&libraries=services&autoload=false">
	</script>
	
	<script type="text/javascript">
	
		function goPopup() {
		    window.open(
		        "/jusoPopup",
		        "pop",
		        "width=570,height=420,scrollbars=yes,resizable=yes"
		    );
		}
		
		function jusoCallBack(roadAddrPart1, addrDetail, zipNo) {
		    const fullAddr = roadAddrPart1 + " " + addrDetail;

		    // DB에 저장할 전체 주소
		    document.getElementById("r_addr").value = fullAddr;

		    // 지역 자동 입력
		    const parts = roadAddrPart1.split(" ");

		    if (parts.length >= 2) {
		        document.getElementById("r_region").value = parts[1];
		    }

		    // 위도/경도는 도로명주소만 사용
		    searchLatLon(roadAddrPart1);
		}
	
	
		// 주소 → 위도, 경도 변환
		function searchLatLon(address) {
		    kakao.maps.load(function() {
		        const geocoder = new kakao.maps.services.Geocoder();
		        geocoder.addressSearch(address, function(result, status) {
		
		            if (status === kakao.maps.services.Status.OK) {
		
		                document.getElementById("r_lat").value = result[0].y;
		                document.getElementById("r_lon").value = result[0].x;
		
		                console.log("위도:", result[0].y);
		                console.log("경도:", result[0].x);
		
		            } else {
		                console.log("좌표 검색 실패:", address, status);
		                alert("주소의 위도/경도를 찾지 못했습니다.");
		            }
		        });
		    });
		}
		
		function addMenu() {

		    const menuArea = document.getElementById("menuArea");

		    const div = document.createElement("div");
		    div.className = "menu-item";

		    div.innerHTML = `
		        메뉴명
		        <input type="text" name="mn_name">
		        <br>

		        메뉴설명
		        <textarea name="mn_content"></textarea>
		        <br>

		        가격
		        <input type="number" name="mn_price">
		        <br>

		        메뉴이미지
		        <input type="file" name="mn_upload" accept="image/*">

		        <br><br>
		    `;

		    menuArea.appendChild(div);
		}
	</script>
	

</body>
</html>
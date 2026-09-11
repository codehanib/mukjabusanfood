<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>식당 정보 수정</title>
</head>
<body>
	<h2>식당 정보 수정</h2>
	<form action="/restaurant/update" method="post" name="restaurantUpdateForm" enctype="multipart/form-data">
		
		<input type="hidden" id="r_region" name="r_region" value="${restaurant.r_region}">
		<input type="hidden" id="r_lat" name="r_lat" value="${restaurant.r_lat}">
		<input type="hidden" id="r_lon" name="r_lon" value="${restaurant.r_lon}">
			
		<!-- 수정 기준이 되는 상품 PK 번호 전달 -->
        <input type="hidden" name="r_no" value="${restaurant.r_no}">
        <input type="hidden" name="old_r_img" value="${restaurant.r_img}">
	<table border="1">
		<tr>
			<td>식당 이름</td>
			<td><input type="text" name="r_name" value="${restaurant.r_name}"></td>
		</tr>
		<tr>
			<td>식당 주소</td>
			<td>
				<input type="text" id="r_addr" name="r_addr" value="${restaurant.r_addr}">
				<input type="button" value="주소 검색" onclick="goPopup();">
			</td>
		</tr>
		<tr>
			<td>매장 소개</td>
			<td><textarea name="r_info" rows="5" cols="60">${restaurant.r_info}</textarea></td>
		</tr>
		<tr>
			<td>상세 정보</td>
			<td><textarea name="r_desc" rows="15" cols="60">${restaurant.r_desc}</textarea></td>
		</tr>
		<tr>
			<td>영업시간</td>
			<td><textarea name="r_time" rows="5" cols="60">${restaurant.r_time}</textarea></td>
		</tr>
		<tr>
			<td>휴무일</td>
			<td><input type="text" name="r_rest" value="${restaurant.r_rest}"></td>
		</tr>
	    <tr>
	        <td>식당 이미지</td>
	        <td><input type="file" name="r_upload" accept="image/*"></td>
    	</tr>
		<tr>
		    <td>음식종류</td>
		    <td>
		        <select name="mukja_c_no" required>
		            <option value="">음식종류 선택</option>
		
		            <c:forEach var="category" items="${categoryList}">
		                <option value="${category.mukja_c_no}"
		                    <c:if test="${category.mukja_c_no == restaurant.mukja_c_no}">
		                        selected
		                    </c:if>>
		                    ${category.mukja_c_name}
		                </option>
		            </c:forEach>
		
		        </select>
		    </td>
		</tr>
        <tr>
            <td colspan="2"><button type="submit">식당 정보 수정</button></td>
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
	</script>
	
</body>
</html>
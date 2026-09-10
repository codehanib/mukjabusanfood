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
			<td>지역</td>
			<td><input type="text" name="r_region"></td>
		</tr>
		<tr>
			<td>위도</td>
			<td><input type="number" step="any" name="r_lat"></td>
		</tr>
		<tr>
			<td>경도</td>
			<td><input type="number" step="any" name="r_lon"></td>
		</tr>
		<tr>
			<td>매장 소개</td>
			<td><input type="text" name="r_info"></td>
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
홈페이지: https://www."></textarea>
		    </td>
		</tr>
		<tr>
			<td>영업시간</td>
			<td><input type="text" name="r_time"></td>
		</tr>
		<tr>
			<td>휴무일</td>
			<td><input type="text" name="r_rest"></td>
		</tr>
		<tr>
		    <td>식당 이미지</td>
		    <td>
		        <input type="file" name="r_upload" accept="image/*">
		    </td>
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
            <td colspan="2"><button type="submit">식당 등록</button></td>
        </tr>
    </table>
	</form>
	
	<script type="text/javascript">
		function goPopup() {
		    var pop = window.open(
		        "/jusoPopup",
		        "pop",
		        "width=570,height=420,scrollbars=yes,resizable=yes"
		    );
		}
		
		function jusoCallBack(roadAddrPart1, addrDetail, zipNo) {
		    document.getElementById("r_addr").value =
		        roadAddrPart1 + " " + addrDetail;
		}
	</script>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>식당 정보 수정</title>
</head>
<body>
	<form action="/restaurant/update" method="post" name="restaurantUpdateForm">
	
			<!-- 수정 기준이 되는 상품 PK 번호 전달 -->
            <input type="hidden" name="r_no" value="${restaurant.r_no}">
	<table border="1">
		<tr>
			<td>식당 이름</td>
			<td><input type="text" name="r_name" value="${restaurant.r_name}"></td>
		</tr>
		<tr>
			<td>식당 주소</td>
			<td><input type="text" name="r_addr" value="${restaurant.r_addr}"></td>
		</tr>
		<tr>
			<td>지역</td>
			<td><input type="text" name="r_region" value="${restaurant.r_region}"></td>
		</tr>
		<tr>
			<td>위도</td>
			<td><input type="number" step="any" name="r_lat" value="${restaurant.r_lat}"></td>
		</tr>
		<tr>
			<td>경도</td>
			<td><input type="number" step="any" name="r_lon" value="${restaurant.r_lon}"></td>
		</tr>
		<tr>
			<td>매장 소개</td>
			<td><input type="text" name="r_info" value="${restaurant.r_info}"></td>
		</tr>
		<tr>
			<td>상세 정보</td>
			<td><input type="text" name="r_desc" value="${restaurant.r_desc}"></td>
		</tr>
		<tr>
			<td>영업시간</td>
			<td><input type="text" name="r_time" value="${restaurant.r_time}"></td>
		</tr>
		<tr>
			<td>휴무일</td>
			<td><input type="text" name="r_rest" value="${restaurant.r_rest}"></td>
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
</body>
</html>
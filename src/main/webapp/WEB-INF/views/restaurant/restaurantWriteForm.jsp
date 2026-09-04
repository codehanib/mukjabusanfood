<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>식당 추가</title>
</head>
<body>
	<form action="/restaurant/insert" method="post" name="restaurantWriteForm">
	<table border="1">
		<tr>
			<td>식당 이름</td>
			<td><input type="text" name="r_name"></td>
		</tr>
		<tr>
			<td>식당 주소</td>
			<td><input type="text" name="r_addr"></td>
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
			<td><input type="text" name="r_desc"></td>
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
	
	----------------------------
	밑에는 나중에 메인 화면에 넣을 검색창
	<form action="/restaurant/search" method="get">
	    <input type="text" name="keyword" placeholder="식당, 메뉴, 지역 검색">
	    <button type="submit">검색</button>
	</form>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>북마크 목록</title>
</head>
<body>
	<h2>찜 목록</h2>
	<c:choose>
	<c:when test="${not empty bklist}">
		<c:forEach var="bk" items="${bklist}">
			<table border="1">
			    <tr>
			        <td rowspan="3">
			             <img src="${bk.r_img}" width="200" height="200">
			        </td>
			        <td>${bk.r_name}</td>
			        <td rowspan="3">
			        	<p><a href="/restaurant/detail?r_no=${bk.r_no}">바로가기</a></p>
			        	<p><a href="/users/bookmarkDelete?bk_no=${bk.bk_no}">삭제</a></p>
			        </td>
			    </tr>
			    <tr>
			        <td>${bk.r_region}</td>
			    </tr>
			    <tr>
			        <td>${bk.r_point}</td>
			    </tr>
			</table>
		</c:forEach>
	</c:when>
	<c:otherwise>
		<p>찜한 가게가 없습니다.</p>
	</c:otherwise>
	</c:choose>
</body>
</html>
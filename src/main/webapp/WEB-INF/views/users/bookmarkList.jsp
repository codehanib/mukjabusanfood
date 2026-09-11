<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>bookmark list</title>
</head>
<body>
	<h2>찜한 가게</h2>
	<c:choose>
	<c:when test="${not empty bklist}">
		<c:forEach var="bk" items="${bklist}">
			<table width="700">
			    <tr>
			        <td rowspan="4" width="200">
			             <c:choose>
						    <c:when test="${not empty bk.r_img and fn:startsWith(bk.r_img, 'http')}">
						        <img src="${bk.r_img}"
						             width="200"
						             height="200">
						    </c:when>
						
						    <c:otherwise>
						        <img src="/upload/${bk.r_img}"
						             width="200"
						             height="200">
						    </c:otherwise>
						</c:choose>
			        </td>
			        <td width="300" height="20">${bk.r_name}</td>
			        <td rowspan="4">
			        	<p><a href="/restaurant/detail?r_no=${bk.r_no}">바로가기</a></p>
			        	<p><a href="/users/bookmarkDelete?bk_no=${bk.bk_no}">삭제</a></p>
			        </td>
			    </tr>
			    <tr>
			        <td height="20">${bk.r_region}</td>
			    </tr>
			    <tr>
			        <td height="20">★ ${bk.r_point}</td>
			    </tr>
			    <tr><td> </td></tr>
			</table>
		<hr>
		</c:forEach>
	</c:when>
	<c:otherwise>
		<p>찜한 가게가 없습니다.</p>
	</c:otherwise>
	</c:choose>
	<a href="/main">홈으로</a>
</body>
</html>
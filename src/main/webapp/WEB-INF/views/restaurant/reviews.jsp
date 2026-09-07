<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>리뷰 리스트</title>
</head>
<body>
	 <h2>식당 리뷰</h2>
	 <c:choose>
	 	<c:when test="${not empty rvList}">
	 		<c:forEach var="rv" items="${rvList}">
	 			<table border="1">
	 				<tr>
	 					<td colspan="2">${rv.u_name}</td>
	 				</tr>
	 				<tr>
	 					<td>${rv.rv_point}</td>
	 					<td>${rv.rv_reg_date}</td>
	 				</tr>
	 				<tr>
	 					<td colspan="2">
	 						<c:forEach var="rg" items="${rv.reviewImages}">
	 						<c:choose>
	 							<c:when test="${fn:startsWith(rg.rvimg_img, 'http://')
                      							 or fn:startsWith(rg.rvimg_img, 'https://')}">
	 								<img src="${rg.rvimg_img}" width="100" height="100">
	 							</c:when>
	 							<c:otherwise>
	 								<img src="/upload/${rg.rvimg_img}" width="100" height="100">
	 							</c:otherwise>
	 						</c:choose>
	 						</c:forEach>
	 					</td>
	 					<td colspan="2">${rv.rv_content}</td>
	 				</tr>
	 			</table>
	 		</c:forEach>
	 	</c:when>
	 	<c:otherwise>
	 		<p>리뷰가 없습니다.</p>
	 	</c:otherwise>
	 </c:choose>
</body>
</html>
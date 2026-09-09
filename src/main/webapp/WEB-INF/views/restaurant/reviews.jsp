<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
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
	 					<td colspan="2">${rv.u_name}
	 					<c:if test="${loginUserNo == rv.u_no}">
	 					<a href="/users/reviewUpdateForm?rv_no=${rv.rv_no}">수정</a>
	 					 <a href="/restaurant/reviewDelete?rv_no=${rv.rv_no}&r_no=${rv.r_no}">삭제</a>
	 					</c:if>
	 					</td>
	 				</tr>
	 				<tr>
	 					<td>★ ${rv.rv_point}</td>
	 					<td><fmt:formatDate value="${rv.rv_reg_date}" pattern="yyyy/MM/dd"/></td>
	 				</tr>
	 				<tr>
	 					<td colspan="2">
	 						<c:forEach var="rg" items="${rv.reviewImages}">
	 						<c:choose>
	 							<c:when test="${rg.rvimg_img == null || rg.rvimg_img == ''}">
        								<!-- 이미지 없음 -->
    							</c:when>
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
	 				</tr>
	 				<tr>
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
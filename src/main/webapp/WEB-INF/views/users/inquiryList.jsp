<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>1:1 문의 목록</title>
</head>
<body>
	<c:if test="${param.error == 'notOwner'}">
    <script>
        alert("본인이 작성한 문의만 확인할 수 있습니다.");
    </script>
	</c:if>
	<h3>문의 목록</h3>
	<hr>
	<table border="1" width="800">
		<tr>
			<th width="40">번호</th>
			<th>제목</th>
			<th width="100">작성일</th>
			<th width="100">답변상태</th>
			<th width="100">작성자</th>
		</tr>
		<c:forEach var="inq" items="${ilist}">
			<tr>
				<td>${inq.mi_no}</td>
				<td><a href="/users/inquiryView?mi_no=${inq.mi_no}">${inq.mi_title}</a></td>
				<td><fmt:formatDate value="${inq.mi_reg_date}" pattern="yy/MM/dd"/></td>
				<td>${inq.mi_stats}</td>
				<td>${fn:substring(inq.u_name, 0, 1)}**</td>
			</tr>
		</c:forEach>
	</table>
	<div>
    <c:forEach var="p" begin="1" end="${totalPage}">
        <a href="/users/inquiryList?page=${p}">${p}</a>
    </c:forEach>
	</div>
	<a href="/main">홈으로</a> 
	<sec:authorize access="hasRole('USER')">
      <a href="/users/inquiryWriteForm">문의 작성</a></sec:authorize>
</body>
</html>
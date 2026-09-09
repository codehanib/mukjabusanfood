<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공지 목록</title>
</head>
<body>
	<h2>공지 목록</h2>
	<table border="1" width="800">
		<tr>
			<th width="30">번호</th>
			<th width="450">제목</th>
			<th width="100">작성일</th>
			<th width="50">작성자</th>
		</tr>
		<c:forEach var="list" items="${ntlist}">
		<tr>
			<td>${list.nt_no}</td>
			<td><a href="/noticeView?nt_no=${list.nt_no}">${list.nt_title}</a></td>
			<td><fmt:formatDate value="${list.nt_reg_date}" pattern="yyyy/MM/dd"/></td>
			<td>관리자</td>
		</tr>
		</c:forEach>
	</table>
	<p><a href="/">돌아가기</a>
	 <sec:authorize access="hasRole('ADMIN')">
      <a href="/admin/noticeWrite">공지 작성</a></sec:authorize>
    </p>
</body>
</html>
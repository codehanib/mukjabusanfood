<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공지 상세보기</title>
</head>
<body>
	<table border="1" width="800">
		<tr>
			<th width="70">번호</th>
			<td width="500">${ntview.nt_no}</td>
			<th width="70">작성일</th>
			<td><fmt:formatDate value="${ntview.nt_reg_date}" pattern="yyyy/MM/dd"/></td>
		</tr>
		<tr>
			<th>작성자</th>
			<td colspan="3">관리자</td>
		</tr>
		<tr>
			<th>제목</th>
			<td colspan="3">${ntview.nt_title}</td>
		</tr>
		<tr>
			<td colspan="4">
				<c:if test="${not empty ntview.nt_img}">
        			<img src="/upload/${ntview.nt_img}" width="300"> <br>
    			</c:if>
				${ntview.nt_content}
			</td>
		</tr>
	</table>
	<a href="/noticeList">목록으로</a>
	<sec:authorize access="hasRole('ADMIN')">
	<a href="/admin/noticeUpdateForm?nt_no=${ntview.nt_no}">공지 수정</a>
	<a href="/admin/noticeDelete?nt_no=${ntview.nt_no}">공지 삭제</a>
	</sec:authorize>
</body>
</html>
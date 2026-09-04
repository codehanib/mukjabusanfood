<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원목록</title>

</head>

<body>
	<div class="title">회원목록</div>
	<table>
		<tr>
			<th style="width: 80px;">NO</th>
			<th style="width: 180px;">ID</th>
			<th style="width: 150px;">이름</th>
			<th style="width: 180px;">전화번호</th>
			<th>이메일</th>
			<th style="width: 80px;">삭제</th>
		</tr>
		<c:choose>
			<c:when test="${not empty usersList}">
				<c:forEach var="users" items="${usersList}">
					<tr>
						<td class="users-no"><a
							href="/admin/usersView?u_no=${users.u_no}"> ${users.u_no} </a></td>
						<td class="users-id">${users.u_id}</td>
						<td>${users.u_name}</td>
						<td>${users.u_tel}</td>
						<td>${users.u_email}</td>
						<td>
							<button type="button"
								onclick="if(confirm('정말로 삭제하시겠습니까?')) { location.href='/admin/usersDelete?u_no=${users.u_no}'; }">
								삭제</button>
						</td>
					</tr>
				</c:forEach>
			</c:when>
			<c:otherwise>
				<tr>
					<td colspan="6" class="empty">등록된 회원이 없습니다.</td>
				</tr>
			</c:otherwise>
		</c:choose>
	</table>
	<a href="/main"> 메인 </a>
</body>
</html>
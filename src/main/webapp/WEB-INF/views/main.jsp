<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<h1>메인페이지</h1>
	<a href="/users/userviewForm">
    회원자세히보기
</a>

<sec:authorize access="hasRole('ADMIN')">
<a href="/admin/usersList">
    회원목록
</a>
</sec:authorize>
<a href="/logout">
    로그아웃
</a>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>문의 수정</title>
</head>
<body>
	<h3>문의 수정</h3>
	<hr>
	<form name="inquiryUpdateForm" method="post" action="/users/inquiryUpdate">
		<input type="hidden" name="mi_no" value="${iview.mi_no}">
		<p>제목 <input type="text" name="mi_title" value="${iview.mi_title}"></p>
		<p>내용</p>
		<p><textarea name="mi_content" rows="15" cols="60">${iview.mi_content}</textarea></p>
		<button type="submit">수정하기</button>
	</form>
</body>
</html>
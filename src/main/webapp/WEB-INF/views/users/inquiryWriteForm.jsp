<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>문의 작성</title>
</head>
<body>
	<h3>문의 작성</h3>
	<hr>
	<form name="inquiryWriteForm" method="post" action="/users/inquiryInsert">
		<p>제목 <input type="text" name="mi_title"></p>
		<p>내용</p>
		<p><textarea name="mi_content" rows="15" cols="60"></textarea></p>
		<button type="submit">문의등록</button>
	</form>
</body>
</html>
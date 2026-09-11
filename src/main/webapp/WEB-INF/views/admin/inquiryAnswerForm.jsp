<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>답변 작성</title>
</head>
<body>
	<h3>문의 답변 작성</h3>
	<hr>
	<form method="post" action="/admin/inquiryAnswer">
    <input type="hidden" name="mi_no" value="${ianswer.mi_no}">
    
    <textarea name="mi_answer" rows="20" cols="60"></textarea>
    <br>
    <button type="submit">등록</button>
</form>
</body>
</html>
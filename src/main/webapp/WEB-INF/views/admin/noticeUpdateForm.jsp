<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공지 수정폼</title>
</head>
<body>
	<h2>공지 수정</h2>
	<form name="noticeform" method="post" action="/admin/noticeUpdate" enctype="multipart/form-data">
		<input type="hidden" name="nt_no" value="${nt.nt_no}">
		<input type="hidden" name="nt_img" value="${nt.nt_img}">
		
		<table border="1">
			<tr>
				<th>제목</th>
				<td><input type="text" name="nt_title" value="${nt.nt_title}"></td>
			</tr>
			<tr>
				<td colspan="2">
				<textarea name="nt_content" rows="15" cols="60">${nt.nt_content}</textarea>
				</td>
			</tr>
			<tr>
				<td colspan="2"> ${nt.nt_img} <input type="file" name="ntfile"></td>
			</tr>
		</table>
		<input type="submit" value="수정하기"> <input type="reset" value="다시쓰기">
	</form>
</body>
</html>
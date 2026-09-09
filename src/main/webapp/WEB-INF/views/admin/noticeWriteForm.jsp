<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공지 작성폼</title>
</head>
<body>
	<h2>공지 쓰기</h2>
	<form name="noticeform" method="post" action="/admin/noticeInsert" enctype="multipart/form-data">
		<table border="1">
			<tr>
				<th>제목</th>
				<td><input type="text" name="nt_title"></td>
			</tr>
			<tr>
				<td colspan="2"><textarea name="nt_content" rows="15" cols="60"></textarea></td>
			</tr>
			<tr>
				<td colspan="2"><input type="file" name="ntfile"></td>
			</tr>
		</table>
		<input type="submit" value="작성하기"> <input type="reset" value="다시쓰기">
	</form>
</body>
</html>
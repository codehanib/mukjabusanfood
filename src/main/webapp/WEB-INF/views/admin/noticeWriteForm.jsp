<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공지 작성폼</title>
<link rel="stylesheet" href="/css/noticeForm.css">
</head>
<body>
	<div class="notice-container">
	<div class="page-title">
        <h1>공지 작성</h1>
        <p>공지를 등록해주세요</p>
    </div>
	<form name="noticeform" method="post" 
	 action="/admin/noticeInsert" enctype="multipart/form-data" class="notice-form">
		<div class="form-group">
            <label for="nt_title">제목</label>
            <input
                type="text"
                id="nt_title"
                name="nt_title"
                class="title-input"
                placeholder="제목을 입력해주세요">
        </div>

        <div class="form-group">
            <label for="nt_content">내용</label>
            <textarea
                id="nt_content"
                name="nt_content"
                class="content-input"
                placeholder="내용을 입력해주세요"></textarea>
        </div>

        <div class="form-group">
            <label for="ntfile">첨부파일</label>
            <div class="file-box">
                <input type="file" id="ntfile" name="ntfile">
            </div>
        </div>

        <div class="button-area">
            <input type="reset" value="다시쓰기" class="btn-reset">
            <input type="submit" value="작성하기" class="btn-submit">
        </div>
	</form>
	</div>
</body>
</html>
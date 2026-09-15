<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공지 수정폼</title>
<link rel="stylesheet" href="/css/noticeForm.css">
<%@ include file="/WEB-INF/views/header.jsp" %>
</head>
<body>
<div class="notice-container">
	<div class="page-title">
        <h1>공지 수정</h1>
    </div>
    <form name="noticeform" method="post" action="/admin/noticeUpdate"
      enctype="multipart/form-data" class="notice-form">
      <input type="hidden" name="nt_no" value="${nt.nt_no}">
	  <input type="hidden" name="nt_img" value="${nt.nt_img}">
		<div class="form-group">
            <label for="nt_title">제목</label>
            <input
                type="text"
                id="nt_title"
                name="nt_title"
                class="title-input"
                value="${nt.nt_title}">
    	</div>
        <div class="form-group">
            <label for="nt_content">내용</label>
            <textarea
                id="nt_content"
                name="nt_content"
                class="content-input">${nt.nt_content}</textarea>
        </div>
        <div class="form-group">
            <label for="ntfile">첨부파일</label>
            <div class="file-box">
                ${nt.nt_img} <input type="file" name="ntfile">
            </div>
        </div>
        <div class="button-area">
            <input type="submit" value="수정하기" class="btn-submit">
        </div>
	</form>
</div>
<%@ include file="/WEB-INF/views/footer.jsp" %>
</body>
</html>
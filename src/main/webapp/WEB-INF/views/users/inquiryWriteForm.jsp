<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>문의 작성</title>
<link rel="stylesheet" href="/css/inquiryForm.css">
<%@ include file="/WEB-INF/views/header.jsp" %>
</head>
<body>
<div class="inquiry-form-container">
	<div class="inquiry-page-title">
        <h1>1:1 문의 작성</h1>
        <p>식당 예약이나 배달 주문, 사이트 관련 문의사항을 남겨주세요.</p>
    </div>

	<form name="inquiryWriteForm" id="inquiryWriteForm" method="post" action="/users/inquiryInsert"  class="inquiry-form" onsubmit="return inquiryFormVerifi()">
		<div class="inquiry-form-group">
			<label for="mi_title">제목</label>
			<input type="text" name="mi_title" id="mi_title" class="inquiry-title-input">
		</div>
		<div class="inquiry-form-group">
			<label for="mi_content">내용</label>
			<textarea name="mi_content" id="mi_content" rows="15" class="inquiry-content-input"></textarea>
		<div class="inquiry-form-buttons">
		<button type="reset" class="nquiry-btn-reset">다시쓰기</button>
		<button type="submit" class="inquiry-btn-submit">문의등록</button>
		</div>
		</div>
	</form>
</div>
<%@ include file="/WEB-INF/views/footer.jsp" %>
<script src="/js/boardVerifiy.js"></script>
</body>
</html>
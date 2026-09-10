<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>리뷰 작성</title>
<link rel="stylesheet" href="/css/reviewWrite.css">
</head>
<body>
	<h3>리뷰 쓰기</h3>
	<form name="reviewwriteform" method="post" action="/restaurant/reviewInsert" enctype="multipart/form-data">
		<input type="hidden" name="r_no" value="${r_no}">
		<div class="star-rating">
		    <div class="stars">
		        <span class="star" data-value="1">★</span>
		        <span class="star" data-value="2">★</span>
		        <span class="star" data-value="3">★</span>
		        <span class="star" data-value="4">★</span>
		        <span class="star" data-value="5">★</span>
		    </div>
		    <input type="hidden" id="rv_point" name="rv_point">
		</div>
		<br>
		<br>
		<textarea id ="rv_content" name="rv_content" rows="5" cols="50"
				placeholder="리뷰를 작성해주세요."></textarea> <br>
		
		<label for="reviewFiles">이미지등록</label> <br>
		<input type="file" name="reviewFiles" multiple accept="image/*">
		<br>
		<button type="submit">리뷰 작성</button> <br>
	</form>
<!-- 스크립트 구역 -->
<script src="/js/reviewWrite.js"></script>
</body>
</html>
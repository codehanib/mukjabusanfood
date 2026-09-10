<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>리뷰 수정</title>
<link rel="stylesheet" href="/css/reviewWrite.css">
</head>
<body>
	<h3>리뷰 수정</h3>
	<form name="reviewUpdateform" method="post" action="/restaurant/reviewUpdate" enctype="multipart/form-data">
		<input type="hidden" name="rv_no" value="${rvUP.rv_no}">
		<input type="hidden" name="r_no" value="${rvUP.r_no}">
		
	<div class="star-rating">
	    <div class="stars">
	        <span class="star" data-value="1">★</span>
	        <span class="star" data-value="2">★</span>
	        <span class="star" data-value="3">★</span>
	        <span class="star" data-value="4">★</span>
	        <span class="star" data-value="5">★</span>
	    </div>
	    <input type="hidden"
	           id="rv_point"
	           name="rv_point"
	           value="${rvUP.rv_point}">
	</div>
	<br><br>
		<textarea id ="rv_content" name="rv_content" rows="5" cols="50"
				placeholder="리뷰를 작성해주세요.">${rvUP.rv_content}</textarea> <br>
		
		<label for="reviewFiles">이미지등록</label> <br>
		<input type="file" name="reviewFiles" multiple accept="image/*">
		<button type="submit">수정하기</button> <br>
	</form>
</body>
<!-- 스크립트 구역 -->
<script src="/js/reviewWrite.js"></script>
<script>
	// 기존 평점 표시
	const initialValue = Number(rvPoint.value);
	
	if (!isNaN(initialValue) && initialValue > 0) {	
	    stars.forEach(star => {
	        const starValue = Number(star.dataset.value);
	
	        if (starValue <= initialValue) {
	            star.classList.add('full');
	        } else if (starValue - 0.5 === initialValue) {
	            star.classList.add('half');
	        }
	    });
	}
</script>
</html>
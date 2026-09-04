<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>리뷰 작성</title>
</head>
<body>
	<form name="reviewwriteform" method="post" action="/restaurant/reviewInsert" enctype="multipart/form-data">
		<input type="hidden" name="r_no" value="1300">
		평점 : <input type="radio" id="star5" name="rv_point" value="5">
			  <input type="radio" id="star4" name="rv_point" value="4">
			  <input type="radio" id="star3" name="rv_point" value="3">
			  <input type="radio" id="star2" name="rv_point" value="2">
			  <input type="radio" id="star1" name="rv_point" value="1"> <br>
		내용 : <textarea id ="rv_content" name="rv_content" rows="5" cols="50"
				placeholder="리뷰를 작성해주세요."></textarea> <br>
		
		<label for="reviewFiles">이미지등록</label> <br>
		<input type="file" name="reviewFiles" multiple accept="image/*">
		<button type="submit">리뷰 작성</button> <br>
	</form>
</body>
</html>
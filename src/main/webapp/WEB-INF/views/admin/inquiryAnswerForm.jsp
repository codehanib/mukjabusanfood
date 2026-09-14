<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>답변 작성</title>
<style>
    .inquiry-button-area {
        display: flex;
        justify-content: center;
        gap: 10px;
        margin-top: 25px;
    }
    .inquiry-button-area button {
        display: inline-block;
        padding: 12px 22px;
        border-radius: 8px;
        text-decoration: none;
        font-size: 16px;
        font-weight: 600;
        transition: all 0.2s ease;
    }
    .inquiry-write {
        background: #FF4B32;
        color: #fff;
    }
    .inquiry-write:hover {
        background: #E83F28;
        transform: translateY(-2px);
    }
</style>
</head>
<body>
	<h2>문의 답변 작성</h2>
	<hr>
	<form method="post" action="/admin/inquiryAnswer">
    <input type="hidden" name="mi_no" value="${ianswer.mi_no}">
    
    <textarea name="mi_answer" rows="22" cols="70"></textarea>
    <br>
    <div class="inquiry-button-area">
    <button type="submit" class="inquiry-write">등록</button>
    </div>
</form>
</body>
</html>
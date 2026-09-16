<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공지 목록</title>
<style>
    * {
        box-sizing: border-box;
    }
    body {
        margin: 0;
	    padding: 0;
	    background: #f8f9fa;
	    color: #333;
        font-family: "Pretendard", "Noto Sans KR", Arial, sans-serif;
    }
    /* 전체 영역 */
    .notice-container {
        width: 800px;
        max-width: 100%;
        margin: 0 auto;
    }
    /* 페이지 제목 */
    .page-title {
        margin-bottom: 30px;
        text-align: left;
    }
    .page-title h1 {
        margin: 0;
        color: #darkgeay;
        font-size: 32px;
        font-weight: 800;
    }
    .page-title p {
        margin-top: 8px;

        color: #999;
        font-size: 14px;
    }
    /* 공지사항 테이블 */
    .notice-table {
        width: 100%;
        border-collapse: collapse;
        background: #fff;
        border: 1px solid #e9e9e9;
        border-radius: 16px;
        overflow: hidden;
        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.04);
    }
    /* 테이블 헤더 */
    .notice-table th {
        padding: 16px 12px;
        background: #FFF7F4;
        color: #FF4B32;
        font-size: 14px;
        font-weight: 700;
        text-align: center;
        border-bottom: 1px solid #eeeeee;
    }
    /* 테이블 내용 */
    .notice-table td {
        padding: 16px 12px;
        background: #fff;
        color: #555;
        font-size: 14px;
        text-align: center;
        border-bottom: 1px solid #eeeeee;
    }
    /* 마지막 행 */
    .notice-table tr:last-child td {
        border-bottom: none;
    }
    /* 제목 영역 */
    .notice-table td.title {
        text-align: left;
    }
    /* 제목 링크 */
    .notice-table td.title a {
        color: #333;
        font-size: 15px;
        font-weight: 500;
        text-decoration: none;
        transition: all 0.2s ease;
    }
    /* 제목에 마우스를 올렸을 때 */
    .notice-table td.title a:hover {
        color: #FF4B32;
        font-weight: 700;
    }
    /* 행에 마우스를 올렸을 때 */
    .notice-table tbody tr {
        transition: background-color 0.2s ease;
    }
    .notice-table tbody tr:hover td {
        background: #FFF9F7;
    }
 	/* 번호 */
    .notice-table td.no {
        color: #888;
        font-size: 13px;
    }
    /* 날짜 */
    .notice-table td.date {
        color: #999;
        font-size: 13px;
    }
    /* 작성자 */
    .notice-table td.writer {
        color: #777;
        font-size: 13px;
    }
    /* 하단 버튼 영역 */
    .button-area {
        display: flex;
        justify-content: center;
        align-items: center;
        gap: 10px;
        margin-top: 25px;
    }
    /* 버튼 공통 */
    .button-area a {
        display: inline-block;
        padding: 12px 22px;
        border-radius: 8px;
        text-decoration: none;
        font-size: 14px;
        font-weight: 600;
        transition: all 0.2s ease;
        margin : 3px;
    }
    /* 홈으로 */
    .btn-home {
        border: 1px solid #FF4B32;
		color: #FF4B32;
    }
    .btn-home:hover {
        background: #FF4B32;
        color: #fff;
        transform: translateY(-2px);
    }
    /* 공지 작성 */
    .btn-write {
        background: #FF4B32;
        color: #fff;
    }
    .btn-write:hover {
        background: #E83F28;
        transform: translateY(-2px);
    }
</style>
<%@ include file="/WEB-INF/views/header.jsp" %>
</head>
<body>
	<div class="notice-container">
    	<!-- 페이지 제목 -->
    	<div class="page-title">
        <h1>공지사항</h1>
        <p>MUKJA에서 알려드립니다</p>
    </div>
	<table class="notice-table">
		<thead>
		<tr>
			<th width="50">번호</th>
			<th width="450">제목</th>
			<th width="100">작성일</th>
			<th width="70" class="writer">작성자</th>
		</tr>
		</thead>
		<tbody>
		<c:forEach var="list" items="${ntlist}">
		<tr>
			<td class="no">${list.nt_no}</td>
			<td class="title"><a href="/noticeView?nt_no=${list.nt_no}">${list.nt_title}</a></td>
			<td class="date"><fmt:formatDate value="${list.nt_reg_date}" pattern="yyyy/MM/dd"/></td>
			<td class="writer">관리자</td>
		</tr>
		</c:forEach>
		</tbody>
	</table>
	
	<div class="button-area">
	<p><a href="/" class="btn-home">홈으로</a>
	 <sec:authorize access="hasRole('ADMIN')">
      <a href="/admin/noticeWrite" class="btn-write">공지 작성</a></sec:authorize>
    </p>
    </div>
</div>
<%@ include file="/WEB-INF/views/clickbutton.jsp" %>
<%@ include file="/WEB-INF/views/footer.jsp" %>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공지 상세보기</title>
<style>
    * {
        box-sizing: border-box;
    }
    body {
        margin: 0;
	    padding: 0;
	    background: #f8f9fa;
	    color: #333;
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
	
	    /* 주황색 테두리 대신 연한 회색 */
	    border: 1px solid #e9e9e9;
	
	    border-radius: 16px;
	    overflow: hidden;
	
	    /* 그림자도 아주 약하게 */
	    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.04);
	}
	/* 테이블 셀 */
	.notice-table th,
	.notice-table td {
	    border-bottom: 1px solid #eeeeee;
	    padding: 16px 18px;
	}
	/* 왼쪽 항목 */
	.notice-table th {
	    width: 90px;
	
	    /* 아주 연한 주황색 */
	    background: #FFF7F4;
	
	    color: #FF4B32;
	    font-size: 14px;
	    font-weight: 700;
	    text-align: center;
	    white-space: nowrap;
	}
	/* 내용 */
	.notice-table td {
	    font-size: 15px;
	    color: #444;
	}
	/* 제목 */
	.notice-title {
	    font-size: 20px !important;
	    font-weight: 700;
	    color: #222 !important;
	}
	/* 공지 내용 */
	.notice-content {
	    min-height: 300px;
	    padding: 35px 20px !important;
	    line-height: 1.8;
	    font-size: 16px !important;
	    color: #444;
	    vertical-align: top;
	}
	.content-text {
    white-space: pre-wrap;
	}
	/* 첨부 이미지 */
	.notice-content img {
	    display: block;
	    max-width: 100%;
	    height: auto;
	    margin: 0 auto 30px;
	    border-radius: 3px;
	}
	/* 버튼 영역 */
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
	}
	/* 목록 버튼 */
	.btn-list {
		border: 1px solid #FF4B32;
	    color: #FF4B32;
	}
	.btn-list:hover {
	    background: #FF4B32;
        color: #fff;
	    transform: translateY(-2px);
	}
	/* 수정 버튼 */
	.btn-edit {
	    background: #FFDDD4;
	    color: #FF4B32;
	}
	.btn-edit:hover {
	    background: #FFE2DB;
	}
	/* 삭제 버튼 */
	.btn-delete {
	    background: #ddd;
        color: #333;
	}
	.btn-delete:hover {
	    background: #e8e8e8;
	}
	/* 이전글 / 다음글 */
	.prev-next {
	    margin-top: 35px;
	    background: #fff;
	    border: 1px solid #e9e9e9;
	    border-radius: 12px;
	    overflow: hidden;
	}
	.prev-next p {
	    margin: 0;
	    padding: 15px 20px;
	    border-bottom: 1px solid #eeeeee;
	    font-size: 14px;
	}
	.prev-next p:last-child {
	    border-bottom: none;
	}
	.prev-next span {
	    display: inline-block;
	    width: 70px;
	    color: #FF4B32;
	    font-weight: 700;
	}
	.prev-next a {
	    color: #444;
	    text-decoration: none;
	}
	.prev-next a:hover {
	    color: #FF4B32;
	    text-decoration: underline;
	}
</style>
<%@ include file="/WEB-INF/views/header.jsp" %>
</head>
<body>
	<div class="notice-container">
    <div class="page-title">
        <h1>공지사항</h1>
        <p>MUKJA에서 알려드립니다</p>
    </div>
	
	<table class="notice-table">
		<tr>
			<th width="70">번호</th>
			<td width="500">${ntview.nt_no}</td>
			<th width="70">작성일</th>
			<td><fmt:formatDate value="${ntview.nt_reg_date}" pattern="yyyy/MM/dd"/></td>
		</tr>
		<tr>
			<th>작성자</th>
			<td colspan="3">관리자</td>
		</tr>
		<tr>
			<th>제목</th>
			<td colspan="3" class="notice-title">${ntview.nt_title}</td>
		</tr>
		<tr>
			<td colspan="4" class="notice-content">
				<c:if test="${not empty ntview.nt_img}">
        			<img src="/upload/${ntview.nt_img}" width="300">
    			</c:if>
    			<div class="content-text">${ntview.nt_content}</div>
    		</td>
		</tr>
	</table>
		<div class="prev-next">
	<c:if test="${not empty next}">
        <p>
        <span>다음글</span>
            <a href="/noticeView?nt_no=${next.nt_no}">
                ${next.nt_title}</a>
        </p>
    </c:if>
    <c:if test="${not empty prev}">
        <p>
        <span>이전글</span>
            <a href="/noticeView?nt_no=${prev.nt_no}">
                ${prev.nt_title}</a>
        </p>
    </c:if>
	</div>
	<div class="button-area">
	<a href="/noticeList" class="btn-list">목록으로</a>
	<sec:authorize access="hasRole('ADMIN')">
	<a href="/admin/noticeUpdateForm?nt_no=${ntview.nt_no}" class="btn-edit">공지 수정</a>
	<a href="/admin/noticeDelete?nt_no=${ntview.nt_no}" class="btn-delete" onclick="return confirm('공지글을 삭제하시겠습니까?');">공지 삭제</a>
	</sec:authorize>
	</div>

</div>
</body>
<%@ include file="/WEB-INF/views/clickbutton.jsp" %>
<%@ include file="/WEB-INF/views/footer.jsp" %>
</html>
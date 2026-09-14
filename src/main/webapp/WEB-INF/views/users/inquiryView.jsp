<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>문의 상세보기</title>
<style>
	* { box-sizing: border-box; }
	body {
	    margin: 0;
	    padding: 60px 20px;
	    background: #ffffff;
	    color: #333;
	    font-family: "Pretendard", "Noto Sans KR", Arial, sans-serif;
	}

	/* 전체 영역 */
	.inquiry-container {
	    width: 800px;
	    max-width: 100%;
	    margin: 0 auto;
	}

	/* 페이지 제목 */
	.page-title {
	    margin-bottom: 30px;
	}
	.page-title h1 {
	    margin: 0;
	    color: #333;
	    font-size: 30px;
	    font-weight: 800;
	}

	.inquiry-view {
	    width: 100%;
	    border-collapse: collapse;
	    background: #fff;
	    border: 1px solid #e9e9e9;
	    border-radius: 16px;
	    overflow: hidden;
	    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.04);
	}
	.inquiry-view th,
	.inquiry-view td {
	    padding: 16px 18px;
	    border-bottom: 1px solid #eeeeee;
	}	
	.inquiry-view th {
	    background: #FFF7F4;
	    color: #FF4B32;
	    font-size: 14px;
	    font-weight: 700;
	    text-align: center;
	    white-space: nowrap;
	}	
	.inquiry-view td {
	    font-size: 14px;
	    color: #444;
	}
		
	/* 문의 제목 */
	.inquiry-title {
	    font-size: 20px !important;
	    font-weight: 700;
	    color: #222 !important;
	}
	
	/* 문의 내용 */
	.inquiry-content {
	    min-height: 280px;
	    padding: 35px 25px !important;
	    vertical-align: top;
	    line-height: 1.8;
	    font-size: 15px !important;
	    color: #444;
	    white-space: pre-wrap;
	}
	
	/* 답변란 */
	.answer-box {
	    margin-top: 25px;
	    background: #FFF7F4;
	    border: 1px solid #FFE0D8;
	    border-radius: 14px;
	    overflow: hidden;
	}
	.answer-header {
	    display: flex;
	    justify-content: space-between;
	    align-items: center;
	    padding: 15px 20px;
	    background: #FFF0EC;
	    border-bottom: 1px solid #FFE0D8;
	    color: #FF4B32;
	    font-size: 14px;
	    font-weight: 700;
	}	
	/* 답변 상태 */
	.answer-status {
    padding: 5px 10px;
    border-radius: 20px;
    font-size: 11px;
    font-weight: 600;
	}
	
	.answer-status.complete {
	    background: #FF4B32;
	    color: #fff;
	}
	
	.answer-status.waiting {
	    background: #eeeeee;
	    color: #888;
	}
	/* 답변 내용 */
	.answer-content {
	    min-height: 130px;
	    padding: 25px 5px;
	    color: #555;
	    font-size: 15px;
	    line-height: 1.8;
	    white-space: pre-wrap;
	}
	/* 답변 준비중 */
	.answer-content:has(+ *) {
	    color: #999;
	}

	.button-area {
	    display: flex;
	    justify-content: center;
	    gap: 10px;
	    margin-top: 25px;
	}
	.button-area a {
	    display: inline-block;
	    padding: 12px 22px;
	    border-radius: 8px;
	    text-decoration: none;
	    font-size: 14px;
	    font-weight: 600;
	    transition: all 0.2s ease;
	}	
	/* 목록 */
	.btn-list {
	    background: #FF4B32;
	    color: #fff;
	}	
	.btn-list:hover {
	    background: #E83F28;
	    transform: translateY(-2px);
	}
	/* 수정 */
	.btn-edit {
	    background: #FFF0EC;
	    color: #FF4B32;
	}	
	.btn-edit:hover {
	    background: #FFE2DB;
	}
	/* 삭제 */
	.btn-delete {
	    background: #f5f5f5;
	    color: #777;
	}
	.btn-delete:hover {
	    background: #e8e8e8;
	}

	/* 답변하기 */
	.btn-answer {
	    background: #333;
	    color: #fff;
	}
	.btn-answer:hover {
	    background: #222;
	    transform: translateY(-2px);
	}
</style>
</head>
<body>
<div class="inquiry-container">
    <div class="page-title">
        <h1>문의 내용</h1>
    </div>
	<table class="inquiry-view">
		<tr>
			<th width="60">${iview.mi_no}</th>
			<td colspan="4" class="inquiry-title">${iview.mi_title}</td>
		</tr>
		<tr>
			<th>작성자</th>
			<td width="120">${iview.u_name}</td>
			<td width="500"> </td>
			<th>문의날짜</th>
			<td><fmt:formatDate value="${iview.mi_reg_date}" pattern="yy/MM/dd"/></td>
		</tr>
		<tr>
			<td colspan="5" class="inquiry-content">${iview.mi_content}</td>
		</tr>
	</table>
	<div class="answer-box">
        <div class="answer-header">
            <span>관리자 답변</span>
            <span class="answer-status ${iview.mi_stats == '답변완료' ? 'complete' : 'waiting'}">
    		${iview.mi_stats}
			</span>
        </div>
        <div class="answer-content">
            <c:if test="${empty iview.mi_answer}">답변을 준비중입니다.</c:if><c:if test="${not empty iview.mi_answer}">${iview.mi_answer}</c:if>
        </div>
	</div>
    <div class="button-area">
        <a href="/users/inquiryList" class="btn-list">목록으로</a>
        <sec:authorize access="hasRole('USER')">
            <a href="/users/inquiryUpdateForm?mi_no=${iview.mi_no}"
               class="btn-edit">수정</a>
            <a href="/users/inquiryDelete?mi_no=${iview.mi_no}"
               class="btn-delete">삭제</a>
        </sec:authorize>
        <sec:authorize access="hasRole('ADMIN')">
            <a href="/admin/inquiryAnswerForm"
               class="btn-answer"
               onclick="window.open('/admin/inquiryAnswerForm?mi_no=${iview.mi_no}',
               'answerPopup',
               'width=460,height=480,left=600,top=200');
               return false;">
                답변하기
            </a>
        </sec:authorize>
    </div>
</div>
</body>
</html>
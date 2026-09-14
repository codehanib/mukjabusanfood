<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>1:1 문의 목록</title>
<style>
    * {
        box-sizing: border-box;
    }
    body {
        margin: 0;
        padding: 60px 20px;
        background: #ffffff;
        color: #333;
        font-family: "Pretendard", "Noto Sans KR", Arial, sans-serif;
    }
    /* 문의 목록 전체 영역 */
    .inquiry-container {
        width: 800px;
        max-width: 100%;
        margin: 0 auto;
    }
    /* 페이지 제목 */
    .inquiry-title {
        margin-bottom: 30px;
    }
    .inquiry-title h1 {
        margin: 0;
        color: #333;
        font-size: 32px;
        font-weight: 800;
    }
    .inquiry-title p {
        margin-top: 8px;
        color: #999;
        font-size: 14px;
    }
    /* 문의 목록 테이블 */
    .inquiry-table {
        width: 100%;
        border-collapse: collapse;
        background: #fff;
        border: 1px solid #e9e9e9;
        border-radius: 16px;
        overflow: hidden;
        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.04);
    }
    /* 테이블 셀 */
    .inquiry-table th,
    .inquiry-table td {
        padding: 16px 14px;
        border-bottom: 1px solid #eeeeee;
        text-align: center;
        font-size: 14px;
    }
    /* 테이블 헤더 */
    .inquiry-table th {
        background: #FFF7F4;
        color: #FF4B32;
        font-weight: 700;
    }
    /* 마지막 줄 border 제거 */
    .inquiry-table tr:last-child td {
        border-bottom: none;
    }
    /* 제목 */
    .inquiry-table .inquiry-subject {
        text-align: left;
        padding-left: 20px;
    }
    .inquiry-table .inquiry-subject a {
        color: #444;
        text-decoration: none;
        font-weight: 500;
    }
    .inquiry-table .inquiry-subject a:hover {
        color: #FF4B32;
        text-decoration: underline;
    }
    /* 답변 상태 */
    .inquiry-status {
        display: inline-block;
        padding: 5px 10px;
        border-radius: 20px;
        font-size: 14px;
        font-weight: 600;
    }
    .inquiry-status.waiting {
        background: #f5f5f5;
        color: #777;
    }
    .inquiry-status.complete {
        background: #FFF0EC;
        color: #FF4B32;
    }
    /* 작성자 */
    .inquiry-writer {
        color: #777;
    }
    /* 페이지네이션 */
    .inquiry-pagination {
        display: flex;
        justify-content: center;
        gap: 6px;
        margin-top: 25px;
    }
    .inquiry-pagination a {
        display: flex;
        justify-content: center;
        align-items: center;
        width: 36px;
        height: 36px;
        border: 1px solid #e5e5e5;
        border-radius: 8px;
        color: #666;
        text-decoration: none;
        font-size: 14px;
        transition: all 0.2s ease;
    }
    .inquiry-pagination a:hover {
        border-color: #FF4B32;
        color: #FF4B32;
    }
    /* 하단 버튼 */
    .inquiry-button-area {
        display: flex;
        justify-content: center;
        gap: 10px;
        margin-top: 25px;
    }
    .inquiry-button-area a {
        display: inline-block;
        padding: 12px 22px;
        border-radius: 8px;
        text-decoration: none;
        font-size: 14px;
        font-weight: 600;
        transition: all 0.2s ease;
    }
    /* 홈으로 */
    .inquiry-home {
        background: #f5f5f5;
        color: #777;
    }
    .inquiry-home:hover {
        background: #e8e8e8;
    }
    /* 문의 작성 */
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
	<c:if test="${param.error == 'notOwner'}">
    <script>
        alert("본인이 작성한 문의만 확인할 수 있습니다.");
    </script>
	</c:if>
	<div class="inquiry-container">
	<div class="inquiry-title">
       <h1>1:1 문의</h1>
       <p>궁금한 점이 있다면 문의해주세요</p>
    </div>
	<table class="inquiry-table">
		<tr>
			<th width="70">번호</th>
			<th>제목</th>
			<th width="100">작성일</th>
			<th width="120">답변상태</th>
			<th width="100">작성자</th>
		</tr>
		<c:forEach var="inq" items="${ilist}">
			<tr>
				<td>${inq.mi_no}</td>
				<td class="inquiry-subject"><a href="/users/inquiryView?mi_no=${inq.mi_no}">${inq.mi_title}</a></td>
				<td><fmt:formatDate value="${inq.mi_reg_date}" pattern="yy/MM/dd"/></td>
				<td><span class="inquiry-status">${inq.mi_stats}</span></td>
				<td class="inquiry-writer">${fn:substring(inq.u_name, 0, 1)}**</td>
			</tr>
		</c:forEach>
	</table>
	<div class="inquiry-pagination">
    <c:forEach var="p" begin="1" end="${totalPage}">
        <a href="/users/inquiryList?page=${p}">${p}</a>
    </c:forEach>
	</div>
	<div class="inquiry-button-area">
	<a href="/main" class="inquiry-home">홈으로</a> 
	<sec:authorize access="hasAnyRole('USER','OWNER')">
      <a href="/users/inquiryWriteForm" class="inquiry-write">문의 작성</a></sec:authorize>
    </div>
</div>
</body>
</html>
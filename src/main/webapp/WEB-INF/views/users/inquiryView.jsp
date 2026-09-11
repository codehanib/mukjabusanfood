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
</head>
<body>
	<h3>문의 상세보기</h3>
	<hr>
	<table border="1" width="800">
		<tr>
			<th width="60">${iview.mi_no}</th>
			<td colspan="4">${iview.mi_title}</td>
		</tr>
		<tr>
			<th>작성자</th>
			<td>${iview.u_name}</td>
			<td width="500"> </td>
			<th>문의날짜</th>
			<td><fmt:formatDate value="${iview.mi_reg_date}" pattern="yy/MM/dd"/></td>
		</tr>
		<tr>
			<td colspan="5">${iview.mi_content}</td>
		</tr>
	</table>
	<br>
	<table border="1" width="800">
		<tr>
			<th width="60">답변란</th>
			<td> ${iview.mi_stats}</td>
		</tr>
		<tr>
			<c:if test="${empty iview.mi_answer}">
			<td colspan="2">답변을 준비중입니다.</td>
			</c:if>
			<c:if test="${not empty iview.mi_answer}">
			<td colspan="2">${iview.mi_answer}</td>
			</c:if>	
		</tr>
	</table>
	<a href="/users/inquiryList">목록으로</a>
	|
	<sec:authorize access="hasRole('USER')">
      <a href="/users/inquiryUpdateForm?mi_no=${iview.mi_no}">수정</a>
    |
      <a href="/users/inquiryDelete?mi_no=${iview.mi_no}">삭제</a>
    </sec:authorize>
	<sec:authorize access="hasRole('ADMIN')">
      <a href="/admin/inquiryAnswerForm"
   		onclick="window.open('/admin/inquiryAnswerForm?mi_no=${iview.mi_no}', 'answerPopup', 
   		'width=460,height=450,left=600,top=200'); return false;">
    	답변하기
	  </a>
    </sec:authorize>
</body>
</html>
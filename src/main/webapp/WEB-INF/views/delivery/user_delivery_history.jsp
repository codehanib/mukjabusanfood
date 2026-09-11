<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>유저 배송 주문 내역 조회</title>
	<style>
		body {font-family: '맑은 고딕', sans-serif; margin: 20px; background-color:#f8f9fa; color:#333; }
		  .container {max-width: 900px; margin:0 auto; backgroundL white; padding:30px; border-radius: 12px; box-shadow: 0 4px 10px rgba(0,0,0,0.05); }
		  
		  .header-box { display: flex; justify-content: space-between; align-items: center; border-bottom: 2px solid #FF5722; padding-bottom: 15px; margin-bottom: 25px; }
		  .header-title {font-size: 1.5em; font-weight: bold; color: #222;}
		  
		  .history-table { width: 100%; border-collapse: collapse; margin-top:10px;}
		  .history-table th, .history-table td {padding: 14px 10px; text-align: center; border-bottom: 1px solid #eee;}
		  .history-table th { background-color: #f8f9fa; color: #555; font-weight: bold; border-top: 1px solid #ddd; }
		  .history-table tr:hover { background-color: #fcfcfc; }
		    
		  .status-badge { display: inline-block; padding: 5px 12px; border-radius: 15px; font-size: 0.85em; font-weight: bold; color: white; background-color: #FF5722; }
		  .status-done { background-color: #28a745; }
		  .status-reject { background-color: #dc3545; }
		    
		  .btn-detail { background: #333; color: white; border: none; padding: 7px 14px; border-radius: 4px; font-size: 0.85em; font-weight: bold; text-decoration: none; cursor: pointer; }
		  .btn-detail:hover { background: #555; }
		    
		  .empty-msg { text-align: center; padding: 50px 0; color: #888; font-size: 1.05em; }
		
	</style>
</head>
<body>
	<div class="container">
		<div class="header-box">
			<div class="header-title"> 나의 배달 주문내역 (회원: ${userName})</div>
		</div>
		
		<table class="history-table">
			<thead>
				<tr>
					<th style="width: 12%;">주문번호</th>
					<th style="width: 12%;">가게이름</th>
					<th style="width: 20%;">주문 일시</th>
					<th style="width: 32%;">배달 주소</th>
					<th style="width: 14%;">주문 상태</th>
					<th style="width: 10%;">조회</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="item" items="${myOrderList}">
					<tr>
						<td><strong>${item.d_no}</strong></td>
						<td>${item.r_name }</td>
						<td><fmt:formatDate value="${item.d_reg_date}" pattern="yyyy-MM-dd HH:mm"/></td>
						<td style="text-align: left; padding-left: 15px;">${item.d_addr}</td>
						<td>
							<c:choose>
								<c:when test= "${item.d_stats == '배달완료'}">
									<span class="status-badge status-done">${item.d_stats}</span>
								</c:when>
								<c:when test="${item.d_stats == '주문거절'}">
									<span class="status-badge status-reject">${item.d_stats}</span>
								</c:when>
								<c:otherwise>
									<span class="status-badge">${item.d_stats}</span>
								</c:otherwise>	
							</c:choose>
						</td>
						<td>
							<a href="${pageContext.request.contextPath}/delivery/detail?d_no=${item.d_no}" class="btn-detail">상세보기</a>
						</td>
					</tr>
				</c:forEach>
				
				<c:if test="${empty myOrderList}">
					<tr>
						<td colspan="6" class="empty-msg">
							아직 신청하신 배달 주문 내역이 없습니다.
						</td>
					</tr>
				</c:if>
			</tbody>
		</table>
	</div>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>점주 - 전체 주문 내역 [Mukja]</title>
<style>
    body { font-family: '맑은 고딕', sans-serif; margin: 20px; background-color: #f8f9fa; color: #333; }
    .container { max-width: 1100px; margin: 0 auto; }
    
    /* 상단 요약 카드 */
    .summary-cards { display: flex; gap: 15px; margin-bottom: 25px; }
    .card { flex: 1; background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.05); text-align: center; border-left: 5px solid #2196F3; }
    .card.success { border-left-color: #4CAF50; }
    .card.danger { border-left-color: #F44336; }
    .card.warning { border-left-color: #FF9800; }
    .card .title { font-size: 0.9em; color: #666; margin-bottom: 5px; }
    .card .value { font-size: 1.6em; font-weight: bold; color: #111; }

    /* 검색 및 필터 박스 */
    .filter-box { background: white; padding: 15px 20px; border-radius: 8px; margin-bottom: 20px; display: flex; align-items: center; justify-content: space-between; box-shadow: 0 2px 4px rgba(0,0,0,0.05); }
    .filter-group { display: flex; align-items: center; gap: 10px; }
    select, input[type="date"], input[type="text"] { padding: 8px 12px; border: 1px solid #ddd; border-radius: 4px; font-size: 0.95em; }
    
    /* 테이블 스타일 */
    .table-container { background: white; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.05); overflow: hidden; }
    table { width: 100%; border-collapse: collapse; }
    th, td { padding: 14px 15px; text-align: center; border-bottom: 1px solid #eee; font-size: 0.95em; }
    th { background-color: #f1f3f5; font-weight: bold; color: #495057; }
    tr:hover { background-color: #f8f9fa; }

    /* 상태 뱃지 */
    .status-badge { padding: 5px 10px; border-radius: 12px; font-size: 0.85em; font-weight: bold; display: inline-block; }
    .status-PENDING { background-color: #e3f2fd; color: #1976d2; }   /* 주문확인 */
    .status-ACCEPTED { background-color: #fff3e0; color: #e65100; }  /* 주문승인 */
    .status-COOKING { background-color: #fff8e1; color: #f57f17; }   /* 조리중 */
    .status-DELIVERING { background-color: #e8f5e9; color: #2e7d32; }/* 배달중 */
    .status-COMPLETED { background-color: #e0e0e0; color: #424242; } /* 배달완료 */
    .status-REJECTED { background-color: #ffebee; color: #c62828; }  /* 주문거절 */

    .btn { padding: 6px 12px; border: none; border-radius: 4px; cursor: pointer; text-decoration: none; font-size: 0.88em; font-weight: bold; }
    .btn-detail { background-color: #2196F3; color: white; }
    .btn-detail:hover { background-color: #1976D2; }
    .btn-search { background-color: #333; color: white; }
</style>
</head>
<body>

<div class="container">
    <h2>🏪 점주 전용 - 전체 주문 내역 관리</h2>
    <p style="color: #666; font-size: 0.95em;">가게 매장(#${r_no})에 접수된 모든 배달 주문 이력을 조회하고 관리합니다.</p>

    <!-- 1. 상단 매출 및 주문 통계 요약 카드 -->
    <div class="summary-cards">
        <div class="card">
            <div class="title">총 주문 건수</div>
            <div class="value">${totalOrderCount != null ? totalOrderCount : 0} 건</div>
        </div>
        <div class="card success">
            <div class="title">총 누적 매출액</div>
            <div class="value"><fmt:formatNumber value="${totalRevenue != null ? totalRevenue : 0}" type="currency"/></div>
        </div>
        <div class="card warning">
            <div class="title">진행 중인 배달</div>
            <div class="value">${activeOrderCount != null ? activeOrderCount : 0} 건</div>
        </div>
        <div class="card danger">
            <div class="title">거절 / 취소 건수</div>
            <div class="value">${rejectedOrderCount != null ? rejectedOrderCount : 0} 건</div>
        </div>
    </div>

    <!-- 2. 검색 및 상태 필터링 영역 -->
    <div class="filter-box">
        <form action="${pageContext.request.contextPath}/store/order/history" method="GET" style="display: flex; width: 100%; justify-content: space-between;">
            <input type="hidden" name="r_no" value="${r_no}">
            
            <div class="filter-group">
                <label><strong>주문 상태:</strong></label>
                <select name="d_stats">
                    <option value="">전체 상태</option>
                    <option value="주문확인" ${param.d_stats == '주문확인' ? 'selected' : ''}>주문확인(대기)</option>
                    <option value="주문승인" ${param.d_stats == '주문승인' ? 'selected' : ''}>주문승인</option>
                    <option value="조리중" ${param.d_stats == '조리중' ? 'selected' : ''}>조리중</option>
                    <option value="배달중" ${param.d_stats == '배달중' ? 'selected' : ''}>배달중</option>
                    <option value="배달완료" ${param.d_stats == '배달완료' ? 'selected' : ''}>배달완료</option>
                    <option value="주문거절" ${param.d_stats == '주문거절' ? 'selected' : ''}>주문거절</option>
                </select>

                <label style="margin-left: 15px;"><strong>기간 조회:</strong></label>
                <input type="date" name="startDate" value="${param.startDate}"> ~ 
                <input type="date" name="endDate" value="${param.endDate}">
            </div>

            <div class="filter-group">
                <button type="submit" class="btn btn-search">조회하기</button>
            </div>
        </form>
    </div>

    <!-- 3. 전체 주문 내역 테이블 -->
    <div class="table-container">
        <table>
            <thead>
                <tr>
                    <th>주문번호</th>
                    <th>주문 시각</th>
                    <th>배달 주소</th>
                    <th>조리 / 배달시간</th>
                    <th>도착 예정 시각</th>
                    <th>주문 상태</th>
                    <th>상세 보기</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="order" items="${orderHistoryList}">
                    <tr>
                        <td><strong>#${order.d_no}</strong></td>
                        <td><fmt:formatDate value="${order.d_reg_date}" pattern="yyyy-MM-dd HH:mm"/></td>
                        <td style="text-align: left; max-width: 250px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">
                            ${order.d_addr}
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${not empty order.d_cooking_time}">
                                    조리 ${order.d_cooking_time}분 / 배달 ${order.d_delivery_time}분
                                </c:when>
                                <c:otherwise><span style="color:#aaa;">미정</span></c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${not empty order.d_arrival_time}">
                                    <fmt:formatDate value="${order.d_arrival_time}" pattern="HH:mm"/>
                                </c:when>
                                <c:otherwise><span style="color:#aaa;">-</span></c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <span class="status-badge status-${order.d_stats == '주문확인' ? 'PENDING' : (order.d_stats == '주문승인' ? 'ACCEPTED' : (order.d_stats == '조리중' ? 'COOKING' : (order.d_stats == '배달중' ? 'DELIVERING' : (order.d_stats == '배달완료' ? 'COMPLETED' : 'REJECTED'))))}">
                                ${order.d_stats}
                            </span>
                        </td>
                        <td>
                            <a href="${pageContext.request.contextPath}/store/order/detail?d_no=${order.d_no}" class="btn btn-detail">상세보기</a>
                        </td>
                    </tr>
                </c:forEach>

                <c:if test="${empty orderHistoryList}">
                    <tr>
                        <td colspan="7" style="padding: 30px; color: #999;">조회된 배달 주문 내역이 없습니다.</td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>
</div>

</body>
</html>
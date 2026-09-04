<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>전체 배달 통합 관제 [Mukja 관리자]</title>
<style>
    body { font-family: '맑은 고딕', sans-serif; margin: 0; background-color: #f0f2f5; color: #333; }
    
    /* 관리자 헤더 바 */
    .admin-header { background-color: #1a202c; color: white; padding: 15px 30px; display: flex; justify-content: space-between; align-items: center; }
    .admin-header h1 { margin: 0; font-size: 1.4em; }
    .admin-badge { background-color: #e53e3e; padding: 4px 10px; border-radius: 4px; font-size: 0.8em; font-weight: bold; }

    .main-container { padding: 30px; max-width: 1300px; margin: 0 auto; }

    /* 대시보드 요약 KPI */
    .kpi-container { display: flex; gap: 20px; margin-bottom: 25px; }
    .kpi-card { flex: 1; background: white; padding: 20px; border-radius: 8px; box-shadow: 0 1px 3px rgba(0,0,0,0.1); }
    .kpi-title { font-size: 0.85em; color: #718096; text-transform: uppercase; font-weight: bold; }
    .kpi-num { font-size: 1.8em; font-weight: bold; margin-top: 5px; color: #2d3748; }

    /* 경고 영역 (지연 주문) */
    .alert-box { background-color: #fff5f5; border-left: 4px solid #e53e3e; padding: 15px; border-radius: 4px; margin-bottom: 20px; display: flex; justify-content: space-between; align-items: center; }
    .alert-text { color: #c53030; font-weight: bold; font-size: 0.95em; }

    /* 통합 필터 박스 */
    .search-section { background: white; padding: 20px; border-radius: 8px; margin-bottom: 20px; box-shadow: 0 1px 3px rgba(0,0,0,0.1); }
    .search-form { display: flex; gap: 12px; flex-wrap: wrap; align-items: center; }
    .search-input { padding: 8px 12px; border: 1px solid #cbd5e0; border-radius: 4px; font-size: 0.9em; }

    /* 데이터 테이블 */
    .table-box { background: white; border-radius: 8px; box-shadow: 0 1px 3px rgba(0,0,0,0.1); overflow: hidden; }
    table { width: 100%; border-collapse: collapse; text-align: left; }
    th { background-color: #edf2f7; color: #4a5568; padding: 12px 15px; font-size: 0.9em; font-weight: bold; }
    td { padding: 12px 15px; border-top: 1px solid #e2e8f0; font-size: 0.9em; }
    tr:hover { background-color: #f7fafc; }

    /* 관리자 제어 버튼 */
    .btn-admin { padding: 5px 10px; border: none; border-radius: 4px; cursor: pointer; font-size: 0.8em; font-weight: bold; color: white; }
    .btn-cancel { background-color: #e53e3e; } /* 강제 취소 */
    .btn-complete { background-color: #319795; } /* 강제 완료 */
</style>
</head>
<body>

<div class="admin-header">
    <h1>🛡️ Mukja 플랫폼 - 전체 배달 통합 관제 센터</h1>
    <span class="admin-badge">SYSTEM ADMIN</span>
</div>

<div class="main-container">

    <!-- 1. 지연/위험 주문 모니터링 알림 -->
    <div class="alert-box">
        <div class="alert-text">
            ⚠️ 10분 이상 점주 수락 미처리 주문: <strong>${delayedOrderCount != null ? delayedOrderCount : 0}건</strong> 발생 중!
        </div>
        <small style="color: #742a2a;">* 고객 미응대 방지를 위한 모니터링 권장</small>
    </div>

    <!-- 2. 전체 배달 관제 지표 (KPI) -->
    <div class="kpi-container">
        <div class="kpi-card">
            <div class="kpi-title">금일 전체 배달 요청</div>
            <div class="kpi-num">${todayTotalCount != null ? todayTotalCount : 0} 건</div>
        </div>
        <div class="kpi-card">
            <div class="kpi-title">실시간 배달 중</div>
            <div class="kpi-num" style="color: #3182ce;">${deliveringCount != null ? deliveringCount : 0} 건</div>
        </div>
        <div class="kpi-card">
            <div class="kpi-title">배달 완료 성공률</div>
            <div class="kpi-num" style="color: #38a169;">${completionRate != null ? completionRate : 98.5}%</div>
        </div>
        <div class="kpi-card">
            <div class="kpi-title">금일 배달 거래액</div>
            <div class="kpi-num" style="color: #d69e2e;"><fmt:formatNumber value="${todayTotalAmount != null ? todayTotalAmount : 0}" type="currency"/></div>
        </div>
    </div>

    <!-- 3. 필터 및 식당/주문 검색 -->
    <div class="search-section">
        <form class="search-form" action="${pageContext.request.contextPath}/admin/delivery/manage" method="GET">
            <input type="text" class="search-input" name="restaurantKeyword" placeholder="식당명 검색..." value="${param.restaurantKeyword}">
            <input type="text" class="search-input" name="orderIdKeyword" placeholder="주문번호(#) 검색..." value="${param.orderIdKeyword}">
            
            <select class="search-input" name="d_stats">
                <option value="">전체 상태 보기</option>
                <option value="주문확인">주문확인(대기)</option>
                <option value="주문승인">주문승인</option>
                <option value="조리중">조리중</option>
                <option value="배달중">배달중</option>
                <option value="배달완료">배달완료</option>
                <option value="주문거절">주문거절</option>
            </select>

            <button type="submit" class="btn-admin" style="background-color: #2b6cb0; padding: 8px 16px;">통합 검색</button>
        </form>
    </div>

    <!-- 4. 전체 식당 배달 데이터 현황 테이블 -->
    <div class="table-box">
        <table>
            <thead>
                <tr>
                    <th>주문번호</th>
                    <th>식당 정보 (r_no / 식당명)</th>
                    <th>주문 고객 (u_no)</th>
                    <th>배달 주소</th>
                    <th>요청 시각</th>
                    <th>현재 상태</th>
                    <th>관리자 강제 제어</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="delivery" items="${allDeliveryList}">
                    <tr>
                        <td><strong>#${delivery.d_no}</strong></td>
                        <td>
                            <!-- 식당 테이블(restaurant) JOIN 데이터 -->
                            <strong>[#${delivery.r_no}]</strong> ${delivery.r_name != null ? delivery.r_name : '식당정보'}
                        </td>
                        <td>회원번호 #${delivery.u_no}</td>
                        <td style="max-width: 200px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">
                            ${delivery.d_addr}
                        </td>
                        <td><fmt:formatDate value="${delivery.d_reg_date}" pattern="MM-dd HH:mm:ss"/></td>
                        <td>
                            <strong style="color: #2b6cb0;">${delivery.d_stats}</strong>
                        </td>
                        <td>
                            <!-- 관리자 강제 상태 변경 / 개입 버튼 -->
                            <form action="${pageContext.request.contextPath}/admin/delivery/forceUpdate" method="POST" style="display:inline;">
                                <input type="hidden" name="d_no" value="${delivery.d_no}">
                                
                                <c:if test="${delivery.d_stats != '배달완료' && delivery.d_stats != '주문거절'}">
                                    <input type="hidden" name="actionType" value="CANCEL">
                                    <button type="submit" class="btn-admin btn-cancel" onclick="return confirm('관리자 권한으로 본 주문을 강제 취소하시겠습니까?');">강제취소</button>
                                </c:if>

                                <c:if test="${delivery.d_stats == '배달중'}">
                                    <input type="hidden" name="actionType" value="COMPLETE">
                                    <button type="submit" class="btn-admin btn-complete" onclick="return confirm('강제 배달완료 처리하시겠습니까?');">강제완료</button>
                                </c:if>
                            </form>
                        </td>
                    </tr>
                </c:forEach>

                <c:if test="${empty allDeliveryList}">
                    <tr>
                        <td colspan="7" style="text-align: center; padding: 40px; color: #a0aec0;">
                            현재 모니터링할 배달 주문 데이터가 존재하지 않습니다.
                        </td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>

</div>

</body>
</html>
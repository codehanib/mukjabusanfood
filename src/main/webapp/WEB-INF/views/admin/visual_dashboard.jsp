<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Mukja BigData Analytics Center</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<style>
    :root {
        --bg-main: #f4f6f9;
        --card-bg: #ffffff;
        --primary-color: #3182ce;
        --accent-orange: #ff6b35;
        --text-main: #2d3748;
        --border-color: #e2e8f0;
    }

    body {
        font-family: 'Pretendard', '맑은 고딕', sans-serif;
        background-color: var(--bg-main);
        margin: 0;
        padding: 0;
        color: var(--text-main);
    }

    /* 페이지 메인 레이아웃 래퍼 */
    .dashboard-container {
        max-width: 1400px;
        margin: 20px auto;
        padding: 0 20px;
        display: flex;
        flex-direction: column;
        gap: 20px;
    }

    /* 대시보드 전용 서브 헤더 */
    .dashboard-header {
        background: linear-gradient(135deg, #1a202c 0%, #2d3748 100%);
        color: white;
        padding: 16px 24px;
        border-radius: 12px;
        display: flex;
        justify-content: space-between;
        align-items: center;
        box-shadow: 0 4px 12px rgba(0,0,0,0.08);
    }
    
    .dashboard-title-box h1 {
        margin: 0;
        font-size: 1.3rem;
        font-weight: 700;
        display: flex;
        align-items: center;
        gap: 10px;
    }

    .dashboard-title-box p {
        margin: 4px 0 0 0;
        font-size: 0.8rem;
        color: #a0aec0;
    }

    .live-tag {
        background: rgba(72, 187, 120, 0.2);
        color: #48bb78;
        border: 1px solid #48bb78;
        padding: 5px 12px;
        border-radius: 20px;
        font-size: 0.75rem;
        font-weight: 700;
        display: flex;
        align-items: center;
        gap: 6px;
    }

    .live-dot {
        width: 8px;
        height: 8px;
        background-color: #48bb78;
        border-radius: 50%;
        box-shadow: 0 0 6px #48bb78;
        animation: pulse 1.5s infinite;
    }

    @keyframes pulse {
        0% { opacity: 1; transform: scale(1); }
        50% { opacity: 0.4; transform: scale(1.2); }
        100% { opacity: 1; transform: scale(1); }
    }

    /* 카드 기본 구조 */
    .dash-card {
        background: var(--card-bg);
        border-radius: 12px;
        border: 1px solid var(--border-color);
        box-shadow: 0 2px 8px rgba(0,0,0,0.04);
        overflow: hidden;
    }

    .card-header {
        padding: 12px 16px;
        background: #fafbfc;
        border-bottom: 1px solid var(--border-color);
        display: flex;
        justify-content: space-between;
        align-items: center;
    }

    .card-title {
        font-size: 0.9rem;
        font-weight: 700;
        color: #2d3748;
        display: flex;
        align-items: center;
        gap: 8px;
    }

    .card-title i {
        color: var(--primary-color);
    }

    /* 4열 그리드 레이아웃 */
    .chart-grid-4 {
        display: grid;
        grid-template-columns: repeat(4, 1fr);
        gap: 16px;
    }

    /* ⚡ 1. 상단 4개 차트 완벽 고정 컴포넌트 (외부 영향 0%) */
    .kibana-crop-box {
        width: 100%;
        height: 220px;
        position: relative;
        overflow: hidden;
        background: #ffffff;
        isolation: isolate; /* 외부 CSS 간섭 원천 차단 */
    }

    .kibana-crop-box iframe {
        position: absolute;
        top: -42px !important;
        left: -6px !important;
        width: 154% !important;
        height: 400px !important;
        border: none !important;
        transform: scale(0.65) !important;
        transform-origin: 0 0 !important;
    }

    /* 3번 전용 네이티브 KPI 카드 */
    .kpi-native-box {
        height: 220px;
        display: flex;
        flex-direction: column;
        justify-content: center;
        align-items: center;
        background: linear-gradient(180deg, #ffffff 0%, #f7fafc 100%);
    }

    .kpi-number {
        font-size: 3rem;
        font-weight: 800;
        color: #1a202c;
        letter-spacing: -1px;
        line-height: 1;
    }

    .kpi-subtext {
        font-size: 0.8rem;
        color: #718096;
        margin-top: 12px;
        font-weight: 600;
    }

    /* ⚡ 2. 하단 지도 완벽 고정 컴포넌트 (외부 영향 0%) */
    .map-crop-box {
        width: 100%;
        height: 520px;
        position: relative;
        overflow: hidden;
        background: #ffffff;
        isolation: isolate;
    }

    .map-crop-box iframe {
        position: absolute;
        top: -38px !important;
        left: 0 !important;
        width: 100% !important;
        height: 560px !important;
        border: none !important;
    }

    /* 반응형 처리 */
    @media (max-width: 1200px) {
        .chart-grid-4 {
            grid-template-columns: repeat(2, 1fr);
        }
    }
</style>
</head>
<body>

    <!-- 📌 공통 상단 헤더 (필요시 주석 해제) -->
    <%@ include file="/WEB-INF/views/header.jsp" %>

    <div class="dashboard-container">

        <!-- 서브 대시보드 헤더 -->
        <header class="dashboard-header">
            <div class="dashboard-title-box">
                <button type="button" onclick="history.back()" style="background:none; border:none; color:#a0aec0; padding:0; margin-bottom:6px; cursor:pointer; font-size:0.8rem; font-weight:600;">
                    <i class="fa-solid fa-arrow-left"></i> 이전 화면으로 돌아가기
                </button>
                <h1><i class="fa-solid fa-chart-pie" style="color: #ff6b35;"></i> MUKJA 빅데이터 종합 관제 대시보드</h1>
                <p>부산 지역구별 외식 물가, 매장 분포 및 검색어 트렌드 실시간 분석</p>
            </div>
            <div class="live-tag">
                <div class="live-dot"></div> REALTIME ANALYTICS
            </div>
        </header>

        <!-- 상단 4열 관제 영역 -->
        <div class="chart-grid-4">
            
            <!-- [1] 지역별 식당수 TOP 10 -->
            <div class="dash-card">
                <div class="card-header">
                    <div class="card-title"><i class="fa-solid fa-chart-column"></i> 1. 지역별 식당수 TOP 10</div>
                </div>
                <div class="card-body" style="padding:0;">
                    <div class="kibana-crop-box">
                        <iframe src="http://192.168.10.49:5601/app/dashboards#/view/c375ed90-b266-11f1-9d15-c965fba4529f?embed=true&_g=(filters%3A!()%2CrefreshInterval%3A(pause%3A!t%2Cvalue%3A0)%2Ctime%3A(from%3Anow-15m%2Cto%3Anow))" scrolling="no"></iframe>
                    </div>
                </div>
            </div>

            <!-- [2] 음식 카테고리별 비율 -->
            <div class="dash-card">
                <div class="card-header">
                    <div class="card-title"><i class="fa-solid fa-chart-pie"></i> 2. 음식 카테고리별 비율</div>
                </div>
                <div class="card-body" style="padding:0;">
                    <div class="kibana-crop-box">
                        <iframe src="http://192.168.10.49:5601/app/dashboards#/view/a5d7d5f0-b266-11f1-9d15-c965fba4529f?embed=true&_g=(filters%3A!()%2CrefreshInterval%3A(pause%3A!t%2Cvalue%3A0)%2Ctime%3A(from%3Anow-15m%2Cto%3Anow))" scrolling="no"></iframe>
                    </div>
                </div>
            </div>

            <!-- [3] 전체 등록 매장 수 -->
            <div class="dash-card">
                <div class="card-header">
                    <div class="card-title"><i class="fa-solid fa-store"></i> 3. 전체 등록 매장 수</div>
                </div>
                <div class="card-body" style="padding:0;">
                    <div class="kpi-native-box">
                        <div class="kpi-number">${restaurantCount}</div>
                        <div class="kpi-subtext"><i class="fa-solid fa-circle-check" style="color:#3182ce;"></i> 부산시 검증 입점 매장</div>
                    </div>
                </div>
            </div>

            <!-- [4] 인기 검색어 (트렌드) -->
            <div class="dash-card">
                <div class="card-header">
                    <div class="card-title"><i class="fa-solid fa-cloud"></i> 4. 인기 검색어 (트렌드)</div>
                </div>
                <div class="card-body" style="padding:0;">
                    <div class="kibana-crop-box">
                        <iframe src="http://192.168.10.49:5601/app/dashboards#/view/6a320f70-b266-11f1-9d15-c965fba4529f?embed=true&_g=(filters%3A!()%2CrefreshInterval%3A(pause%3A!t%2Cvalue%3A0)%2Ctime%3A(from%3Anow-15m%2Cto%3Anow))" scrolling="no"></iframe>
                    </div>
                </div>
            </div>

        </div>

        <!-- 하단 공간 지도 영역 -->
        <div class="dash-card">
            <div class="card-header">
                <div class="card-title">
                    <i class="fa-solid fa-map-location-dot"></i> 부산 지역구별 외식 물가 및 식당 분포 지도
                </div>
                <span style="font-size: 0.75rem; color: #a0aec0;"><i class="fa-solid fa-rotate"></i> 실시간 위치 기반 분석</span>
            </div>
            <div class="card-body" style="padding:0;">
                <div class="map-crop-box">
                    <iframe src="http://192.168.10.49:5601/app/dashboards#/view/a4c6f880-b171-11f1-9d15-c965fba4529f?embed=true&_g=(filters%3A!()%2CrefreshInterval%3A(pause%3A!t%2Cvalue%3A0)%2Ctime%3A(from%3Anow-15m%2Cto%3Anow))" scrolling="no"></iframe>
                </div>
            </div>
        </div>

    </div>

    <!-- 📌 공통 하단 푸터 (필요시 주석 해제) -->
    <%@ include file="/WEB-INF/views/footer.jsp" %>

</body>
</html>
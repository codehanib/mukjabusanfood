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
        overflow-x: hidden;
    }

    /* 대시보드 헤더 */
    .dashboard-header {
        background: linear-gradient(135deg, #1a202c 0%, #2d3748 100%);
        color: white;
        padding: 12px 24px;
        display: flex;
        justify-content: space-between;
        align-items: center;
        box-shadow: 0 4px 10px rgba(0,0,0,0.12);
    }
    
    .dashboard-title-box h1 {
        margin: 0;
        font-size: 1.2rem;
        font-weight: 700;
        display: flex;
        align-items: center;
        gap: 8px;
    }

    .dashboard-title-box p {
        margin: 2px 0 0 0;
        font-size: 0.75rem;
        color: #a0aec0;
    }

    .live-tag {
        background: rgba(72, 187, 120, 0.2);
        color: #48bb78;
        border: 1px solid #48bb78;
        padding: 4px 10px;
        border-radius: 20px;
        font-size: 0.7rem;
        font-weight: 700;
        display: flex;
        align-items: center;
        gap: 5px;
    }

    .live-dot {
        width: 6px;
        height: 6px;
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

    .main-wrapper {
        max-width: 100%;
        margin: 12px auto;
        padding: 0 16px;
        display: flex;
        flex-direction: column;
        gap: 12px;
    }

    /* 카드 구조 */
    .dash-card {
        background: var(--card-bg);
        border-radius: 8px;
        border: 1px solid var(--border-color);
        box-shadow: 0 2px 4px rgba(0,0,0,0.03);
        overflow: hidden;
    }

    .card-header {
        padding: 8px 12px;
        background: #fafbfc;
        border-bottom: 1px solid var(--border-color);
        display: flex;
        justify-content: space-between;
        align-items: center;
    }

    .card-title {
        font-size: 0.82rem;
        font-weight: 700;
        color: #2d3748;
        display: flex;
        align-items: center;
        gap: 6px;
    }

    .card-title i {
        color: var(--primary-color);
    }

    /* 4열 가로 레이아웃 */
    .chart-grid-4 {
        display: grid;
        grid-template-columns: repeat(4, 1fr);
        gap: 12px;
    }

    /* ★ 4개 차트 비틀림/잘림 없는 스케일링 컨테이너 */
    .kibana-crop-box {
        width: 100%;
        height: 220px;
        overflow: hidden;
        position: relative;
        background: #ffffff;
    }

    .kibana-crop-box iframe {
        position: absolute;
        top: -42px;
        left: -6px;
        width: 152%;
        height: 390px;
        border: none;
        transform: scale(0.65);
        transform-origin: top left;
    }

    /* 3번 전용 네이티브 KPI 카드 */
    .kpi-native-box {
        height: 215px;
        display: flex;
        flex-direction: column;
        justify-content: center;
        align-items: center;
        background: linear-gradient(180deg, #ffffff 0%, #f7fafc 100%);
    }

    .kpi-number {
        font-size: 2.8rem;
        font-weight: 800;
        color: #1a202c;
        letter-spacing: -1px;
        line-height: 1;
    }

    .kpi-subtext {
        font-size: 0.78rem;
        color: #718096;
        margin-top: 10px;
        font-weight: 600;
    }

    /* 하단 지도 박스 */
    .map-crop-box {
        width: 100%;
        height: 500px;
        overflow: hidden;
        position: relative;
    }

    .map-crop-box iframe {
        position: absolute;
        top: -38px;
        left: 0;
        width: 100%;
        height: calc(100% + 38px);
        border: none;
    }
</style>
</head>
<body>

<header class="dashboard-header">
    <div class="dashboard-title-box">
        <h1><i class="fa-solid fa-chart-pie" style="color: #ff6b35;"></i> MUKJA 빅데이터 종합 관제 대시보드</h1>
        <p>부산 지역구별 외식 물가, 매장 분포 및 실시간 검색어 트렌드 분석</p>
    </div>
    <div class="live-tag">
        <div class="live-dot"></div> REALTIME ANALYTICS
    </div>
</header>

<div class="main-wrapper">

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
                    <div class="kpi-number">1,567</div>
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

</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MUKJA 빅데이터 분석 대시보드</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f4f6f9;
            font-family: 'Pretendard', -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
        }
        .dashboard-header {
            background-color: #ffffff;
            padding: 20px 30px;
            border-bottom: 1px solid #e3e6f0;
            margin-bottom: 25px;
        }
        .card-custom {
            border: none;
            border-radius: 12px;
            box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.1);
            background-color: #ffffff;
            margin-bottom: 30px;
            overflow: hidden;
        }
        .card-header-custom {
            background-color: #ffffff;
            border-bottom: 1px solid #e3e6f0;
            padding: 16px 20px;
            font-weight: 700;
            color: #4e73df;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .kibana-frame {
            width: 100%;
            border: none;
            display: block;
        }
    </style>
</head>
<body>

    <!-- 공통 헤더 include -->
    <%@ include file="/WEB-INF/views/header.jsp" %>

    <!-- 대시보드 타이틀 영역 -->
    <div class="dashboard-header d-flex justify-content-between align-items-center">
        <div>
            <h3 class="fw-bold mb-1 text-dark">📍 MUKJA 빅데이터 분석 대시보드</h3>
            <p class="text-muted mb-0">부산 지역구별 외식 물가, 매장 분포 및 통계 분석 관제</p>
        </div>
        <button class="btn btn-primary btn-sm px-3" onclick="location.reload();">🔄 데이터 갱신</button>
    </div>

    <div class="container-fluid px-4">
        
        <!-- SECTION 1: 지도 영역 (내 대시보드) -->
        <div class="row">
            <div class="col-12">
                <div class="card card-custom">
                    <div class="card-header-custom">
                        <span>🗺️ 부산 지역구별 외식 물가 및 식당 분포 지도</span>
                        <span class="badge bg-success">LIVE STREAMING</span>
                    </div>
                    <div class="card-body p-0">
                        <!-- 지도가 카드 영역에 꽉 차도록 height 750px 지정 -->
                        <iframe class="kibana-frame" 
                                src="http://192.168.10.49:5601/app/dashboards#/view/a4c6f880-b171-11f1-9d15-c965fba4529f?embed=true&_g=(filters%3A!()%2CrefreshInterval%3A(pause%3A!t%2Cvalue%3A0)%2Ctime%3A(from%3Anow-15m%2Cto%3Anow))" 
                                height="750" 
                                width="100%" 
                                style="border:none;">
                        </iframe>
                    </div>
                </div>
            </div>
        </div>

        <!-- SECTION 2: 차트 통계 영역 (팀원 대시보드) -->
        <div class="row">
            <div class="col-12">
                <div class="card card-custom">
                    <div class="card-header-custom">
                        <span class="text-dark">📊 카테고리별 식당 수 및 입점 현황 분석</span>
                        <span class="badge bg-info text-white">STATISTICS</span>
                    </div>
                    <div class="card-body p-0">
                        <iframe class="kibana-frame" 
                                src="http://192.168.10.49:5601/app/dashboards#/view/abdf0710-b0dc-11f1-9d15-c965fba4529f?embed=true&_g=(filters%3A!()%2CrefreshInterval%3A(pause%3A!t%2Cvalue%3A0)%2Ctime%3A(from%3Anow-15m%2Cto%3Anow))" 
                                height="650" 
                                width="100%" 
                                style="border:none;">
                        </iframe>
                    </div>
                </div>
            </div>
        </div>

    </div>

    <!-- 공통 푸터 include -->
    <%@ include file="/WEB-INF/views/footer.jsp" %>

</body>
</html>
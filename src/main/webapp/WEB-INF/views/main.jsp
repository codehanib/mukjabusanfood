<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="referrer" content="no-referrer">
<title>Mukja - 맛있는 즐거움의 시작</title>
<style>
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body { font-family: '맑은 고딕', sans-serif; background-color: #f8f9fa; color: #333; line-height: 1.5; }
    
    /* 전체 메인 래퍼 */
    .page-wrapper { display: flex; gap: 25px; max-width: 1400px; margin: 0 auto; padding: 25px 15px; position: relative; }

    /* 1. 좌측 카테고리 고정 사이드바 */
    .sidebar-category { 
        width: 210px; 
        background: white; 
        border-radius: 12px; 
        padding: 20px 15px; 
        box-shadow: 0 2px 10px rgba(0,0,0,0.06); 
        flex-shrink: 0; 
        position: sticky; 
        top: 25px; 
        height: fit-content; 
        align-self: flex-start; 
        z-index: 99; 
    }
    .sidebar-category h3 { font-size: 1.1em; font-weight: bold; padding-bottom: 12px; margin-bottom: 10px; border-bottom: 2px solid #222; }
    .category-list { list-style: none; }
    .category-list li { margin-bottom: 6px; }
    .category-list a { display: block; padding: 9px 12px; border-radius: 6px; color: #444; text-decoration: none; font-size: 0.95em; transition: all 0.2s; }
    .category-list a:hover, .category-list a.active { background-color: #fff3e0; color: #FF5722; font-weight: bold; }

    /* 우측 메인 컨텐츠 영역 */
    .main-content { flex: 1; min-width: 0; }

    /* ================= 🎠 2. 상단 자동 롤링 광고 배너 스몰 툴 ================= */
    .banner-slider-container {
        position: relative;
        width: 100%;
        height: 230px;
        overflow: hidden;
        border-radius: 12px;
        box-shadow: 0 4px 15px rgba(0,0,0,0.08);
        margin-bottom: 35px;
    }
    .banner-track {
        display: flex;
        width: 100%;
        height: 100%;
        transition: transform 0.5s ease-in-out;
    }
    .banner-slide {
        min-width: 100%;
        height: 100%;
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 30px 45px;
        color: white;
        text-decoration: none;
        box-sizing: border-radius;
        position: relative;
    }
    
    /* 각 슬라이드별 커스텀 배경색 / 이미지 예시 */
    .slide-bg-1 { background: linear-gradient(135deg, #FF7043, #FF5722); }
    .slide-bg-2 { background: linear-gradient(135deg, #42A5F5, #1E88E5); }
    .slide-bg-3 { background: linear-gradient(135deg, #66BB6A, #43A047); }
    .slide-bg-4 { background: linear-gradient(135deg, #AB47BC, #8E24AA); }
    .slide-bg-5 { background: linear-gradient(135deg, #FFA726, #FB8C00); }

    .banner-text { max-width: 60%; z-index: 2; }
    .banner-badge { display: inline-block; background: rgba(0,0,0,0.25); padding: 4px 12px; border-radius: 20px; font-size: 0.82em; margin-bottom: 8px; font-weight: bold; }
    .banner-text h2 { font-size: 1.9em; margin-bottom: 8px; line-height: 1.2; word-break: keep-all; font-weight: bold; }
    .banner-text p { font-size: 0.95em; opacity: 0.95; }
    
    .banner-img-box { height: 160px; width: 220px; border-radius: 10px; overflow: hidden; box-shadow: 0 4px 12px rgba(0,0,0,0.2); z-index: 2; }
    .banner-img-box img { width: 100%; height: 100%; object-fit: cover; }

    /* 좌/우 이동 화살표 버튼 */
    .slider-btn {
        position: absolute;
        top: 50%;
        transform: translateY(-50%);
        background: rgba(0, 0, 0, 0.3);
        color: white;
        border: none;
        width: 38px;
        height: 38px;
        border-radius: 50%;
        cursor: pointer;
        font-size: 18px;
        display: flex;
        align-items: center;
        justify-content: center;
        z-index: 10;
        transition: background 0.2s;
    }
    .slider-btn:hover { background: rgba(0, 0, 0, 0.6); }
    .slider-btn.prev { left: 15px; }
    .slider-btn.next { right: 15px; }

    /* 오른쪽 하단 카운터 (예: 1 / 5) */
    .slide-counter {
        position: absolute;
        bottom: 12px;
        right: 20px;
        background: rgba(0, 0, 0, 0.4);
        color: white;
        padding: 4px 12px;
        border-radius: 15px;
        font-size: 0.8em;
        font-weight: bold;
        z-index: 10;
    }

    /* 공통 섹션 헤더 & 탭 */
    .section-header { display: flex; flex-direction: column; gap: 12px; margin-bottom: 20px; margin-top: 30px; }
    .section-title { font-size: 1.35em; font-weight: bold; color: #111; display: flex; align-items: center; gap: 8px; }
    
    /* 탭 메뉴 가로 스크롤 레이아웃 */
    .tab-scroll-container { width: 100%; overflow-x: auto; padding-bottom: 6px; scrollbar-width: thin; }
    .tab-scroll-container::-webkit-scrollbar { height: 5px; }
    .tab-scroll-container::-webkit-scrollbar-thumb { background: #ddd; border-radius: 4px; }
    
    .tab-group { display: inline-flex; gap: 8px; background: white; padding: 6px 10px; border-radius: 30px; box-shadow: 0 2px 6px rgba(0,0,0,0.05); white-space: nowrap; }
    .tab-btn { padding: 6px 16px; border: none; background: transparent; border-radius: 20px; cursor: pointer; font-size: 0.88em; color: #666; font-weight: bold; transition: all 0.2s; flex-shrink: 0; }
    .tab-btn.active { background: #FF5722; color: white; }

    /* 카드 그리드 레이아웃 (4열 구성) */
    .grid-container { display: grid; grid-template-columns: repeat(4, 1fr); gap: 20px; margin-bottom: 20px; }
    
    .store-card { background: white; border-radius: 10px; overflow: hidden; box-shadow: 0 2px 8px rgba(0,0,0,0.06); text-decoration: none; color: inherit; transition: transform 0.2s, box-shadow 0.2s; }
    .store-card:hover { transform: translateY(-4px); box-shadow: 0 6px 16px rgba(0,0,0,0.12); }
    
    .card-img-box { position: relative; width: 100%; height: 160px; background: #eee; }
    .card-img-box img { width: 100%; height: 100%; object-fit: cover; }
    .status-badge { position: absolute; top: 10px; left: 10px; background: rgba(0,0,0,0.7); color: white; padding: 3px 8px; border-radius: 4px; font-size: 0.75em; font-weight: bold; }
    .badge-price { background: #2e7d32; }
    .badge-star { background: #f57f17; }
    
    .card-content { padding: 15px; }
    .store-name { font-size: 1.05em; font-weight: bold; margin-bottom: 5px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
    .store-info { font-size: 0.85em; color: #666; margin-bottom: 10px; display: flex; gap: 8px; }
    .rating { color: #FFA000; font-weight: bold; }
    
    .card-footer { border-top: 1px solid #f0f0f0; padding-top: 10px; display: flex; justify-content: space-between; align-items: center; font-size: 0.85em; color: #888; }
    .btn-detail { padding: 5px 10px; background: #2196F3; color: white; border-radius: 4px; text-decoration: none; font-size: 0.8em; font-weight: bold; }

    @media (max-width: 1100px) {
        .grid-container { grid-template-columns: repeat(3, 1fr); }
    }
    @media (max-width: 768px) {
        .page-wrapper { flex-direction: column; }
        .sidebar-category { width: 100%; position: static; }
        .grid-container { grid-template-columns: repeat(2, 1fr); }
    }
</style>
</head>
<%@ include file="/WEB-INF/views/header.jsp" %>
<body>

<div class="page-wrapper">

    <!-- 좌측 고정 카테고리 사이드바 -->
    <aside class="sidebar-category">
        <h3>🍽️ 음식 카테고리</h3>
        <ul class="category-list">
            <li><a href="#" class="active">전체 메뉴</a></li>
            <li><a href="#">🔥 인기 추천 맛집</a></li>
            <li><a href="#">🥩 돈까스 / 일식</a></li>
            <li><a href="#">🍚 한식 / 찌개</a></li>
            <li><a href="#">🍕 피자 / 양식</a></li>
            <li><a href="#">🍗 치킨 / 패스트푸드</a></li>
            <li><a href="#">🥟 중식 / 아시안</a></li>
            <li><a href="#">☕ 디저트 / 카페</a></li>
            <li><a href="#">🌙 야식 / 족발 / 보쌈</a></li>
        </ul>
    </aside>

    <!-- 우측 메인 콘텐츠 영역 -->
    <main class="main-content">
        
        <!-- 🎠 1. 자동 롤링 메인 광고 배너 영역 -->
        <div class="banner-slider-container" id="bannerSlider">
            <div class="banner-track" id="bannerTrack">
                
                <!-- 슬라이드 1 (클릭시 해당 가게로 이동) -->
                <a href="${pageContext.request.contextPath}/store/detail?r_no=6047" class="banner-slide slide-bg-1">
                    <div class="banner-text">
                        <span class="banner-badge">🔥 TODAY'S PICK</span>
                        <h2>오늘의 수제 돈카츠 추천 맛집</h2>
                        <p>바삭한 식감과 육즙 가득한 프리미엄 일식 돈카츠 10% 할인 진행중!</p>
                    </div>
                    <div class="banner-img-box">
                        <img src="https://images.unsplash.com/photo-1552611052-33e04de081de?auto=format&fit=crop&w=400&q=80" alt="광고1">
                    </div>
                </a>

                <!-- 슬라이드 2 -->
                <a href="${pageContext.request.contextPath}/store/detail?r_no=6042" class="banner-slide slide-bg-2">
                    <div class="banner-text">
                        <span class="banner-badge">✨ NEW OPEN</span>
                        <h2>올선데이 광안점 수제 베이글</h2>
                        <p>갓 구워낸 쫄깃한 베이글과 풍미 가득한 크림치즈의 만남</p>
                    </div>
                    <div class="banner-img-box">
                        <img src="https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?auto=format&fit=crop&w=400&q=80" alt="광고2">
                    </div>
                </a>

                <!-- 슬라이드 3 -->
                <a href="${pageContext.request.contextPath}/store/detail?r_no=6045" class="banner-slide slide-bg-3">
                    <div class="banner-text">
                        <span class="banner-badge">🍗 SPECIAL EVENT</span>
                        <h2>묵자치킨 범천점 배달팁 0원!</h2>
                        <p>비삭하고 촉촉한 양념치킨 주문 시 무조건 배달팁 무료 혜택</p>
                    </div>
                    <div class="banner-img-box">
                        <img src="https://images.unsplash.com/photo-1562967914-608f82629710?auto=format&fit=crop&w=400&q=80" alt="광고3">
                    </div>
                </a>

                <!-- 슬라이드 4 -->
                <a href="${pageContext.request.contextPath}/store/detail?r_no=6043" class="banner-slide slide-bg-4">
                    <div class="banner-text">
                        <span class="banner-badge">🍕 CHEESE BOMB</span>
                        <h2>화덕 피자 & 오븐 파스타 세트</h2>
                        <p>입안 가득 터지는 치즈! 정통 ই탈리안 화덕피자를 우리집에서</p>
                    </div>
                    <div class="banner-img-box">
                        <img src="https://images.unsplash.com/photo-1513104890138-7c749659a591?auto=format&fit=crop&w=400&q=80" alt="광고4">
                    </div>
                </a>

                <!-- 슬라이드 5 -->
                <a href="${pageContext.request.contextPath}/store/detail?r_no=6044" class="banner-slide slide-bg-5">
                    <div class="banner-text">
                        <span class="banner-badge">🍱 LUNCH BOX</span>
                        <h2>금요일식당 한식 정식 특가</h2>
                        <p>정성스럽게 차린 정갈한 가정식 백반 정식 배달 개시</p>
                    </div>
                    <div class="banner-img-box">
                        <img src="https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=400&q=80" alt="광고5">
                    </div>
                </a>

            </div>

            <!-- 컨트롤 버튼 & 카운터 -->
            <button class="slider-btn prev" onclick="moveBanner(-1)">❮</button>
            <button class="slider-btn next" onclick="moveBanner(1)">❯</button>
            <div class="slide-counter" id="bannerCounter">1 / 5</div>
        </div>

        <!-- 2. 지역별 추천 맛집 섹션 -->
        <div class="section-header" style="margin-top: 0;">
            <div class="section-title">📍 지역별 인기 추천 매장</div>
            <div class="tab-scroll-container">
                <div class="tab-group">
                    <button class="tab-btn active" onclick="filterTab(this, 'region', '전체')">전체</button>
                    <button class="tab-btn" onclick="filterTab(this, 'region', '부산진구')">부산진구</button>
                    <button class="tab-btn" onclick="filterTab(this, 'region', '남구')">남구</button>
                    <button class="tab-btn" onclick="filterTab(this, 'region', '해운대구')">해운대구</button>
                    <button class="tab-btn" onclick="filterTab(this, 'region', '수영구')">수영구</button>
                    <button class="tab-btn" onclick="filterTab(this, 'region', '연제구')">연제구</button>
                    <button class="tab-btn" onclick="filterTab(this, 'region', '동래구')">동래구</button>
                    <button class="tab-btn" onclick="filterTab(this, 'region', '금정구')">금정구</button>
                    <button class="tab-btn" onclick="filterTab(this, 'region', '북구')">북구</button>
                    <button class="tab-btn" onclick="filterTab(this, 'region', '사하구')">사하구</button>
                    <button class="tab-btn" onclick="filterTab(this, 'region', '사상구')">사상구</button>
                    <button class="tab-btn" onclick="filterTab(this, 'region', '강서구')">강서구</button>
                    <button class="tab-btn" onclick="filterTab(this, 'region', '중구')">중구</button>
                    <button class="tab-btn" onclick="filterTab(this, 'region', '서구')">서구</button>
                    <button class="tab-btn" onclick="filterTab(this, 'region', '동구')">동구</button>
                    <button class="tab-btn" onclick="filterTab(this, 'region', '영도구')">영도구</button>
                    <button class="tab-btn" onclick="filterTab(this, 'region', '기장군')">기장군</button>
                </div>
            </div>
        </div>

        <div class="grid-container">
            <div class="store-card">
                <div class="card-img-box">
                    <img src="https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=400&q=80" alt="매장">
                    <span class="status-badge">영업중</span>
                </div>
                <div class="card-content">
                    <div class="store-name">묵자치킨 범천점</div>
                    <div class="store-info"><span class="rating">★ 4.9</span><span>• 최소주문 15,000원</span></div>
                    <div class="card-footer"><span>🚀 배달팁 2,000원</span><span class="btn-detail">보기</span></div>
                </div>
            </div>
            <div class="store-card">
                <div class="card-img-box">
                    <img src="https://images.unsplash.com/photo-1555396273-367ea4eb4db5?auto=format&fit=crop&w=400&q=80" alt="매장">
                    <span class="status-badge">영업중</span>
                </div>
                <div class="card-content">
                    <div class="store-name">미지응3</div>
                    <div class="store-info"><span class="rating">★ 4.9</span><span>• 최소주문 15,000원</span></div>
                    <div class="card-footer"><span>🚀 배달팁 2,000원</span><span class="btn-detail">보기</span></div>
                </div>
            </div>
            <div class="store-card">
                <div class="card-img-box">
                    <img src="https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?auto=format&fit=crop&w=400&q=80" alt="매장">
                    <span class="status-badge">영업중</span>
                </div>
                <div class="card-content">
                    <div class="store-name">test</div>
                    <div class="store-info"><span class="rating">★ 4.8</span><span>• 최소주문 15,000원</span></div>
                    <div class="card-footer"><span>🚀 배달팁 2,000원</span><span class="btn-detail">보기</span></div>
                </div>
            </div>
            <div class="store-card">
                <div class="card-img-box">
                    <img src="https://images.unsplash.com/photo-1565299585323-38d6b0865b47?auto=format&fit=crop&w=400&q=80" alt="매장">
                    <span class="status-badge">영업중</span>
                </div>
                <div class="card-content">
                    <div class="store-name">금요일식당</div>
                    <div class="store-info"><span class="rating">★ 4.9</span><span>• 최소주문 15,000원</span></div>
                    <div class="card-footer"><span>🚀 배달팁 2,000원</span><span class="btn-detail">보기</span></div>
                </div>
            </div>
        </div>

        <!-- 3. 평점 높은 순 BEST 매장 섹션 -->
        <div class="section-header">
            <div class="section-title">⭐ 고객 평점 TOP 브랜드 매장</div>
            <div class="tab-scroll-container">
                <div class="tab-group">
                    <button class="tab-btn active" onclick="filterTab(this, 'rating', 'all')">전체보기</button>
                    <button class="tab-btn" onclick="filterTab(this, 'rating', '5.0')">★ 5.0 만점</button>
                    <button class="tab-btn" onclick="filterTab(this, 'rating', '4.9')">★ 4.9 이상</button>
                    <button class="tab-btn" onclick="filterTab(this, 'rating', 'review')">리뷰 500개 이상</button>
                </div>
            </div>
        </div>

        <div class="grid-container">
            <div class="store-card">
                <div class="card-img-box">
                    <img src="https://images.unsplash.com/photo-1552611052-33e04de081de?auto=format&fit=crop&w=400&q=80" alt="매장">
                    <span class="status-badge badge-star">★ 5.0</span>
                </div>
                <div class="card-content">
                    <div class="store-name">LAB 24 프리미엄 돈카츠</div>
                    <div class="store-info"><span class="rating">★ 5.0 (680+)</span><span>• 최소 12,000원</span></div>
                    <div class="card-footer"><span>🚀 20분 소요</span><span class="btn-detail">보기</span></div>
                </div>
            </div>
            <div class="store-card">
                <div class="card-img-box">
                    <img src="https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?auto=format&fit=crop&w=400&q=80" alt="매장">
                    <span class="status-badge badge-star">★ 4.9</span>
                </div>
                <div class="card-content">
                    <div class="store-name">올선데이 광안 수제베이글</div>
                    <div class="store-info"><span class="rating">★ 4.9 (1,200+)</span><span>• 최소 10,000원</span></div>
                    <div class="card-footer"><span>🚀 15분 소요</span><span class="btn-detail">보기</span></div>
                </div>
            </div>
            <div class="store-card">
                <div class="card-img-box">
                    <img src="https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?auto=format&fit=crop&w=400&q=80" alt="매장">
                    <span class="status-badge badge-star">★ 4.9</span>
                </div>
                <div class="card-content">
                    <div class="store-name">야키토리 슛 전포 본점</div>
                    <div class="store-info"><span class="rating">★ 4.9 (450+)</span><span>• 최소 16,000원</span></div>
                    <div class="card-footer"><span>🚀 25분 소요</span><span class="btn-detail">보기</span></div>
                </div>
            </div>
            <div class="store-card">
                <div class="card-img-box">
                    <img src="https://images.unsplash.com/photo-1513104890138-7c749659a591?auto=format&fit=crop&w=400&q=80" alt="매장">
                    <span class="status-badge badge-star">★ 4.8</span>
                </div>
                <div class="card-content">
                    <div class="store-name">화덕피자 파스타 전문점</div>
                    <div class="store-info"><span class="rating">★ 4.8 (890+)</span><span>• 최소 14,000원</span></div>
                    <div class="card-footer"><span>🚀 30분 소요</span><span class="btn-detail">보기</span></div>
                </div>
            </div>
        </div>

        <!-- 4. 가성비 알뜰 매장 섹션 -->
        <div class="section-header">
            <div class="section-title">💰 부담 없는 가성비 & 알뜰 배달 추천</div>
            <div class="tab-scroll-container">
                <div class="tab-group">
                    <button class="tab-btn active" onclick="filterTab(this, 'price', 'all')">전체보기</button>
                    <button class="tab-btn" onclick="filterTab(this, 'price', '10000')">1만원 이하 (갓성비)</button>
                    <button class="tab-btn" onclick="filterTab(this, 'price', '15000')">1만원~1.5만원</button>
                    <button class="tab-btn" onclick="filterTab(this, 'price', 'tip')">배달팁 2,000원 이하</button>
                </div>
            </div>
        </div>

        <div class="grid-container">
            <div class="store-card">
                <div class="card-img-box">
                    <img src="https://images.unsplash.com/photo-1509722747041-616f39b57569?auto=format&fit=crop&w=400&q=80" alt="매장">
                    <span class="status-badge badge-price">최소 8,000원</span>
                </div>
                <div class="card-content">
                    <div class="store-name">할매 뚝배기 국밥</div>
                    <div class="store-info"><span class="rating">★ 4.8</span><span>• 최소 8,000원</span></div>
                    <div class="card-footer"><span>🚀 배달팁 1,000원</span><span class="btn-detail">보기</span></div>
                </div>
            </div>
            <div class="store-card">
                <div class="card-img-box">
                    <img src="https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&w=400&q=80" alt="매장">
                    <span class="status-badge badge-price">최소 9,900원</span>
                </div>
                <div class="card-content">
                    <div class="store-name">수제 수제버거 1인세트</div>
                    <div class="store-info"><span class="rating">★ 4.7</span><span>• 최소 9,900원</span></div>
                    <div class="card-footer"><span>🚀 배달팁 1,500원</span><span class="btn-detail">보기</span></div>
                </div>
            </div>
            <div class="store-card">
                <div class="card-img-box">
                    <img src="https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&w=400&q=80" alt="매장">
                    <span class="status-badge badge-price">최소 10,000원</span>
                </div>
                <div class="card-content">
                    <div class="store-name">프레시 샐러드 & 샌드위치</div>
                    <div class="store-info"><span class="rating">★ 4.9</span><span>• 최소 10,000원</span></div>
                    <div class="card-footer"><span>🚀 배달팁 2,000원</span><span class="btn-detail">보기</span></div>
                </div>
            </div>
            <div class="store-card">
                <div class="card-img-box">
                    <img src="https://images.unsplash.com/photo-1585032226651-759b368d7246?auto=format&fit=crop&w=400&q=80" alt="매장">
                    <span class="status-badge badge-price">최소 11,000원</span>
                </div>
                <div class="card-content">
                    <div class="store-name">착한짜장 중화요리</div>
                    <div class="store-info"><span class="rating">★ 4.6</span><span>• 최소 11,000원</span></div>
                    <div class="card-footer"><span>🚀 배달팁 1,000원</span><span class="btn-detail">보기</span></div>
                </div>
            </div>
        </div>

        <!-- 5. 전체 입점 가게 목록 (20개 리스트) -->
        <div class="section-header">
            <div class="section-title">🏪 맛있는 배달 매장 전체 보기</div>
        </div>

        <div class="grid-container">
            <c:forEach var="r" items="${allRestaurantList}" varStatus="status">
                <a href="${pageContext.request.contextPath}/store/detail?r_no=${r.r_no}" class="store-card">
                    <div class="card-img-box">
                        <img src="${not empty r.r_img ? r.r_img : 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=400&q=80'}" 
                             alt="${r.r_name}"
                             onerror="this.src='https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?auto=format&fit=crop&w=400&q=80';">
                    </div>
                    <div class="card-content">
                        <div class="store-name">${r.r_name}</div>
                        <div class="store-info">
                            <span class="rating">★ 4.8</span>
                            <span>• 배달시간 20~30분</span>
                        </div>
                        <div class="card-footer">
                            <span>배달팁 2,000원</span>
                            <span class="btn-detail">주문하기</span>
                        </div>
                    </div>
                </a>
            </c:forEach>

            <c:if test="${empty allRestaurantList}">
                <c:forEach var="i" begin="1" end="20">
                    <div class="store-card">
                        <div class="card-img-box">
                            <img src="https://picsum.photos/300/160?random=${i}" alt="더미매장">
                        </div>
                        <div class="card-content">
                            <div class="store-name">Mukja 맛있는 가게 #${i}호점</div>
                            <div class="store-info">
                                <span class="rating">★ 4.${(i % 3) + 7}</span>
                                <span>• 최소주문 12,000원</span>
                            </div>
                            <div class="card-footer">
                                <span>🚀 20~30분 소요</span>
                                <span class="btn-detail">주문하기</span>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:if>
        </div>

    </main>

</div>

<!-- 🎠 상단 자동 롤링 광고 배너 자바스크립트 -->
<script>
    var currentSlide = 0;
    var track = document.getElementById('bannerTrack');
    var slides = document.querySelectorAll('.banner-slide');
    var counter = document.getElementById('bannerCounter');
    var totalSlides = slides.length;
    var autoSlideTimer = null;

    function updateSlider() {
        track.style.transform = 'translateX(-' + (currentSlide * 100) + '%)';
        if (counter) {
            counter.innerText = (currentSlide + 1) + ' / ' + totalSlides;
        }
    }

    function moveBanner(direction) {
        currentSlide += direction;
        if (currentSlide >= totalSlides) {
            currentSlide = 0;
        } else if (currentSlide < 0) {
            currentSlide = totalSlides - 1;
        }
        updateSlider();
    }

    function startAutoSlide() {
        autoSlideTimer = setInterval(function() {
            moveBanner(1);
        }, 3500); // 3.5초마다 다음 슬라이드로 자동 이동
    }

    function stopAutoSlide() {
        if (autoSlideTimer) {
            clearInterval(autoSlideTimer);
        }
    }

    // 마우스가 배너 위에 오면 자동 이동 멈춤, 벗어나면 다시 재개
    var sliderContainer = document.getElementById('bannerSlider');
    sliderContainer.addEventListener('mouseenter', stopAutoSlide);
    sliderContainer.addEventListener('mouseleave', startAutoSlide);

    // 최초 자동 롤링 시작
    startAutoSlide();

    // 탭 필터링 클릭 함수
    function filterTab(btnElement, type, value) {
        var parentGroup = btnElement.closest('.tab-group');
        var buttons = parentGroup.querySelectorAll('.tab-btn');
        buttons.forEach(function(btn) { btn.classList.remove('active'); });
        btnElement.classList.add('active');

        console.log("필터 유형: " + type + ", 값: " + value);
    }
</script>

</body>
</html>
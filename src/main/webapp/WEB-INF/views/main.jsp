<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="referrer" content="no-referrer">
<title>Mukja - 맛있는 즐거움의 시작</title>
<style>
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body { font-family: '맑은 고딕', sans-serif; background-color: #f8f9fa; color: #333; line-height: 1.5; }
    
    /* 1. 전체 메인 레이아웃 */
    .page-wrapper { display: flex; gap: 25px; max-width: 1400px; margin: 0 auto; padding: 25px 15px; position: relative; }

    /* 2. 좌측 카테고리 고정 사이드바 */
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

    /* 3. 🎠 자동 롤링 메인 배너 슬라이더 */
    .banner-slider-container {
        position: relative;
        width: 100%;
        height: 230px;
        overflow: hidden;
        border-radius: 16px;
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
        color: #ffffff;
        text-decoration: none;
        flex-shrink: 0;
        transition: transform 0.3s ease;
    }
    .banner-slide:hover { transform: translateY(-2px); }

    .banner-text { max-width: 65%; z-index: 2; }
    .banner-badge { 
        display: inline-block; 
        background-color: #FF5722; 
        color: #ffffff; 
        font-size: 0.8em; 
        font-weight: bold; 
        padding: 4px 12px; 
        border-radius: 12px; 
        margin-bottom: 10px; 
    }
    .banner-text h2 { font-size: 1.55em; font-weight: bold; margin-bottom: 8px; color: #ffffff; word-break: keep-all; line-height: 1.25; }
    .banner-text p { font-size: 0.92em; color: #e0e0e0; line-height: 1.4; word-break: keep-all; }
    
    .banner-img-box { 
        width: 160px; 
        height: 160px; 
        border-radius: 50%; 
        overflow: hidden; 
        border: 3px solid rgba(255,255,255,0.25); 
        flex-shrink: 0; 
        box-shadow: 0 4px 10px rgba(0,0,0,0.2); 
        z-index: 2; 
    }
    .banner-img-box img { width: 100%; height: 100%; object-fit: cover; }

    /* 9가지 카테고리별 테마 배경 */
    .slide-bg-korean   { background: linear-gradient(135deg, #3d2c20 0%, #5c4333 100%); }
    .slide-bg-chinese  { background: linear-gradient(135deg, #8a1c1c 0%, #4a0e0e 100%); }
    .slide-bg-japanese { background: linear-gradient(135deg, #1c2b36 0%, #2e4354 100%); }
    .slide-bg-western  { background: linear-gradient(135deg, #2d3b2d 0%, #465946 100%); }
    .slide-bg-meat     { background: linear-gradient(135deg, #421616 0%, #6e2525 100%); }
    .slide-bg-seafood  { background: linear-gradient(135deg, #0e3d59 0%, #1d658f 100%); }
    .slide-bg-cafe     { background: linear-gradient(135deg, #4d3a30 0%, #785a4a 100%); }
    .slide-bg-pub      { background: linear-gradient(135deg, #2b2510 0%, #574b21 100%); }
    .slide-bg-dining   { background: linear-gradient(135deg, #222222 0%, #3a3a3a 100%); }

    /* 좌/우 화살표 및 카운터 */
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

    /* 4. 공통 섹션 헤더 & 탭 */
    .section-header { display: flex; flex-direction: column; gap: 12px; margin-bottom: 20px; margin-top: 30px; }
    .section-title { font-size: 1.35em; font-weight: bold; color: #111; display: flex; align-items: center; gap: 8px; }
    
    .tab-scroll-container { width: 100%; overflow-x: auto; padding-bottom: 6px; scrollbar-width: thin; }
    .tab-scroll-container::-webkit-scrollbar { height: 5px; }
    .tab-scroll-container::-webkit-scrollbar-thumb { background: #ddd; border-radius: 4px; }
    
    .tab-group { display: inline-flex; gap: 8px; background: white; padding: 6px 10px; border-radius: 30px; box-shadow: 0 2px 6px rgba(0,0,0,0.05); white-space: nowrap; }
    .tab-btn { padding: 6px 16px; border: none; background: transparent; border-radius: 20px; cursor: pointer; font-size: 0.88em; color: #666; font-weight: bold; transition: all 0.2s; flex-shrink: 0; }
    .tab-btn.active { background: #FF5722; color: white; }

    /* 5. 4열 카드 그리드 레이아웃 */
    .grid-container { display: grid; grid-template-columns: repeat(4, 1fr); gap: 20px; margin-bottom: 20px; }
    
    .store-card { background: white; border-radius: 10px; overflow: hidden; box-shadow: 0 2px 8px rgba(0,0,0,0.06); text-decoration: none; color: inherit; transition: transform 0.2s, box-shadow 0.2s; }
    .store-card:hover { transform: translateY(-4px); box-shadow: 0 6px 16px rgba(0,0,0,0.12); }
    
    .card-img-box { position: relative; width: 100%; height: 160px; background: #eee; }
    .card-img-box img { width: 100%; height: 100%; object-fit: cover; }
    .status-badge { position: absolute; top: 10px; left: 10px; background: rgba(0,0,0,0.7); color: white; padding: 3px 8px; border-radius: 4px; font-size: 0.75em; font-weight: bold; }
    .badge-price { background: #2196F3; }
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
<%@ include file="/WEB-INF/views/header.jsp" %>
</head>

<body>

<div class="page-wrapper">

    <!-- 좌측 고정 카테고리 사이드바 -->
    <aside class="sidebar-category">
        <h3>🍽️ 음식 카테고리</h3>
        <ul class="category-list">
            <li><a href="${pageContext.request.contextPath}/category?category=0" class="active">전체 메뉴</a></li>
            <li><a href="${pageContext.request.contextPath}/category?category=1">🍚 한식</a></li>
            <li><a href="${pageContext.request.contextPath}/category?cate=2">🥟 중식</a></li>
            <li><a href="${pageContext.request.contextPath}/category?cate=3">🥩 일식</a></li>
            <li><a href="${pageContext.request.contextPath}/category?cate=4">🍕 양식 / 세계음식</a></li>
            <li><a href="${pageContext.request.contextPath}/category?cate=5">🍗 육류</a></li>
            <li><a href="${pageContext.request.contextPath}/category?cate=6">🦞 해산물</a></li>
            <li><a href="${pageContext.request.contextPath}/category?cate=7">☕ 디저트 / 카페</a></li>
            <li><a href="${pageContext.request.contextPath}/category?cate=8">🌙 기타</a></li>
        </ul>
    </aside>

    <!-- 우측 메인 콘텐츠 영역 -->
    <main class="main-content">
        
        <!-- 🎠 1. 자동 롤링 메인 광고 배너 영역 -->
        <div class="banner-slider-container" id="bannerSlider">
            <div class="banner-track" id="bannerTrack">
            
                <!-- 1. 한식: 금죽헌 금정산성점 (r_no=403) -->
                <a href="${pageContext.request.contextPath}/restaurant/restaurantDetail?r_no=403" class="banner-slide slide-bg-korean">
                    <div class="banner-text">
                        <span class="banner-badge">🔥 든든한 한식 PICK</span>
                        <h2>금정산성 깊은 맛, 소불고기 버섯전골</h2>
                        <p>오랫동안 푹 삶아낸 진한 육수와 야채의 완벽한 풍미! (금죽헌)</p>
                    </div>
                    <div class="banner-img-box">
                        <img src="https://ugc-images.catchtable.co.kr/shop/manager/images/5e94deed191b437d96b5b0106d360cd6" 
                             alt="금죽헌 금정산성점"
                             onerror="this.src='https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=400&q=80';">
                    </div>
                </a>

                <!-- 2. 중식: 송정돌짬뽕 (r_no=226) -->
                <a href="${pageContext.request.contextPath}/store/detail?r_no=226" class="banner-slide slide-bg-chinese">
                    <div class="banner-text">
                        <span class="banner-badge">🥟 이색 중식 PICK</span>
                        <h2>볶음·야끼·일반 3가지 조화! 송정돌짬뽕</h2>
                        <p>뜨거운 돌판 위에서 지글지글 끓어오르는 특별한 해물 돌짬뽕</p>
                    </div>
                    <div class="banner-img-box">
                        <img src="https://ugc-images.catchtable.co.kr/shop/manager/images/b8aeff9b3c1a447db1f72ce961501cbe" 
                             alt="송정돌짬뽕"
                             onerror="this.src='https://images.unsplash.com/photo-1585032226651-759b368d7246?auto=format&fit=crop&w=400&q=80';">
                    </div>
                </a>

                <!-- 3. 일식: 허교수스시 (r_no=19) -->
                <a href="${pageContext.request.contextPath}/store/detail?r_no=19" class="banner-slide slide-bg-japanese">
                    <div class="banner-text">
                        <span class="banner-badge">🍣 정통 일식 PICK</span>
                        <h2>해운대 에도마에 스시, 허교수스시</h2>
                        <p>부산 엘시티에서 만나는 최고급 정통 오마카세 다이닝</p>
                    </div>
                    <div class="banner-img-box">
                        <img src="https://ugc-images.catchtable.co.kr/shop/manager/images/72319353a2f44804bbe00c75309077db" 
                             alt="허교수스시"
                             onerror="this.src='https://images.unsplash.com/photo-1579871494447-9811cf80d66c?auto=format&fit=crop&w=400&q=80';">
                    </div>
                </a>

                <!-- 4. 양식/세계음식: PUSIL (r_no=16) -->
                <a href="${pageContext.request.contextPath}/store/detail?r_no=16" class="banner-slide slide-bg-western">
                    <div class="banner-text">
                        <span class="banner-badge">🍝 생면 파스타 PICK</span>
                        <h2>당일 제면 생면 레스토랑, PUSIL</h2>
                        <p>광안리 프라이빗한 공간에서 즐기는 감성 생면 파스타</p>
                    </div>
                    <div class="banner-img-box">
                        <img src="https://ugc-images.catchtable.co.kr/catchtable/shopinfo/saa6YddgITBoc-_JFuzp4kw/1094c48a70bb4e9fac756b52c077fd6a" 
                             alt="PUSIL"
                             onerror="this.src='https://images.unsplash.com/photo-1551183053-bf91a1d81141?auto=format&fit=crop&w=400&q=80';">
                    </div>
                </a>

                <!-- 5. 육류: 비쇼쿠 광안점 (r_no=12) -->
                <a href="${pageContext.request.contextPath}/store/detail?r_no=12" class="banner-slide slide-bg-meat">
                    <div class="banner-text">
                        <span class="banner-badge">🥩 한우 야키니꾸 PICK</span>
                        <h2>사계절 눈내리는 한우, 비쇼쿠 광안점</h2>
                        <p>최상급 한우의 사르르 녹는 육즙과 특별한 감성 야키니꾸</p>
                    </div>
                    <div class="banner-img-box">
                        <img src="https://ugc-images.catchtable.co.kr/shop/manager/images/e51b19bd92f6427ebbe84351166efb46" 
                             alt="비쇼쿠 광안점"
                             onerror="this.src='https://images.unsplash.com/photo-1544025162-d76694265947?auto=format&fit=crop&w=400&q=80';">
                    </div>
                </a>

                <!-- 6. 해산물: 식감 (r_no=296) -->
                <a href="${pageContext.request.contextPath}/store/detail?r_no=296" class="banner-slide slide-bg-seafood">
                    <div class="banner-text">
                        <span class="banner-badge">🦞 싱싱 해산물 PICK</span>
                        <h2>입안 가득 터지는 완벽함, 식감</h2>
                        <p>신선함이 살아있는 프리미엄 해산물 요리의 진수를 느껴보세요!</p>
                    </div>
                    <div class="banner-img-box">
                        <img src="https://ugc-images.catchtable.co.kr/shop/manager/images/c339d589e39346079f490ad1c413b018" 
                             alt="식감"
                             onerror="this.src='https://images.unsplash.com/photo-1534422298391-e4f8c172dddb?auto=format&fit=crop&w=400&q=80';">
                    </div>
                </a>

                <!-- 7. 디저트/카페: 카페 레이어드 센텀시티점 (r_no=113) -->
                <a href="${pageContext.request.contextPath}/store/detail?r_no=113" class="banner-slide slide-bg-cafe">
                    <div class="banner-text">
                        <span class="banner-badge">☕ 빈티지 디저트 PICK</span>
                        <h2>런던&파리 감성 카페 레이어드 센텀점</h2>
                        <p>유럽 가정집의 따스함과 당일 픽업 스콘·케이크 디저트 천국</p>
                    </div>
                    <div class="banner-img-box">
                        <img src="https://ugc-images.catchtable.co.kr/catchtable/shopinfo/sdwnJbWEzsobRazmSnoyJqw/70231c18e79549928fe1af6ef220f56b" 
                             alt="카페 레이어드"
                             onerror="this.src='https://images.unsplash.com/photo-1559925393-8be0ec4767c8?auto=format&fit=crop&w=400&q=80';">
                    </div>
                </a>

                <!-- 8. 주점: 글라스앤보틀 (r_no=139) -->
                <a href="${pageContext.request.contextPath}/store/detail?r_no=139" class="banner-slide slide-bg-pub">
                    <div class="banner-text">
                        <span class="banner-badge">🍺 야키토리 다이닝 PICK</span>
                        <h2>에비수 생맥주 & 야키토리, 글라스앤보틀</h2>
                        <p>시원한 하이볼·와인과 완벽 조화를 이루는 숯불 야키토리 코스</p>
                    </div>
                    <div class="banner-img-box">
                        <img src="https://ugc-images.catchtable.co.kr/shop/manager/images/e30c8b9b2abd44c89286bff40826e81c" 
                             alt="글라스앤보틀"
                             onerror="this.src='https://images.unsplash.com/photo-1514933651103-005eec06c04b?auto=format&fit=crop&w=400&q=80';">
                    </div>
                </a>

                <!-- 9. 기타: 주양간 제안 동래직영점 (r_no=102) -->
                <a href="${pageContext.request.contextPath}/store/detail?r_no=102" class="banner-slide slide-bg-dining">
                    <div class="banner-text">
                        <span class="banner-badge">🍷 퓨전 한식 다이닝 PICK</span>
                        <h2>육해공의 다채로운 조화, 주양간 제안</h2>
                        <p>육류와 해산물의 풍성한 맛을 담아낸 동래 한식 다이닝바</p>
                    </div>
                    <div class="banner-img-box">
                        <img src="https://ugc-images.catchtable.co.kr/shop/manager/images/ec8f05f4be6d48db94133c84c8c18267" 
                             alt="주양간 제안"
                             onerror="this.src='https://images.unsplash.com/photo-1555396273-367ea4eb4db5?auto=format&fit=crop&w=400&q=80';">
                    </div>
                </a>

            </div>

            <!-- 컨트롤 버튼 & 카운터 -->
            <button class="slider-btn prev" onclick="moveBanner(-1)">❮</button>
            <button class="slider-btn next" onclick="moveBanner(1)">❯</button>
            <div class="slide-counter" id="bannerCounter">1 / 9</div>
        </div>

		<!-- 2. 지역별 추천 맛집 섹션 -->
		<div class="section-header" style="margin-top: 0;">
		    <div class="section-title">📍 지역별 인기 추천 매장</div>
		    <div class="tab-scroll-container">
		        <div class="tab-group" id="regionTabGroup">
		            <button class="tab-btn active" onclick="changeRegionTab(this, '전체')">전체</button>
		            <button class="tab-btn" onclick="changeRegionTab(this, '부산진구')">부산진구</button>
		            <button class="tab-btn" onclick="changeRegionTab(this, '남구')">남구</button>
		            <button class="tab-btn" onclick="changeRegionTab(this, '해운대구')">해운대구</button>
		            <button class="tab-btn" onclick="changeRegionTab(this, '수영구')">수영구</button>
		            <button class="tab-btn" onclick="changeRegionTab(this, '연제구')">연제구</button>
		            <button class="tab-btn" onclick="changeRegionTab(this, '동래구')">동래구</button>
		            <button class="tab-btn" onclick="changeRegionTab(this, '금정구')">금정구</button>
		            <button class="tab-btn" onclick="changeRegionTab(this, '북구')">북구</button>
		            <button class="tab-btn" onclick="changeRegionTab(this, '사하구')">사하구</button>
		            <button class="tab-btn" onclick="changeRegionTab(this, '사상구')">사상구</button>
		            <button class="tab-btn" onclick="changeRegionTab(this, '강서구')">강서구</button>
		            <button class="tab-btn" onclick="changeRegionTab(this, '중구')">중구</button>
		            <button class="tab-btn" onclick="changeRegionTab(this, '서구')">서구</button>
		            <button class="tab-btn" onclick="changeRegionTab(this, '동구')">동구</button>
		            <button class="tab-btn" onclick="changeRegionTab(this, '영도구')">영도구</button>
		            <button class="tab-btn" onclick="changeRegionTab(this, '기장군')">기장군</button>
		        </div>
		    </div>
		</div>
		
		<!-- 4개 매장이 보여질 카드 그리드 -->
		<div class="grid-container" id="regionStoreGrid">
		    <!-- 비동기로 4개씩 동적 렌더링 됩니다 -->
		</div>

        <!-- 3. 고객 평점 TOP 브랜드 매장 섹션 -->
		<div class="section-header">
		    <div class="section-title">⭐ 고객 평점 TOP 브랜드 매장</div>
		    <div class="tab-scroll-container">
		        <div class="tab-group" id="ratingTabGroup">
		            <button class="tab-btn active" onclick="changeRatingTab(this, 'all')">전체보기</button>
		            <button class="tab-btn" onclick="changeRatingTab(this, 'rating_4.8')">★ 4.8 이상</button>
		            <button class="tab-btn" onclick="changeRatingTab(this, 'rating_4.5')">★ 4.5 이상</button>
		            <button class="tab-btn" onclick="changeRatingTab(this, 'rating_4.0')">★ 4.0 이상</button>
		        </div>
		    </div>
		</div>
		
		<!-- 비동기로 4개씩 카드 동적 출력 (평점) -->
		<div class="grid-container" id="ratingStoreGrid">
		</div>

        <!-- 4. 맛있는 배달 매장 전체 보기 (DB AJAX & 5초 자동 롤링) -->
        <div class="section-header">
            <div class="section-title">🏪 맛있는 배달 매장 전체 보기</div>
        </div>

        <div class="grid-container" id="allStoreGrid">
            <!-- 비동기로 DB 매장 정보 4개씩 동적 출력 -->
        </div>

    </main>

</div>

<!-- 🎠 1. 메인 배너 자동 롤링 자바스크립트 -->
<script>
    var currentSlide = 0;
    var track = document.getElementById('bannerTrack');
    var slides = document.querySelectorAll('.banner-slide');
    var counter = document.getElementById('bannerCounter');
    var totalSlides = slides.length;
    var autoSlideTimer = null;

    function updateSlider() {
        if (!track) return;
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
        }, 3500);
    }

    function stopAutoSlide() {
        if (autoSlideTimer) {
            clearInterval(autoSlideTimer);
        }
    }

    var sliderContainer = document.getElementById('bannerSlider');
    if (sliderContainer) {
        sliderContainer.addEventListener('mouseenter', stopAutoSlide);
        sliderContainer.addEventListener('mouseleave', startAutoSlide);
        startAutoSlide();
    }
</script>

<!-- 🤖 2. 지역별 자동 롤링 & AJAX 스크립트 -->
<script>
    var currentRegion = '전체';
    var currentRegionStores = [];
    var regionPageIndex = 0;
    var regionRotateTimer = null;
    var contextPath = "${pageContext.request.contextPath}";

    document.addEventListener("DOMContentLoaded", function() {
        fetchRegionStores('전체');
    });

    function changeRegionTab(btnElement, regionName) {
        var buttons = document.querySelectorAll('#regionTabGroup .tab-btn');
        buttons.forEach(function(btn) { btn.classList.remove('active'); });
        btnElement.classList.add('active');

        currentRegion = regionName;
        regionPageIndex = 0;
        fetchRegionStores(regionName);
    }

    function fetchRegionStores(regionName) {
        fetch(contextPath + '/api/store/region?region=' + encodeURIComponent(regionName))
            .then(function(response) { return response.json(); })
            .then(function(data) {
                currentRegionStores = data;
                regionPageIndex = 0;
                renderRegionGrid();
                resetRegionAutoRotate();
            })
            .catch(function(err) {
                console.error("지역 매장 로드 실패:", err);
            });
    }

    function renderRegionGrid() {
        var grid = document.getElementById('regionStoreGrid');
        if (!grid) return;

        if (!currentRegionStores || currentRegionStores.length === 0) {
            grid.innerHTML = '<div style="grid-column: 1/-1; padding: 40px; text-align: center; color: #888; background: white; border-radius: 10px;">등록된 매장이 없습니다.</div>';
            return;
        }

        var pageSize = 4;
        var total = currentRegionStores.length;
        var startIdx = (regionPageIndex * pageSize) % total;
        
        var displayItems = [];
        for (var i = 0; i < pageSize; i++) {
            displayItems.push(currentRegionStores[(startIdx + i) % total]);
        }

        var html = '';
        displayItems.forEach(function(r) {
            var imgUrl = r.r_img ? r.r_img : 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=400&q=80';
            var defaultImg = 'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?auto=format&fit=crop&w=400&q=80';
            var point = r.r_point ? parseFloat(r.r_point).toFixed(1) : '0.0';
            var timeInfo = r.r_time ? r.r_time : (r.r_info ? r.r_info : '영업시간 참조');

            html += '<a href="' + contextPath + '/restaurant/restaurantDetail?r_no=' + r.r_no + '" class="store-card">';
            html += '  <div class="card-img-box">';
            html += '    <img src="' + imgUrl + '" alt="' + r.r_name + '" onerror="this.src=\'' + defaultImg + '\';">';
            html += '    <span class="status-badge">영업중</span>';
            html += '  </div>';
            html += '  <div class="card-content">';
            html += '    <div class="store-name">' + r.r_name + '</div>';
            html += '    <div class="store-info">';
            html += '      <span class="rating">★ ' + point + '</span>';
            html += '      <span>• ' + (r.r_region ? r.r_region : '부산') + '</span>';
            html += '    </div>';
            html += '    <div class="card-footer">';
            html += '      <span style="white-space: nowrap; overflow: hidden; text-overflow: ellipsis; max-width: 140px;">🕒 ' + timeInfo + '</span>';
            html += '      <span class="btn-detail">보기</span>';
            html += '    </div>';
            html += '  </div>';
            html += '</a>';
        });

        grid.innerHTML = html;
    }

    function resetRegionAutoRotate() {
        if (regionRotateTimer) clearInterval(regionRotateTimer);
        regionRotateTimer = setInterval(function() {
            if (currentRegionStores.length > 4) {
                regionPageIndex++;
                renderRegionGrid();
            }
        }, 5000);
    }
</script>

<!-- 🤖 3. 평점 TOP 매장 AJAX & 자동 롤링 스크립트 -->
<script>
    var currentRatingFilter = 'all';
    var currentRatingStores = [];
    var ratingPageIndex = 0;
    var ratingRotateTimer = null;

    document.addEventListener("DOMContentLoaded", function() {
        fetchRatingStores('all');
    });

    function changeRatingTab(btnElement, filterValue) {
        var buttons = document.querySelectorAll('#ratingTabGroup .tab-btn');
        buttons.forEach(function(btn) { btn.classList.remove('active'); });
        btnElement.classList.add('active');

        currentRatingFilter = filterValue;
        ratingPageIndex = 0;
        fetchRatingStores(filterValue);
    }

    function fetchRatingStores(filterValue) {
        fetch(contextPath + '/api/store/top-rating?filter=' + encodeURIComponent(filterValue))
            .then(function(response) { return response.json(); })
            .then(function(data) {
                currentRatingStores = data;
                ratingPageIndex = 0;
                renderRatingGrid();
                resetRatingAutoRotate();
            })
            .catch(function(err) {
                console.error("평점 매장 로드 실패:", err);
            });
    }

    function renderRatingGrid() {
        var grid = document.getElementById('ratingStoreGrid');
        if (!grid) return;

        if (!currentRatingStores || currentRatingStores.length === 0) {
            grid.innerHTML = '<div style="grid-column: 1/-1; padding: 40px; text-align: center; color: #888; background: white; border-radius: 10px;">조건에 해당하는 매장이 없습니다.</div>';
            return;
        }

        var pageSize = 4;
        var total = currentRatingStores.length;
        var startIdx = (ratingPageIndex * pageSize) % total;
        
        var displayItems = [];
        for (var i = 0; i < pageSize; i++) {
            displayItems.push(currentRatingStores[(startIdx + i) % total]);
        }

        var html = '';
        displayItems.forEach(function(r) {
            var imgUrl = r.r_img ? r.r_img : 'https://images.unsplash.com/photo-1552611052-33e04de081de?auto=format&fit=crop&w=400&q=80';
            var defaultImg = 'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?auto=format&fit=crop&w=400&q=80';
            var point = r.r_point ? parseFloat(r.r_point).toFixed(1) : '0.0';
            var reviewCnt = r.reviewCount ? r.reviewCount : 0;
            var timeInfo = r.r_time ? r.r_time : (r.r_info ? r.r_info : '영업시간 참조');

            html += '<a href="' + contextPath + '/restaurant/restaurantDetail?r_no=' + r.r_no + '" class="store-card">';
            html += '  <div class="card-img-box">';
            html += '    <img src="' + imgUrl + '" alt="' + r.r_name + '" onerror="this.src=\'' + defaultImg + '\';">';
            html += '    <span class="status-badge badge-star">★ ' + point + '</span>';
            html += '  </div>';
            html += '  <div class="card-content">';
            html += '    <div class="store-name">' + r.r_name + '</div>';
            html += '    <div class="store-info">';
            html += '      <span class="rating">★ ' + point + ' (' + reviewCnt + '+)</span>';
            html += '      <span>• ' + (r.r_region ? r.r_region : '부산') + '</span>';
            html += '    </div>';
            html += '    <div class="card-footer">';
            html += '      <span style="white-space: nowrap; overflow: hidden; text-overflow: ellipsis; max-width: 140px;">🕒 ' + timeInfo + '</span>';
            html += '      <span class="btn-detail">보기</span>';
            html += '    </div>';
            html += '  </div>';
            html += '</a>';
        });

        grid.innerHTML = html;
    }

    function resetRatingAutoRotate() {
        if (ratingRotateTimer) clearInterval(ratingRotateTimer);
        ratingRotateTimer = setInterval(function() {
            if (currentRatingStores.length > 4) {
                ratingPageIndex++;
                renderRatingGrid();
            }
        }, 5000);
    }
</script>

<!-- 🤖 4. 전체 매장 목록 DB AJAX 통신 & 5초 자동 롤링 스크립트 -->
<script>
    var currentAllStores = [];
    var allPageIndex = 0;
    var allRotateTimer = null;

    document.addEventListener("DOMContentLoaded", function() {
        fetchAllStores();
    });

    function fetchAllStores() {
        fetch(contextPath + '/api/store/all')
            .then(function(response) { return response.json(); })
            .then(function(data) {
                currentAllStores = data;
                allPageIndex = 0;
                renderAllGrid();
                resetAllAutoRotate();
            })
            .catch(function(err) {
                console.error("전체 매장 로드 실패:", err);
            });
    }

    function renderAllGrid() {
        var grid = document.getElementById('allStoreGrid');
        if (!grid) return;

        if (!currentAllStores || currentAllStores.length === 0) {
            grid.innerHTML = '<div style="grid-column: 1/-1; padding: 40px; text-align: center; color: #888; background: white; border-radius: 10px;">등록된 매장이 없습니다.</div>';
            return;
        }

        var pageSize = 4;
        var total = currentAllStores.length;
        var startIdx = (allPageIndex * pageSize) % total;
        
        var displayItems = [];
        for (var i = 0; i < pageSize; i++) {
            displayItems.push(currentAllStores[(startIdx + i) % total]);
        }

        var html = '';
        displayItems.forEach(function(r) {
            var imgUrl = r.r_img ? r.r_img : 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=400&q=80';
            var defaultImg = 'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?auto=format&fit=crop&w=400&q=80';
            var point = r.r_point ? parseFloat(r.r_point).toFixed(1) : '0.0';
            var timeInfo = r.r_time ? r.r_time : (r.r_info ? r.r_info : '영업시간 참조');

            html += '<a href="' + contextPath + '/restaurant/restaurantDetail?r_no=' + r.r_no + '" class="store-card">';
            html += '  <div class="card-img-box">';
            html += '    <img src="' + imgUrl + '" alt="' + r.r_name + '" onerror="this.src=\'' + defaultImg + '\';">';
            html += '    <span class="status-badge">전체매장</span>';
            html += '  </div>';
            html += '  <div class="card-content">';
            html += '    <div class="store-name">' + r.r_name + '</div>';
            html += '    <div class="store-info">';
            html += '      <span class="rating">★ ' + point + '</span>';
            html += '      <span>• ' + (r.r_region ? r.r_region : '부산') + '</span>';
            html += '    </div>';
            html += '    <div class="card-footer">';
            html += '      <span style="white-space: nowrap; overflow: hidden; text-overflow: ellipsis; max-width: 140px;">🕒 ' + timeInfo + '</span>';
            html += '      <span class="btn-detail">주문하기</span>';
            html += '    </div>';
            html += '  </div>';
            html += '</a>';
        });

        grid.innerHTML = html;
    }

    function resetAllAutoRotate() {
        if (allRotateTimer) clearInterval(allRotateTimer);
        allRotateTimer = setInterval(function() {
            if (currentAllStores.length > 4) {
                allPageIndex++;
                renderAllGrid();
            }
        }, 5000);
    }
</script>
<%@ include file="/WEB-INF/views/footer.jsp" %>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="referrer" content="no-referrer">
<title>${selectedCategory != null ? selectedCategory : '카테고리별 맛집'} - Mukja</title>
<style>
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body { font-family: '맑은 고딕', sans-serif; background-color: #f8f9fa; color: #333; line-height: 1.5; }

    /* 전체 레이아웃 래퍼 */
    .page-wrapper { display: flex; gap: 25px; max-width: 1400px; margin: 0 auto; padding: 25px 15px; position: relative; }

    /* 1. 좌측 고정 카테고리 사이드바 */
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

    /* 우측 메인 컨텐츠 */
    .main-content { flex: 1; min-width: 0; }

    /* 카테고리 헤더 & 정렬 바 */
    .category-header { background: white; border-radius: 12px; padding: 20px 25px; margin-bottom: 25px; box-shadow: 0 2px 8px rgba(0,0,0,0.05); display: flex; justify-content: space-between; align-items: center; }
    .category-title { font-size: 1.5em; font-weight: bold; color: #111; display: flex; align-items: center; gap: 10px; }
    .category-count { font-size: 0.9em; color: #FF5722; font-weight: bold; }

    /* 정렬 필터 탭 (기본순, 평점순) */
    .sort-group { display: flex; gap: 6px; background: #f0f0f0; padding: 4px; border-radius: 20px; }
    .sort-btn { padding: 5px 14px; border: none; background: transparent; border-radius: 16px; font-size: 0.85em; color: #666; font-weight: bold; cursor: pointer; transition: all 0.2s; }
    .sort-btn.active { background: white; color: #FF5722; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }

    /* 4열 매장 카드 그리드 */
    .grid-container { display: grid; grid-template-columns: repeat(4, 1fr); gap: 20px; margin-bottom: 30px; }
    
    .store-card { background: white; border-radius: 10px; overflow: hidden; box-shadow: 0 2px 8px rgba(0,0,0,0.06); text-decoration: none; color: inherit; transition: transform 0.2s, box-shadow 0.2s; }
    .store-card:hover { transform: translateY(-4px); box-shadow: 0 6px 16px rgba(0,0,0,0.12); }
    
    .card-img-box { position: relative; width: 100%; height: 160px; background: #eee; }
    .card-img-box img { width: 100%; height: 100%; object-fit: cover; }
    .status-badge { position: absolute; top: 10px; left: 10px; background: rgba(0,0,0,0.7); color: white; padding: 3px 8px; border-radius: 4px; font-size: 0.75em; font-weight: bold; }
    
    .card-content { padding: 15px; }
    .store-name { font-size: 1.05em; font-weight: bold; margin-bottom: 5px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
    .store-info { font-size: 0.85em; color: #666; margin-bottom: 10px; display: flex; gap: 8px; flex-wrap: wrap; }
    .rating { color: #FFA000; font-weight: bold; }
    
    .card-footer { border-top: 1px solid #f0f0f0; padding-top: 10px; display: flex; justify-content: space-between; align-items: center; font-size: 0.85em; color: #888; }
    .btn-detail { padding: 5px 10px; background: #FF5722; color: white; border-radius: 4px; text-decoration: none; font-size: 0.8em; font-weight: bold; }

    /* 데이터가 없을 때 표시할 빈 영역 */
    .empty-box { background: white; border-radius: 12px; padding: 60px 20px; text-align: center; color: #777; box-shadow: 0 2px 8px rgba(0,0,0,0.05); }
    .empty-icon { font-size: 40px; margin-bottom: 15px; }

    /* 페이징 하단 바 */
    .pagination { display: flex; justify-content: center; gap: 6px; margin-top: 30px; margin-bottom: 20px; }
    .page-item { display: inline-block; padding: 8px 14px; background: white; border: 1px solid #ddd; border-radius: 6px; color: #444; text-decoration: none; font-size: 0.9em; font-weight: bold; transition: all 0.2s; }
    .page-item:hover, .page-item.active { background: #FF5722; color: white; border-color: #FF5722; }

    @media (max-width: 1100px) {
        .grid-container { grid-template-columns: repeat(3, 1fr); }
    }
    @media (max-width: 768px) {
        .page-wrapper { flex-direction: column; }
        .sidebar-category { width: 100%; position: static; }
        .grid-container { grid-template-columns: repeat(2, 1fr); }
        .category-header { flex-direction: column; align-items: flex-start; gap: 12px; }
    }
</style>
</head>
<body>

<div class="page-wrapper">

    <!-- 1. 좌측 카테고리 고정 사이드바 -->
    <aside class="sidebar-category">
        <h3>🍽️ 음식 카테고리</h3>
        <ul class="category-list">
            <li><a href="${pageContext.request.contextPath}/store/category?cate=all" class="${selectedCate == 'all' || empty selectedCate ? 'active' : ''}">전체 메뉴</a></li>
            <li><a href="${pageContext.request.contextPath}/store/category?cate=1" class="${selectedCate == '1' ? 'active' : ''}">🥩 돈까스 / 일식</a></li>
            <li><a href="${pageContext.request.contextPath}/store/category?cate=2" class="${selectedCate == '2' ? 'active' : ''}">🍚 한식 / 찌개</a></li>
            <li><a href="${pageContext.request.contextPath}/store/category?cate=3" class="${selectedCate == '3' ? 'active' : ''}">🍕 피자 / 양식</a></li>
            <li><a href="${pageContext.request.contextPath}/store/category?cate=4" class="${selectedCate == '4' ? 'active' : ''}">🍗 치킨 / 패스트푸드</a></li>
            <li><a href="${pageContext.request.contextPath}/store/category?cate=5" class="${selectedCate == '5' ? 'active' : ''}">🥟 중식 / 아시안</a></li>
            <li><a href="${pageContext.request.contextPath}/store/category?cate=6" class="${selectedCate == '6' ? 'active' : ''}">☕ 디저트 / 카페</a></li>
            <li><a href="${pageContext.request.contextPath}/store/category?cate=7" class="${selectedCate == '7' ? 'active' : ''}">🌙 야식 / 족발 / 보쌈</a></li>
        </ul>
    </aside>

    <!-- 2. 우측 맛집 리스트 메인 영역 -->
    <main class="main-content">
        
        <!-- 상단 카테고리 타이틀 및 정렬 바 -->
        <div class="category-header">
            <div>
                <span class="category-title">
                    ${selectedCategory != null ? selectedCategory : '전체 맛집'}
                    <span class="category-count">(${totalCount != null ? totalCount : 0}개 매장)</span>
                </span>
            </div>
            
            <!-- 정렬 필터 -->
            <div class="sort-group">
                <button class="sort-btn ${sort == 'default' || empty sort ? 'active' : ''}" onclick="changeSort('default')">기본순</button>
                <button class="sort-btn ${sort == 'rating' ? 'active' : ''}" onclick="changeSort('rating')">평점 높은순</button>
            </div>
        </div>

        <!-- 3. 매장 카드 4열 그리드 -->
        <c:if test="${not empty storeList}">
            <div class="grid-container">
                <c:forEach var="r" items="${storeList}">
                    <a href="${pageContext.request.contextPath}/store/detail?r_no=${r.r_no}" class="store-card">
                        <div class="card-img-box">
                            <img src="${not empty r.r_img ? r.r_img : 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=400&q=80'}" 
                                 alt="${r.r_name}"
                                 onerror="this.src='https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?auto=format&fit=crop&w=400&q=80';">
                            <span class="status-badge">영업중</span>
                        </div>
                        <div class="card-content">
                            <!-- DB 컬럼: r_name -->
                            <div class="store-name">${r.r_name}</div>
                            <div class="store-info">
                                <!-- DB 컬럼: r_point -->
                                <span class="rating">★ ${r.r_point != null ? r.r_point : '0.0'}</span>
                                <!-- DB 컬럼: r_region -->
                                <span>• ${r.r_region != null ? r.r_region : '부산'}</span>
                            </div>
                            <div class="card-footer">
                                <!-- DB 컬럼: r_time -->
                                <span>🕒 ${not empty r.r_time ? r.r_time : '영업시간 참조'}</span>
                                <span class="btn-detail">상세보기</span>
                            </div>
                        </div>
                    </a>
                </c:forEach>
            </div>
        </c:if>

        <!-- 데이터가 없을 때 표시할 안내 -->
        <c:if test="${empty storeList}">
            <div class="empty-box">
                <div class="empty-icon">🍽️</div>
                <h3>해당 카테고리에 등록된 매장이 없습니다.</h3>
                <p style="margin-top: 8px; font-size: 0.9em;">다른 카테고리를 선택해 보세요.</p>
            </div>
        </c:if>

        <!-- 4. 하단 페이징 영역 -->
        <c:if test="${totalPage > 1}">
            <div class="pagination">
                <c:if test="${startPage > 1}">
                    <a href="${pageContext.request.contextPath}/store/category?cate=${selectedCate}&page=${startPage - 1}&sort=${sort}" class="page-item">이전</a>
                </c:if>

                <c:forEach var="p" begin="${startPage}" end="${endPage}">
                    <a href="${pageContext.request.contextPath}/store/category?cate=${selectedCate}&page=${p}&sort=${sort}" 
                       class="page-item ${p == page ? 'active' : ''}">${p}</a>
                </c:forEach>

                <c:if test="${endPage < totalPage}">
                    <a href="${pageContext.request.contextPath}/store/category?cate=${selectedCate}&page=${endPage + 1}&sort=${sort}" class="page-item">다음</a>
                </c:if>
            </div>
        </c:if>

    </main>
</div>

<script>
    function changeSort(sortType) {
        var currentCate = "${selectedCate != null ? selectedCate : 'all'}";
        location.href = "${pageContext.request.contextPath}/store/category?cate=" + encodeURIComponent(currentCate) + "&sort=" + sortType;
    }
</script>

</body>
</html>
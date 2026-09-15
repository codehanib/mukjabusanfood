<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>bookmark list</title>
<style>
* {
        box-sizing: border-box;
        }
        body {
            margin: 0;
            padding: 0px 0px;
            background: #f8f9fa;
            color: #333;
        }
        /* 제목 */
        .bookmark-title {
            width: 800px;
            margin: 0 auto 30px;
            color: #222;
            font-size: 28px;
            font-weight: 700;
        }
        /* 북마크 목록 */
        .bookmark-list {
            width: 800px;
            margin: 0 auto;
        }
        /* 식당 카드 */
        .bookmark-card {
            display: flex;
            width: 100%;
            height: 200px;
            margin-bottom: 18px;
            background: #fff;
            border-radius: 16px;
            overflow: hidden;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.07);
            transition: all 0.2s ease;
        }
        .bookmark-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 22px rgba(0, 0, 0, 0.1);
        }
        /* 음식점 이미지 */
        .bookmark-image {
            width: 200px;
            height: 200px;
            flex-shrink: 0;
        }
        .bookmark-image img {
            display: block;
            width: 200px;
            height: 200px;
            object-fit: cover;
        }
        /* 식당 정보 */
        .bookmark-info {
            flex: 1;
            padding: 25px 20px;
        }
        /* 식당 이름 */
        .restaurant-name {
            margin: 0 0 15px;
            color: #222;
            font-size: 25px;
            font-weight: 700;
        }
        /* 지역 */
        .restaurant-region {
            margin: 0 0 15px;
            color: #777;
            font-size: 14px;
        }
        /* 별점 */
        .restaurant-point {
            margin: 0;
            color: #FF4B32;
            font-size: 16px;
            font-weight: 600;
        }
        /* 버튼 영역 */
        .bookmark-actions {
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            width: 120px;
            padding: 20px 15px;
            border-left: 1px solid #f0f0f0;
        }
        .bookmark-actions a {
            text-decoration: none;
        }
        /* 바로가기 버튼 */
        .detail-btn {
            width: 90px;
            padding: 10px 5px;
            background: #FF4B32;
            border-radius: 8px;
            color: #fff;
            font-size: 15px;
            font-weight: 600;
            text-align: center;
            transition: background 0.2s ease;
        }
        .detail-btn:hover {
            background: #e83d26;
        }
        /* 삭제 버튼 */
        .delete-btn {
            width: 90px;
            padding: 10px 5px;
            background: #dddddd;
            border-radius: 8px;
            color: #555555;
            font-size: 15px;
            font-weight: 600;
            text-align: center;
            transition: background 0.2s ease;
            margin-top: 10px;
        }
        .delete-btn:hover {
            background: #aaaaaa;
            color: #fff;
        }
        /* 찜한 가게가 없는 경우 */
        .empty-bookmark {
            width: 700px;
            margin: 70px auto 30px;
            padding: 50px 20px;
            background: #fff;
            border-radius: 16px;
            color: #999;
            text-align: center;
            font-size: 15px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
        }
        /* 홈으로 */
        .home-btn {
            display: block;
            width: 120px;
            margin: 35px auto 0;
            padding: 11px 20px;
            border: 1px solid #FF4B32;
            border-radius: 8px;
            color: #FF4B32;
            text-align: center;
            text-decoration: none;
            font-size: 14px;
            font-weight: 600;
            transition: all 0.2s ease;
        }
        .home-btn:hover {
            background: #FF4B32;
            color: #fff;
        }
        #bm {
        	color: #ff6644;
        	margin-right: 10px;
        }
</style>
<%@ include file="/WEB-INF/views/header.jsp" %>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css">

</head>
<body>
	<h2 class="bookmark-title"><i class="fa-solid fa-bookmark" id="bm"></i> 찜한 가게</h2>
	<c:choose>
        <c:when test="${not empty bklist}">
            <div class="bookmark-list">
                <c:forEach var="bk" items="${bklist}">
                    <div class="bookmark-card">
                        <!-- 음식점 이미지 -->
                        <div class="bookmark-image">
                            <c:choose>
                                <c:when test="${not empty bk.r_img and fn:startsWith(bk.r_img, 'http')}">
                                    <a href="/restaurant/detail?r_no=${bk.r_no}"><img src="${bk.r_img}" alt="${bk.r_name}"></a>
                                </c:when>
                                <c:otherwise>
                                    <a href="/restaurant/detail?r_no=${bk.r_no}"><img src="/upload/${bk.r_img}" alt="${bk.r_name}"></a>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <!-- 음식점 정보 -->
                        <div class="bookmark-info">
                            <h3 class="restaurant-name">
                                ${bk.r_name}
                            </h3>
                            <p class="restaurant-region">
                                ${bk.r_region}
                            </p>
                            <p class="restaurant-point">
                                ★ ${bk.r_point}
                            </p>
                        </div>
                        <!-- 버튼 -->
                        <div class="bookmark-actions">
                            <a class="detail-btn"
                               href="/restaurant/detail?r_no=${bk.r_no}">바로가기</a>
                            <a class="delete-btn"
                               href="/users/bookmarkDelete?bk_no=${bk.bk_no}">삭제</a>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:when>
        <c:otherwise>
            <p class="empty-bookmark">찜한 가게가 없습니다.</p>
        </c:otherwise>
    </c:choose>
    <a class="home-btn" href="/main">홈으로</a>
<%@ include file="/WEB-INF/views/footer.jsp" %>
</body>
</html>
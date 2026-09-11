<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>메뉴 선택 - Mukja</title>
<style>
    body { font-family: '맑은 고딕', sans-serif; background-color: #f8f9fa; margin: 0; padding: 20px; }
    .container { max-width: 700px; margin: 0 auto; background: #ffffff; border-radius: 12px; padding: 25px; box-shadow: 0 4px 10px rgba(0,0,0,0.05); }
    
    .header { display: flex; justify-content: space-between; align-items: center; border-bottom: 2px solid #FF5722; padding-bottom: 15px; margin-bottom: 20px; }
    .header h2 { margin: 0; color: #333; font-size: 1.4em; }
    .btn-cart { background: #333; color: white; text-decoration: none; padding: 8px 15px; border-radius: 6px; font-size: 0.9em; font-weight: bold; }
    .btn-cart:hover { background: #555; }

    .menu-card { display: flex; align-items: center; border: 1px solid #eee; border-radius: 10px; padding: 15px; margin-bottom: 15px; background: #fff; transition: transform 0.2s; }
    .menu-card:hover { transform: translateY(-2px); box-shadow: 0 4px 12px rgba(0,0,0,0.08); }
    
    .menu-img { width: 90px; height: 90px; object-fit: cover; border-radius: 8px; margin-right: 15px; background-color: #f0f0f0; }
    .menu-info { flex: 1; }
    .menu-name { font-size: 1.1em; font-weight: bold; color: #222; margin-bottom: 5px; }
    .menu-price { font-size: 1em; color: #FF5722; font-weight: bold; margin-bottom: 10px; }

    .cart-form { display: flex; align-items: center; gap: 8px; }
    .count-input { width: 50px; padding: 6px; text-align: center; border: 1px solid #ccc; border-radius: 4px; font-weight: bold; }
    .btn-add-cart { background: #FF5722; color: white; border: none; padding: 8px 12px; border-radius: 4px; cursor: pointer; font-weight: bold; font-size: 0.9em; }
    .btn-add-cart:hover { background: #e64a19; }

    .empty-msg { text-align: center; color: #888; padding: 40px 0; }
</style>
</head>
<body>

<div class="container">
    <div class="header">
        <h2>🍽️ 배달 메뉴 선택</h2>
        <!-- 💡 1. 상단 장바구니 이동 버튼에 r_no 및 r_name 추가 -->
        <a href="${pageContext.request.contextPath}/cart?mc_no=1&r_no=${r_no}&r_name=${restaurant.r_name}" class="btn-cart">🛒 장바구니 보러가기</a>
    </div>

    <!-- 메뉴 목록 출력 -->
    <c:forEach var="menu" items="${menuList}">
        <div class="menu-card">
            <c:if test="${not empty menu.mn_img}">
                <img src="${menu.mn_img}" 
                     alt="${menu.mn_name}" 
                     class="menu-img" 
                     onerror="this.style.display='none';">
            </c:if>
            <div class="menu-info">
                <div class="menu-name">${menu.mn_name}</div>
                <div style="font-size: 0.85em; color: #777; margin-bottom: 8px;">${menu.mn_content}</div>
                <div class="menu-price">
                    <fmt:formatNumber value="${menu.mn_price}" pattern="#,###"/>원
                </div>

                <!-- 장바구니 담기 전송 폼 -->
                <form action="${pageContext.request.contextPath}/cart/insert" method="POST" class="cart-form">
                    <input type="hidden" name="mc_no" value="1">
                    <input type="hidden" name="mn_no" value="${menu.mn_no}">
                    <input type="hidden" name="mcm_price" value="${menu.mn_price}">
                    
                    <!-- 💡 2. 중복 태그 제거 후 1개씩만 유지 -->
                    <input type="hidden" name="r_no" value="${r_no}">
                    <input type="hidden" name="r_name" value="${restaurant.r_name}">
                    
                    <label for="count_${menu.mn_no}" style="font-size: 0.85em; color: #666;">수량:</label>
                    <input type="number" id="count_${menu.mn_no}" name="mcm_count" value="1" min="1" max="99" class="count-input" required>
                    
                    <button type="submit" class="btn-add-cart">🛒 담기</button>
                </form>
            </div>
        </div>
    </c:forEach>

    <c:if test="${empty menuList}">
        <div class="empty-msg">
            등록된 메뉴가 없습니다.
        </div>
    </c:if>
</div>

</body>
</html>
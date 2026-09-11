<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>장바구니 - Mukja</title>
<style>
    body { font-family: '맑은 고딕', sans-serif; margin: 20px; background-color: #f8f9fa; }
    .cart-container { max-width: 700px; margin: 0 auto; background: white; padding: 25px; border-radius: 12px; box-shadow: 0 4px 10px rgba(0,0,0,0.05); }
    .header-box { display: flex; justify-content: space-between; align-items: flex-start; border-bottom: 2px solid #FF5722; padding-bottom: 12px; margin-bottom: 20px; }
    
    /* 식당명 링크 스타일 추가 */
    .store-link { display: inline-block; margin-top: 6px; font-size: 0.95em; color: #555; text-decoration: none; font-weight: bold; }
    .store-link:hover { color: #FF5722; text-decoration: underline; }
    
    .cart-table { width: 100%; border-collapse: collapse; margin-bottom: 20px; }
    .cart-table th, .cart-table td { padding: 12px; border-bottom: 1px solid #eee; text-align: center; }
    .cart-table th { background-color: #f1f1f1; color: #333; }
    .menu-name { text-align: left !important; font-weight: bold; }
    
    .qty-input { width: 50px; text-align: center; padding: 4px; border: 1px solid #ccc; border-radius: 3px; }
    .btn-sm { padding: 5px 9px; font-size: 0.85em; border: none; border-radius: 3px; cursor: pointer; }
    .btn-update { background: #2196F3; color: white; }
    .btn-delete { background: #f44336; color: white; }
    .btn-clear { background: #757575; color: white; }
    
    .total-box { background: #fafafa; padding: 15px; border-radius: 6px; border: 1px solid #eee; margin-bottom: 20px; text-align: right; font-size: 1.2em; font-weight: bold; color: #FF5722; }
    .btn-order { width: 100%; background: #FF5722; color: white; border: none; padding: 15px; font-size: 1.1em; font-weight: bold; border-radius: 6px; cursor: pointer; }
    .btn-order:hover { background: #e64a19; }
</style>
</head>
<body>

<div class="cart-container">
    <div class="header-box">
        <div>
            <h2 style="margin: 0;">🛒 장바구니</h2>
				
			
			<a href="${pageContext.request.contextPath}/cart/delivery/menu?r_no=${r_no}" class="store-link">
    			🏪 ${not empty r_name ? r_name : '가게 바로가기'} ➔
			</a>
        </div>
        <c:if test="${not empty cartList}">
		    <form action="${pageContext.request.contextPath}/cart/clear" method="POST">
		        <input type="hidden" name="mc_no" value="${mc_no}">
		        <!-- 💡 r_no, r_name 유지 -->
		        <input type="hidden" name="r_no" value="${r_no}">
		        <input type="hidden" name="r_name" value="${r_name}">
		        <button type="submit" class="btn-sm btn-clear">전체 비우기</button>
		    </form>
		</c:if>
    </div>

    <table class="cart-table">
        <thead>
            <tr>
                <th style="width: 35%;">메뉴명</th>
                <th style="width: 20%;">단가</th>
                <th style="width: 25%;">수량</th>
                <th style="width: 20%;">관리</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="item" items="${cartList}">
                <tr>
                    <td class="menu-name">
                        ${not empty item.mn_name ? item.mn_name : '메뉴번호 '.concat(item.mn_no)}
                    </td>
                    <td><fmt:formatNumber value="${item.mcm_price}" pattern="#,###"/>원</td>
	                       <td>
					            <!-- 2) 수량 수정 폼 -->
					            <form action="${pageContext.request.contextPath}/cart/update" method="POST" style="display: inline-flex; gap: 4px;">
					                <input type="hidden" name="mcm_no" value="${item.mcm_no}">
					                <input type="hidden" name="mc_no" value="${item.mc_no}">
					                <!-- 💡 r_no, r_name 유지 -->
					                <input type="hidden" name="r_no" value="${r_no}">
					                <input type="hidden" name="r_name" value="${r_name}">
					                <input type="number" name="mcm_count" value="${item.mcm_count}" min="1" class="qty-input">
					                <button type="submit" class="btn-sm btn-update">수정</button>
					            </form>
					        </td>
                    	<td>
				            <!-- 3) 개별 삭제 폼 -->
				            <form action="${pageContext.request.contextPath}/cart/delete" method="POST">
				                <input type="hidden" name="mcm_no" value="${item.mcm_no}">
				                <input type="hidden" name="mc_no" value="${item.mc_no}">
				                <!-- 💡 r_no, r_name 유지 -->
				                <input type="hidden" name="r_no" value="${r_no}">
				                <input type="hidden" name="r_name" value="${r_name}">
				                <button type="submit" class="btn-sm btn-delete">삭제</button>
				            </form>
			        	</td>
                </tr>
            </c:forEach>
            <c:if test="${empty cartList}">
                <tr>
                    <td colspan="4" style="padding: 30px; color: #888;">
                        장바구니에 담긴 메뉴가 없습니다.
                    </td>
                </tr>
            </c:if>
        </tbody>
    </table>

    <div class="total-box">
        총 주문 금액: <fmt:formatNumber value="${totalPrice}" pattern="#,###"/>원
    </div>

    <c:if test="${not empty cartList}">
        <button type="button" class="btn-order" onclick="location.href='${pageContext.request.contextPath}/delivery/order?r_no=${r_no}&mc_no=${mc_no}'">
            주문 작성 및 결제하기 ➔
        </button>
    </c:if>
</div>

</body>
</html>
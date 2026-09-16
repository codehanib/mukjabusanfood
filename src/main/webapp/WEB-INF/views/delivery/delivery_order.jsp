<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>배달 주문하기 - Mukja</title>
<style>
    body { font-family: '맑은 고딕', sans-serif; margin: 0; background-color: #f8f9fa; }
    .form-container { max-width: 650px; margin: 30px auto; border: 1px solid #e0e0e0; padding: 25px; border-radius: 12px; background: #ffffff; box-shadow: 0 4px 10px rgba(0,0,0,0.05); }
    .section-title { font-size: 1.1em; font-weight: bold; border-bottom: 2px solid #FF5722; padding-bottom: 8px; margin-top: 25px; margin-bottom: 15px; color: #333; }
    .form-group { margin-bottom: 15px; }
    label { display: block; font-weight: bold; margin-bottom: 5px; color: #555; }
    input[type="text"] { width: 70%; padding: 8px; border: 1px solid #ccc; border-radius: 4px; }
    button { padding: 8px 15px; background: #FF5722; color: white; border: none; cursor: pointer; border-radius: 4px; font-weight: bold; }
    button:hover { background: #e64a19; }

    /* 메뉴 목록 테이블 스타일 */
    .menu-table { width: 100%; border-collapse: collapse; margin-bottom: 15px; }
    .menu-table th, .menu-table td { padding: 10px; border-bottom: 1px solid #eee; text-align: left; }
    .menu-table th { background-color: #f1f1f1; color: #444; font-size: 0.9em; }
    .menu-table td.price { text-align: right; font-weight: bold; }
    
    /* 결제 금액 요약 박스 */
    .summary-box { background: #fafafa; border: 1px solid #eee; padding: 15px; border-radius: 6px; }
    .summary-row { display: flex; justify-content: space-between; margin-bottom: 8px; font-size: 0.95em; color: #666; }
    .summary-row.total { font-size: 1.2em; font-weight: bold; color: #FF5722; border-top: 1px dashed #ccc; padding-top: 10px; margin-top: 10px; }
</style>

<!-- 카카오 주소검색 및 좌표변환 API -->
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=725ccfecc146dd521381871e82fd928b&libraries=services"></script>

<!-- 포트원 결제 SDK -->
<script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script src="https://cdn.iamport.kr/v1/iamport.js"></script>

<!-- JS 데이터 전달 -->
<script>
    const ORDER_DATA = {
        rName: "${r_name}",
        totalPrice: parseInt("${(totalPrice != null ? totalPrice : 0) + (deliveryFee != null ? deliveryFee : 3000)}")
    };
</script>

<!-- 외부 payment.js 로드 -->
<script src="${pageContext.request.contextPath}/js/payment.js"></script>
</head>

<body>

<%@ include file="/WEB-INF/views/header.jsp" %>

<div class="form-container">
    <h2>🛒 배달 주문 작성</h2>
    
    <form id="orderForm" action="${pageContext.request.contextPath}/delivery/order/create" method="POST">
        
        <input type="hidden" name="r_no" value="${r_no}">
        <input type="hidden" name="u_no" value="${u_no}">
        <input type="hidden" name="mc_no" value="${mc_no}">
        <!-- ★ 오타 수정 (<<input -> <input) -->
        <input type="hidden" name="d_total_price" value="${totalPrice + deliveryFee}">
        <input type="hidden" name="deliveryFee" value="${deliveryFee}">
        <input type="hidden" name="py_type" value="배달">
        
        <!-- 위도/경도 기본값 -->
        <input type="hidden" name="d_lat" id="d_lat" value="35.1765">
        <input type="hidden" name="d_lng" id="d_lng" value="129.0785">

        <!-- 1. 주문 메뉴 내역 -->
        <div class="section-title">🍽️ 주문 메뉴 확인</div>
        <table class="menu-table">
            <thead>
                <tr>
                    <th>메뉴명</th>
                    <th style="text-align: center;">수량</th>
                    <th style="text-align: right;">금액</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="item" items="${cartList}">
                    <tr>
                        
                        <td>${item.mn_name}</td>
                        <td style="text-align: center;">${item.mcm_count}개</td>
                        <td class="price">
                            <fmt:formatNumber value="${item.mcm_price * item.mcm_count}" pattern="#,###"/>원
                        </td>
                    </tr>
                </c:forEach>
                
                <c:if test="${empty cartList}">
                    <tr>
                        <td colspan="3" style="text-align: center; color: #888; padding: 20px;">
                            선택된 주문 메뉴 정보가 없습니다.
                        </td>
                    </tr>
                </c:if>
            </tbody>
        </table>

        <!-- 2. 결제 금액 요약 -->
        <div class="section-title">💳 결제 금액</div>
        <div class="summary-box">
            <div class="summary-row">
                <span>총 메뉴 금액</span>
                <span><fmt:formatNumber value="${totalPrice != null ? totalPrice : 0}" pattern="#,###"/>원</span>
            </div>
            <div class="summary-row">
                <span>배달팁</span>
                <span><fmt:formatNumber value="${deliveryFee != null ? deliveryFee : 3000}" pattern="#,###"/>원</span>
            </div>
            <div class="summary-row total">
                <span>최종 결제 금액</span>
                <span><fmt:formatNumber value="${(totalPrice != null ? totalPrice : 0) + (deliveryFee != null ? deliveryFee : 3000)}" pattern="#,###"/>원</span>
            </div>
        </div>

        <!-- 3. 배달 주소 입력 -->
        <div class="section-title">📍 배달지 정보</div>
        <div class="form-group">
            <label for="d_addr">배달 주소</label>
            <input type="text" id="d_addr" name="d_addr" readonly required placeholder="주소 검색 버튼을 눌러주세요">
            <button type="button" onclick="execDaumPostcode()">주소 검색</button>
        </div>

        <div class="form-group">
            <label for="d_detail_addr">상세 주소</label>
            <input type="text" id="d_detail_addr" name="d_detail_addr" placeholder="예: 101동 202호">
        </div>

        <button type="button" style="width: 100%; padding: 14px; font-size: 1.1em; margin-top: 15px;" onclick="requestPay(event)">주문 결제하기</button>
    </form>
</div>

<script>
    // 주소 검색 및 위경도 추출 함수
    function execDaumPostcode() {
        new daum.Postcode({
            oncomplete: function(data) {
                var addr = data.address;
                document.getElementById("d_addr").value = addr;

                var geocoder = new kakao.maps.services.Geocoder();
                geocoder.addressSearch(addr, function(result, status) {
                    if (status === kakao.maps.services.Status.OK) {
                        document.getElementById("d_lat").value = result[0].y;
                        document.getElementById("d_lng").value = result[0].x;
                    }
                });
            }
        }).open();
    }
</script>

<%@ include file="/WEB-INF/views/footer.jsp" %>
</body>
</html>
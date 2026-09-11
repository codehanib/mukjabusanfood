// <포트원 v1 sdk 라이브러리>
var IMP = window.IMP;
IMP.init("imp19424728"); // 본인 테스트 식별 코드

/**
 * 1. 배달 주문 전용 결제 함수
 */
function requestPay(event) {
    if (event) event.preventDefault(); 
    
    var addr = document.getElementById("d_addr") ? document.getElementById("d_addr").value : "";
    var detailAddr = document.getElementById("d_detail_addr") ? document.getElementById("d_detail_addr").value : "";
    
    if (!addr || !detailAddr) {
        alert("배달지 주소를 모두 입력해주세요.");
        return false;
    }
    
    var totalPrice = ORDER_DATA.totalPrice;
    var rName = ORDER_DATA.rName;
    
    if (totalPrice <= 3000) {
        alert("장바구니에 결제할 메뉴를 담아주세요!");
        return false;
    }
    
    executePortOnePayment({
        merchantUid: "order_no_" + new Date().getTime(),
        name: rName + " 배달 주문",
        amount: totalPrice,
        buyerAddr: addr + " " + detailAddr,
        formId: "orderForm"
    });
}

/**
 * 2. 식당 예약(예약금) 전용 결제 함수 (JSP에서 호출하는 함수명으로 맞춤)
 */
function handleReservationPayment(event) {
    if (event) event.preventDefault();
    
    var resName = document.getElementById("res_name") ? document.getElementById("res_name").value : "";
    if (!resName) {
        alert("예약자 이름을 입력해주세요.");
        return false;
    }
    
    executePortOnePayment({
        merchantUid: "res_no_" + new Date().getTime(),
        name: "식당 방문 예약금",
        amount: 1000, // 1,000원 예약금
        buyerAddr: "방문 예약",
        formId: "reservationForm" // 식당 예약 전용 폼 ID
    });
}

/**
 * 공통 포트원 결제 실행 함수
 */
function executePortOnePayment(payInfo) {
    IMP.request_pay({
        pg: "kakaopay.TC0ONETIME", 
        pay_method: "card",
        merchant_uid: payInfo.merchantUid,
        name: payInfo.name,
        amount: payInfo.amount,
        buyer_name: "구매자",
        buyer_tel: "010-1234-5678",
        buyer_addr: payInfo.buyerAddr
    }, function (rsp) {
        if (rsp.success) {
            alert("결제가 완료되었습니다.");
            document.getElementById(payInfo.formId).submit();
        } else {
            alert("결제 실패: " + rsp.error_msg);
        }
    });
}
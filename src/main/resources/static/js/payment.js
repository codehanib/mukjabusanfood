/**
 * 
 */
// <포트원 v1 sdk 라이브러리>
var IMP = window.IMP;
IMP.init("imp19424728"); //포트원 테스트 식별 코드

function requestPay(event) {
	event.preventDefault(); // 기본 form submit 방지
	
	var addr = document.getElementById("d_addr").value;
	var detailAddr = document.getElementById("d_detail_addr").value;
	
	if (!addr || ! detailAddr) {
		alert("배달지 주소를 입력해주세요.");
		return false;
	}
	
	//jsp에서 전달받은 전역 변수(ORDER_DATA) 활용
	var totalPrice = OREDR_DATA.totalPrice;
	var rName = ORDER_DATA.rName;
	var merchantUid = "order_no" + new Date().getTime();
	
	// 포트원 결제창 호출 (이니시스 테스트 PG)
	IMP.request_pay({
		pg: "html5_inicis",
		pay_method: "card",
		merchant_uid: merchantUid,
		name: rName + "배달 주문",
		amount: totalPrice,
		buyer_name: "구매자",
		buyer_tel: "010-1234-5678",
		buyer_addr: addr + " " + detailAddr
	}, function (rsp) {
		if (rsp.success) {
			alert("결제가 완료되었습니다.");
			document.getElementById("orderForm").submit();
		}else {
			alert("결제 실패: " + rsp.error_msg);
		}
	});
	
}

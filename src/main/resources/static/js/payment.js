// <포트원 v1 sdk 라이브러리>
var IMP = window.IMP;
IMP.init("imp19424728"); // 본인 테스트 식별 코드

/**
 * 0. 예약 폼(reservation) 유효성검사
 *    - reservationForm.jsp 의 onsubmit="return check1();" 및
 *      결제하기 버튼의 onclick="if (check1()) { handleReservationPayment(event); }" 에서 호출됨
 */
function check1() {
    var form = document.reservation;

    var resName  = form.res_name;
    var resTel1  = form.res_tel1;
    var resTel2  = form.res_tel2;
    var resTel3  = form.res_tel3;
    var resDay   = form.res_day;
    var resTime  = form.res_time;
    var resCount = form.res_count;

    var regTel1 = /^\d{2,3}$/;
    var regTel  = /^\d{3,4}$/;

    if (!resName.value.trim()) {
        alert("예약자 이름을 입력해주세요.");
        resName.focus();
        return false;
    }

    if (!resTel1.value || !regTel1.test(resTel1.value)) {
        alert("연락처를 올바르게 입력해주세요.");
        resTel1.focus();
        return false;
    }

    if (!resTel2.value || !regTel.test(resTel2.value)) {
        alert("연락처를 올바르게 입력해주세요.");
        resTel2.focus();
        return false;
    }

    if (!resTel3.value || !regTel.test(resTel3.value)) {
        alert("연락처를 올바르게 입력해주세요.");
        resTel3.focus();
        return false;
    }

    if (!resDay.value) {
        alert("예약날짜를 선택해주세요.");
        resDay.focus();
        return false;
    }

    // 오늘 이전 날짜 재검증 (input의 min 속성은 사용자가 우회할 수 있으므로 JS로도 확인)
    var today = new Date();
    today.setHours(0, 0, 0, 0);
    var selectedDay = new Date(resDay.value);

    if (selectedDay < today) {
        alert("예약날짜는 오늘 이후로 선택해주세요.");
        resDay.focus();
        return false;
    }

    if (!resTime.value) {
        alert("예약시간을 선택해주세요.");
        resTime.focus();
        return false;
    }

    if (!resCount.value || parseInt(resCount.value, 10) < 1) {
        alert("인원수를 1명 이상 입력해주세요.");
        resCount.focus();
        return false;
    }

    return true;
}

/**
 * 0-1. 예약 수정 폼(reservationUpdate) 유효성검사
 *      - reservationUpdateForm.jsp 의 onsubmit="return checkUpdate();" 에서 호출됨
 *      - 연락처가 res_tel 하나로 합쳐져 있어 check1()과 필드 구조가 달라 별도 함수로 분리
 */
function checkUpdate() {
    var form = document.reservationUpdate;

    var resName  = form.res_name;
    var resTel   = form.res_tel;
    var resDay   = form.res_day;
    var resTime  = form.res_time;
    var resCount = form.res_count;

    var regTel = /^[0-9-]{9,13}$/;

    if (!resName.value.trim()) {
        alert("예약자 이름을 입력해주세요.");
        resName.focus();
        return false;
    }

    if (!resTel.value.trim() || !regTel.test(resTel.value.trim())) {
        alert("연락처를 올바르게 입력해주세요.");
        resTel.focus();
        return false;
    }

    if (!resDay.value) {
        alert("예약날짜를 선택해주세요.");
        resDay.focus();
        return false;
    }

    var today = new Date();
    today.setHours(0, 0, 0, 0);
    var selectedDay = new Date(resDay.value);

    if (selectedDay < today) {
        alert("예약날짜는 오늘 이후로 선택해주세요.");
        resDay.focus();
        return false;
    }

    if (!resTime.value) {
        alert("예약시간을 선택해주세요.");
        resTime.focus();
        return false;
    }

    if (!resCount.value || parseInt(resCount.value, 10) < 1) {
        alert("인원수를 1명 이상 입력해주세요.");
        resCount.focus();
        return false;
    }

    return true;
}
/**
 * 1. 배달 주문 전용 결제 함수 (서버 사전 검증 추가)
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

    var mcNo = document.querySelector("input[name='mc_no']").value;

    // 결제창 띄우기 전, 서버에 금액 사전 검증 요청
    $.ajax({
        url: "/delivery/order/validate",
        type: "POST",
        data: {
            mc_no: mcNo,
            totalPrice: totalPrice
        },
        success: function (res) {
            if (!res.valid) {
                alert(res.message || "주문 금액을 다시 확인해주세요.");
                return;
            }
            // 검증 통과 시에만 실제 결제창 오픈
            executePortOnePayment({
                merchantUid: "order_no_" + new Date().getTime(),
                name: rName + " 배달 주문",
                amount: totalPrice,
                buyerAddr: addr + " " + detailAddr,
                formId: "orderForm"
            });
        },
        error: function () {
            alert("주문 금액 확인 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.");
        }
    });
}

/**
 * 2. 식당 예약(예약금) 전용 결제 함수 (JSP에서 호출하는 함수명으로 맞춤)
 */
function handleReservationPayment(event) {
    if (event) event.preventDefault();

    // check1()에서 이미 전체 검증을 하지만, 이 함수가 단독으로 호출될 경우를 대비해 한 번 더 확인
    if (!check1()) {
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


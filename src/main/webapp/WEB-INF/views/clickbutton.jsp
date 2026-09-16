<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>문의 클릭 버튼</title>
<style>
	.inqbtn {
    position: fixed !important;
    right: 20px !important;
    bottom: 100px !important;
    width: 70px !important;
    height: 70px !important;
    object-fit: contain;
    cursor: pointer;
    z-index: 9999;
	}
	
	/* 챗봇 창 */
	.chatbot-window {
	    position: fixed;
	    right: 30px;
	    bottom: 90px;
	    width: 350px;
	    height: 450px;
	    background-color: #fff;
	    border-radius: 15px;
	    box-shadow: 0 5px 20px rgba(0, 0, 0, 0.15);
	    overflow: hidden;
	    /* 처음에는 숨김 */
	    display: none;
	    z-index: 10000;
	}
	
	/* 챗봇 상단 */
	.chatbot-header {
	    display: flex;
	    justify-content: space-between;
	    align-items: center;
	    padding: 15px 20px;
	    background-color: #FF4B32;
	    color: #fff;
	    font-weight: 700;
	}
	
	/* 닫기 버튼 */
	.chatbot-header button {
	    border: none;
	    background: none;
	    color: #fff;
	    font-size: 22px;
	    cursor: pointer;
	}
	
	/* 챗봇 내용 */
	.chatbot-content {
	    padding: 20px;
	    color: #333;
	    font-size: 14px;
	    line-height: 1.6;
	}
	
	.chatbot-buttons {
	    display: flex;
	    flex-direction: column;
	    gap: 12px;
	    margin-top: 20px;
	}
	
	.chatbot-option {
	    width: 100%;
	    padding: 12px;
	
	    border: 1px solid #FF4B32;
	    border-radius: 8px;
	
	    background-color: #fff;
	    color: #FF4B32;
	
	    font-size: 15px;
	    font-weight: 600;
	
	    cursor: pointer;
	}
	
	.chatbot-option:hover {
	    background-color: #FF4B32;
	    color: #fff;
	}
	
	.restaurant-image {
	    width: 80px;
	    height: 80px;
	    object-fit: cover;
	    border-radius: 8px;
	}
	
	.restaurant-info {
	    flex: 1;
	}
	
	.restaurant-info h4 {
	    margin: 0 0 6px;
	    font-size: 16px;
	}
	
	.restaurant-info p {
	    margin: 3px 0;
	    font-size: 13px;
	    color: #666;
	}

	.restaurant-card {
		display: flex;
	    gap: 10px;
	    margin: 10px 0;
	    padding: 10px;
	    border: 1px solid #ddd;
	    border-radius: 10px;
	    background-color: #fff;
	    cursor: pointer;
	    transition: transform 0.2s, box-shadow 0.2s;
	}
	
	.restaurant-card:hover {
	    transform: translateY(-2px);
	    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
	}
	
	#restaurantList {
	    max-height: 400px;
	    overflow-y: auto;
	    overflow-x: hidden;
	}
	
	#restaurantList::-webkit-scrollbar {
    	width: 6px;
	}

	#restaurantList::-webkit-scrollbar-thumb {
	    background-color: #ccc;
	    border-radius: 10px;
	}

	#restaurantList::-webkit-scrollbar-track {
	    background-color: #f5f5f5;
	}
	
	.notice-card {
	    margin: 10px 0;
	    padding: 12px;
	    border: 1px solid #ddd;
	    border-radius: 10px;
	    background-color: #fff;
	    cursor: pointer;
	    transition: transform 0.2s, box-shadow 0.2s;
	}
	.notice-card:hover {
	    transform: translateY(-2px);
	    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
	}
	.notice-info h4 {
	    margin: 0;
	    font-size: 13px;
	    font-weight: 600;
	    color: #333;
	}
	
	.guide-message {
    	font-size: 15px;
	    margin-top: 0;
	    margin-bottom: 15px;
	}
</style>
</head>
<body>
	<img src="/images/inqbtn.png" class="inqbtn" id="inqbtn" alt="문의하기">
	
	<div class="chatbot-window" id="chatbotWindow">
	    <div class="chatbot-header">
	        <span>🤖 맛집 도우미</span>
	        <button type="button" id="chatbotClose">
	            ×
	        </button>
	    </div>
		<div class="chatbot-content" id="chatbotContent">
		    안녕하세요! 👋<br>
		    무엇을 도와드릴까요?
		    <div class="chatbot-buttons"></div>
		</div>
	</div>

<script>
	window.contextPath = '${pageContext.request.contextPath}';	
	document.addEventListener('DOMContentLoaded', function() {
	    const inquiryButton = document.getElementById('inqbtn');
	    const chatbotWindow = document.getElementById('chatbotWindow');
	    const chatbotClose = document.getElementById('chatbotClose');
	    const chatbotContent = document.getElementById('chatbotContent');

	    // 처음 화면
	    function showStartMessage() {

	        chatbotContent.innerHTML =
	            '<div class="bot-message">' +
	                '안녕하세요! 👋<br>' +
	                '무엇을 도와드릴까요?' +
	            '</div>' +
	            '<div class="chatbot-buttons">' +
	                '<button type="button" id="recommendButton" class="chatbot-option">' +
	                    '🍽 맛집 추천' +
	                '</button>' +
	                '<button type="button" id="noticeButton" class="chatbot-option">' +
	                    '📢 공지사항' +
	                '</button>' +
	                '<button type="button" id="guideButton" class="chatbot-option">' +
	                    '📖 이용 방법' +
	                '</button>' +
	                '<button type="button" id="qnaButton" class="chatbot-option">' +
	                    '❓ 자주 묻는 질문' +
	                '</button>' +
	            '</div>';
	        const recommendButton = document.getElementById('recommendButton');
	        recommendButton.addEventListener('click', showFoodCategory);
	        
	        const noticeButton = document.getElementById('noticeButton');
	        noticeButton.addEventListener('click', showNoticeList);
	        
	        const guideButton = document.getElementById('guideButton');
	        guideButton.addEventListener('click', showGuide);
	        
	        const qnaButton = document.getElementById('qnaButton');
	        qnaButton.addEventListener('click', showQna);
	    }

	    // 음식 종류 선택 화면
	    function showFoodCategory() {

	        const categories = [
	            { id: 1, name: '한식', emoji: '🍚' },
	            { id: 2, name: '중식', emoji: '🍜' },
	            { id: 3, name: '일식', emoji: '🍣' },
	            { id: 4, name: '양식 & 세계음식', emoji: '🍝' },
	            { id: 7, name: '카페 & 디저트', emoji: '🍰' }
	        ];

	        let buttonsHtml = '';

	        categories.forEach(function(category) {

	            buttonsHtml +=
	                '<button type="button" ' +
	                        'class="chatbot-option category-button" ' +
	                        'data-category-no="' + category.id + '" ' +
	                        'data-category-name="' + category.name + '">' +
	                    category.emoji + ' ' + category.name +
	                '</button>';
	        });

	        chatbotContent.innerHTML =
	            '<div class="bot-message">' +
	                '어떤 종류의 음식을 찾으세요?' +
	            '</div>' +
	            '<div class="chatbot-buttons">' +
	                buttonsHtml +
	            '</div>';

	        const categoryButtons =
	            document.querySelectorAll('.category-button');

	        categoryButtons.forEach(function(button) {

	            button.addEventListener('click', function() {

	                const categoryNo =
	                    this.getAttribute('data-category-no');
	                const categoryName =
	                    this.getAttribute('data-category-name');
	                showRestaurants(categoryNo, categoryName);
	            });
	        });

	    }

	    // 식당 목록 조회
	    function showRestaurants(categoryNo, categoryName) {

	        chatbotContent.innerHTML =
	            '<div class="bot-message">' +
	                categoryName + ' 맛집을 추천해 드릴게요!' +
	            '</div>' +

	            '<div id="restaurantList">' +
	                '식당 정보를 불러오는 중입니다...' +
	            '</div>';

	        //const contextPath =
	            //'${pageContext.request.contextPath}';
	        //const url =
	            //contextPath + '/clickbuttons?mukja_c_no=' + categoryNo;
			const url = window.contextPath + '/clickbuttons?mukja_c_no=' + categoryNo;
				
	        fetch(url)

	            .then(function(response) {
	                if (!response.ok) {
	                    throw new Error(
	                        'HTTP 오류: ' + response.status
	                    );
	                }
	                return response.json();

	            })

	            .then(function(restaurants) {

	                const restaurantList =
	                    document.getElementById('restaurantList');
	                if (!restaurants || restaurants.length === 0) {
	                    restaurantList.innerHTML =
	                        '<div class="bot-message">' +
	                            '등록된 맛집이 없습니다.' +
	                        '</div>';
	                    return;
	                }

	                restaurantList.innerHTML = '';
	                restaurants.forEach(function(restaurant) {

	                    const card =
	                        document.createElement('div');
	                    card.className =
	                        'restaurant-card';
	                    const restaurantNo =
	                        restaurant.r_no || restaurant.rNo;
	                    const restaurantName =
	                        restaurant.r_name ||
	                        restaurant.rName ||
	                        '식당 이름 없음';
	                    const restaurantRegion =
	                        restaurant.r_region ||
	                        restaurant.rRegion ||
	                        '지역 정보 없음';
	                    const restaurantPoint =
	                        restaurant.r_point ??
	                        restaurant.rPoint ??
	                        '평점 정보 없음';
	                    const restaurantImage =
	                        restaurant.r_img ||
	                        restaurant.rImg ||
	                        '';

	                    card.innerHTML =
	                        '<img src="' +
	                            restaurantImage +
	                        '" alt="' +
	                            restaurantName +
	                        '" class="restaurant-image" ' +
	                        'onerror="this.style.display=\'none\';">' +

	                        '<div class="restaurant-info">' +
	                            '<h4>' +
	                                restaurantName +
	                            '</h4>' +
	                            '<p>지역: ' +
	                                restaurantRegion +
	                            '</p>' +
	                            '<p>평점: ' +
	                                restaurantPoint +
	                            '</p>' +
	                        '</div>';

	                    // 식당 카드 클릭 시 상세 페이지로 이동
	                    card.addEventListener('click', function() {
	                        location.href =
	                            window.contextPath +
	                            '/restaurant/detail?r_no=' +
	                            restaurantNo;

	                    });
	                    restaurantList.appendChild(card);
	                });

	            })

	            .catch(function(error) {

	                const restaurantList =
	                    document.getElementById('restaurantList');

	                if (restaurantList) {
	                    restaurantList.innerHTML =
	                        '<div class="bot-message">' +
	                            '식당 정보를 불러오지 못했습니다.<br>' +
	                            error.message +
	                        '</div>';
	                }
	            });

	    }

	    // 도움말 버튼 클릭
	    if (inquiryButton && chatbotWindow) {
	        inquiryButton.addEventListener('click', function() {
	            chatbotWindow.style.display = 'block';
	            showStartMessage();
	        });
	    }

	    // 닫기 버튼 클릭
	    if (chatbotClose && chatbotWindow) {
	        chatbotClose.addEventListener('click', function() {
	            chatbotWindow.style.display = 'none';
	        });
	    }
	    
	 // 공지사항
	    function showNoticeList() {
	        chatbotContent.innerHTML =
	            '<div class="bot-message">' +
	                '📢 공지사항을 확인해보세요.' +
	            '</div>' +
	            '<div id="noticeList">' +
	                '잠시만 기다려주세요...' +
	            '</div>';
			
			const url = window.contextPath + '/clickbuttons/notices';
	        
			fetch(url)
	            .then(function(response) {

	                if (!response.ok) {
	                    throw new Error(
	                        'HTTP 오류: ' + response.status
	                    );
	                }
	                return response.json();
	            })
	            .then(function(notices) {

	                const noticeList =
	                    document.getElementById('noticeList');
	                if (!notices || notices.length === 0) {
	                    noticeList.innerHTML =
	                        '<div class="bot-message">' +
	                            '등록된 공지사항이 없습니다.' +
	                        '</div>';
	                    return;
	                }

	                let html = '';

	                notices.forEach(function(notice) {
	                    html +=
	                    	'<div class="notice-card" onclick="location.href=\'' +
	                        window.contextPath + '/noticeView?nt_no=' + notice.nt_no +
	                    		'\'">' +
	                            '<div class="notice-info">' +
	                                '<h4>' +
	                                    notice.nt_title +
	                                '</h4>' +
	                            '</div>' +
	                        '</div>';
	                });

	                noticeList.innerHTML = html;
	            })
	            .catch(function(error) {

	                const noticeList =
	                    document.getElementById('noticeList');
	                if (noticeList) {
	                    noticeList.innerHTML =
	                        '<div class="bot-message">' +
	                            '공지사항을 불러오지 못했습니다.<br>' +
	                            error.message +
	                        '</div>';
	                }
	            });
	    }
	});

	function showGuide() {
	    chatbotContent.innerHTML =
	        '<div class="bot-message"> 📖 사이트 이용 방법을 안내해드리겠습니다. </div>' +
	        '<div class="chatbot-buttons">' +
	            '<button type="button" class="chatbot-option" id="reservationGuideButton"> 🍽 식당 예약 방법 </button>' +
	            '<button type="button" class="chatbot-option" id="deliveryGuideButton"> 🛵 배달 주문 방법 </button>' +
	        '</div>';
	        
	    const reservationGuideButton = document.getElementById('reservationGuideButton');
	    reservationGuideButton.addEventListener('click',showReservationGuide);
	    
	    const deliveryGuideButton = document.getElementById('deliveryGuideButton');
	    deliveryGuideButton.addEventListener('click',showDeliveryGuide);
	}

	function showReservationGuide() {
	    chatbotContent.innerHTML = `
	        <div class="bot-message guide-message">
	            🍽 식당 예약 방법
	            <br><br>
	            → 원하는 식당을 선택해주세요.<br>
	            → 식당 페이지에서 예약하기 버튼을 눌러주세요.<br>
	            → 예약 날짜와 시간을 선택해주세요.<br>
	            → 인원을 선택한 후 예약을 진행해주세요.<br>
	            → 예약이 완료되면 예약 정보를 확인해주세요. <br>
	            → 비회원은 홈페이지의 최상단에서 이름과 전화번호를 입력하여 예약 내역을 조회할 수 있습니다.
	        </div> 
	        <div class="chatbot-buttons">
	            <button type="button"
	                    class="chatbot-option"
	                    id="backToGuideButton">
	                ↩ 이용 방법으로 돌아가기
	            </button>
	        </div>
	    `;
	    document.getElementById('backToGuideButton').addEventListener('click', showGuide);
	}

	function showDeliveryGuide() {
	    chatbotContent.innerHTML = `
	        <div class="bot-message guide-message">
	    		🛵 배달 주문 방법
	            <br><br>
	            → 배달 주문은 회원만 이용 가능합니다.<br>
	            → 원하는 식당을 선택해주세요.<br>
	            → 식당 페이지에서 배달 주문 버튼을 눌러주세요.<br>
	            → 원하시는 메뉴와 수량을 정해 담기 버튼을 눌러주세요.<br>
	            → 장바구니에서 메뉴와 가격을 확인해주세요.<br>
	            → 주문 작성 및 결제하기 버튼을 눌러 주문서를 확인해주세요.<br>
	            → 배달지 정보를 입력해주세요.<br>
	            → 결제 버튼으로 결제 하시면 주문이 완료됩니다.
	        </div> 
	        <div class="chatbot-buttons">
	            <button type="button"
	                    class="chatbot-option"
	                    id="backToGuideButton">
	                ↩ 이용 방법으로 돌아가기
	            </button>
	        </div>
	    `;
	    document.getElementById('backToGuideButton').addEventListener('click', showGuide);
	}
	
	function showQna() {
	    chatbotContent.innerHTML =
	        '<div class="bot-message"> ❓ 자주 묻는 질문을 선택해주세요. </div>' +
	        '<div class="chatbot-buttons">' +
	            '<button type="button" class="chatbot-option" id="qna1">' +
	                '❓ 비밀번호 변경 방법' +
	            '</button>' +
	            '<button type="button" class="chatbot-option" id="qna2">' +
	                '❓ 가게 입점 방법' +
	            '</button>' +
	            '<button type="button" class="chatbot-option" id="qna3">' +
	                '❌ 예약을 취소하고 싶어요.' +
	            '</button>' +
	        '</div>';

	    document.getElementById('qna1').addEventListener('click', showQna1);
	    document.getElementById('qna2').addEventListener('click', showQna2);
	    document.getElementById('qna3').addEventListener('click', showQna3);
	}
	
	function showQna1() {
	    chatbotContent.innerHTML =
	        '<div class="bot-message"> ❓ 자주 묻는 질문 <br><br> </div>' +
	        '<div class="guide-message">' +
	            'Q. 비밀번호 변경 방법 <br><br> A. 회원 정보 수정 및 비밀번호 변경은 마이페이지의 회원 정보 보기 탭에서 하실 수 있습니다.' +
	        '</div>' +
	        '<div class="chatbot-buttons">' +
	            '<button type="button" class="chatbot-option" id="backToQnaButton"> ↩ 자주 묻는 질문으로 돌아가기 </button> </div>';
	    document.getElementById('backToQnaButton').addEventListener('click', showQna);
	}
	function showQna2() {
	    chatbotContent.innerHTML =
	        '<div class="bot-message"> ❓ 자주 묻는 질문 <br><br> </div>' +
	        '<div class="guide-message">' +
	            'Q. 가게 입점 방법 <br><br> A. 회원 가입 후 관리자에게 권한을 요청하여 점주 권한을 부여받으면 식당을 등록할 수 있습니다.<br>식당을 삭제할 시에는 관리자에게 삭제 요청이 필요합니다.' +
	        '</div>' +
	        '<div class="chatbot-buttons">' +
	            '<button type="button" class="chatbot-option" id="backToQnaButton"> ↩ 자주 묻는 질문으로 돌아가기 </button> </div>';
	    document.getElementById('backToQnaButton').addEventListener('click', showQna);
	}
	function showQna3() {
	    chatbotContent.innerHTML =
	        '<div class="bot-message"> ❓ 자주 묻는 질문 <br><br> </div>' +
	        '<div class="guide-message">' +
	            'Q. 예약을 취소하고 싶어요. <br><br> A. 식당 예약 취소나 배달 후기 등의 문의는 사이트 문의가 아닌 식당 상세페이지의 연락처를 이용해주세요.' +
	        '</div>' +
	        '<div class="chatbot-buttons">' +
	            '<button type="button" class="chatbot-option" id="backToQnaButton"> ↩ 자주 묻는 질문으로 돌아가기 </button> </div>';
	    document.getElementById('backToQnaButton').addEventListener('click', showQna);
	}
</script>
</body>

</html>
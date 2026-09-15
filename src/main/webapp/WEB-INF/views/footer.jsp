<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<meta charset="UTF-8">
<%@ taglib prefix="sec"
    uri="http://www.springframework.org/security/tags" %>
<link rel="stylesheet" href="/css/footer.css">
<title>footer</title>

<footer class="footer">

    <!-- 1. 왼쪽 : 로고 -->
    <div class="footer-logo">
        <img src="/images/footerlogo.png" alt="MUKJA 로고">
    </div>

    <!-- 2. 가운데 : 회사정보 -->
    <div class="footer-company">

        <h3>묵자 MUKJA - 부산 식당 예약 & 배달 주문 사이트</h3>

        상호명 : MUKJA <br>

        사업자등록번호 : 123-12-12345
        대표자명 : 김은진, 이동희, 차도일, 홍혜진 <br>

        주소 : 부산 부산진구 중앙대로 627,
        12층 (우)47351 <br>

        통신판매업신고 : 제2026-부산진구-0001호
        개인정보보호책임자 : 홍혜진 <br>

        이메일 : MUKJA@gmail.com <br>

        고객센터 :
        <b>1234-1110</b>
        (평일 09:00~18:00)

    </div>


    <!-- 3. 오른쪽 : 이용안내 -->
    <div class="footer-menu">
        <div>
            <a href="/noticeList">서비스 이용약관</a>
            <a href="/noticeList">위치정보 이용약관</a>
            <a href="/noticeList">개인정보 처리방침</a>
            <a href="/noticeList">리뷰 운영 정책</a>
            <a href="/users/inquiryList" onclick="return confirm('로그인이 필요한 서비스입니다.');">입점 문의</a>
        </div>
    </div>

    <!-- 4. Copyright -->
    <div class="footer-bottom">

        Copyright © 2026 MUKJA.
        All Rights Reserved.

    </div>

</footer>
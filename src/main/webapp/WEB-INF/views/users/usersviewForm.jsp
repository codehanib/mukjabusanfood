<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원상세정보</title>

</head>
<body>
    <!-- 제목 -->
    <div>
        회원정보
    </div>

    <!-- 회원정보 -->
    <table>
        <tr>
            <th>아이디</th>
            <td>${view.u_id}</td>
        </tr>

        <tr>
            <th>이름</th>
            <td>${view.u_name}</td>
        </tr>

        <tr>
            <th>이메일</th>
            <td>${view.u_email}</td>
        </tr>

        <tr>
            <th>우편번호</th>
            <td>${view.u_zipno}</td>
        </tr>

        <tr>
            <th>주소</th>
            <td>${view.u_addr}</td>
        </tr>

        <tr>
            <th>전화번호</th>
            <td>${view.u_tel}</td>
        </tr>
    </table>

    <!-- 버튼 -->
    <div>

        <a href="/users/passwordCheckForm?mode=update">
            회원정보 수정
        </a>
        <a href="/users/passwordCheckForm?mode=passwd">
            비밀번호 변경
        </a>
        <a href="/users/passwordCheckForm?mode=delete">
            회원 탈퇴
        </a>
        <a href="/main">
            메인
        </a>
    </div>
</body>
</html>
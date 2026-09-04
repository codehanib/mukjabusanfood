<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 상세정보 (관리자)</title>
</head>
<body>
    <div class="title">회원정보 상세</div>

    <table class="users-info">
        <tr><th>번호</th><td>${view.u_no}</td></tr>
        <tr><th>아이디</th><td>${view.u_id}</td></tr>
        <tr><th>이름</th><td>${view.u_name}</td></tr>
        <tr><th>이메일</th><td>${view.u_email}</td></tr>
        <tr><th>우편번호</th><td>${view.u_zipno}</td></tr>
        <tr><th>주소</th><td>${view.u_addr}</td></tr>
        <tr><th>전화번호</th><td>${view.u_tel}</td></tr>
        <tr><th>권한</th><td>${view.u_auth}</td></tr>
        <tr><th>가입일</th><td><fmt:formatDate value="${view.u_date}" pattern="yyyy년 MM월 dd일" /></td></tr>
        <tr><th>상태</th><td>${view.u_stats}</td></tr>
        <tr>
    <th>권한 변경</th>
    <td>
        <form action="/admin/usersAuthUpdate" method="post">
            <input type="hidden" name="u_no" value="${view.u_no}">
            <select name="u_auth">
                <option value="USER"  ${view.u_auth == 'USER'  ? 'selected' : ''}>USER</option>
                <option value="OWNER" ${view.u_auth == 'OWNER' ? 'selected' : ''}>OWNER</option>
                <option value="ADMIN" ${view.u_auth == 'ADMIN' ? 'selected' : ''}>ADMIN</option>
            </select>
            식당번호: <input type="text" name="r_no" value="${view.r_no}">
            <button type="submit" 
                onclick="return confirm('${view.u_id} 회원의 권한을 변경하시겠습니까?');">
                변경
            </button>
            
        </form>
    </td>
</tr>

    </table>

    <div class="button-area">
        <a href="/admin/usersList">목록으로</a>
    </div>
</body>
</html>
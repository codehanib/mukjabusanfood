<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원목록</title>
<link rel="stylesheet" href="/css/mypage.css">
</head>
<%@ include file="/WEB-INF/views/header.jsp" %>
<body>

<div class="mypage-container">

    <div class="mypage-title">회원목록</div>

    <table class="list-table">
        <tr>
            <th style="width: 80px;">NO</th>
            <th style="width: 180px;">ID</th>
            <th style="width: 150px;">이름</th>
            <th style="width: 180px;">전화번호</th>
            <th>이메일</th>
            <th style="width: 80px;">삭제</th>
        </tr>
        <c:choose>
            <c:when test="${not empty usersList}">
                <c:forEach var="users" items="${usersList}">
                    <tr>
                        <td><a href="/admin/usersView?u_no=${users.u_no}">${users.u_no}</a></td>
                        <td>${users.u_id}</td>
                        <td>${users.u_name}</td>
                        <td>${users.u_tel}</td>
                        <td>${users.u_email}</td>
                        <td>
                            <button type="button" class="btn-outline"
                                onclick="if(confirm('정말로 삭제하시겠습니까?')) { location.href='/admin/usersDelete?u_no=${users.u_no}'; }">
                                삭제</button>
                        </td>
                    </tr>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <tr>
                    <td colspan="6">등록된 회원이 없습니다.</td>
                </tr>
            </c:otherwise>
        </c:choose>
    </table>

    <div class="info-actions">
        <a href="/main" class="primary">메인으로</a>
    </div>

</div>
<%@ include file="/WEB-INF/views/footer.jsp" %>
<%@ include file="/WEB-INF/views/clickbutton.jsp" %>

</body>
</html>
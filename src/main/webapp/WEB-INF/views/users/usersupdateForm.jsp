<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원정보수정</title>

</head>
<script src="/js/writeForm.js"></script>
<body>


<main class="update-main">

    <div class="update-box">

        <div class="update-title">
            <h3>회원정보수정</h3>
        </div>

        <form action="/users/usersUpdate"
              method="post"
              name="users"
              class="update-form">

            <input type="hidden"
                   name="u_id"
                   value="${updateForm.u_id}">

            <table class="update-table">

                <tr>
                    <td>아이디</td>
                    <td>${updateForm.u_id}</td>
                </tr>
                <tr>
                    <td>이름</td>
                    <td>${updateForm.u_name}</td>
                </tr>

                <tr>
                    <td>이메일</td>
                    <td>
                        <input type="text"
                               name="u_email"
                               value="${fn:split(updateForm.u_email,'@')[0]}">@

                        <select name="u_email2">
                            <option value="">선택</option>

                            <option value="naver.com"
                                <c:if test="${fn:contains(updateForm.u_email,'naver.com')}">
                                    selected
                                </c:if>>
                                naver.com
                            </option>

                            <option value="gmail.com"
                                <c:if test="${fn:contains(updateForm.u_email,'gmail.com')}">
                                    selected
                                </c:if>>
                                gmail.com
                            </option>

                            <option value="daum.com"
                                <c:if test="${fn:contains(updateForm.u_email,'daum.com')}">
                                    selected
                                </c:if>>
                                daum.com
                            </option>

                            <option value="nate.com"
                                <c:if test="${fn:contains(updateForm.u_email,'nate.com')}">
                                    selected
                                </c:if>>
                                nate.com
                            </option>
                        </select>
                    </td>
                </tr>

                <tr>
                    <td>우편번호</td>
                    <td>
                        <input type="text"
                               name="u_zipno"
                               readonly
                               value="${updateForm.u_zipno}">
                    </td>
                </tr>

                <tr>
                    <td>주소</td>
                    <td>
                        <input type="text"
                               name="u_addr"
                               readonly
                               value="${fn:split(updateForm.u_addr,',')[0]}">

                        <input type="button"
                               value="주소검색"
                               onclick="goPopup()">
                    </td>
                </tr>

                <tr>
                    <td>상세주소</td>
                    <td>
                        <input type="text"
                               name="u_addr2"
                               readonly
                               value="${fn:split(updateForm.u_addr,',')[1]}">
                    </td>
                </tr>

                <tr>
                    <td>전화번호</td>
                    <td>
                        <input type="text"
                               name="u_tel"
                               size="3"
                               maxlength="3"
                               value="${fn:split(updateForm.u_tel,'-')[0]}">
                        -
                        <input type="text"
                               name="u_tel2"
                               size="4"
                               maxlength="4"
                               value="${fn:split(updateForm.u_tel,'-')[1]}">
                        -
                        <input type="text"
                               name="u_tel3"
                               size="4"
                               maxlength="4"
                               value="${fn:split(updateForm.u_tel,'-')[2]}">
                    </td>
                </tr>

            </table>

            <div class="update-buttons">
                <input type="reset"
                       value="수정취소">
			
                <input type="submit" value="수정하기" onclick="return check()" class="update-blue">
            </div>

        </form>

    </div>

</main>

<a href="/main">
            메인
        </a>
</body>
</html>
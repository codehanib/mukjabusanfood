<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>주소 검색</title>

<%
    request.setCharacterEncoding("UTF-8");

    String inputYn = request.getParameter("inputYn");

    String roadAddrPart1 = request.getParameter("roadAddrPart1");
    String zipNo = request.getParameter("zipNo");
    String addrDetail = request.getParameter("addrDetail");
%>

<script type="text/javascript">

function init() {

    var url = location.href;

    // 도로명주소 API 승인키
    var confmKey = "devU01TX0FVVEgyMDI2MDYxODE1MTUzMjExOTQ1Mjc=";

    // 검색 결과 유형
    var resultType = "4";

    var inputYn = "<%=inputYn%>";

    // 아직 주소검색을 하지 않은 경우
    if (inputYn != "Y") {

        document.form.confmKey.value = confmKey;
        document.form.returnUrl.value = url;
        document.form.resultType.value = resultType;

        document.form.action =
            "https://business.juso.go.kr/addrlink/addrLinkUrl.do";

        document.form.submit();

    } else {

        // 주소 검색 결과를 부모 창으로 전달
        opener.jusoCallBack(
            "<%=roadAddrPart1%>",
            "<%=addrDetail%>",
            "<%=zipNo%>"
        );

        // 팝업 닫기
        window.close();
    }
}

</script>
</head>

<body onload="init();">

<form id="form" name="form" method="post">

    <input type="hidden" id="confmKey" name="confmKey" value="">
    <input type="hidden" id="returnUrl" name="returnUrl" value="">
    <input type="hidden" id="resultType" name="resultType" value="">

</form>

</body>
</html>
```

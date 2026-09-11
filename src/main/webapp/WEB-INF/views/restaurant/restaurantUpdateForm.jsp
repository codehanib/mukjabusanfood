<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>식당 정보 수정</title>
</head>

<body>

<h2>식당 정보 수정</h2>

<form action="/restaurant/update" method="post" name="restaurantUpdateForm" enctype="multipart/form-data">

    <!-- 식당 번호 -->
    <input type="hidden" name="r_no" value="${restaurant.r_no}">

    <!-- 기존 식당 이미지 -->
    <input type="hidden" name="old_r_img" value="${restaurant.r_img}">

    <!-- 주소에서 자동 설정 -->
    <input type="hidden" id="r_region" name="r_region" value="${restaurant.r_region}">
    <input type="hidden" id="r_lat" name="r_lat" value="${restaurant.r_lat}">
    <input type="hidden" id="r_lon" name="r_lon" value="${restaurant.r_lon}">

    <table border="1">

        <!-- 식당 이름 -->
        <tr>
            <td>식당 이름</td>
            <td>
                <input type="text" name="r_name"  value="${restaurant.r_name}" required>
            </td>
        </tr>

        <!-- 식당 주소 -->
        <tr>
            <td>식당 주소</td>
            <td>
                <input type="text" id="r_addr" name="r_addr" value="${restaurant.r_addr}" readonly required>
                <input type="button" value="주소 검색" onclick="goPopup();">
            </td>
        </tr>


        <!-- 매장 소개 -->
        <tr>
            <td>매장 소개</td>
            <td>
                <textarea name="r_info" rows="5" cols="60">${restaurant.r_info}</textarea>
            </td>
        </tr>


        <!-- 영업시간 -->
        <tr>
            <td>영업시간</td>
            <td>
                <textarea name="r_time" rows="5" cols="60">${restaurant.r_time}</textarea>
            </td>
        </tr>
        
        <!-- 휴무일 -->
        <tr>
            <td>휴무일</td>
            <td>
                <input type="text" name="r_rest" value="${restaurant.r_rest}" placeholder="예: 매주 월요일" required>
            </td>
        </tr>

        <!-- 식당 이미지 -->
        <tr>
            <td>식당 이미지</td>
            <td>

                <!-- 현재 이미지 -->
                <c:if test="${not empty restaurant.r_img}">
                    <div>
                        현재 이미지<br>

                        <c:choose>
                            <c:when test="${restaurant.r_img.startsWith('http')}">
                                <img src="${restaurant.r_img}" width="150">
                            </c:when>

                            <c:otherwise>
                                <img src="/upload/${restaurant.r_img}" width="150">
                            </c:otherwise>
                        </c:choose>
                    </div>
                </c:if>

                <!-- 새 이미지 -->
                <input type="file" name="r_upload" accept="image/*">

                <div>
                    새 이미지를 선택하지 않으면 기존 이미지를 사용합니다.
                </div>

            </td>
        </tr>

        <!-- 음식종류 -->
        <tr>
            <td>음식종류</td>

            <td>
                <select name="mukja_c_no" required>

                    <option value="">음식종류 선택</option>

                    <c:forEach var="category"
                               items="${categoryList}">

                        <option value="${category.mukja_c_no}"
                            <c:if test="${category.mukja_c_no == restaurant.mukja_c_no}">
                                selected
                            </c:if>>

                            ${category.mukja_c_name}

                        </option>

                    </c:forEach>

                </select>
            </td>
        </tr>

        <!-- 메뉴판 이미지 -->
        <tr>
            <td>메뉴판 이미지</td>

            <td>

                <!-- 기존 메뉴판 -->
                <c:if test="${not empty menuBoardImageList}">

                    <div>현재 메뉴판</div>

				<c:forEach var="img" items="${menuBoardImageList}">
				
				    <div class="menu-board-item">
				
				        <c:choose>
				            <c:when test="${fn:startsWith(img.mbi_img, 'http')}">
				                <img src="${img.mbi_img}" width="150">
				            </c:when>
				
				            <c:otherwise>
				                <img src="/upload/${img.mbi_img}" width="150">
				            </c:otherwise>
				        </c:choose>
				        <br>
				
				        <!-- 삭제할 기존 메뉴판 선택 -->
				        <label>
				            <input type="checkbox" name="delete_mbi_no" value="${img.mbi_no}">
				            삭제
				        </label>
				
				    </div>
				
				</c:forEach>

                    <br><br>

                </c:if>

                <!-- 새 메뉴판 이미지 -->
                <input type="file" name="mbi_upload" accept="image/*" multiple>

                <div>
                    새 메뉴판 이미지를 추가할 경우 선택하세요.
                </div>

            </td>
        </tr>

        <!-- 메뉴 -->
        <tr>
            <td>메뉴</td>

            <td>

                <div id="menuContainer">

                    <!-- 기존 메뉴 -->
                    <c:forEach var="menu" items="${menuList}">

                        <div class="menu-item">
						
                            <input type="hidden" name="mn_no" value="${menu.mn_no}">
                            메뉴명<br>
                            <input type="text" name="mn_name" value="${menu.mn_name}">
                            <br>
                            메뉴 설명<br>
							<textarea name="mn_content">${menu.mn_content}</textarea>
							<br>
                            가격<br>
                            <input type="number" name="mn_price" value="${menu.mn_price}">
                            <br>

                            현재 이미지<br>

                            <c:if test="${not empty menu.mn_img}">
							    <c:choose>
							        <c:when test="${fn:startsWith(menu.mn_img, 'http')}">
							            <img src="${menu.mn_img}" width="100">
							        </c:when>
							        <c:otherwise>
							            <img src="/upload/${menu.mn_img}" width="100">
							        </c:otherwise>
							    </c:choose>
							
							    <br>
							</c:if>

							<input type="hidden" name="old_mn_img" value="${menu.mn_img}">

                            새 메뉴 이미지<br>
                            <input type="file" name="mn_upload"  accept="image/*">

                            <hr>

                        </div>

                    </c:forEach>

                    <!-- 메뉴가 하나도 없는 경우 -->
                    <c:if test="${empty menuList}">

                        <div class="menu-item">
							<input type="hidden" name="mn_no" value="">
							<input type="hidden" name="old_mn_img" value="">
							
                            메뉴명<br>
                            <input type="text" name="mn_name">
                            <br>

                            메뉴 설명<br>
							<textarea name="mn_content"></textarea>
							<br>

                            가격<br>
                            <input type="number" name="mn_price">
                            <br>

                            메뉴 이미지<br>
                            <input type="file" name="mn_upload" accept="image/*">

                            <hr>

                        </div>

                    </c:if>

                </div>

                <button type="button" onclick="addMenu();">
                    메뉴 추가
                </button>

            </td>
        </tr>


        <!-- 상세 정보 -->
        <tr>
            <td>상세 정보</td>

            <td>
                <textarea name="r_desc" rows="10" cols="60">${restaurant.r_desc}</textarea>
            </td>
        </tr>


        <!-- 수정 -->
        <tr>
            <td colspan="2">

                <button type="submit">
                    식당 정보 수정
                </button>

            </td>
        </tr>

    </table>

</form>


<script type="text/javascript"
    src="//dapi.kakao.com/v2/maps/sdk.js?appkey=YOUR_KEY&libraries=services&autoload=false">
</script>


<script type="text/javascript">
function goPopup() {

    window.open(
        "/jusoPopup",
        "pop",
        "width=570,height=420,scrollbars=yes,resizable=yes"
    );
}

function jusoCallBack(roadAddrPart1, addrDetail, zipNo) {

    const fullAddr = roadAddrPart1 + " " + addrDetail;

    document.getElementById("r_addr").value = fullAddr;

    const parts = roadAddrPart1.split(" ");

    if (parts.length >= 2) {
        document.getElementById("r_region").value = parts[1];
    }

    searchLatLon(roadAddrPart1);
}


/* 주소 → 위도/경도 */
function searchLatLon(address) {

    kakao.maps.load(function() {

        const geocoder =
            new kakao.maps.services.Geocoder();

        geocoder.addressSearch(
            address,
            function(result, status) {

                if (
                    status ===
                    kakao.maps.services.Status.OK
                ) {

                    document.getElementById("r_lat").value =
                        result[0].y;

                    document.getElementById("r_lon").value =
                        result[0].x;

                } else {

                    alert(
                        "주소의 위도/경도를 찾지 못했습니다."
                    );

                }

            }
        );

    });
}

/* 메뉴 추가 */
function addMenu() {

    const container =
        document.getElementById("menuContainer");

    const div =
        document.createElement("div");

    div.className = "menu-item";

    div.innerHTML = `

        <input type="hidden"
               name="mn_no"
               value="">

        <input type="hidden"
               name="old_mn_img"
               value="">

        메뉴명<br>

        <input type="text"
               name="mn_name">

        <br>

        메뉴 설명<br>

        <textarea name="mn_content"></textarea>

        <br>

        가격<br>

        <input type="number"
               name="mn_price">

        <br>

        메뉴 이미지<br>

        <input type="file"
               name="mn_upload"
               accept="image/*">

        <hr>
    `;

    container.appendChild(div);
}

</script>

</body>
</html>
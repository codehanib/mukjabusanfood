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

    // 새 주소로 좌표 검색
    searchLatLon(roadAddrPart1);
}


/* 주소 → 위도/경도 */
function searchLatLon(address) {

    if (!address || address.trim() === "") {
        alert("주소가 없습니다.");
        return;
    }

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

                    const lat = result[0].y;
                    const lon = result[0].x;

                    document.getElementById("r_lat").value = lat;
                    document.getElementById("r_lon").value = lon;

                    console.log("주소:", address);
                    console.log("위도:", lat);
                    console.log("경도:", lon);

                } else {

                    console.log(
                        "좌표 검색 실패:",
                        address,
                        status
                    );

                    alert(
                        "주소의 위도/경도를 찾지 못했습니다."
                    );
                }
            }
        );
    });
}


/* 수정 직전 좌표 확인 */
/* 수정 전 필수 항목 확인 */
document.restaurantUpdateForm.addEventListener("submit", function(e) {

    // 식당 이름
    const rName = document.querySelector('[name="r_name"]');

    if (!rName.value.trim()) {
        e.preventDefault();
        alert("식당 이름을 입력해주세요.");
        rName.focus();
        return false;
    }

    // 주소
    const rAddr = document.getElementById("r_addr");

    if (!rAddr.value.trim()) {
        e.preventDefault();
        alert("식당 주소를 입력해주세요.");
        return false;
    }

    // 위도 / 경도
    const lat = document.getElementById("r_lat").value;
    const lon = document.getElementById("r_lon").value;

    if (!lat || !lon) {
        e.preventDefault();
        alert("주소 검색 후 좌표가 확인될 때까지 잠시 기다려주세요.");
        return false;
    }

    // 매장 소개
    const rInfo = document.querySelector('[name="r_info"]');

    if (!rInfo.value.trim()) {
        e.preventDefault();
        alert("매장 소개를 입력해주세요.");
        rInfo.focus();
        return false;
    }

    // 영업시간
    const rTime = document.querySelector('[name="r_time"]');

    if (!rTime.value.trim()) {
        e.preventDefault();
        alert("영업시간을 입력해주세요.");
        rTime.focus();
        return false;
    }

    // 휴무일
    const rRest = document.querySelector('[name="r_rest"]');

    if (!rRest.value.trim()) {
        e.preventDefault();
        alert("휴무일을 입력해주세요.");
        rRest.focus();
        return false;
    }

    // 음식종류
    const category = document.querySelector('[name="mukja_c_no"]');

    if (!category.value) {
        e.preventDefault();
        alert("음식종류를 선택해주세요.");
        category.focus();
        return false;
    }

    // 메뉴
    const menuItems = document.querySelectorAll(".menu-item");

    for (let i = 0; i < menuItems.length; i++) {

        const menuName =
            menuItems[i].querySelector('[name="mn_name"]');

        const menuContent =
            menuItems[i].querySelector('[name="mn_content"]');

        const menuPrice =
            menuItems[i].querySelector('[name="mn_price"]');

        const menuUpload =
            menuItems[i].querySelector('[name="mn_upload"]');

        const oldMenuImg =
            menuItems[i].querySelector('[name="old_mn_img"]');

        // 메뉴명
        if (!menuName.value.trim()) {
            e.preventDefault();
            alert((i + 1) + "번째 메뉴명을 입력해주세요.");
            menuName.focus();
            return false;
        }

        // 메뉴 설명
        if (!menuContent.value.trim()) {
            e.preventDefault();
            alert((i + 1) + "번째 메뉴 설명을 입력해주세요.");
            menuContent.focus();
            return false;
        }

        // 메뉴 가격
        if (!menuPrice.value) {
            e.preventDefault();
            alert((i + 1) + "번째 메뉴 가격을 입력해주세요.");
            menuPrice.focus();
            return false;
        }

        // 기존 이미지도 없고 새 이미지도 없는 경우
        if (
            (!oldMenuImg || !oldMenuImg.value.trim()) &&
            (!menuUpload.files || menuUpload.files.length === 0)
        ) {
            e.preventDefault();
            alert((i + 1) + "번째 메뉴 이미지를 등록해주세요.");
            menuUpload.focus();
            return false;
        }
    }

    // 상세 정보
    const rDesc = document.querySelector('[name="r_desc"]');

    if (!rDesc.value.trim()) {
        e.preventDefault();
        alert("상세 정보를 입력해주세요.");
        rDesc.focus();
        return false;
    }
});


/* 메뉴 추가 */
function addMenu() {

    const container =
        document.getElementById("menuContainer");

    const div =
        document.createElement("div");

    div.className = "menu-item";

    div.innerHTML = `
        <input type="hidden" name="mn_no" value="">
        <input type="hidden" name="old_mn_img" value="">

        메뉴명<br>
        <input type="text" name="mn_name" required>
        <br>

        메뉴 설명<br>
        <textarea name="mn_content" required></textarea>
        <br>

        가격<br>
        <input type="number" name="mn_price" required>
        <br>

        메뉴 이미지<br>
        <input type="file" name="mn_upload" accept="image/*" required>
        <hr>
    `;

    container.appendChild(div);
}
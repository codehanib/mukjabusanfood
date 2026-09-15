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

    // 주소 변경 시 기존 좌표 초기화
    document.getElementById("r_lat").value = "";
    document.getElementById("r_lon").value = "";

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

                    console.log("위도:", result[0].y);
                    console.log("경도:", result[0].x);

                } else {

                    document.getElementById("r_lat").value = "";
                    document.getElementById("r_lon").value = "";

                    console.log("좌표 검색 실패:", address, status);

                    alert(
                        "주소의 위도/경도를 찾지 못했습니다."
                    );
                }

            }
        );

    });

}


/* 수정 직전 좌표 확인 */
document.restaurantUpdateForm.addEventListener(
    "submit",
    function(e) {

        const lat =
            document.getElementById("r_lat").value;

        const lon =
            document.getElementById("r_lon").value;

        if (!lat || !lon) {

            e.preventDefault();

            alert(
                "주소 검색 후 좌표가 확인될 때까지 잠시 기다려주세요."
            );

            return false;
        }
    }
);


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
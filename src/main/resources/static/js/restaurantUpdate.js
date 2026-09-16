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
document.restaurantUpdateForm.addEventListener(
    "submit",
    function(e) {

        const lat =
            document.getElementById("r_lat").value;

        const lon =
            document.getElementById("r_lon").value;

        console.log("수정할 위도:", lat);
        console.log("수정할 경도:", lon);

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
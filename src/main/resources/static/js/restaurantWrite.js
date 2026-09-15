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

    document.getElementById("r_lat").value = "";
    document.getElementById("r_lon").value = "";

    searchLatLon(roadAddrPart1);
}

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


// 등록 직전 좌표 확인
document.restaurantWriteForm.addEventListener(
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


function addMenu() {

    const menuArea =
        document.getElementById("menuArea");

    const div =
        document.createElement("div");

    div.className = "menu-item";

    div.innerHTML = `
        메뉴명
        <input type="text" name="mn_name">
        <br>

        메뉴설명
        <textarea name="mn_content"></textarea>
        <br>

        가격
        <input type="number" name="mn_price">
        <br>

        메뉴이미지
        <input type="file" name="mn_upload" accept="image/*">
        <br><br>
    `;

    menuArea.appendChild(div);
}
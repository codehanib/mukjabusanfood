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


// 등록 전 필수 입력값 + 좌표 확인
document.restaurantWriteForm.addEventListener(
    "submit",
    function(e) {

        // 식당 이름
        const rName =
            document.getElementById("r_name").value.trim();

        if (!rName) {
            e.preventDefault();
            alert("식당 이름을 입력해주세요.");
            document.getElementById("r_name").focus();
            return false;
        }


        // 주소
        const address =
            document.getElementById("r_addr").value.trim();

        if (!address) {
            e.preventDefault();
            alert("식당 주소를 검색해주세요.");
            return false;
        }


        // 위도 / 경도
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


        // 식당 대표 이미지
        const rUpload =
            document.getElementById("r_upload");

        if (!rUpload.files ||
            rUpload.files.length === 0) {

            e.preventDefault();
            alert("식당 대표 이미지를 등록해주세요.");
            rUpload.focus();
            return false;
        }


        // 매장 소개
        const rInfo =
            document.getElementById("r_info").value.trim();

        if (!rInfo) {
            e.preventDefault();
            alert("매장 소개를 입력해주세요.");
            document.getElementById("r_info").focus();
            return false;
        }


        // 영업시간
        const rTime =
            document.getElementById("r_time").value.trim();

        if (!rTime) {
            e.preventDefault();
            alert("영업시간을 입력해주세요.");
            document.getElementById("r_time").focus();
            return false;
        }


        // 휴무일
        const rRest =
            document.getElementById("r_rest").value.trim();

        if (!rRest) {
            e.preventDefault();
            alert("휴무일을 입력해주세요.");
            document.getElementById("r_rest").focus();
            return false;
        }


        // 음식 종류
        const category =
            document.getElementById("mukja_c_no").value;

        if (!category) {
            e.preventDefault();
            alert("음식 종류를 선택해주세요.");
            document.getElementById("mukja_c_no").focus();
            return false;
        }


        // 메뉴판 이미지
        const menuBoard =
            document.getElementById("mbi_upload");

        if (!menuBoard.files ||
            menuBoard.files.length === 0) {

            e.preventDefault();
            alert("메뉴판 이미지를 등록해주세요.");
            menuBoard.focus();
            return false;
        }


		// 메뉴 검사

		const menuItems =
		    document.querySelectorAll(".menu-item");

		for (let i = 0; i < menuItems.length; i++) {

		    const menuName =
		        menuItems[i].querySelector('[name="mn_name"]');

		    const menuContent =
		        menuItems[i].querySelector('[name="mn_content"]');

		    const menuPrice =
		        menuItems[i].querySelector('[name="mn_price"]');

		    const menuImage =
		        menuItems[i].querySelector('[name="mn_upload"]');


		    // 메뉴 이름 확인
		    if (!menuName.value.trim()) {
		        e.preventDefault();
		        alert((i + 1) + "번째 메뉴명을 입력해주세요.");
		        menuName.focus();
		        return false;
		    }


		    // 메뉴 설명 확인
		    if (!menuContent.value.trim()) {
		        e.preventDefault();
		        alert((i + 1) + "번째 메뉴 설명을 입력해주세요.");
		        menuContent.focus();
		        return false;
		    }


		    // 메뉴 가격 확인
		    if (!menuPrice.value) {
		        e.preventDefault();
		        alert((i + 1) + "번째 메뉴 가격을 입력해주세요.");
		        menuPrice.focus();
		        return false;
		    }


		    // 메뉴 이미지 확인
		    if (!menuImage.files ||
		        menuImage.files.length === 0) {

		        e.preventDefault();
		        alert((i + 1) + "번째 메뉴 이미지를 등록해주세요.");
		        menuImage.focus();
		        return false;
		    }
		}

        // 상세 정보
        const rDesc =
            document.getElementById("r_desc").value.trim();

        if (!rDesc) {
            e.preventDefault();
            alert("상세 정보를 입력해주세요.");
            document.getElementById("r_desc").focus();
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
        <input type="file"
               name="mn_upload"
               accept="image/*">
        <br><br>
    `;

    menuArea.appendChild(div);
}
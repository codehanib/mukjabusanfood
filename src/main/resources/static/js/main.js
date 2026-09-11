let selectedIndex = -1;

// =============================
// 검색어 입력 → 자동완성
// =============================
$("#keyword").on("input", function () {

    const keyword = $(this).val().trim();

    if (keyword.length < 1) {
        $("#suggestions").empty().hide();
        selectedIndex = -1;
        return;
    }

    $.ajax({
        url: "/autocomplete",
        data: {
            keyword: keyword
        },

        success: function (list) {

            let html = "";

            list.forEach(function (item) {
                html +=
                    "<div class='item'>" +
                    item.highlight +
                    "</div>";
            });

            if (html === "") {
                $("#suggestions").empty().hide();
            } else {
                $("#suggestions").html(html).show();
            }

            selectedIndex = -1;
        },

        error: function () {
            console.log("autocomplete error");
        }
    });
});


// =============================
// ↑ ↓ Enter 키
// =============================
$("#keyword").on("keydown", function (e) {

    const items = $("#suggestions .item");

    // ↓
    if (e.key === "ArrowDown") {

        e.preventDefault();

        if (items.length === 0) {
            return;
        }

        selectedIndex++;

        if (selectedIndex >= items.length) {
            selectedIndex = 0;
        }

        items.removeClass("selected");
        $(items[selectedIndex]).addClass("selected");

        return;
    }

    // ↑
    if (e.key === "ArrowUp") {

        e.preventDefault();

        if (items.length === 0) {
            return;
        }

        selectedIndex--;

        if (selectedIndex < 0) {
            selectedIndex = items.length - 1;
        }

        items.removeClass("selected");
        $(items[selectedIndex]).addClass("selected");

        return;
    }

    // Enter
    if (e.key === "Enter") {

        if (selectedIndex >= 0 && items.length > 0) {

            e.preventDefault();

            const text = $(items[selectedIndex]).text();

            $("#keyword").val(text);
            $("#suggestions").empty().hide();

            selectedIndex = -1;

            $(".search-form")[0].submit();
        }
    }
});


// =============================
// 마우스로 자동완성 선택
// =============================
$(document).on("click", "#suggestions .item", function () {

    $("#keyword").val($(this).text());

    $("#suggestions").empty().hide();

    selectedIndex = -1;
});

$("#popularToggle").on("click", function () {

    $("#popularList").slideToggle(150);

    const arrow = $(".popular-arrow");

    if (arrow.text() === "▼") {
        arrow.text("▲");
    } else {
        arrow.text("▼");
    }
});
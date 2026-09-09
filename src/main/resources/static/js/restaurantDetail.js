document.addEventListener("DOMContentLoaded", function () {

    // ==========================================
    // 식당 상세정보
    // ==========================================

    const rawElement = document.getElementById("rawRestaurantDesc");

    const container = document.getElementById("restaurantDesc");

    if (rawElement && container) {

        const raw = rawElement.value;

        // [제목] 기준으로 분리
        const regex = /\[([^\]]+)\]\s*([\s\S]*?)(?=\[[^\]]+\]|$)/g;

        let match;

        while ((match = regex.exec(raw)) !== null) {

            const title = match[1].trim();

            const content = match[2].trim();

            // 내용 없는 항목은 출력하지 않음
            if (!content) {

                continue;

            }

            const item = document.createElement("div");

            item.className = "info-item";

            const titleElement = document.createElement("div");

            titleElement.className = "info-title";

            titleElement.textContent = title;

            const contentElement = document.createElement("div");

            contentElement.className = "info-content";

            // 주차안내
            if (title === "주차안내") {

                contentElement.textContent =
                    content.replace(/(?<!\d)([.!?)])\s+/g, "$1\n");

            }

            // 홈페이지
            else if (title === "홈페이지") {

                const link = document.createElement("a");

                link.href = content;

                link.textContent = content;

                link.target = "_blank";

                contentElement.appendChild(link);

            }

            // 나머지 상세정보
            else {

                contentElement.textContent = content;

            }

            item.appendChild(titleElement);

            item.appendChild(contentElement);

            container.appendChild(item);

        }

    }



    // ==========================================
    // 영업시간
    // ==========================================

    const source = document.getElementById("businessHoursSource");

    const todayElement = document.getElementById("todayBusinessHours");

    const allElement = document.getElementById("businessHoursAll");

    if (source && todayElement && allElement) {

        const days = ["일", "월", "화", "수", "목", "금", "토"];

        const today = days[new Date().getDay()];

        const lines = source.innerHTML.split("<br>");

        const todayLines = [];

        const otherLines = [];

        const firstText = lines[0]
            .replace(/&nbsp;/g, " ")
            .trim();

        if (firstText.startsWith("매일")) {

            todayElement.innerHTML = lines.join("<br>");

            allElement.innerHTML = "";

        } else {

            let isToday = false;

            lines.forEach(function (line) {

                const text = line.replace(/&nbsp;/g, " ").trim();

                if (/^[월화수목금토일]/.test(text)) {

                    isToday = text.startsWith(today);

                }

                if (isToday) {

                    todayLines.push(line);

                } else {

                    otherLines.push(line);

                }

            });

            todayElement.innerHTML = todayLines.join("<br>");

            allElement.innerHTML = otherLines.join("<br>");

        }

    }

});



// 영업시간 펼치기 / 접기
function toggleBusinessHours() {

    const all = document.getElementById("businessHoursAll");

    const arrow = document.getElementById("hoursArrow");

    if (!all || !arrow) {

        return;

    }

    if (all.style.display === "block") {

        all.style.display = "none";

        arrow.textContent = "⌄";

    } else {

        all.style.display = "block";

        arrow.textContent = "⌃";

    }

}
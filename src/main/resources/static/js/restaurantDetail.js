document.addEventListener("DOMContentLoaded", function () {

    // ==========================================
    // 식당 상세정보
    // ==========================================
    const rawElement = document.getElementById("rawRestaurantDesc");
    const container = document.getElementById("restaurantDesc");

    if (rawElement && container) {

        const raw = rawElement.value.trim();

        // 기존 데이터: [제목] 다음 줄 내용
        if (raw.includes("[")) {

            const regex = /\[([^\]]+)\]\s*([\s\S]*?)(?=\[[^\]]+\]|$)/g;
            let match;

            while ((match = regex.exec(raw)) !== null) {

                const title = match[1].trim();
                const content = match[2].trim();

                if (!content) continue;

                createInfoItem(title, content);
            }

        } else {

            // 새 데이터: 제목: 내용
            const lines = raw.split(/\r?\n/);

            lines.forEach(function(line) {

                line = line.trim();

                if (!line) return;

                const colonIndex = line.indexOf(":");

                if (colonIndex === -1) return;

                const title = line.substring(0, colonIndex).trim();
                const content = line.substring(colonIndex + 1).trim();

                if (!content) return;

                createInfoItem(title, content);
            });
        }

        function createInfoItem(title, content) {

            const item = document.createElement("div");
            item.className = "info-item";

            const titleElement = document.createElement("div");
            titleElement.className = "info-title";
            titleElement.textContent = title;

            const contentElement = document.createElement("div");
            contentElement.className = "info-content";

            if (title === "홈페이지") {

                const link = document.createElement("a");

                link.href = content;
                link.textContent = content;
                link.target = "_blank";

                contentElement.appendChild(link);

            } else {

                contentElement.textContent = content;
            }

            item.appendChild(titleElement);
            item.appendChild(contentElement);

            container.appendChild(item);
        }
		const detailSection = document.getElementById("detailInfoSection");

		if (detailSection && container.children.length > 0) {
		    detailSection.style.display = "block";
		}
    }



    // ==========================================
    // 영업시간
    // ==========================================
    const source = document.getElementById("businessHoursSource");
    const todayElement = document.getElementById("todayBusinessHours");
    const allElement = document.getElementById("businessHoursAll");
    const summaryElement = document.querySelector(".business-hours-summary");

    if (source && todayElement && allElement) {

        let sourceText = source.innerText.trim();

        // 영업시간 없는 경우
        if (
            !sourceText ||
            sourceText.toLowerCase().includes("영업시간 정보 없음") ||
            sourceText.toLowerCase().includes("nan")
        ) {

            if (summaryElement) {
                summaryElement.style.display = "none";
            }

            allElement.style.display = "none";
            return;
        }


        const days = ["일", "월", "화", "수", "목", "금", "토"];
        const todayIndex = new Date().getDay();
        const today = days[todayIndex];


        // ==========================================
        // 공백 및 기존 데이터 기호 정리
        // ==========================================
        sourceText = sourceText
            .replace(/\u00a0/g, " ")
            .replace(/·/g, " ")
            .replace(/\s+/g, " ")
            .trim();


        // ==========================================
        // 매일 영업
        // ==========================================
		if (sourceText.startsWith("매일")) {

		    // 맨 앞의 "매일" 제거
		    const dailyText = sourceText
		        .replace(/^매일\s*/, "")
		        .trim();

		    // 중간에 다시 나오는 "매일"을 기준으로 분리
		    const dailyParts = dailyText
		        .split(/\s+매일\s+/)
		        .map(function(text) {
		            return text.trim();
		        })
		        .filter(function(text) {
		            return text !== "";
		        });

		    const dailyContents = dailyParts.map(function(content, index) {

		        // 첫 번째 영업시간
		        if (index === 0) {
		            return content;
		        }

		        // 두 번째부터 들여쓰기
		        return '<span style="display:inline-block; padding-left:30px;">'
		            + content +
		            '</span>';

		    }).join("<br>");

		    todayElement.innerHTML =
		        "<strong>매일</strong> " + dailyContents;

		    allElement.innerHTML = "";

		} else {

            // ==========================================
            // 요일 단위로 분리
            // ==========================================
			const parts = sourceText
			    .replace(
			        /([월화수목금토일])(?=\s*(?:점심|저녁|오전|오후|새벽|\d{1,2}:\d{2}|\d{1,2}\/\d{1,2}|휴무|휴무일|영업))/g,
			        "\n$1"
			    )
                .split("\n")
                .map(function(text) {
                    return text.trim();
                })
                .filter(function(text) {
                    return text !== "";
                });


            const dayData = {};
            let currentDay = null;


            parts.forEach(function(text) {

                const match = text.match(/^([월화수목금토일])\s*(.*)$/);

                if (!match) {
                    return;
                }

				const foundDay = match[1];

				let content = match[2].trim();

				content = content
				    .replace(/^월\s+/, "")
				    .trim();


                /*
                 * 기존 크롤링 데이터 보정
                 *
                 * 예:
                 * 수 점심 11:30 ~ 15:00
                 * 월 점심 13:45 까지 라스트오더
                 * 월 저녁 17:00 ~ 22:00
                 *
                 * 수요일 다음에 잘못 들어간 "월"은
                 * 실제 월요일이 아니라 수요일의 추가 정보로 처리
                 */
				if (
				    foundDay === "월" &&
				    currentDay !== null &&
				    currentDay !== "월"
				) {

				    if (!dayData[currentDay]) {
				        dayData[currentDay] = [];
				    }

				    if (content) {

				        // 잘못 반복된 "월"은 빼고 현재 요일의 추가 내용으로 넣음
				        dayData[currentDay].push(content);
				    }

				    return;
				}


                // 새로운 요일
                currentDay = foundDay;

                if (!dayData[currentDay]) {
                    dayData[currentDay] = [];
                }

                if (content) {
                    dayData[currentDay].push(content);
                }
            });


			// ==========================================
			// 오늘 영업시간
			// ==========================================
			if (
			    dayData[today] &&
			    dayData[today].length > 0
			) {

			    const todayContents = dayData[today].map(function(content, index) {

			        // 첫 번째 줄은 들여쓰기 없음
			        if (index === 0) {
			            return content;
			        }

			        // 두 번째 줄부터 들여쓰기
			        return '<span style="display:inline-block; padding-left:30px;">'
			            + content +
			            '</span>';

			    }).join("<br>");

			    todayElement.innerHTML =
			        "<strong>" + today + "</strong> " +
			        todayContents;

			} else {

			    todayElement.textContent =
			        "오늘 영업시간 정보 없음";
			}

            // ==========================================
            // 나머지 요일
            // ==========================================
            const orderedLines = [];

            for (let i = 1; i < 7; i++) {

                const day =
                    days[(todayIndex + i) % 7];

                if (
                    dayData[day] &&
                    dayData[day].length > 0
                ) {

					const contents = dayData[day].map(function(content, index) {

					    // 첫 번째 줄은 들여쓰기 X
					    if (index === 0) {
					        return content;
					    }

					    // 두 번째 줄부터 들여쓰기
					    return '<span class="sub-time">' + content + '</span>';

					}).join("<br>");

					orderedLines.push(
					    "<strong>" + day + "</strong> " + contents
					);
                }
            }

            allElement.innerHTML =
                orderedLines.join("<br>");
        }
    }

});



// 영업시간 펼치기 / 접기
function toggleBusinessHours() {

    const all =
        document.getElementById("businessHoursAll");

    const arrow =
        document.getElementById("hoursArrow");

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
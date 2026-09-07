package com.springboot.MUKJA.service;

import org.springframework.stereotype.Service;

@Service
public class RestaurantService {

    public String formatRestaurantTime(String rTime) {

        // 영업시간이 없는 경우
        if (rTime == null
                || rTime.trim().isEmpty()
                || rTime.toLowerCase().contains("nan")) {

            return "영업시간 정보 없음";
        }

        // 공백 정리
        rTime = rTime.replaceAll("\\s+", " ").trim();

        // -------------------------------------------------
        // "매일·" 보호
        // 매일의 '일'을 일요일로 인식하지 않도록 임시 변경
        // -------------------------------------------------
        rTime = rTime.replace("매일·", "__DAILY__");

        String[] days = {"월", "화", "수", "목", "금", "토", "일"};

        StringBuilder result = new StringBuilder();

        // -------------------------------------------------
        // 요일별 처리
        // -------------------------------------------------
        for (int i = 0; i < days.length; i++) {

            String day = days[i];

            int start = rTime.indexOf(day + "·");

            if (start == -1) {
                continue;
            }

            int end = rTime.length();

            // 다음 요일 위치 찾기
            for (int j = i + 1; j < days.length; j++) {

                int next = rTime.indexOf(
                    days[j] + "·",
                    start + 2
                );

                if (next != -1 && next < end) {
                    end = next;
                }
            }

            String dayText = rTime
                    .substring(start + 2, end)
                    .trim();

            // -------------------------------------------------
            // 같은 내용 안에서 반복되는 요일 제거
            // -------------------------------------------------
            dayText = dayText.replaceAll(
                "(월|화|수|목|금|토|일)·",
                ""
            );

            // 보호했던 매일 복구
            dayText = dayText.replace(
                "__DAILY__",
                "매일·"
            );

            // -------------------------------------------------
            // 점심 / 저녁
            // -------------------------------------------------
            dayText = dayText
                .replace(
                    "점심·",
                    "점심&nbsp;&nbsp;"
                )
                .replace(
                    "저녁·",
                    "저녁&nbsp;&nbsp;"
                );

            // -------------------------------------------------
            // 브레이크 타임
            // 15:00 ~ 17:00·브레이크 타임
            // -------------------------------------------------
            dayText = dayText.replaceAll(
                "(\\d{1,2}:\\d{2}\\s*~\\s*(?:새벽\\s*)?\\d{1,2}:\\d{2})\\s*·?\\s*브레이크\\s*타임",
                "<br>&nbsp;&nbsp;&nbsp;&nbsp;$1&nbsp;&nbsp;브레이크 타임"
            );

            // -------------------------------------------------
            // 라스트오더 앞에 반복되는 매일 제거
            // -------------------------------------------------
            dayText = dayText.replaceAll(
                "매일·(?=(?:새벽\\s*)?\\d{1,2}:\\d{2}\\s*까지\\s*라스트오더)",
                ""
            );

            // -------------------------------------------------
            // 라스트오더
            // 23:30 까지 라스트오더
            // -------------------------------------------------
            dayText = dayText.replaceAll(
                "((?:새벽\\s*)?\\d{1,2}:\\d{2})\\s*까지\\s*라스트오더",
                "<br>&nbsp;&nbsp;&nbsp;&nbsp;$1 까지 라스트오더"
            );

            // -------------------------------------------------
            // 혹시 '매'만 남은 경우 제거
            // -------------------------------------------------
            dayText = dayText.replaceAll(
                "\\s+매\\s*(?=<br>)",
                ""
            );

            // 남은 · 제거
            dayText = dayText.replace(
                "·",
                " "
            );

            // 여러 공백 정리
            dayText = dayText
                    .replaceAll(" {2,}", " ")
                    .trim();

            // <br> 뒤 일반 공백 제거
            dayText = dayText.replaceAll(
                "<br>\\s*",
                "<br>"
            );

            // 요일 사이 한 줄 띄우기
            if (result.length() > 0) {
                result.append("<br>");
            }

            result.append(day)
                  .append("&nbsp;&nbsp;")
                  .append(dayText);
        }


        // -------------------------------------------------
        // 요일 없이 "매일"만 존재하는 경우
        // -------------------------------------------------
        if (result.length() == 0
                && rTime.contains("__DAILY__")) {

            String daily = rTime.replace(
                "__DAILY__",
                ""
            );

            // 점심 / 저녁
            daily = daily
                .replace(
                    "점심·",
                    "점심&nbsp;&nbsp;"
                )
                .replace(
                    "저녁·",
                    "저녁&nbsp;&nbsp;"
                );

            // 브레이크 타임
            daily = daily.replaceAll(
                "(\\d{1,2}:\\d{2}\\s*~\\s*(?:새벽\\s*)?\\d{1,2}:\\d{2})\\s*·?\\s*브레이크\\s*타임",
                "<br>&nbsp;&nbsp;&nbsp;&nbsp;$1&nbsp;&nbsp;브레이크 타임"
            );

            // 혹시 남아있는 매일 제거
            daily = daily.replace(
                "__DAILY__",
                ""
            );

            // 라스트오더
            daily = daily.replaceAll(
                "((?:새벽\\s*)?\\d{1,2}:\\d{2})\\s*까지\\s*라스트오더",
                "<br>&nbsp;&nbsp;&nbsp;&nbsp;$1 까지 라스트오더"
            );

            // 남은 · 제거
            daily = daily.replace(
                "·",
                " "
            );

            daily = daily
                    .replaceAll(" {2,}", " ")
                    .trim();

            daily = daily.replaceAll(
                "<br>\\s*",
                "<br>"
            );

            result.append("매일&nbsp;&nbsp;")
                  .append(daily);
        }


        // -------------------------------------------------
        // 위 조건에 해당하지 않는 특이한 데이터
        // -------------------------------------------------
        if (result.length() == 0) {

            rTime = rTime
                .replace(
                    "__DAILY__",
                    "매일·"
                )
                .replace(
                    "·",
                    " "
                );

            return rTime;
        }

        return result.toString();
    }
}

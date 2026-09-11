package com.springboot.MUKJA.service;

import java.io.File;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.springboot.MUKJA.dao.restaurantDAO;
import com.springboot.MUKJA.dao.usersDAO;
import com.springboot.MUKJA.dto.menuDTO;
import com.springboot.MUKJA.dto.restaurantDTO;
import com.springboot.MUKJA.dto.usersDTO;

@Service
public class RestaurantService {
	
	@Autowired
	private restaurantDAO restaurantdao;

	@Autowired
	private RestaurantESService restaurantESService;
	
	@Autowired
	private usersDAO usersdao;
	
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
    
    // 상세페이지용 영업시간
    public String formatRestaurantDetailTime(String rTime) {

        if (rTime == null
                || rTime.trim().isEmpty()
                || rTime.toLowerCase().contains("nan")) {

            return "영업시간 정보 없음";
        }

        // 공백 정리
        rTime = rTime.replaceAll("\\s+", " ").trim();

        // ★ 여기로 이동
        rTime = rTime.replace("매일·", "__DAILY__");

        // ★ 반복된 매일 제거
        rTime = rTime.replaceAll(
            "\\s*__DAILY__(?=(?:새벽\\s*)?\\d{1,2}:\\d{2}\\s*·?\\s*(?:까지\\s*)?라스트오더)",
            " "
        );
        
        // 브레이크 타임 앞 요일 제거
        rTime = rTime.replaceAll(
            "(월|화|수|목|금|토|일)·(?=\\d{1,2}:\\d{2}\\s*~\\s*(?:새벽\\s*)?\\d{1,2}:\\d{2}\\s*·?\\s*브레이크\\s*타임)",
            ""
        );
        
        // 여러 시간 앞 잘못 붙은 요일 제거
        rTime = rTime.replaceAll(
        	    "(월|화|수|목|금|토|일)·(?=\\d{1,2}:\\d{2}\\s*,)",
        	    ""
        	);
        
        // 라스트오더 앞에 붙어 있는 요일 제거
        // 예: 월·20:30·라스트오더 → 20:30·라스트오더
        rTime = rTime.replaceAll(
            "(월|화|수|목|금|토|일)·(?=(?:새벽\\s*)?\\d{1,2}:\\d{2}\\s*·?\\s*(?:까지\\s*)?라스트오더)",
            ""
        );

        // 브레이크타임 줄바꿈
        rTime = rTime.replaceAll(
            "(\\d{1,2}:\\d{2}\\s*~\\s*(?:새벽\\s*)?\\d{1,2}:\\d{2})\\s*·?\\s*브레이크\\s*타임",
            "<br>&nbsp;&nbsp;&nbsp;&nbsp;$1&nbsp;&nbsp;브레이크 타임"
        );

        // 여러 시간 라스트오더 줄바꿈
        rTime = rTime.replaceAll(
            "(\\d{1,2}:\\d{2}\\s*,\\s*(?:새벽\\s*)?\\d{1,2}:\\d{2})\\s*·\\s*라스트오더",
            "<br>&nbsp;&nbsp;&nbsp;&nbsp;$1&nbsp;&nbsp;라스트오더"
        );

        // 일반 라스트오더 줄바꿈
        rTime = rTime.replaceAll(
            "((?:새벽\\s*)?\\d{1,2}:\\d{2})\\s*·\\s*라스트오더",
            "<br>&nbsp;&nbsp;&nbsp;&nbsp;$1&nbsp;&nbsp;라스트오더"
        );

        // 다음 요일 앞에서 줄바꿈
        rTime = rTime.replaceAll(
            "\\s+(?=(월|화|수|목|금|토|일)·)",
            "<br>"
        );
        
        // 요일 뒤 · 제거
        rTime = rTime.replaceAll(
            "(월|화|수|목|금|토|일)·",
            "$1&nbsp;&nbsp;"
        );

        // 남은 · 제거
        rTime = rTime.replace("·", " ");
        
        // 매일 복원
        rTime = rTime.replace("__DAILY__", "매일&nbsp;&nbsp;");
        
        return rTime;
    }
    
 // 오늘 요일의 영업시간만 가져오기
    public String getTodayRestaurantTime(String rTime) {

        if (rTime == null
                || rTime.trim().isEmpty()
                || rTime.toLowerCase().contains("nan")) {
            return "영업시간 정보 없음";
        }

        // 오늘 요일 구하기
        String[] days = {"월", "화", "수", "목", "금", "토", "일"};

        int dayIndex = java.time.LocalDate.now()
                .getDayOfWeek()
                .getValue() - 1;

        String today = days[dayIndex];

        // 상세페이지용으로 먼저 가공
        String formatted = formatRestaurantDetailTime(rTime);

        // 오늘 요일 시작 위치
        String marker = today + "&nbsp;&nbsp;";

        int start = formatted.indexOf(marker);

        if (start == -1) {
            return "오늘 영업시간 정보 없음";
        }

        // 다음 요일 위치 찾기
        int end = formatted.length();

        for (String day : days) {

            String nextMarker = "<br>" + day + "&nbsp;&nbsp;";
            int next = formatted.indexOf(nextMarker, start + marker.length());

            if (next != -1 && next < end) {
                end = next;
            }
        }

        return formatted.substring(start, end);
    }
    
 // =====================================================
 // 식당 정보 수정
 // =====================================================
 public void updateRestaurant(
         restaurantDTO dto,
         String oldRImg,
         MultipartFile restaurantFile,
         List<String> mnNoList,
         List<String> mnNameList,
         List<String> mnContentList,
         List<String> mnPriceList,
         List<String> oldMnImgList,
         List<MultipartFile> mnUploadList,
         List<Integer> deleteMbiNoList,
         List<MultipartFile> mbiUploadList
 ) throws Exception {

     // 1. 식당 대표 이미지
     updateRestaurantImage(
             dto,
             oldRImg,
             restaurantFile
     );

     // 2. 식당 기본정보 수정
     restaurantdao.restaurantUpdate(dto);

     // 3. 메뉴 수정 / 추가
     updateMenus(
             dto.getR_no(),
             mnNoList,
             mnNameList,
             mnContentList,
             mnPriceList,
             oldMnImgList,
             mnUploadList
     );

     // 4. 기존 메뉴판 이미지 삭제
     deleteMenuBoardImages(
             deleteMbiNoList
     );

     // 5. 새 메뉴판 이미지 추가
     addMenuBoardImages(
             dto.getR_no(),
             mbiUploadList
     );

     // 6. Elasticsearch 갱신
     restaurantDTO updatedRestaurant =
             restaurantdao.restaurantDetail(
                     dto.getR_no()
             );

     restaurantESService.save(
             updatedRestaurant
     );
 }


 // =====================================================
 // 식당 대표 이미지 수정
 // =====================================================
 private void updateRestaurantImage(
         restaurantDTO dto,
         String oldRImg,
         MultipartFile file
 ) throws Exception {

     // 새 이미지 선택
     if (file != null && !file.isEmpty()) {

         String fileName =
                 file.getOriginalFilename();

         File saveFile =
                 new File(
                         "C:/upload/" +
                         fileName
                 );

         file.transferTo(saveFile);

         dto.setR_img(fileName);

     } else {

         // 새 이미지를 선택하지 않으면 기존 이미지 유지
         dto.setR_img(oldRImg);
     }
 }


 // =====================================================
 // 메뉴 수정 / 추가
 // =====================================================
 private void updateMenus(
         int rNo,
         List<String> mnNoList,
         List<String> mnNameList,
         List<String> mnContentList,
         List<String> mnPriceList,
         List<String> oldMnImgList,
         List<MultipartFile> mnUploadList
 ) throws Exception {

     if (mnNameList == null) {
         return;
     }

     for (int i = 0; i < mnNameList.size(); i++) {

         String mnName =
                 mnNameList.get(i);

         // 메뉴명이 없으면 저장하지 않음
         if (mnName == null ||
             mnName.trim().isEmpty()) {

             continue;
         }

         menuDTO menu =
                 new menuDTO();

         menu.setR_no(rNo);
         menu.setMn_name(mnName);


         // -------------------------
         // 메뉴 설명
         // -------------------------
         if (mnContentList != null &&
             i < mnContentList.size()) {

             menu.setMn_content(
                     mnContentList.get(i)
             );
         }


         // -------------------------
         // 메뉴 가격
         // -------------------------
         if (mnPriceList != null &&
             i < mnPriceList.size()) {

             String price =
                     mnPriceList.get(i);

             if (price != null &&
                 !price.trim().isEmpty()) {

                 menu.setMn_price(
                         Integer.parseInt(price)
                 );
             }
         }


         // -------------------------
         // 기존 메뉴 이미지
         // -------------------------
         String menuImg = null;

         if (oldMnImgList != null &&
             i < oldMnImgList.size()) {

             menuImg =
                     oldMnImgList.get(i);
         }


         // -------------------------
         // 새 메뉴 이미지
         // -------------------------
         if (mnUploadList != null &&
             i < mnUploadList.size()) {

             MultipartFile menuFile =
                     mnUploadList.get(i);

             if (menuFile != null &&
                 !menuFile.isEmpty()) {

                 String fileName =
                         menuFile.getOriginalFilename();

                 File saveFile =
                         new File(
                                 "C:/upload/" +
                                 fileName
                         );

                 menuFile.transferTo(saveFile);

                 // 새 이미지로 변경
                 menuImg = fileName;
             }
         }

         menu.setMn_img(menuImg);


         // -------------------------
         // 기존 메뉴 / 새 메뉴 구분
         // -------------------------
         String mnNo = null;

         if (mnNoList != null &&
             i < mnNoList.size()) {

             mnNo =
                     mnNoList.get(i);
         }


         if (mnNo != null &&
             !mnNo.trim().isEmpty()) {

             // 기존 메뉴 수정
             menu.setMn_no(
                     Integer.parseInt(mnNo)
             );

             restaurantdao.menuUpdate(menu);

         } else {

             // 새 메뉴 등록
             restaurantdao.menuInsert(menu);
         }
     }
 }


 // =====================================================
 // 메뉴판 이미지 추가
 // =====================================================
 private void addMenuBoardImages(
         int rNo,
         List<MultipartFile> mbiUploadList
 ) throws Exception {

     if (mbiUploadList == null) {
         return;
     }

     for (MultipartFile file :
             mbiUploadList) {

         if (file == null ||
             file.isEmpty()) {

             continue;
         }

         String fileName =
                 file.getOriginalFilename();

         File saveFile =
                 new File(
                         "C:/upload/" +
                         fileName
                 );

         file.transferTo(saveFile);


         restaurantDTO mbiDto =
                 new restaurantDTO();

         mbiDto.setR_no(rNo);
         mbiDto.setMbi_img(fileName);

         restaurantdao
                 .menuBoardImageInsert(
                         mbiDto
                 );
     }
 }
 
//=====================================================
//식당 등록
//=====================================================
public void insertRestaurant(
      restaurantDTO dto,
      MultipartFile restaurantFile,
      List<String> mnNameList,
      List<String> mnContentList,
      List<Integer> mnPriceList,
      List<MultipartFile> mnUploadList,
      List<MultipartFile> mbiUploadList,
      String userId
) throws Exception {

  // 1. 식당 대표 이미지 저장
  saveRestaurantImage(dto, restaurantFile);

  // 2. 식당 DB 저장
  restaurantdao.restaurantInsert(dto);

  int rNo = dto.getR_no();

  // 3. 메뉴 저장
  insertMenus(
          rNo,
          mnNameList,
          mnContentList,
          mnPriceList,
          mnUploadList
  );

  // 4. 메뉴판 이미지 저장
  insertMenuBoardImages(
          rNo,
          mbiUploadList
  );

  // 5. OWNER와 식당 연결
  usersDTO user =
          usersdao.findById(userId);

  user.setR_no(rNo);

  usersdao.usersRestaurantUpdate(user);

  // 6. DB에서 다시 조회
  restaurantDTO savedRestaurant =
          restaurantdao.restaurantDetail(rNo);

  // 7. Elasticsearch 저장
  restaurantESService.save(savedRestaurant);
	}
    
//=====================================================
//식당 대표 이미지 저장
//=====================================================
private void saveRestaurantImage(
     restaurantDTO dto,
     MultipartFile file
) throws Exception {

 if (file == null || file.isEmpty()) {
     return;
 }

 String fileName =
         file.getOriginalFilename();

 File saveFile =
         new File(
                 "C:/upload/" +
                 fileName
         );

 file.transferTo(saveFile);

 dto.setR_img(fileName);
}
//=====================================================
//메뉴 등록
//=====================================================
private void insertMenus(
     int rNo,
     List<String> mnNameList,
     List<String> mnContentList,
     List<Integer> mnPriceList,
     List<MultipartFile> mnUploadList
) throws Exception {

 if (mnNameList == null) {
     return;
 }

 for (int i = 0; i < mnNameList.size(); i++) {

     String mnName =
             mnNameList.get(i);

     // 메뉴명이 비어 있으면 등록하지 않음
     if (mnName == null ||
         mnName.trim().isEmpty()) {

         continue;
     }

     menuDTO menu =
             new menuDTO();

     menu.setR_no(rNo);
     menu.setMn_name(mnName);


     // 메뉴 설명
     if (mnContentList != null &&
         i < mnContentList.size()) {

         menu.setMn_content(
                 mnContentList.get(i)
         );
     }


     // 메뉴 가격
     if (mnPriceList != null &&
         i < mnPriceList.size() &&
         mnPriceList.get(i) != null) {

         menu.setMn_price(
                 mnPriceList.get(i)
         );
     }


     // 메뉴 이미지
     if (mnUploadList != null &&
         i < mnUploadList.size()) {

         MultipartFile menuFile =
                 mnUploadList.get(i);

         if (menuFile != null &&
             !menuFile.isEmpty()) {

             String fileName =
                     menuFile.getOriginalFilename();

             File saveFile =
                     new File(
                             "C:/upload/" +
                             fileName
                     );

             menuFile.transferTo(saveFile);

             menu.setMn_img(fileName);
         }
     }

     restaurantdao.menuInsert(menu);
 }
}
//=====================================================
//메뉴판 이미지 등록
//=====================================================
private void insertMenuBoardImages(
     int rNo,
     List<MultipartFile> mbiUploadList
) throws Exception {

 if (mbiUploadList == null) {
     return;
 }

 for (MultipartFile file :
         mbiUploadList) {

     if (file == null ||
         file.isEmpty()) {

         continue;
     }

     String fileName =
             file.getOriginalFilename();

     File saveFile =
             new File(
                     "C:/upload/" +
                     fileName
             );

     file.transferTo(saveFile);

     restaurantDTO menuBoard =
             new restaurantDTO();

     menuBoard.setR_no(rNo);
     menuBoard.setMbi_img(fileName);

     restaurantdao
             .menuBoardImageInsert(
                     menuBoard
             );
 }
}
private void deleteMenuBoardImages(
        List<Integer> deleteMbiNoList
) {

    if (deleteMbiNoList == null) {
        return;
    }

    for (Integer mbiNo : deleteMbiNoList) {

        if (mbiNo == null) {
            continue;
        }

        restaurantdao.menuBoardImageDelete(mbiNo);
    }
}
}

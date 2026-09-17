package com.springboot.MUKJA.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.elasticsearch.action.bulk.BulkRequest;
import org.elasticsearch.action.bulk.BulkResponse;
import org.elasticsearch.action.index.IndexRequest;
import org.elasticsearch.client.RequestOptions;
import org.elasticsearch.client.RestHighLevelClient;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.springboot.MUKJA.dao.IMukjaDeliveryESDAO;
import com.springboot.MUKJA.dao.IMukjaPaymentESDAO;
import com.springboot.MUKJA.dao.IMukjaReservationESDAO;
// --- ES DAO 및 DTO ---
import com.springboot.MUKJA.dao.IMukjaRestaurantESDAO;
import com.springboot.MUKJA.dao.IMukjaReviewESDAO;
import com.springboot.MUKJA.dao.IdeliveryDAO;
import com.springboot.MUKJA.dao.mukjaSearchDAO;
import com.springboot.MUKJA.dao.paymentDAO;
import com.springboot.MUKJA.dao.reservationDAO;
// --- 기존 오라클 DB DAO 및 DTO ---
import com.springboot.MUKJA.dao.restaurantDAO;
import com.springboot.MUKJA.dao.reviewDAO;
import com.springboot.MUKJA.dto.MukjaDeliveryESDTO;
import com.springboot.MUKJA.dto.MukjaPaymentESDTO;
import com.springboot.MUKJA.dto.MukjaRestaurantESDTO;
import com.springboot.MUKJA.dto.deliveryDTO;
import com.springboot.MUKJA.dto.mukjaSearchDTO;
import com.springboot.MUKJA.dto.paymentDTO;
import com.springboot.MUKJA.dto.restaurantDTO;

@RestController
@RequestMapping("/es")
public class ElasticSyncController {

    // 1. 식당
    @Autowired private restaurantDAO restaurantDao;
    @Autowired private IMukjaRestaurantESDAO mukjaRestaurantESDao;

    // 2. 배달
    @Autowired private IdeliveryDAO deliveryDao;
    @Autowired private IMukjaDeliveryESDAO mukjaDeliveryESDao;

    // 3. 예약
    @Autowired private reservationDAO reservationDao;
    @Autowired private IMukjaReservationESDAO mukjaReservationESDao;

    // 4. 결제
    @Autowired private paymentDAO paymentDao;
    @Autowired private IMukjaPaymentESDAO mukjaPaymentESDao;

    // 5. 리뷰
    @Autowired private reviewDAO reviewDao;
    @Autowired private IMukjaReviewESDAO mukjaReviewESDao;

    // 6. 검색어
    @Autowired private mukjaSearchDAO mukjaSearchDao;
    
    @Autowired
    private RestHighLevelClient client;


    // ========================================================
    // 1. 식당 데이터 동기화
    // ========================================================
    @GetMapping("/sync/restaurants")
    public String syncRestaurants() {
    	
    	// 기존 db의 dto정보 불러오기
        List<restaurantDTO> oracleList = restaurantDao.restaurantListAll();
        List<MukjaRestaurantESDTO> esList = new ArrayList<>();
        
        // db의 dto를 엘라스틱서치dto형식으로 변환
        for (restaurantDTO dto : oracleList) {
            MukjaRestaurantESDTO esDto = MukjaRestaurantESDTO.builder()
                    .r_no(dto.getR_no())
                    .r_name(dto.getR_name())
                    .r_addr(dto.getR_addr())
                    .r_region(dto.getR_region())
                    .r_lat((float) dto.getR_lat())
                    .r_lon((float) dto.getR_lon())
                    .r_point((float) dto.getR_point())
                    .mukja_c_no(dto.getMukja_c_no())
                    .mukja_c_name(dto.getMukja_c_name())
                    .r_avg_price(dto.getMn_price())
                    .location(dto.getR_lat() + "," + dto.getR_lon())
                    .build();
            esList.add(esDto);
        }
        
        //엘라스틱서치 인덱스에 정보 저장
        mukjaRestaurantESDao.saveAll(esList);
        return "식당 데이터 " + esList.size() + "건 전송 완료!";
    }

    // ========================================================
    // 2. 배달 데이터 동기화
    // ========================================================
    @GetMapping("/sync/deliveries")
    public String syncDeliveries() {
        List<deliveryDTO> oracleList = deliveryDao.selectOrderList();
        List<MukjaDeliveryESDTO> esList = new ArrayList<>();

        for (deliveryDTO dto : oracleList) {
            MukjaDeliveryESDTO esDto = MukjaDeliveryESDTO.builder()
                    .d_no(dto.getD_no())
                    .r_no(dto.getR_no())
                    .r_name(dto.getR_name())
                    .user_id(dto.getU_name()) // u_name 또는 String.valueOf(dto.getU_no())
                    .d_status(dto.getD_stats()) // d_status ➔ d_stats
                    .d_price(dto.getD_total_price()) // d_price ➔ d_total_price
                    .d_date(dto.getD_reg_date() != null ? dto.getD_reg_date().toString() : null) // Date ➔ String 변환
                    .r_region(null) // deliveryDTO에 r_region이 없어 null 처리
                    .build();
            esList.add(esDto);
        }
        mukjaDeliveryESDao.saveAll(esList);
        return "배달 데이터 " + esList.size() + "건 전송 완료!";
    }

    // ========================================================
    // 3. 결제 데이터 동기화
    // ========================================================
    @GetMapping("/sync/payments")
    public String syncPayments() {
        List<paymentDTO> oracleList = paymentDao.paymentList();
        List<MukjaPaymentESDTO> esList = new ArrayList<>();

        for (paymentDTO dto : oracleList) {
            MukjaPaymentESDTO esDto = MukjaPaymentESDTO.builder()
                    .p_no(dto.getPy_no()) // p_no ➔ py_no
                    .user_id(null) // paymentDTO에 유저 정보가 없어서 null 처리
                    .p_method(dto.getPy_type()) // p_method ➔ py_type
                    .p_amount(dto.getPy_price()) // p_amount ➔ py_price
                    .p_status(dto.getPy_stats()) // p_status ➔ py_stats
                    .p_date(dto.getPy_reg_date() != null ? dto.getPy_reg_date().toString() : null) // Date ➔ String 변환
                    .build();
            esList.add(esDto);
        }
        mukjaPaymentESDao.saveAll(esList);
        return "결제 데이터 " + esList.size() + "건 전송 완료!";
    }
    // ========================================================
    //  4. 전체 인덱스 한 번에 동기화
    // ========================================================
    @GetMapping("/sync/all")
    public String syncAll() throws Exception {

        String msg1 = syncRestaurants();
        String msg2 = syncDeliveries();
        String msg3 = syncPayments();
        String msg4 = syncSearch();

        return String.format(
            "=== 전체 동기화 완료 ===<br>%s<br>%s<br>%s<br>%s",
            msg1, msg2, msg3, msg4
        );
    }
    
    // ========================================================
    //  5.검색(은진씨 추가분)
    // ========================================================
    @GetMapping("/sync/search")
    public String syncSearch() throws Exception {

        // Oracle 검색로그 전체 조회
        List<mukjaSearchDTO> oracleList = mukjaSearchDao.searchListAll();

        // 한 번에 전송할 BulkRequest 생성
        BulkRequest bulkRequest = new BulkRequest();

        for (mukjaSearchDTO dto : oracleList) {

            Map<String, Object> map = new HashMap<>();

            map.put("ms_no", dto.getMs_no());
            map.put("ms_word", dto.getMs_word());
            map.put(
            	    "ms_date",
            	    dto.getMs_date() != null ? dto.getMs_date().getTime() : null
            	);

            IndexRequest request = new IndexRequest("mukja_search")
                    .id(String.valueOf(dto.getMs_no()))
                    .source(map);

            bulkRequest.add(request);
        }

        BulkResponse response =
                client.bulk(bulkRequest, RequestOptions.DEFAULT);

        if (response.hasFailures()) {
            return "Elasticsearch 전송 중 오류: "
                    + response.buildFailureMessage();
        }

        return "오라클 DB 검색로그 "
                + oracleList.size()
                + "건이 mukja_search 인덱스로 전송되었습니다!";
    }
    
   
}
    

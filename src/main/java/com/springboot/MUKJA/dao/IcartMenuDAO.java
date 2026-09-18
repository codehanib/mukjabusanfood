package com.springboot.MUKJA.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.springboot.MUKJA.dto.cartMenuDTO;

@Mapper
public interface IcartMenuDAO {

    // =========================================================================
    // 1. 회원(u_no) 기반 장바구니 및 식당 정보 조회
    // =========================================================================
    
    // 유저 번호(u_no) 기준 장바구니 번호(mc_no) 조회
    Integer selectMcNoByUno(int u_no);

    // 유저 번호(u_no) 기준 장바구니 번호 + 식당 정보(r_no, r_name) 통합 조회
    Map<String, Object> selectCartStoreInfo(int u_no);
    
    //유저 전용 장바구니 신규 생성
 
    void insertNewCartForUser(int u_no);

    // =========================================================================
    // 2. 단일 식당 제한 검증용 (r_no 관련)
    // =========================================================================
    
    // 현재 장바구니에 담긴 식당 번호(r_no) 조회
    Integer selectCartRestaurant(int mc_no);

    // 장바구니의 식당 번호(r_no) 갱신 (처음 담거나 강제 교체 시)
    void updateCartRestaurant(@Param("mc_no") int mc_no, @Param("r_no") int r_no);


    // =========================================================================
    // 3. 장바구니 메뉴 CRUD
    // =========================================================================
    
    // 장바구니 번호(mc_no) 기준 메뉴 목록 조회
    List<cartMenuDTO> selectCartMenuList(int mc_no);

    // 장바구니 메뉴 추가
    int insertCartMenu(cartMenuDTO dto);

    // 수량 변경
    int updateCartMenuCount(@Param("mcm_no") int mcm_no, @Param("mcm_count") int mcm_count);

    // 개별 메뉴 삭제
    int deleteCartMenu(int mcm_no);

    // 장바구니 전체 비우기
    int clearCartMenu(int mc_no);
}
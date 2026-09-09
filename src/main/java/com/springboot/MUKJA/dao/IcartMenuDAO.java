package com.springboot.MUKJA.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import com.springboot.MUKJA.dto.cartMenuDTO;

@Mapper
public interface IcartMenuDAO {
	// 장바구니 번호(mc_no) 기준 메뉴 목록 조회
    List<cartMenuDTO> selectCartMenuList(int mc_no);
    
    // 수량 변경
    int updateCartMenuCount(@Param("mcm_no") int mcm_no, @Param("mcm_count") int mcm_count);
    
    // 개별 메뉴 삭제
    int deleteCartMenu(int mcm_no);
    
    // 장바구니 비우기
    int clearCartMenu(int mc_no);
    
    // 장바구니 메뉴 추가
    int insertCartMenu(cartMenuDTO dto);

}

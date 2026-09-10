package com.springboot.MUKJA.dao;

import org.apache.ibatis.annotations.Mapper;

import com.springboot.MUKJA.dto.mukjaSearchDTO;

@Mapper
public interface mukjaSearchDAO {
	
	int searchLogInsert(mukjaSearchDTO dto);
}

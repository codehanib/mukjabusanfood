package com.springboot.MUKJA.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.springboot.MUKJA.dto.mukjaSearchDTO;

@Mapper
public interface mukjaSearchDAO {
	
	int searchLogInsert(mukjaSearchDTO dto);
	
	List<mukjaSearchDTO> popularSearchList();
}

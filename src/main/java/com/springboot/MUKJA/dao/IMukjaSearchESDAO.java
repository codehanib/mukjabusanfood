package com.springboot.MUKJA.dao;

import org.springframework.data.elasticsearch.repository.ElasticsearchRepository;
import org.springframework.stereotype.Repository;

import com.springboot.MUKJA.dto.mukjaSearchDTO;

@Repository
public interface IMukjaSearchESDAO
        extends ElasticsearchRepository<mukjaSearchDTO, Integer> {

}
package com.springboot.MUKJA.dao;

import org.springframework.data.elasticsearch.repository.ElasticsearchRepository;
import org.springframework.stereotype.Repository;

import com.springboot.MUKJA.dto.MukjaReviewESDTO;

@Repository
public interface IMukjaReviewESDAO extends ElasticsearchRepository<MukjaReviewESDTO, Integer> {
}
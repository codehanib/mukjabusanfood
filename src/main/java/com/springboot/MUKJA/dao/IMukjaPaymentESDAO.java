package com.springboot.MUKJA.dao;

import com.springboot.MUKJA.dto.MukjaPaymentESDTO;
import org.springframework.data.elasticsearch.repository.ElasticsearchRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface IMukjaPaymentESDAO extends ElasticsearchRepository<MukjaPaymentESDTO, Integer> {
}
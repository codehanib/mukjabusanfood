package com.springboot.MUKJA.dao;

import com.springboot.MUKJA.dto.MukjaDeliveryESDTO;
import org.springframework.data.elasticsearch.repository.ElasticsearchRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface IMukjaDeliveryESDAO extends ElasticsearchRepository<MukjaDeliveryESDTO, Integer> {
}
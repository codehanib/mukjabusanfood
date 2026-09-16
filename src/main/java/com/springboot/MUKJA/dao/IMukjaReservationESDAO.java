package com.springboot.MUKJA.dao;

import org.springframework.data.elasticsearch.repository.ElasticsearchRepository;
import org.springframework.stereotype.Repository;

import com.springboot.MUKJA.dto.MukjaReservationESDTO;

@Repository
public interface IMukjaReservationESDAO extends ElasticsearchRepository<MukjaReservationESDTO, Integer> {
}
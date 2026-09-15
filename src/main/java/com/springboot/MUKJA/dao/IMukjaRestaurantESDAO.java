package com.springboot.MUKJA.dao;

import org.springframework.data.elasticsearch.repository.ElasticsearchRepository;
import org.springframework.stereotype.Repository;
import com.springboot.MUKJA.dto.MukjaRestaurantESDTO;

@Repository
public interface IMukjaRestaurantESDAO extends ElasticsearchRepository<MukjaRestaurantESDTO, Integer> {

}

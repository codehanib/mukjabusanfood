package com.springboot.MUKJA.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.elasticsearch.action.index.IndexRequest;
import org.elasticsearch.action.search.SearchRequest;
import org.elasticsearch.action.search.SearchResponse;
import org.elasticsearch.client.RequestOptions;
import org.elasticsearch.client.RestHighLevelClient;
import org.elasticsearch.index.query.QueryBuilders;
import org.elasticsearch.search.SearchHit;
import org.elasticsearch.search.builder.SearchSourceBuilder;
import org.elasticsearch.search.fetch.subphase.highlight.HighlightBuilder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.springboot.MUKJA.dto.restaurantDTO;

@Service
public class RestaurantESService {

    @Autowired
    private RestHighLevelClient client;

    // 식당 Elasticsearch 저장
    public void save(restaurantDTO dto) throws Exception {

        if (dto.getR_no() == 0) {
            throw new IllegalStateException("식당 번호가 없습니다.");
        }

        Map<String, Object> map = new HashMap<>();

        map.put("r_no", dto.getR_no());
        map.put("r_name", dto.getR_name());
        map.put("r_region", dto.getR_region());
        map.put("r_addr", dto.getR_addr());
        map.put("mukja_c_name", dto.getMukja_c_name());
        map.put("mn_name", dto.getMn_name());

        IndexRequest request =
                new IndexRequest("restaurants")
                .id(String.valueOf(dto.getR_no()))
                .source(map);

        client.index(request, RequestOptions.DEFAULT);

        System.out.println("ES INDEX ID : " + dto.getR_no());
        System.out.println("ES INDEX 식당명 : " + dto.getR_name());
    }


    // 식당 검색
    public List<restaurantDTO> search(String keyword) throws Exception {

        SearchRequest request = new SearchRequest("restaurants");

        SearchSourceBuilder builder = new SearchSourceBuilder();

        builder.query(
            QueryBuilders.multiMatchQuery(
                keyword,
                "r_name",
                "r_region",
                "r_addr",
                "mukja_c_name",
                "mn_name"
            )
        );

        request.source(builder);

        SearchResponse response =
                client.search(request, RequestOptions.DEFAULT);

        List<restaurantDTO> list = new ArrayList<>();

        for (SearchHit hit : response.getHits().getHits()) {

            Map<String, Object> map = hit.getSourceAsMap();

            restaurantDTO dto = new restaurantDTO();

            dto.setR_no(
                Integer.parseInt(map.get("r_no").toString())
            );

            dto.setR_name(map.get("r_name").toString());
            dto.setR_region(map.get("r_region").toString());
            dto.setR_addr(map.get("r_addr").toString());

            if (map.get("mukja_c_name") != null) {
                dto.setMukja_c_name(
                    map.get("mukja_c_name").toString()
                );
            }

            if (map.get("mn_name") != null) {
                dto.setMn_name(
                    map.get("mn_name").toString()
                );
            }

            list.add(dto);
        }

        return list;
    }


    // 식당명 자동완성 + 하이라이트
    public List<Map<String, String>> autocompleteHighlight(
            String keyword) throws Exception {

        SearchRequest request =
                new SearchRequest("restaurants");

        SearchSourceBuilder source =
                new SearchSourceBuilder();

        source.size(10);

        source.query(
            QueryBuilders.matchPhrasePrefixQuery(
                "r_name",
                keyword
            )
        );

        HighlightBuilder highlight =
                new HighlightBuilder();

        highlight.field(
            new HighlightBuilder.Field("r_name")
                .highlightQuery(
                    QueryBuilders.matchPhrasePrefixQuery(
                        "r_name",
                        keyword
                    )
                )
        );

        highlight.preTags("<em>");
        highlight.postTags("</em>");

        source.highlighter(highlight);
        request.source(source);

        SearchResponse response =
                client.search(
                    request,
                    RequestOptions.DEFAULT
                );

        List<Map<String, String>> result =
                new ArrayList<>();

        for (SearchHit hit : response.getHits().getHits()) {

            String r_name =
                hit.getSourceAsMap()
                   .get("r_name")
                   .toString();

            String highlighted = r_name;

            if (hit.getHighlightFields().get("r_name") != null) {

                highlighted =
                    hit.getHighlightFields()
                       .get("r_name")
                       .fragments()[0]
                       .string();
            }
            

            Map<String, String> map =
                    new HashMap<>();

            map.put("r_name", r_name);
            map.put("highlight", highlighted);

            result.add(map);
        }

        return result;
    }
}
package com.springboot.MUKJA.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.elasticsearch.action.delete.DeleteRequest;
import org.elasticsearch.action.index.IndexRequest;
import org.elasticsearch.action.search.SearchRequest;
import org.elasticsearch.action.search.SearchResponse;
import org.elasticsearch.action.support.WriteRequest;
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
        map.put("r_point", dto.getR_point());
        map.put("r_time", dto.getR_time());
        map.put("r_rest", dto.getR_rest());
        map.put("r_img", dto.getR_img());
        map.put("mukja_c_name", dto.getMukja_c_name());
        map.put("mukja_c_no", dto.getMukja_c_no());
        map.put("mn_name", dto.getMn_name());

        IndexRequest request =
                new IndexRequest("restaurants")
                .id(String.valueOf(dto.getR_no()))
                .source(map);
        request.setRefreshPolicy(WriteRequest.RefreshPolicy.WAIT_UNTIL);

        client.index(request, RequestOptions.DEFAULT);
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
        
        builder.size(20);
        request.source(builder);

        SearchResponse response =
                client.search(request, RequestOptions.DEFAULT);

        List<restaurantDTO> list = new ArrayList<>();

        for (SearchHit hit : response.getHits().getHits()) {

            Map<String, Object> map = hit.getSourceAsMap();

            //System.out.println(map);

            restaurantDTO dto = new restaurantDTO();

            if (map.get("r_no") != null) {
                dto.setR_no(
                    Integer.parseInt(map.get("r_no").toString())
                );
            }

            if (map.get("r_name") != null) {
                dto.setR_name(map.get("r_name").toString());
            }

            if (map.get("r_region") != null) {
                dto.setR_region(map.get("r_region").toString());
            }

            if (map.get("r_addr") != null) {
                dto.setR_addr(map.get("r_addr").toString());
            }

            if (map.get("r_img") != null) {
                dto.setR_img(map.get("r_img").toString());
            }

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
            if (map.get("r_point") != null) {
                dto.setR_point(
                		Double.parseDouble(map.get("r_point").toString())
                );
            }

            if (map.get("r_time") != null) {

                String r_time = map.get("r_time").toString();
                dto.setR_time(r_time);

                // 영업시간 추출
                java.util.regex.Pattern timePattern =
                        java.util.regex.Pattern.compile(
                            "(\\d{1,2}:\\d{2})\\s*~\\s*(?:새벽\\s*)?(\\d{1,2}:\\d{2})"
                        );

                java.util.regex.Matcher timeMatcher =
                        timePattern.matcher(r_time);

                if (timeMatcher.find()) {
                    dto.setSimple_time(
                        timeMatcher.group(1) + " ~ " + timeMatcher.group(2)
                    );
                } else {
                    dto.setSimple_time("정보 없음");
                }

                // 휴무일 추출
                java.util.regex.Pattern restPattern =
                        java.util.regex.Pattern.compile(
                            "(월|화|수|목|금|토|일)·(?:\\d{1,2}/\\d{1,2}\\s*)?(?:매주\\s*(?:월|화|수|목|금|토|일)요일\\s*)?휴무"
                        );

                java.util.regex.Matcher restMatcher =
                        restPattern.matcher(r_time);

                if (restMatcher.find()) {
                    dto.setRest_day(restMatcher.group(1));
                } else {
                    dto.setRest_day("없음");
                }
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
    
    public void delete(int r_no) throws Exception {

        DeleteRequest request =
                new DeleteRequest("restaurants", String.valueOf(r_no));
        
        request.setRefreshPolicy(WriteRequest.RefreshPolicy.WAIT_UNTIL);
        
        client.delete(request, RequestOptions.DEFAULT);
    }
}
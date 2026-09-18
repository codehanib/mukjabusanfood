package com.springboot.MUKJA.service;

import java.util.HashMap;
import java.util.Map;

import org.elasticsearch.action.search.SearchRequest;
import org.elasticsearch.action.search.SearchResponse;
import org.elasticsearch.client.RequestOptions;
import org.elasticsearch.client.RestHighLevelClient;
import org.elasticsearch.search.aggregations.AggregationBuilders;
import org.elasticsearch.search.aggregations.bucket.terms.Terms;
import org.elasticsearch.search.aggregations.bucket.terms.TermsAggregationBuilder;
import org.elasticsearch.search.aggregations.metrics.Avg;
import org.elasticsearch.search.aggregations.metrics.ValueCount;
import org.elasticsearch.search.builder.SearchSourceBuilder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;

@Service
public class EsRatingService {

    @Autowired
    private RestHighLevelClient client;

    
    @Cacheable(value = "restaurantRatings")
    public Map<Integer, Map<String, Object>> getRestaurantRatings() {
        Map<Integer, Map<String, Object>> resultMap = new HashMap<>();

        try {
            SearchRequest searchRequest = new SearchRequest("mukja_review");
            SearchSourceBuilder sourceBuilder = new SearchSourceBuilder();
            sourceBuilder.size(0);

            TermsAggregationBuilder agg = AggregationBuilders.terms("by_restaurant")
                    .field("r_no")
                    .size(2000);

            agg.subAggregation(AggregationBuilders.avg("avg_rating").field("rev_score"));
            agg.subAggregation(AggregationBuilders.count("review_count").field("rev_score"));

            sourceBuilder.aggregation(agg);
            searchRequest.source(sourceBuilder);

            SearchResponse response = client.search(searchRequest, RequestOptions.DEFAULT);

            Terms byRestaurant = response.getAggregations().get("by_restaurant");
            if (byRestaurant != null) {
                for (Terms.Bucket bucket : byRestaurant.getBuckets()) {
                    int rNo = Integer.parseInt(bucket.getKeyAsString());

                    Avg avgRating = bucket.getAggregations().get("avg_rating");
                    ValueCount reviewCount = bucket.getAggregations().get("review_count");

                    double rawAvg = (avgRating == null || Double.isNaN(avgRating.getValue())) ? 0.0 : avgRating.getValue();
                    double roundedAvg = Math.round(rawAvg * 10.0) / 10.0;
                    long count = (reviewCount == null) ? 0L : reviewCount.getValue();

                    Map<String, Object> ratingData = new HashMap<>();
                    ratingData.put("avgRating", roundedAvg);
                    ratingData.put("reviewCount", count);

                    resultMap.put(rNo, ratingData);
                    
                    // ⚡ [로그 추가] 이클립스 Console 탭에서 확인용
                    System.out.println(">>> ES 집계 성공 - 식당번호: " + rNo + " | 평점: " + roundedAvg + " | 리뷰수: " + count);
                }
            }
            System.out.println(">>> ES 총 집계된 식당 수: " + resultMap.size() + "개");

        } catch (Exception e) {
            e.printStackTrace();
        }

        return resultMap;
    }
    
 
}
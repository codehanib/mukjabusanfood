package com.springboot.MUKJA.config;

import org.apache.http.HttpHost;
import org.apache.http.HttpResponseInterceptor;
import org.elasticsearch.client.RestClient;
import org.elasticsearch.client.RestHighLevelClient;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.elasticsearch.client.ClientConfiguration;
import org.springframework.data.elasticsearch.client.elc.ElasticsearchClients;
import org.springframework.data.elasticsearch.client.elc.ElasticsearchConfiguration;

@Configuration
public class ESconfig extends ElasticsearchConfiguration {

    // 1. 기존 검색 기능용 RestHighLevelClient 유지
    @Bean
    public RestHighLevelClient client() {
        return new RestHighLevelClient(
            RestClient.builder(new HttpHost("192.168.10.49", 9200, "http"))
        );
    }

    // 2. 새로 추가한 Repository/동기화용 설정 (7.10.1 버전 헤더 에러 방지)
    @Override
    public ClientConfiguration clientConfiguration() {
        return ClientConfiguration.builder()
                .connectedTo("192.168.10.49:9200")
                .withClientConfigurer(
                    ElasticsearchClients.ElasticsearchHttpClientConfigurationCallback.from(
                        httpClientBuilder -> httpClientBuilder.addInterceptorLast(
                            (HttpResponseInterceptor) (response, context) -> 
                                response.addHeader("X-Elastic-Product", "Elasticsearch")
                        )
                    )
                )
                .build();
    }
}
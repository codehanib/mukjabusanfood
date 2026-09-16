package com.springboot.MUKJA.config;

import org.apache.http.HttpHost;
import org.apache.http.HttpRequestInterceptor;
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

    // 1. 기존 검색용 client
    @Bean
    public RestHighLevelClient client() {
        return new RestHighLevelClient(
            RestClient.builder(new HttpHost("192.168.10.49", 9200, "http"))
        );
    }

    // 2. 동기화 및 Repository용 설정 (7.10.1 버전 호환 헤더 처리)
    @Override
    public ClientConfiguration clientConfiguration() {
        return ClientConfiguration.builder()
                .connectedTo("192.168.10.49:9200")
                .withClientConfigurer(
                    ElasticsearchClients.ElasticsearchHttpClientConfigurationCallback.from(
                        httpClientBuilder -> httpClientBuilder
                            // 응답(Response) 헤더 검증 우회
                            .addInterceptorLast((HttpResponseInterceptor) (response, context) -> 
                                response.addHeader("X-Elastic-Product", "Elasticsearch")
                            )
                            // 요청(Request) 헤더 compatible-with=8 제거 및 표준 application/json 고정
                            .addInterceptorLast((HttpRequestInterceptor) (request, context) -> {
                                request.setHeader("Content-Type", "application/json");
                                request.setHeader("Accept", "application/json");
                            })
                    )
                )
                .build();
    }
}
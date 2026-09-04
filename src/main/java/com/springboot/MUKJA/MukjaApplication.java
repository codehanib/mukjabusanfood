package com.springboot.MUKJA;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableAsync;

@SpringBootApplication
@EnableAsync
public class MukjaApplication {

	public static void main(String[] args) {
		SpringApplication.run(MukjaApplication.class, args);
		//BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
        //String encoded = encoder.encode("1234");
        //System.out.println("암호화 결과: " + encoded);
	}

}

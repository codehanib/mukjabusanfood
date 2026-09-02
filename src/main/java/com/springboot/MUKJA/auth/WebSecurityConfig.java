package com.springboot.MUKJA.auth;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;

import jakarta.servlet.DispatcherType;

@Configuration
public class WebSecurityConfig {
	@Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
	
	@Bean
	public SecurityFilterChain filterChain(HttpSecurity http) throws Exception{
		http.csrf((csrf) -> csrf.disable())
			.cors((cors) -> cors.disable())
			.authorizeHttpRequests(request -> request
					.dispatcherTypeMatchers(DispatcherType.FORWARD).permitAll()
					.requestMatchers("/","/writeForm","/loginForm","/jusoPopup","/usersInsert","/loginsuccess",
									"/product/**","/header","/footer","/main","/customerService2","/product/productDetail","/product/productList").permitAll()
					.requestMatchers("/notice/list", "/notice/view","/product/productDetail").permitAll()
					.requestMatchers("/login/**","/loginError").permitAll()
					.requestMatchers("/notice/write*", "/notice/update*", "/notice/delete*").hasRole("ADMIN")
										
					// [수정] .webp 등 다양한 이미지 확장자 및 루트 정적 파일/업로드 경로 추가
					.requestMatchers("/css/**", "/js/**", "/images/**", "/*.webp", "/*.jpg", "/*.png", "/upload/**").permitAll() 
					.requestMatchers("/guest/**").permitAll()
					.requestMatchers("/users/**").hasAnyRole("USER","ADMIN")
					.requestMatchers("/owner/**").hasAnyRole("OWNER","ADMIN")
					.requestMatchers("/admin/**").hasAnyRole("ADMIN")
					.anyRequest().authenticated()
			);
			
		
		// 로그인
		http.formLogin((formLogin) -> formLogin
				.loginPage("/login/login")
				.loginProcessingUrl("/j_spring_security_check")
				.defaultSuccessUrl("/main", true)
				.failureUrl("/login/loginError")
				.usernameParameter("u_id")
				.passwordParameter("u_passwd")
				.permitAll()
				);
		
		// 로그아웃
		http.logout((logout) -> logout
				.logoutUrl("/logout")
				.logoutSuccessUrl("/")
				.permitAll()
				);
		
		return http.build();
	}
}
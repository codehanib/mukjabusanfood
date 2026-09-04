package com.springboot.MUKJA.service;

import java.util.Calendar;
import java.util.Date;

import org.springframework.stereotype.Service;

@Service
public class DeliveryService {
	
	// 지구 반지름 (km)
	private static final double EARTH_RADIUS = 6371.0;
	
	// 1.하버사인 공식을 이용한 직선거리 계산(km)
	public double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
		double dLat = Math.toRadians(lat2 - lat1);
		double dLon = Math.toRadians(lon2 - lon1);
		
		double a = Math.sin(dLat / 2) * Math.sin(dLat /2)
				 + Math.cos(Math.toRadians(lat1))* Math.cos(Math.toRadians(lat2))
				 * Math.sin(dLon / 2 ) * Math.sin(dLon/2);
		double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
		
		return EARTH_RADIUS * c; //단위 km
	}
	
	// 2. 거리에 따른 배달 소요 시간 산출(분) 기본5분 + 1km당 3분 추가 (도로사정 가중치 1.3)
	public int estimateDeliveryTimeMinutes(double distanceKm) {
		double adjustedDistance = distanceKm * 1.3; // 실제 도로 우회율 반영
		int baseTime = 5; // 기본 시작시간
		int teavelTime = (int) Math.ceil(adjustedDistance * 3.0); //1km당 3분
		
		return baseTime + teavelTime;
	}
	
	// 3. 최종 도착 예정 시각 계산 (현재 시각 + 점주 조리시간 + 계산된 배달시간)
	
	public Date calculateArrivalTime(int cookingTimeMinutes, int deliveryTimeMinutes) {
		Calendar cal = Calendar.getInstance();
		cal.setTime(new Date());
		cal.add(Calendar.MINUTE, cookingTimeMinutes + deliveryTimeMinutes);
		return cal.getTime();
	}
}

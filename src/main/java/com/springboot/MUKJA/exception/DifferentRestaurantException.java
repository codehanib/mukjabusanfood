package com.springboot.MUKJA.exception;

// 이미 다른 가게 메뉴가 장바구니에 있을 때 던지는 예외
public class DifferentRestaurantException extends RuntimeException {
    public DifferentRestaurantException(String message) {
        super(message);
    }
}
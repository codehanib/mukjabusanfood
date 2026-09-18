package com.springboot.MUKJA.exception;

// 금액 계산이 맞지 않을 때 던지는 예외
public class PriceMismatchException extends RuntimeException {
    public PriceMismatchException(String message) {
        super(message);
    }
}
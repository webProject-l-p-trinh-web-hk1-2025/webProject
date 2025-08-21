package com.example.webProject.user.exception;

public class UnauthenticatedException extends RuntimeException {

    public UnauthenticatedException(String message) {
        super(message);
    }
}

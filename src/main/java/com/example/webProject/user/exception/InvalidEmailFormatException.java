package com.example.webProject.user.exception;

public class InvalidEmailFormatException extends RuntimeException {

    public InvalidEmailFormatException(String message) {
        super(message);
    }
}

package com.example.webProject.common.exception;

public class PermissionDeny extends RuntimeException {

    public PermissionDeny(String message) {
        super(message);
    }
}

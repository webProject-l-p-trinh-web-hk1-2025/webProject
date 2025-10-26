// package com.proj.webprojrct.common.config;

// import org.springframework.boot.web.server.ErrorPage;
// import org.springframework.boot.web.server.ErrorPageRegistrar;
// import org.springframework.boot.web.server.ErrorPageRegistry;
// import org.springframework.context.annotation.Configuration;

// import org.springframework.http.HttpStatus;

// @Configuration
// public class ErrorPagesConfig implements ErrorPageRegistrar {

//     @Override
//     public void registerErrorPages(ErrorPageRegistry registry) {
//         registry.addErrorPages(
//                 new ErrorPage(HttpStatus.NOT_FOUND, "/error"),
//                 new ErrorPage(HttpStatus.FORBIDDEN, "/error"),
//                 new ErrorPage(HttpStatus.INTERNAL_SERVER_ERROR, "/error")
//         );
//     }
// }

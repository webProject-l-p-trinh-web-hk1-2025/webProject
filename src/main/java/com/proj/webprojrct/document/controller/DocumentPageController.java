package com.proj.webprojrct.document.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class DocumentPageController {

    @GetMapping("/document_list")
    public String list() { return "document_list"; }   

    @GetMapping("/document_detail")
    public String detail() { return "document_detail"; } 
}

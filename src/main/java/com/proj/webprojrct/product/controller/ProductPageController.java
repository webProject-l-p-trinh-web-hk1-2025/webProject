package com.proj.webprojrct.product.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class ProductPageController {
  @GetMapping("/product_list")
  public String list(){ return "product_list"; }

  @GetMapping("/product_detail")
  public String detail(){ return "product_detail"; }
}


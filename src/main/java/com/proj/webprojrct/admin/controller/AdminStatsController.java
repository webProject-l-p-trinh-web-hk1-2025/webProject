package com.proj.webprojrct.admin.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;



import java.util.Map;
import java.util.List;
import com.proj.webprojrct.admin.service.AdminStatsService;

@RestController
@RequestMapping("/admin/api/stats")
public class AdminStatsController {

    

    @Autowired
    private AdminStatsService statsService;

    @GetMapping("/overview")
    public Map<String, Long> overview() {
        return statsService.overview();
    }

    @GetMapping("/orders")
    public Map<String, Long> orders(String period) {
        return statsService.orders(period);
    }

    @GetMapping("/revenue")
    public Map<String, Double> revenue(String period) {
        return statsService.revenue(period);
    }

    @GetMapping("/top-products")
    public List<Map<String, Object>> topProducts(Integer limit) {
        return statsService.topProducts(limit);
    }
}

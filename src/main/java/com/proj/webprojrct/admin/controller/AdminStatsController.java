package com.proj.webprojrct.admin.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
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
    public Map<String, Object> overview() {
        return statsService.overview();
    }

    @GetMapping("/orders")
    public Map<String, Long> orders(
            @RequestParam String period,
            @RequestParam(required = false) String week,
            @RequestParam(required = false) Integer month,
            @RequestParam(required = false) Integer year) {
        return statsService.orders(period, week, month, year);
    }

    @GetMapping("/revenue")
    public Map<String, Double> revenue(
            @RequestParam String period,
            @RequestParam(required = false) String week,
            @RequestParam(required = false) Integer month,
            @RequestParam(required = false) Integer year) {
        return statsService.revenue(period, week, month, year);
    }

    @GetMapping("/top-products")
    public List<Map<String, Object>> topProducts(Integer limit) {
        return statsService.topProducts(limit);
    }

    @GetMapping("/users-by-time")
    public Map<String, Long> usersByTime(
            @RequestParam String period,
            @RequestParam(required = false) String week,
            @RequestParam(required = false) Integer month,
            @RequestParam(required = false) Integer year) {
        return statsService.usersByTime(period, week, month, year);
    }
}

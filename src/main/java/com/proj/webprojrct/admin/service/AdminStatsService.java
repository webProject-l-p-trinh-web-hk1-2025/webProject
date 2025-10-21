package com.proj.webprojrct.admin.service;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.proj.webprojrct.user.repository.UserRepository;
import com.proj.webprojrct.product.repository.ProductRepository;
import com.proj.webprojrct.document.repository.DocumentRepository;
import com.proj.webprojrct.order.repository.OrderRepository;

import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.Query;

@Service
public class AdminStatsService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private ProductRepository productRepository;

    @Autowired
    private DocumentRepository documentRepository;

    @Autowired
    private OrderRepository orderRepository;

    @PersistenceContext
    private EntityManager em;

    public Map<String, Long> overview() {
        long users = userRepository.count();
        long products = productRepository.count();
        long documents = documentRepository.count();
        long orders = orderRepository.count();
        return Map.of(
                "users", users,
                "products", products,
                "documents", documents,
                "orders", orders
        );
    }

    public Map<String, Long> orders(String period) {
        String p = (period == null) ? "week" : period.toLowerCase();
        Map<String, Long> buckets = new LinkedHashMap<>();

        if (p.equals("month")) {
            String sql = "SELECT DATE_FORMAT(created_at, '%Y-%m') as ym, COUNT(*) as cnt FROM orders GROUP BY ym ORDER BY ym";
            Query q = em.createNativeQuery(sql);
            @SuppressWarnings("unchecked")
            List<Object[]> rows = q.getResultList();
            for (Object[] r : rows) {
                String key = (r[0] == null) ? "" : r[0].toString();
                Number num = (Number) r[1];
                buckets.put(key, num == null ? 0L : num.longValue());
            }
        } else {
            DateTimeFormatter fmt = DateTimeFormatter.ISO_DATE;
            LocalDate today = LocalDate.now();
            for (int i = 6; i >= 0; i--) {
                String k = today.minusDays(i).format(fmt);
                buckets.put(k, 0L);
            }
            String sql = "SELECT DATE(created_at) as d, COUNT(*) as cnt FROM orders WHERE created_at >= CURDATE() - INTERVAL 6 DAY GROUP BY d ORDER BY d";
            Query q = em.createNativeQuery(sql);
            @SuppressWarnings("unchecked")
            List<Object[]> rows = q.getResultList();
            for (Object[] r : rows) {
                String key = (r[0] == null) ? "" : r[0].toString();
                Number num = (Number) r[1];
                if (buckets.containsKey(key)) {
                    buckets.put(key, num == null ? 0L : num.longValue());
                }
            }
        }

        return buckets;
    }

    public Map<String, Double> revenue(String period) {
        String p = (period == null) ? "week" : period.toLowerCase();
        Map<String, Double> buckets = new LinkedHashMap<>();

        if (p.equals("month")) {
            String sql = "SELECT DATE_FORMAT(o.created_at, '%Y-%m') as ym, SUM(oi.price * oi.quantity) as rev FROM orders o JOIN order_items oi ON o.order_id = oi.order_id GROUP BY ym ORDER BY ym";
            Query q = em.createNativeQuery(sql);
            @SuppressWarnings("unchecked")
            List<Object[]> rows = q.getResultList();
            for (Object[] r : rows) {
                String key = (r[0] == null) ? "" : r[0].toString();
                Number num = (Number) r[1];
                buckets.put(key, num == null ? 0.0 : num.doubleValue());
            }
        } else {
            LocalDate today = LocalDate.now();
            DateTimeFormatter fmt = DateTimeFormatter.ISO_DATE;
            for (int i = 6; i >= 0; i--) {
                String k = today.minusDays(i).format(fmt);
                buckets.put(k, 0.0);
            }
            String sql = "SELECT DATE(o.created_at) as d, SUM(oi.price * oi.quantity) as rev FROM orders o JOIN order_items oi ON o.order_id = oi.order_id WHERE o.created_at >= CURDATE() - INTERVAL 6 DAY GROUP BY d ORDER BY d";
            Query q = em.createNativeQuery(sql);
            @SuppressWarnings("unchecked")
            List<Object[]> rows = q.getResultList();
            for (Object[] r : rows) {
                String key = (r[0] == null) ? "" : r[0].toString();
                Number num = (Number) r[1];
                if (buckets.containsKey(key)) {
                    buckets.put(key, num == null ? 0.0 : num.doubleValue());
                }
            }
        }
        return buckets;
    }

    public List<Map<String,Object>> topProducts(Integer limit) {
        int lim = (limit == null || limit <= 0) ? 10 : limit;
        String sql = "SELECT p.id, p.name, SUM(oi.quantity) as sold, SUM(oi.price * oi.quantity) as revenue FROM products p JOIN order_items oi ON p.id = oi.product_id GROUP BY p.id, p.name ORDER BY sold DESC LIMIT " + lim;
        Query q = em.createNativeQuery(sql);
        @SuppressWarnings("unchecked")
        List<Object[]> rows = q.getResultList();
        List<Map<String,Object>> out = new ArrayList<>();
        for (Object[] r : rows) {
            Map<String,Object> m = new java.util.HashMap<>();
            m.put("productId", r[0]);
            m.put("name", r[1]);
            Number sold = (Number) r[2];
            Number rev = (Number) r[3];
            m.put("sold", sold == null ? 0L : sold.longValue());
            m.put("revenue", rev == null ? 0.0 : rev.doubleValue());
            out.add(m);
        }
        return out;
    }
}

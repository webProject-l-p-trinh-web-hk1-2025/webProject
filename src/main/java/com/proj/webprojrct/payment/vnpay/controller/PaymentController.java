package com.proj.webprojrct.payment.vnpay.controller;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.TimeZone;

import org.springframework.http.HttpStatus;
import org.springframework.http.HttpStatusCode;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.proj.webprojrct.payment.vnpay.config.Config;

import org.springframework.web.bind.annotation.RestController;

import com.nimbusds.jose.shaded.gson.Gson;
import com.nimbusds.jose.shaded.gson.JsonObject;
import com.proj.webprojrct.payment.dto.response.PaymentResDto;

import jakarta.servlet.http.HttpServletRequest;

/**
 *
 * @author CTT VNPAY
 */
@RestController
@RequestMapping("/api/vnpay/payment")
public class PaymentController {

    @GetMapping("/create_payment")
    public ResponseEntity<?> createPayment() throws UnsupportedEncodingException {
        String orderType = "other";

        // long amount = Integer.parseInt(req.getParameter("amount")) * 100;
        // String bankCode = req.getParameter("bankCode");
        long amount = 100000 * 100;

        String vnp_TxnRef = Config.getRandomNumber(8);
        //String vnp_IpAddr = Config.getIpAddress(req);

        String vnp_TmnCode = Config.vnp_TmnCode;

        String vnp_IpAddr = "127.0.0.1";

        Map<String, String> vnp_Params = new HashMap<>();
        vnp_Params.put("vnp_Version", Config.vnp_Version);
        vnp_Params.put("vnp_Command", Config.vnp_Command);
        vnp_Params.put("vnp_TmnCode", Config.vnp_TmnCode);
        vnp_Params.put("vnp_Amount", String.valueOf(amount));
        vnp_Params.put("vnp_CurrCode", "VND");
        //vnp_Params.put("vnp_BankCode", "NCB");
        vnp_Params.put("vnp_TxnRef", vnp_TxnRef);
        vnp_Params.put("vnp_OrderInfo", "Thanh toan don hang:" + vnp_TxnRef);
        vnp_Params.put("vnp_OrderType", orderType);  // 🔹 bắt buộc
        vnp_Params.put("vnp_Locale", "vn");
        vnp_Params.put("vnp_ReturnUrl", Config.vnp_ReturnUrl); // 🔹 bắt buộc
        vnp_Params.put("vnp_IpAddr", vnp_IpAddr); // 🔹 bắt buộc

        Calendar cld = Calendar.getInstance(TimeZone.getTimeZone("Etc/GMT+7"));
        SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
        String vnp_CreateDate = formatter.format(cld.getTime());
        vnp_Params.put("vnp_CreateDate", vnp_CreateDate);

        cld.add(Calendar.MINUTE, 15);
        String vnp_ExpireDate = formatter.format(cld.getTime());
        vnp_Params.put("vnp_ExpireDate", vnp_ExpireDate);

        List fieldNames = new ArrayList(vnp_Params.keySet());
        Collections.sort(fieldNames);
        StringBuilder hashData = new StringBuilder();
        StringBuilder query = new StringBuilder();
        Iterator itr = fieldNames.iterator();
        while (itr.hasNext()) {
            String fieldName = (String) itr.next();
            String fieldValue = (String) vnp_Params.get(fieldName);
            if ((fieldValue != null) && (fieldValue.length() > 0)) {
                //Build hash data
                hashData.append(fieldName);
                hashData.append('=');
                hashData.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString()));
                //Build query
                query.append(URLEncoder.encode(fieldName, StandardCharsets.US_ASCII.toString()));
                query.append('=');
                query.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString()));
                if (itr.hasNext()) {
                    query.append('&');
                    hashData.append('&');
                }
            }
        }
        String queryUrl = query.toString();
        String vnp_SecureHash = Config.hmacSHA512(Config.secretKey, hashData.toString());
        queryUrl += "&vnp_SecureHash=" + vnp_SecureHash;
        String paymentUrl = Config.vnp_PayUrl + "?" + queryUrl;

        PaymentResDto paymentResDto = new PaymentResDto();
        paymentResDto.setStatus("OK");
        paymentResDto.setMessage("Successfully");
        paymentResDto.setURL(paymentUrl);
        // com.google.gson.JsonObject job = new JsonObject();
        // job.addProperty("code", "00");
        // job.addProperty("message", "success");
        // job.addProperty("data", paymentUrl);
        // Gson gson = new Gson();
        // resp.getWriter().write(gson.toJson(job));
        return ResponseEntity.status(HttpStatus.OK).body(paymentResDto);
    }

    @GetMapping("/vnpay_return")
    public ResponseEntity<?> handleReturn(HttpServletRequest request) throws Exception {

        // Lấy tất cả params từ request
        Map<String, String> fields = new HashMap<>();
        Enumeration<String> paramNames = request.getParameterNames();
        while (paramNames.hasMoreElements()) {
            String fieldName = paramNames.nextElement();
            String fieldValue = request.getParameter(fieldName);

            if (fieldValue != null && fieldValue.length() > 0) {
                // Chỉ encode value theo chuẩn US-ASCII
                String encodedValue = URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString());
                fields.put(fieldName, encodedValue);
            }
        }

        // Lấy SecureHash do VNPAY trả về (chú ý: không encode cái này)
        String vnp_SecureHash = request.getParameter("vnp_SecureHash");

        // Bỏ các trường không dùng để hash
        fields.remove("vnp_SecureHashType");
        fields.remove("vnp_SecureHash");

        // Debug: in ra fields dùng để hash
        System.out.println("=== DEBUG CHECK HASH ===");
        System.out.println("Raw fields for hash: " + fields);

        // Tính lại hash
        String signValue = Config.hashAllFields(fields);

        System.out.println("VNPAY vnp_SecureHash : " + vnp_SecureHash);
        System.out.println("Our signValue        : " + signValue);

        Map<String, Object> result = new HashMap<>();
        if (signValue.equals(vnp_SecureHash)) {
            // Chữ ký hợp lệ
            String responseCode = request.getParameter("vnp_ResponseCode");
            String transactionStatus = request.getParameter("vnp_TransactionStatus");

            // Thông báo vnp_ResponseCode
            Map<String, String> responseMessages = new HashMap<>();
            responseMessages.put("00", "Giao dịch thành công");
            responseMessages.put("07", "Trừ tiền thành công. Giao dịch bị nghi ngờ");
            responseMessages.put("09", "Thẻ/TK chưa đăng ký InternetBanking");
            responseMessages.put("10", "Xác thực thẻ/TK sai quá 3 lần");
            responseMessages.put("11", "Hết hạn chờ thanh toán");
            responseMessages.put("12", "Thẻ/TK bị khóa");
            responseMessages.put("13", "Sai mật khẩu OTP quá 3 lần");
            responseMessages.put("24", "Khách hàng hủy giao dịch");
            responseMessages.put("51", "Không đủ số dư");
            responseMessages.put("65", "Vượt hạn mức giao dịch trong ngày");
            responseMessages.put("75", "Ngân hàng thanh toán đang bảo trì");
            responseMessages.put("79", "Sai mật khẩu thanh toán quá số lần quy định");
            responseMessages.put("99", "Lỗi khác");

            // Thông báo vnp_TransactionStatus
            Map<String, String> statusMessages = new HashMap<>();
            statusMessages.put("00", "Giao dịch thành công");
            statusMessages.put("01", "Giao dịch chưa hoàn tất");
            statusMessages.put("02", "Giao dịch bị lỗi");
            statusMessages.put("04", "Giao dịch đảo (Khách hàng đã bị trừ tiền tại Ngân hàng nhưng GD chưa thành công ở VNPAY)");
            statusMessages.put("05", "VNPAY đang xử lý giao dịch này (GD hoàn tiền)");
            statusMessages.put("06", "VNPAY đã gửi yêu cầu hoàn tiền sang Ngân hàng (GD hoàn tiền)");
            statusMessages.put("07", "Giao dịch bị nghi ngờ gian lận");
            statusMessages.put("09", "GD Hoàn trả bị từ chối");

            result.put("responseCode", responseCode);
            result.put("responseMessage", responseMessages.getOrDefault(responseCode, "Không xác định"));
            result.put("transactionStatus", transactionStatus);
            result.put("transactionMessage", statusMessages.getOrDefault(transactionStatus, "Không xác định"));

        } else {
            // Chữ ký không hợp lệ
            result.put("error", "Chữ ký không hợp lệ");
        }

        return ResponseEntity.status(HttpStatus.OK).body(result);
    }

    // @PostMapping("/query")
    // public ResponseEntity<String> queryTransaction(
    //         @RequestParam("order_id") String orderId,
    //         @RequestParam("trans_date") String transDate,
    //         HttpServletRequest request) {
    //     try {
    //         // Các tham số cơ bản
    //         String vnp_RequestId = Config.getRandomNumber(8);
    //         String vnp_Version = "2.1.0";
    //         String vnp_Command = "querydr";
    //         String vnp_TmnCode = Config.vnp_TmnCode;
    //         String vnp_TxnRef = orderId;
    //         String vnp_OrderInfo = "Kiem tra ket qua GD OrderId:" + vnp_TxnRef;
    //         String vnp_TransDate = transDate;
    //         Calendar cld = Calendar.getInstance(TimeZone.getTimeZone("Etc/GMT+7"));
    //         SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
    //         String vnp_CreateDate = formatter.format(cld.getTime());
    //         String vnp_IpAddr = Config.getIpAddress(request);
    //         // JSON request body
    //         JsonObject vnp_Params = new JsonObject();
    //         vnp_Params.addProperty("vnp_RequestId", vnp_RequestId);
    //         vnp_Params.addProperty("vnp_Version", vnp_Version);
    //         vnp_Params.addProperty("vnp_Command", vnp_Command);
    //         vnp_Params.addProperty("vnp_TmnCode", vnp_TmnCode);
    //         vnp_Params.addProperty("vnp_TxnRef", vnp_TxnRef);
    //         vnp_Params.addProperty("vnp_OrderInfo", vnp_OrderInfo);
    //         vnp_Params.addProperty("vnp_TransactionDate", vnp_TransDate);
    //         vnp_Params.addProperty("vnp_CreateDate", vnp_CreateDate);
    //         vnp_Params.addProperty("vnp_IpAddr", vnp_IpAddr);
    //         // Hash data
    //         String hash_Data = String.join("|",
    //                 vnp_RequestId, vnp_Version, vnp_Command, vnp_TmnCode,
    //                 vnp_TxnRef, vnp_TransDate, vnp_CreateDate, vnp_IpAddr, vnp_OrderInfo);
    //         String vnp_SecureHash = Config.hmacSHA512(Config.secretKey, hash_Data);
    //         vnp_Params.addProperty("vnp_SecureHash", vnp_SecureHash);
    //         // Gửi request POST
    //         URL url = new URL(Config.vnp_ApiUrl);
    //         HttpURLConnection con = (HttpURLConnection) url.openConnection();
    //         con.setRequestMethod("POST");
    //         con.setRequestProperty("Content-Type", "application/json");
    //         con.setDoOutput(true);
    //         try (DataOutputStream wr = new DataOutputStream(con.getOutputStream())) {
    //             wr.writeBytes(vnp_Params.toString());
    //             wr.flush();
    //         }
    //         int responseCode = con.getResponseCode();
    //         System.out.println("POST request to URL : " + url);
    //         System.out.println("Post Data : " + vnp_Params);
    //         System.out.println("Response Code : " + responseCode);
    //         StringBuilder response = new StringBuilder();
    //         try (BufferedReader in = new BufferedReader(new InputStreamReader(con.getInputStream()))) {
    //             String output;
    //             while ((output = in.readLine()) != null) {
    //                 response.append(output);
    //             }
    //         }
    //         return ResponseEntity.ok(response.toString());
    //     } catch (Exception e) {
    //         e.printStackTrace();
    //         return ResponseEntity.status(500).body("Error: " + e.getMessage());
    //     }
    // }
}

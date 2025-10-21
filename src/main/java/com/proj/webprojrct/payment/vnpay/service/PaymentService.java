package com.proj.webprojrct.payment.vnpay.service;

import com.proj.webprojrct.order.entity.Order;
import com.proj.webprojrct.order.repository.OrderRepository;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.math.BigDecimal;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.TimeZone;

import org.springframework.beans.factory.annotation.Autowired;

import lombok.*;

import org.springframework.stereotype.Service;

import com.nimbusds.jose.shaded.gson.JsonObject;
import com.nimbusds.jose.shaded.gson.JsonParser;
import com.proj.webprojrct.payment.vnpay.config.Config;
import com.proj.webprojrct.payment.dto.response.PaymentResDto;
import com.proj.webprojrct.payment.entity.Payment;
import com.proj.webprojrct.payment.repository.PaymentRepository;
import com.twilio.twiml.voice.Pay;

import jakarta.persistence.EntityNotFoundException;
import jakarta.servlet.http.HttpServletRequest;

@RequiredArgsConstructor
@Service
public class PaymentService {

    private final PaymentRepository paymentRepository;

    private final OrderRepository orderRepository;

    public PaymentResDto createPaymentUrl(Long orderId, HttpServletRequest request) throws UnsupportedEncodingException {

        String orderType = "other";

        Order order = orderRepository.findById(orderId).orElseThrow(() -> new EntityNotFoundException("Không tìm thấy đơn hàng (Order) với ID: " + orderId));
        BigDecimal totalAmountBigDecimal = order.getTotalAmount();
        BigDecimal multiplier = new BigDecimal("100");
        long amount = totalAmountBigDecimal.multiply(multiplier).longValue();
        // String bankCode = req.getParameter("bankCode");
        //long amount = 100000 * 100; //test

        String vnp_TxnRef = String.valueOf(orderId);

        String vnp_IpAddr = Config.getIpAddress(request);

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

        Payment payment = Payment.builder()
                .method("VNPAY")
                .orderId(orderId)
                .amount(BigDecimal.valueOf(amount / 100.0))
                .status("PENDING")
                .paidAt(vnp_CreateDate)
                .build();
        savePayment(payment);

        PaymentResDto paymentResDto = new PaymentResDto();
        paymentResDto.setStatus("OK");
        paymentResDto.setMessage("Successfully");
        paymentResDto.setURL(paymentUrl);

        return paymentResDto;
    }

    public Map<String, Object> handleVnPayReturn(HttpServletRequest request) throws Exception {

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

        String vnp_SecureHash = request.getParameter("vnp_SecureHash");

        fields.remove("vnp_SecureHashType");
        fields.remove("vnp_SecureHash");

        System.out.println("=== DEBUG CHECK HASH ===");
        System.out.println("Raw fields for hash: " + fields);

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

        return result;
    }

    public String handleQuery(long orderId, HttpServletRequest request) throws Exception {
        try {

            // Các tham số cơ bản
            String vnp_RequestId = Config.getRandomNumber(8);
            String vnp_Version = "2.1.0";
            String vnp_Command = "querydr";
            String vnp_TmnCode = Config.vnp_TmnCode;
            String vnp_TxnRef = String.valueOf(orderId);
            String vnp_OrderInfo = "Kiem tra ket qua GD OrderId:" + vnp_TxnRef;
            Calendar cld = Calendar.getInstance(TimeZone.getTimeZone("Etc/GMT+7"));
            SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
            String vnp_CreateDate = formatter.format(cld.getTime());
            String vnp_IpAddr = Config.getIpAddress(request);
            String vnp_TransDate = vnp_CreateDate;
            // JSON request body
            JsonObject vnp_Params = new JsonObject();
            vnp_Params.addProperty("vnp_RequestId", vnp_RequestId);
            vnp_Params.addProperty("vnp_Version", vnp_Version);
            vnp_Params.addProperty("vnp_Command", vnp_Command);
            vnp_Params.addProperty("vnp_TmnCode", vnp_TmnCode);
            vnp_Params.addProperty("vnp_TxnRef", vnp_TxnRef);
            vnp_Params.addProperty("vnp_OrderInfo", vnp_OrderInfo);
            vnp_Params.addProperty("vnp_TransactionDate", vnp_TransDate);
            vnp_Params.addProperty("vnp_CreateDate", vnp_CreateDate);
            vnp_Params.addProperty("vnp_IpAddr", vnp_IpAddr);
            // Hash data
            String hash_Data = String.join("|",
                    vnp_RequestId, vnp_Version, vnp_Command, vnp_TmnCode,
                    vnp_TxnRef, vnp_TransDate, vnp_CreateDate, vnp_IpAddr, vnp_OrderInfo);
            String vnp_SecureHash = Config.hmacSHA512(Config.secretKey, hash_Data);
            vnp_Params.addProperty("vnp_SecureHash", vnp_SecureHash);
            // Gửi request POST
            URL url = new URL(Config.vnp_ApiUrl);
            HttpURLConnection con = (HttpURLConnection) url.openConnection();
            con.setRequestMethod("POST");
            con.setRequestProperty("Content-Type", "application/json");
            con.setDoOutput(true);
            try (DataOutputStream wr = new DataOutputStream(con.getOutputStream())) {
                wr.writeBytes(vnp_Params.toString());
                wr.flush();
            }
            int responseCode = con.getResponseCode();
            System.out.println("POST request to URL : " + url);
            System.out.println("Post Data : " + vnp_Params);
            System.out.println("Response Code : " + responseCode);
            StringBuilder response = new StringBuilder();
            try (BufferedReader in = new BufferedReader(new InputStreamReader(con.getInputStream()))) {
                String output;
                while ((output = in.readLine()) != null) {
                    response.append(output);
                }
            }
            String res = response.toString(); // Dòng code của bạn

            // 1. Parse chuỗi JSON response
            JsonObject responseJson = JsonParser.parseString(res).getAsJsonObject();

            // 2. Lấy mã trạng thái giao dịch
            String transactionStatus = "UNDEFINED"; // Đặt mã mặc định
            if (responseJson.has("vnp_TransactionStatus")) {
                transactionStatus = responseJson.get("vnp_TransactionStatus").getAsString();
            }

            // 3. Lấy đối tượng Payment
            Payment payment = paymentRepository.findByOrderId(orderId);

            // 4. Ánh xạ mã VNPAY sang trạng thái của bạn
            String appStatus;
            switch (transactionStatus) {
                case "00":
                    appStatus = "SUCCESS";
                    break;
                case "01":
                    appStatus = "PENDING";
                    break;
                case "02":
                    appStatus = "FAILED";
                    break;
                case "04":
                    appStatus = "REVERSED";
                    break;
                case "05":
                    appStatus = "REFUND_PENDING";
                    break;
                case "06":
                    appStatus = "REFUND_PROCESSING";
                    break;
                case "07":
                    appStatus = "FRAUD_SUSPECTED";
                    break;
                case "09":
                    appStatus = "REFUND_FAILED";
                    break;
                default:
                    appStatus = "UNKNOWN";
                    break;
            }

            payment.setStatus(appStatus);
            paymentRepository.save(payment);
            return response.toString();
        } catch (Exception e) {
            e.printStackTrace();
            return e.getMessage();
        }
    }

    public String handleRefund(long orderId, String trantype, int percent, HttpServletRequest request) throws Exception {
        if ("02".equals(trantype)) {
            percent = 100;
        }

        Order order = orderRepository.findById(orderId).orElseThrow(() -> new EntityNotFoundException("Không tìm thấy đơn hàng (Order) với ID: " + orderId));
        BigDecimal totalAmountBigDecimal = order.getTotalAmount();
        BigDecimal multiplier = new BigDecimal("100");
        long originalAmountVND = totalAmountBigDecimal.multiply(multiplier).longValue();
        double refundAmountVND = originalAmountVND * ((double) percent / 100.0);
        long amount = (long) refundAmountVND;

        String vnp_RequestId = Config.getRandomNumber(8);
        String vnp_Version = "2.1.0";
        String vnp_Command = "refund";
        String vnp_TmnCode = Config.vnp_TmnCode;
        String vnp_TransactionType = trantype;
        String vnp_TxnRef = String.valueOf(orderId);
        double discount = (double) percent / 100.0;
        //long amount = 100000 * 100; //test
        String vnp_Amount = String.valueOf(amount);
        String vnp_OrderInfo = "Hoan tien GD OrderId:" + vnp_TxnRef;
        String vnp_TransactionNo = ""; //Assuming value of the parameter "vnp_TransactionNo" does not exist on your system.
        String vnp_CreateBy = "kiet";

        Calendar cld = Calendar.getInstance(TimeZone.getTimeZone("Etc/GMT+7"));
        SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
        String vnp_CreateDate = formatter.format(cld.getTime());
        String vnp_TransactionDate = vnp_CreateDate;

        String vnp_IpAddr = Config.getIpAddress(request);

        JsonObject vnp_Params = new JsonObject();

        vnp_Params.addProperty("vnp_RequestId", vnp_RequestId);
        vnp_Params.addProperty("vnp_Version", vnp_Version);
        vnp_Params.addProperty("vnp_Command", vnp_Command);
        vnp_Params.addProperty("vnp_TmnCode", vnp_TmnCode);
        vnp_Params.addProperty("vnp_TransactionType", vnp_TransactionType);
        vnp_Params.addProperty("vnp_TxnRef", vnp_TxnRef);
        vnp_Params.addProperty("vnp_Amount", vnp_Amount);
        vnp_Params.addProperty("vnp_OrderInfo", vnp_OrderInfo);

        if (vnp_TransactionNo != null && !vnp_TransactionNo.isEmpty()) {
            vnp_Params.addProperty("vnp_TransactionNo", "{get value of vnp_TransactionNo}");
        }

        vnp_Params.addProperty("vnp_TransactionDate", vnp_TransactionDate);
        vnp_Params.addProperty("vnp_CreateBy", vnp_CreateBy);
        vnp_Params.addProperty("vnp_CreateDate", vnp_CreateDate);
        vnp_Params.addProperty("vnp_IpAddr", vnp_IpAddr);

        String hash_Data = String.join("|", vnp_RequestId, vnp_Version, vnp_Command, vnp_TmnCode,
                vnp_TransactionType, vnp_TxnRef, vnp_Amount, vnp_TransactionNo, vnp_TransactionDate,
                vnp_CreateBy, vnp_CreateDate, vnp_IpAddr, vnp_OrderInfo);

        String vnp_SecureHash = Config.hmacSHA512(Config.secretKey, hash_Data.toString());

        vnp_Params.addProperty("vnp_SecureHash", vnp_SecureHash);

        URL url = new URL(Config.vnp_ApiUrl);
        HttpURLConnection con = (HttpURLConnection) url.openConnection();
        con.setRequestMethod("POST");
        con.setRequestProperty("Content-Type", "application/json");
        con.setDoOutput(true);
        DataOutputStream wr = new DataOutputStream(con.getOutputStream());
        wr.writeBytes(vnp_Params.toString());
        wr.flush();
        wr.close();
        int responseCode = con.getResponseCode();
        System.out.println("nSending 'POST' request to URL : " + url);
        System.out.println("Post Data : " + vnp_Params);
        System.out.println("Response Code : " + responseCode);
        BufferedReader in = new BufferedReader(
                new InputStreamReader(con.getInputStream()));
        String output;
        StringBuffer response = new StringBuffer();
        while ((output = in.readLine()) != null) {
            response.append(output);
        }
        in.close();
        System.out.println(response.toString());
        return response.toString();
    }

    public void createPaymentCOD(Long orderId) {
        Order order = orderRepository.findById(orderId).orElseThrow(() -> new EntityNotFoundException("Không tìm thấy đơn hàng (Order) với ID: " + orderId));

        Payment payment = Payment.builder()
                .method("COD")
                .orderId(orderId)
                .amount(order.getTotalAmount())
                .status("PENDING")
                .paidAt(LocalDateTime.now().toString())
                .build();
        paymentRepository.save(payment);
    }

    public Payment getPaymentById(Long id) {
        return paymentRepository.findById(id).orElse(null);
    }

    public Payment savePayment(Payment payment) {
        return paymentRepository.save(payment);
    }

    public void deletePayment(Long id) {
        paymentRepository.deleteById(id);
    }

    public List<Payment> getAllPayments() {
        return paymentRepository.findAll();
    }
}

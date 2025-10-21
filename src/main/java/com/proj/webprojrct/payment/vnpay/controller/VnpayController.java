package com.proj.webprojrct.payment.vnpay.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.TimeZone;

@Controller
public class VnpayController {

    // URL này khớp với URL VNPAY trả về
    @GetMapping("/payment/return")
    public String vnpayReturn(
            @RequestParam("vnp_Amount") String vnpAmount,
            @RequestParam("vnp_BankCode") String vnpBankCode,
            @RequestParam("vnp_OrderInfo") String vnpOrderInfo,
            @RequestParam("vnp_PayDate") String vnpPayDate,
            @RequestParam("vnp_ResponseCode") String vnpResponseCode,
            @RequestParam("vnp_TransactionNo") String vnpTransactionNo,
            @RequestParam("vnp_TxnRef") String vnpTxnRef,
            @RequestParam("vnp_SecureHash") String vnpSecureHash,
            Model model) {

        String message;
        String status;

        if ("00".equals(vnpResponseCode)) {
            status = "success";
            message = "Thanh toán thành công!";

            // TODO: Cập nhật trạng thái đơn hàng (vnp_TxnRef) trong CSDL
            // ví dụ: orderRepository.updateStatus(vnpTxnRef, "PAID");
        } else {
            // Giao dịch thất bại
            status = "error";
            message = "Thanh toán thất bại. Lỗi: " + vnpResponseCode;

            // TODO: Cập nhật trạng thái đơn hàng (vnp_TxnRef) trong CSDL
            // ví dụ: orderRepository.updateStatus(vnpTxnRef, "FAILED");
        }

        long amount = Long.parseLong(vnpAmount) / 100;
        DecimalFormat formatter = new DecimalFormat("#,### ₫");
        String formattedAmount = formatter.format(amount);

        // Format ngày giờ
        String formattedPayDate = "";
        try {
            SimpleDateFormat sdfIn = new SimpleDateFormat("yyyyMMddHHmmss");
            sdfIn.setTimeZone(TimeZone.getTimeZone("Etc/GMT+7")); // Múi giờ VNPAY
            Date payDate = sdfIn.parse(vnpPayDate);

            SimpleDateFormat sdfOut = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
            formattedPayDate = sdfOut.format(payDate);
        } catch (Exception e) {
            e.printStackTrace();
        }

        // BƯỚC 3: Gửi dữ liệu sang View (JSP)
        model.addAttribute("status", status);
        model.addAttribute("message", message);
        model.addAttribute("orderId", vnpTxnRef);
        model.addAttribute("amount", formattedAmount);
        model.addAttribute("orderInfo", vnpOrderInfo);
        model.addAttribute("bankCode", vnpBankCode);
        model.addAttribute("transactionNo", vnpTransactionNo);
        model.addAttribute("payDate", formattedPayDate);

        return "payment/return";
    }
}

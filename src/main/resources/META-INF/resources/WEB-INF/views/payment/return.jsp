<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<title>Kết quả thanh toán VNPAY</title>

<style>
    .payment-result-page {
        min-height: 80vh;
        display: flex;
        justify-content: center;
        align-items: center;
        padding: 40px 20px;
        background-color: #f4f6f8;
    }

    .result-container {
        background-color: #fff;
        padding: 40px 50px;
        border-radius: 12px;
        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        max-width: 480px;
        width: 100%;
        text-align: center;
        animation: fadeIn 0.4s ease-in;
    }

    .result-container h2 {
        color: #007BFF;
        margin-bottom: 20px;
        font-size: 28px;
    }

    .success {
        color: #28a745;
        font-weight: bold;
        font-size: 18px;
        margin-bottom: 15px;
    }

    .error {
        color: #dc3545;
        font-weight: bold;
        font-size: 18px;
        margin-bottom: 15px;
    }

    .info {
        background-color: #f8f9fa;
        border: 1px solid #dee2e6;
        border-radius: 8px;
        padding: 15px;
        margin-top: 15px;
        text-align: left;
    }

    .info p {
        margin: 8px 0;
        line-height: 1.6;
    }

    .button-group {
        margin-top: 25px;
        display: flex;
        gap: 15px;
        justify-content: center;
    }

    a.button {
        display: inline-block;
        padding: 12px 24px;
        color: white;
        background-color: #007BFF;
        border-radius: 6px;
        text-decoration: none;
        font-weight: bold;
        transition: background-color 0.3s;
    }

    a.button:hover {
        background-color: #0056b3;
    }

    a.button.secondary {
        background-color: #6c757d;
    }

    a.button.secondary:hover {
        background-color: #545b62;
    }

    @keyframes fadeIn {
        from {
            opacity: 0;
            transform: translateY(10px);
        }

        to {
            opacity: 1;
            transform: translateY(0);
        }
    }
</style>

<div class="payment-result-page">
    <div class="result-container">
        <h2>Kết quả thanh toán</h2>

        <c:choose>
            <c:when test="${success}">
                <p class="success">✓ Thanh toán thành công!</p>
                <div class="info">
                    <p><strong>Mã phản hồi:</strong> ${responseCode}</p>
                    <p><strong>Trạng thái giao dịch:</strong> ${transactionStatus}</p>
                    <p><strong>Thông điệp:</strong> ${transactionMessage}</p>
                </div>
            </c:when>
            <c:otherwise>
                <p class="error">✗ Thanh toán thất bại!</p>
                <div class="info">
                    <p><strong>Lý do:</strong> ${message}</p>
                </div>
            </c:otherwise>
        </c:choose>

        <div class="button-group">
            <a href="${pageContext.request.contextPath}/" class="button">Trang chủ</a>
            <a href="${pageContext.request.contextPath}/order" class="button secondary">Đơn hàng của tôi</a>
        </div>
    </div>
</div>
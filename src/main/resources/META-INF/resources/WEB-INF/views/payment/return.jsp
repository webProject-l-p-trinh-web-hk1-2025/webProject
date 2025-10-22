<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <html>

        <head>
            <title>Kết quả thanh toán VNPAY</title>
            <style>
                body {
                    font-family: "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
                    background-color: #f4f6f8;
                    color: #333;
                    display: flex;
                    justify-content: center;
                    align-items: center;
                    height: 100vh;
                    margin: 0;
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

                h2 {
                    color: #007BFF;
                    margin-bottom: 20px;
                }

                .success {
                    color: #28a745;
                    font-weight: bold;
                }

                .error {
                    color: #dc3545;
                    font-weight: bold;
                }

                .info {
                    background-color: #f8f9fa;
                    border: 1px solid #dee2e6;
                    border-radius: 8px;
                    padding: 15px;
                    margin-top: 15px;
                    text-align: left;
                }

                a.button {
                    display: inline-block;
                    margin-top: 25px;
                    padding: 10px 20px;
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
        </head>

        <body>
            <div class="result-container">
                <h2>Kết quả thanh toán</h2>

                <c:choose>
                    <c:when test="${success}">
                        <p class="success">Thanh toán thành công!</p>
                        <div class="info">
                            <p><strong>Mã phản hồi:</strong> ${responseCode}</p>
                            <p><strong>Trạng thái giao dịch:</strong> ${transactionStatus}</p>
                            <p><strong>Thông điệp:</strong> ${transactionMessage}</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <p class="error">Thanh toán thất bại!</p>
                        <div class="info">
                            <p><strong>Lý do:</strong> ${message}</p>
                        </div>
                    </c:otherwise>
                </c:choose>

                <a href="/" class="button">Quay lại trang chủ</a>
            </div>
        </body>

        </html>
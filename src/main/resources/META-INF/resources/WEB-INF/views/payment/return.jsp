<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <html>

        <head>
            <title>Kết quả thanh toán</title>
            <style>
                body {
                    font-family: Arial, sans-serif;
                    background-color: #f4f4f4;
                    display: flex;
                    justify-content: center;
                    align-items: center;
                    height: 100vh;
                    margin: 0;
                }

                .container {
                    background: #fff;
                    padding: 30px;
                    border-radius: 10px;
                    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
                    width: 500px;
                    text-align: center;
                    border-top: 5px solid;
                }

                /* Màu dựa trên trạng thái */
                .success {
                    border-color: #28a745;
                }

                .error {
                    border-color: #dc3545;
                }

                .icon {
                    font-size: 50px;
                    margin-bottom: 20px;
                }

                .success .icon {
                    color: #28a745;
                }

                .error .icon {
                    color: #dc3545;
                }

                h1 {
                    font-size: 24px;
                    margin-bottom: 20px;
                }

                .success h1 {
                    color: #28a745;
                }

                .error h1 {
                    color: #dc3545;
                }

                .info-table {
                    width: 100%;
                    margin-top: 25px;
                    text-align: left;
                }

                .info-table td {
                    padding: 10px 5px;
                    border-bottom: 1px solid #eee;
                }

                .info-table td:first-child {
                    font-weight: 600;
                    color: #555;
                    width: 40%;
                }

                .info-table td:last-child {
                    font-weight: 500;
                    color: #333;
                }

                .amount {
                    font-size: 22px;
                    font-weight: bold;
                    color: #d70018;
                    /* Màu đỏ */
                }

                .btn-group {
                    margin-top: 30px;
                }

                .btn {
                    display: inline-block;
                    padding: 12px 25px;
                    margin: 0 10px;
                    border-radius: 5px;
                    text-decoration: none;
                    color: #fff;
                    font-weight: bold;
                    transition: background 0.3s;
                }

                .btn-primary {
                    background-color: #007bff;
                }

                .btn-primary:hover {
                    background-color: #0056b3;
                }

                .btn-secondary {
                    background-color: #6c757d;
                }

                .btn-secondary:hover {
                    background-color: #5a6268;
                }
            </style>
        </head>

        <body>

            <%-- Dùng JSTL để kiểm tra biến 'status' được gửi từ Controller --%>
                <c:choose>
                    <%-- TRƯỜNG HỢP THÀNH CÔNG --%>
                        <c:when test="${status == 'success'}">
                            <div class="container success">
                                <div class="icon">✓</div>
                                <h1>${message}</h1>
                                <p>Cảm ơn bạn đã hoàn tất thanh toán.</p>
                                <div class="amount">${amount}</div>

                                <table class="info-table">
                                    <tr>
                                        <td>Mã đơn hàng:</td>
                                        <td>${orderId}</td>
                                    </tr>
                                    <tr>
                                        <td>Nội dung:</td>
                                        <td>${orderInfo}</td>
                                    </tr>
                                    <tr>
                                        <td>Ngân hàng:</td>
                                        <td>${bankCode}</td>
                                    </tr>
                                    <tr>
                                        <td>Mã giao dịch VNPAY:</td>
                                        <td>${transactionNo}</td>
                                    </tr>
                                    <tr>
                                        <td>Thời gian thanh toán:</td>
                                        <td>${payDate}</td>
                                    </tr>
                                </table>
                            </div>
                        </c:when>

                        <%-- TRƯỜNG HỢP THẤT BẠI --%>
                            <c:when test="${status == 'error'}">
                                <div class="container error">
                                    <div class="icon">✗</div>
                                    <h1>${message}</h1>
                                    <p>Đã xảy ra lỗi trong quá trình thanh toán. Vui lòng thử lại.</p>

                                    <table class="info-table">
                                        <tr>
                                            <td>Mã đơn hàng:</td>
                                            <td>${orderId}</td>
                                        </tr>
                                        <tr>
                                            <td>Nội dung:</td>
                                            <td>${orderInfo}</td>
                                        </tr>
                                    </table>
                                </div>
                            </c:when>
                </c:choose>

                <div class="btn-group">
                    <%-- Link về trang chủ hoặc trang đơn hàng --%>
                        <a href="/shop" class="btn btn-secondary">Tiếp tục mua sắm</a>
                        <a href="/order/${orderId}" class="btn btn-primary">Xem chi tiết đơn hàng</a>
                </div>

        </body>

        </html>
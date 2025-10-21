<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

        <html>

        <head>
            <title>Đặt hàng thành công</title>
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <style>
                body {
                    font-family: Arial, sans-serif;
                    background-color: #f4f4f4;
                    display: flex;
                    justify-content: center;
                    align-items: center;
                    height: 100vh;
                    margin: 0;
                    padding: 20px;
                    box-sizing: border-box;
                }

                .container {
                    background: #fff;
                    padding: 30px 40px;
                    border-radius: 10px;
                    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
                    width: 500px;
                    max-width: 100%;
                    text-align: center;
                    border-top: 5px solid #28a745;
                    /* Màu xanh lá thành công */
                }

                .icon {
                    font-size: 60px;
                    color: #28a745;
                    margin-bottom: 20px;
                    line-height: 1;
                }

                h1 {
                    font-size: 26px;
                    margin: 0 0 15px 0;
                    color: #28a745;
                }

                p {
                    font-size: 16px;
                    color: #555;
                    line-height: 1.6;
                    margin-bottom: 30px;
                }

                .btn-group {
                    margin-top: 20px;
                    display: flex;
                    flex-direction: column;
                    gap: 10px;
                }

                .btn {
                    display: inline-block;
                    padding: 12px 25px;
                    border-radius: 5px;
                    text-decoration: none;
                    color: #fff;
                    font-weight: bold;
                    transition: background 0.3s;
                    font-size: 16px;
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

            <div class="container">
                <div class="icon">✓</div>
                <h1>Đặt hàng thành công!</h1>

                <p>
                    Cảm ơn bạn đã mua hàng.
                    <c:if test="${not empty orderId}">
                        Mã đơn hàng của bạn là <strong>#${orderId}</strong>.
                    </c:if>
                    <br>
                    Chúng tôi sẽ liên hệ với bạn sớm nhất để xác nhận đơn hàng.
                </p>

                <div class="btn-group">
                    <%-- Hiển thị nút "Xem chi tiết" chỉ khi có orderId --%>
                        <c:if test="${not empty orderId}">
                            <a href="/order/${orderId}" class="btn btn-primary">Xem chi tiết đơn hàng</a>
                        </c:if>

                        <a href="/shop" class="btn btn-secondary">Tiếp tục mua sắm</a>
                </div>
            </div>

        </body>

        </html>
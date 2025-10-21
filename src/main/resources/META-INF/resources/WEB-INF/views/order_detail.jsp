<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

            <html>

            <head>
                <title>Chi tiết đơn hàng</title>
                <style>
                    body {
                        font-family: Arial, sans-serif;
                        margin: 20px;
                        background: #f8f8f8;
                    }

                    .container {
                        max-width: 900px;
                        margin: auto;
                        background: #fff;
                        padding: 20px;
                        border-radius: 8px;
                    }

                    h1 {
                        color: #d70018;
                    }

                    .order-info,
                    .user-info {
                        margin-bottom: 20px;
                    }

                    .order-info div,
                    .user-info div {
                        margin-bottom: 5px;
                    }

                    table {
                        width: 100%;
                        border-collapse: collapse;
                        margin-top: 10px;
                    }

                    th,
                    td {
                        border: 1px solid #ddd;
                        padding: 8px;
                        text-align: center;
                    }

                    th {
                        background-color: #f2f2f2;
                    }

                    .product-img {
                        width: 80px;
                        height: 80px;
                        object-fit: cover;
                        border-radius: 4px;
                    }

                    .status {
                        font-weight: bold;
                    }

                    /* CSS cho phần thanh toán */
                    .payment-section {
                        margin-top: 30px;
                        text-align: center;
                        border-top: 1px solid #eee;
                        padding-top: 20px;
                    }

                    .payment-section select {
                        padding: 10px;
                        font-size: 16px;
                        border-radius: 5px;
                        border: 1px solid #ccc;
                    }

                    .payment-section button,
                    .payment-section .btn-link {
                        padding: 12px 25px;
                        text-decoration: none;
                        border-radius: 5px;
                        margin-left: 10px;
                        font-size: 16px;
                        cursor: pointer;
                        border: none;
                        font-weight: bold;
                    }

                    .btn-link {
                        display: inline-block;
                        background: #555;
                        color: white;
                    }

                    #confirm-purchase-btn {
                        background: #28a745;
                        /* Màu xanh lá */
                        color: white;
                    }

                    #confirm-purchase-btn:disabled {
                        background: #aaa;
                        cursor: not-allowed;
                    }
                </style>
            </head>

            <body>
                <div class="container">
                    <h1>Chi tiết đơn hàng #${order.orderId}</h1>

                    <%-- Thông tin người nhận --%>
                        <div class="user-info">
                            <h3>Thông tin người nhận</h3>
                            <div><strong>Họ tên:</strong> ${user.fullName}</div>
                            <div><strong>Email:</strong> ${user.email}</div>
                            <div><strong>Số điện thoại:</strong> ${user.phone}</div>
                            <div><strong>Địa chỉ giao hàng:</strong> ${order.shippingAddress}</div>
                        </div>

                        <%-- Thông tin đơn hàng --%>
                            <div class="order-info">
                                <h3>Thông tin đơn hàng</h3>
                                <div><strong>Trạng thái:</strong> <span class="status">${order.status}</span></div>
                                <div><strong>Ngày tạo:</strong> ${order.createdAt}</div>
                                <div><strong>Tổng tiền:</strong>
                                    <fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="₫" />
                                </div>
                            </div>

                            <%-- Sản phẩm trong đơn hàng --%>
                                <h3>Sản phẩm trong đơn hàng</h3>
                                <table>
                                    <thead>
                                        <tr>
                                            <th>Ảnh</th>
                                            <th>Tên sản phẩm</th>
                                            <th>Đơn giá</th>
                                            <th>Số lượng</th>
                                            <th>Thành tiền</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="item" items="${order.items}">
                                            <tr>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty item.productImageUrl}">
                                                            <img class="product-img" src="${item.productImageUrl}"
                                                                alt="${item.productName}" />
                                                        </c:when>
                                                        <c:otherwise>
                                                            <img class="product-img" src="/images/no-image.png"
                                                                alt="No Image" />
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>${item.productName}</td>
                                                <td>
                                                    <fmt:formatNumber value="${item.price}" type="currency"
                                                        currencySymbol="₫" />
                                                </td>
                                                <td>${item.quantity}</td>
                                                <td>
                                                    <fmt:formatNumber value="${item.price * item.quantity}"
                                                        type="currency" currencySymbol="₫" />
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>

                                <c:if test="${order.status == 'PENDING'}">
                                    <div class="payment-section">
                                        <div style="margin-bottom: 15px;">
                                            <label for="payment-method" style="font-size: 18px; margin-right: 10px;">
                                                <strong>Chọn phương thức thanh toán:</strong>
                                            </label>
                                            <select id="payment-method">
                                                <option value="COD">Thanh toán khi nhận hàng (COD)
                                                </option>
                                                <option value="VNPAY">Thanh toán qua VNPAY</option>
                                            </select>
                                        </div>

                                        <a href="/order" class="btn-link" style="background: #d70018;">Quay lại</a>

                                        <%-- Nút này gọi hàm JavaScript mới bên dưới --%>
                                            <button id="confirm-purchase-btn"
                                                onclick="confirmPurchase(${order.orderId})">
                                                Xác nhận mua hàng
                                            </button>
                                    </div>
                                </c:if>

                                <%-- Nếu đơn hàng đã hoàn tất/hủy --%>
                                    <c:if test="${order.status != 'PENDING'}">
                                        <div style="margin-top: 20px; text-align: center;">
                                            <a href="/order"
                                                style="padding: 10px 20px; background: #d70018; color: white; text-decoration: none; border-radius: 5px;">
                                                Quay lại danh sách đơn hàng
                                            </a>
                                        </div>
                                    </c:if>

                </div>

                <script>
                    function confirmPurchase(orderId) {
                        const method = document.getElementById('payment-method').value;
                        const confirmBtn = document.getElementById('confirm-purchase-btn');

                        // Vô hiệu hóa nút để tránh nhấn đúp
                        confirmBtn.disabled = true;
                        confirmBtn.textContent = 'Đang xử lý...';
                        console.log(`/api/vnpay/payment/create_payment?orderId=${orderId}&method=${method}`);
                        console.log('Đang gọi API thanh toán cho orderId:', orderId, 'với phương thức:', method);
                        debugger;
                        // Gọi API Controller duy nhất của bạn
                        // Sử dụng template literals (dấu `) để chèn biến vào URL


                        console.log(`/api/vnpay/payment/create_payment?orderId=${orderId}&method=${method}`);
                        if (method === "COD") {
                            fetch(`/api/vnpay/payment/create_payment?orderId=${orderId}&method=COD`, {
                                method: 'GET', // Phải khớp với @GetMapping
                                headers: {
                                    // QUAN TRỌNG: Nếu API của bạn được bảo vệ bằng Spring Security (JWT),
                                    // bạn phải gửi kèm Token
                                    'Authorization': 'Bearer ' + localStorage.getItem('accessToken')
                                }
                            })
                                .then(response => {
                                    if (!response.ok) {
                                        // Bắt lỗi 4xx, 5xx từ server
                                        throw new Error('Xử lý thanh toán thất bại. Lỗi: ' + response.status);
                                    }
                                    return response.json(); // Đọc response body dạng JSON
                                })
                                .then(data => {
                                    // Xử lý JSON (PaymentResDto) trả về
                                    // API của bạn luôn trả về một đối tượng có 'url'
                                    // - Nếu VNPAY: data.url là link của VNPAY
                                    // - Nếu COD: data.url là link trang thành công (vd: /order/success/123)
                                    if (data && data.url) {
                                        console.log('API thành công. Đang chuyển hướng đến:', data.url);
                                        window.location.href = data.url;
                                    } else {
                                        throw new Error('Response từ server không hợp lệ (không có url).');
                                    }
                                })
                                .catch(error => {
                                    // Xử lý nếu fetch bị lỗi mạng, hoặc lỗi logic ở trên
                                    console.error('Lỗi khi gọi API thanh toán:', error);
                                    alert('Có lỗi xảy ra: ' + error.message);

                                    // Kích hoạt lại nút để người dùng thử lại
                                    confirmBtn.disabled = false;
                                    confirmBtn.textContent = 'Xác nhận mua hàng';
                                });
                        } else {
                            fetch(`/api/vnpay/payment/create_payment?orderId=${orderId}&method=method=${method}`, {
                                method: 'GET', // Phải khớp với @GetMapping
                                headers: {
                                    // QUAN TRỌNG: Nếu API của bạn được bảo vệ bằng Spring Security (JWT),
                                    // bạn phải gửi kèm Token
                                    'Authorization': 'Bearer ' + localStorage.getItem('accessToken')
                                }
                            })
                                .then(response => {
                                    if (!response.ok) {
                                        // Bắt lỗi 4xx, 5xx từ server
                                        throw new Error('Xử lý thanh toán thất bại. Lỗi: ' + response.status);
                                    }
                                    return response.json(); // Đọc response body dạng JSON
                                })
                                .then(data => {
                                    // Xử lý JSON (PaymentResDto) trả về
                                    // API của bạn luôn trả về một đối tượng có 'url'
                                    // - Nếu VNPAY: data.url là link của VNPAY
                                    // - Nếu COD: data.url là link trang thành công (vd: /order/success/123)
                                    if (data && data.url) {
                                        console.log('API thành công. Đang chuyển hướng đến:', data.url);
                                        window.location.href = data.url;
                                    } else {
                                        throw new Error('Response từ server không hợp lệ (không có url).');
                                    }
                                })
                                .catch(error => {
                                    // Xử lý nếu fetch bị lỗi mạng, hoặc lỗi logic ở trên
                                    console.error('Lỗi khi gọi API thanh toán:', error);
                                    alert('Có lỗi xảy ra: ' + error.message);

                                    // Kích hoạt lại nút để người dùng thử lại
                                    confirmBtn.disabled = false;
                                    confirmBtn.textContent = 'Xác nhận mua hàng';
                                });
                        }
                    }
                </script>
            </body>

            </html>
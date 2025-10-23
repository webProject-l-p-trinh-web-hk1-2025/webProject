<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

            <html>

            <head>
                <title>Xác nhận đơn hàng</title>
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <style>
                    body {
                        font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
                        background-color: #f4f7f6;
                        margin: 0;
                        padding: 20px;
                        display: flex;
                        justify-content: center;
                    }

                    .container {
                        max-width: 900px;
                        width: 100%;
                        background: #ffffff;
                        border-radius: 8px;
                        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
                        overflow: hidden;
                    }

                    h1 {
                        text-align: center;
                        color: #333;
                        padding: 20px 25px;
                        margin: 0;
                        border-bottom: 1px solid #eee;
                    }

                    .content {
                        display: flex;
                        flex-wrap: wrap;
                        padding: 25px;
                        gap: 25px;
                    }

                    .user-info,
                    .order-summary {
                        flex: 1;
                        min-width: 300px;
                    }

                    h3 {
                        color: #d70018;
                        border-bottom: 2px solid #f0f0f0;
                        padding-bottom: 10px;
                        margin-top: 0;
                    }

                    .user-info p {
                        margin: 10px 0;
                        line-height: 1.6;
                    }

                    .user-info strong {
                        color: #555;
                        min-width: 100px;
                        display: inline-block;
                    }

                    .user-info input[type="text"] {
                        width: calc(100% - 20px);
                        padding: 10px;
                        border: 1px solid #ccc;
                        border-radius: 5px;
                        font-size: 15px;
                    }

                    .user-info label {
                        font-weight: bold;
                        display: block;
                        margin-bottom: 5px;
                        color: #555;
                    }

                    .order-item {
                        display: flex;
                        gap: 15px;
                        padding: 12px 0;
                        border-bottom: 1px solid #f0f0f0;
                        align-items: center;
                    }

                    .order-item:last-child {
                        border-bottom: none;
                    }

                    .item-details {
                        flex: 1;
                    }

                    .item-name {
                        font-weight: 600;
                        color: #333;
                        margin: 0;
                    }

                    .item-info {
                        font-size: 0.9em;
                        color: #777;
                        margin: 4px 0 0;
                    }

                    .item-price {
                        font-weight: 600;
                        color: #333;
                        white-space: nowrap;
                    }

                    .total-summary {
                        margin-top: 20px;
                        border-top: 2px solid #f0f0f0;
                        padding-top: 15px;
                        font-size: 1.4em;
                        font-weight: bold;
                        color: #d70018;
                        text-align: right;
                    }

                    .button-container {
                        padding: 25px;
                        background-color: #f9f9f9;
                        border-top: 1px solid #eee;
                        text-align: right;
                    }

                    #confirm-btn {
                        padding: 14px 28px;
                        font-size: 17px;
                        background: #28a745;
                        color: white;
                        border: none;
                        border-radius: 5px;
                        cursor: pointer;
                        font-weight: bold;
                        transition: background 0.2s;
                    }

                    #confirm-btn:hover {
                        background: #218838;
                    }

                    #confirm-btn:disabled {
                        background: #aaa;
                        cursor: not-allowed;
                    }

                    #message-container {
                        text-align: center;
                        padding: 0 25px 10px;
                        font-weight: bold;
                    }

                    .msg-success {
                        color: #28a745;
                    }

                    .msg-error {
                        color: #dc3545;
                    }

                    .msg-info {
                        color: #007bff;
                    }
                </style>
            </head>

            <body>
                <div class="container">
                    <h1>Xác nhận đơn hàng</h1>

                    <div id="message-container"></div>

                    <div class="content">
                        <!-- Thông tin người dùng -->
                        <div class="user-info">
                            <h3>Thông tin giao hàng</h3>
                            <p><strong>Khách hàng:</strong> ${user.fullName}</p>
                            <p><strong>Email:</strong> ${user.email}</p>
                            <p><strong>Số điện thoại:</strong> ${user.phone}</p>
                            <div>
                                <label for="shippingAddress">Địa chỉ giao hàng:</label>
                                <input type="text" id="shippingAddress" value="${user.address}"
                                    placeholder="Nhập địa chỉ của bạn">
                            </div>
                            <div id="shipping-address"></div>
                        </div>

                        <!-- Tóm tắt đơn hàng -->
                        <div class="order-summary">
                            <h3>Tóm tắt đơn hàng</h3>
                            <div id="order-items-list"></div>
                            <div id="total" class="total-summary"></div>
                        </div>
                    </div>

                    <div class="button-container">
                        <button id="confirm-btn" onclick="confirmAndCreateOrder()">Xác nhận và Tạo đơn hàng</button>
                    </div>
                </div>

                <script>
                    var pendingOrderData;
                    const confirmBtn = document.getElementById('confirm-btn');
                    const messageContainer = document.getElementById('message-container');

                    // 1. Lấy các thẻ DIV quan trọng
                    const itemsListDiv = document.getElementById('order-items-list');
                    const totalDiv = document.getElementById('total');

                    // 2. Chạy khi trang tải xong
                    document.addEventListener('DOMContentLoaded', function () {

                        console.log("Trang order_create.jsp đã tải xong.");

                        // 3. Kiểm tra xem có tìm thấy các thẻ DIV không?
                        if (!itemsListDiv || !totalDiv) {
                            console.error("LỖI NGHIÊM TRỌNG: Không tìm thấy div 'order-items-list' hoặc 'total'.");
                            return;
                        }
                        console.log("Đã tìm thấy các DIV 'order-items-list' và 'total'.");

                        // 4. Lấy dữ liệu từ sessionStorage
                        const dataString = sessionStorage.getItem('pendingOrder');
                        if (!dataString) {
                            alert('Không tìm thấy thông tin đơn hàng. Vui lòng thử lại.');
                            window.location.href = '/cart'; // Trang giỏ hàng của bạn
                            return;
                        }
                        console.log('Đã lấy được dataString từ sessionStorage:', dataString);

                        try {
                            // 5. Thử parse JSON (chuyển chuỗi thành đối tượng)
                            pendingOrderData = JSON.parse(dataString);
                            console.log('Parse JSON thành công:', pendingOrderData);

                            // 6. Gọi hàm render
                            renderOrderSummary(pendingOrderData);

                        } catch (e) {
                            console.error("LỖI NGHIÊM TRỌNG KHI PARSE JSON:", e);
                            alert('Lỗi đọc dữ liệu đơn hàng. Vui lòng quay lại giỏ hàng.');
                        }
                    });

                    // HÀM MỚI (CHỐNG LỖI CÚ PHÁP)
                    function renderOrderSummary(data) {
                        console.log('Đang chạy hàm renderOrderSummary...');

                        if (!data || !Array.isArray(data.orderItems)) {
                            console.error("LỖI: data.orderItems không tồn tại hoặc không phải là mảng.", data);
                            return;
                        }

                        console.log('Tìm thấy ' + data.orderItems.length + ' sản phẩm để render.');

                        itemsListDiv.innerHTML = ''; // Xóa nội dung cũ

                        data.orderItems.forEach(function (item, index) {
                            console.log('Đang render sản phẩm ' + index + ':', item);

                            var itemDiv = document.createElement('div');
                            itemDiv.className = 'order-item';

                            var productName = item.productName || 'Sản phẩm (ID: ' + item.productId + ')';
                            var price = (item.price * item.quantity).toLocaleString('vi-VN');

                            // Dùng dấu '+' để nối chuỗi (an toàn hơn)
                            itemDiv.innerHTML =
                                '<div class="item-details">' +
                                '<p class="item-name">' + productName + '</p>' +
                                '<p class="item-info">Số lượng: ' + item.quantity + '</p>' +
                                '</div>' +
                                '<div class="item-price">' + price + ' ₫</div>';

                            itemsListDiv.appendChild(itemDiv);
                        });

                        console.log('Render tổng tiền...');
                        // Dùng dấu '+' để nối chuỗi
                        totalDiv.innerHTML = 'Tổng cộng: ' + data.totalAmount.toLocaleString('vi-VN') + ' ₫';
                        console.log('RENDER HOÀN TẤT!');
                    }

                    // 9. Hàm xác nhận đơn hàng (giữ nguyên, không sửa)
                    function confirmAndCreateOrder() {
                        debugger;
                        if (!pendingOrderData) {
                            alert('Lỗi: Dữ liệu đơn hàng không tồn tại.');
                            return;
                        }
                        const shippingAddress = document.getElementById('shippingAddress').value;
                        if (!shippingAddress) {
                            alert('Vui lòng nhập địa chỉ giao hàng.');
                            return;
                        }
                        // ... (Code fetch API của bạn) ...
                        confirmBtn.disabled = true;
                        confirmBtn.textContent = 'Đang xử lý...';
                        showMessage('Đang tạo đơn hàng...', 'msg-info');
                        pendingOrderData.shippingAddress = shippingAddress;
                        fetch('/api/orders/create', {
                            method: 'POST',
                            headers: { 'Content-Type': 'application/json' },
                            credentials: 'include',
                            body: JSON.stringify(pendingOrderData)
                        })
                            .then(function (response) {
                                if (response.status === 401 || response.status === 403) {
                                    window.location.href = '/login';
                                    throw new Error('Chưa đăng nhập hoặc không có quyền.');
                                }
                                if (!response.ok) {
                                    throw new Error('Lỗi khi tạo đơn hàng. Mã lỗi: ' + response.status);
                                }
                                return response.json();
                            })
                            .then(function (order) {
                                showMessage('Tạo đơn hàng thành công! Mã đơn: ' + order.orderId, 'msg-success');
                                sessionStorage.removeItem('pendingOrder');
                                window.location.href = '/order/' + order.orderId;
                            })
                            .catch(function (error) {
                                console.error('Error:', error);
                                showMessage('Lỗi khi tạo đơn hàng: ' + error.message, 'msg-error');
                                confirmBtn.disabled = false;
                                confirmBtn.textContent = 'Xác nhận và Tạo đơn hàng';
                            });
                    }

                    function showMessage(message, type) {
                        messageContainer.textContent = message;
                        messageContainer.className = type;
                    }
                </script>
            </body>

            </html>
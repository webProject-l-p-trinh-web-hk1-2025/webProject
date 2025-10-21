<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

            <html>

            <head>
                <title>Xác nhận đơn hàng</title>
                <style>
                    /* (Bạn có thể thêm CSS cho đẹp) */
                    body {
                        font-family: Arial, sans-serif;
                        max-width: 800px;
                        margin: auto;
                        padding: 20px;
                    }

                    .container {
                        display: flex;
                        gap: 30px;
                    }

                    .user-info,
                    .order-summary {
                        flex: 1;
                        border: 1px solid #ccc;
                        padding: 15px;
                        border-radius: 8px;
                    }

                    .order-item {
                        display: flex;
                        justify-content: space-between;
                        border-bottom: 1px solid #eee;
                        padding: 5px 0;
                    }

                    #total {
                        font-size: 1.2em;
                        font-weight: bold;
                        color: #d70018;
                        margin-top: 10px;
                    }

                    #confirm-btn {
                        padding: 15px;
                        font-size: 18px;
                        background: #28a745;
                        color: white;
                        border: none;
                        border-radius: 5px;
                        cursor: pointer;
                        margin-top: 20px;
                        width: 100%;
                    }

                    #confirm-btn:disabled {
                        background: #aaa;
                    }
                </style>
            </head>

            <body>

                <h1>Xác nhận đơn hàng của bạn</h1>
                <div class="container">

                    <div class="user-info">
                        <h3>Thông tin giao hàng</h3>
                        <p><strong>Khách hàng:</strong> ${user.fullName}</p>
                        <p><strong>Email:</strong> ${user.email}</p>
                        <p><strong>Số điện thoại:</strong> ${user.phone}</p>
                        <div>
                            <label for="shippingAddress" style="font-weight: bold;">Địa chỉ giao hàng:</label>
                            <input type="text" id="shippingAddress" value="${user.address}"
                                style="width: 95%; padding: 5px;">
                        </div>
                    </div>

                    <div class="order-summary">
                        <h3>Tóm tắt đơn hàng</h3>
                        <div id="order-items-list">
                        </div>
                        <div id="total">
                        </div>
                    </div>

                </div>

                <button id="confirm-btn" onclick="confirmAndCreateOrder()">
                    Xác nhận và Tạo đơn hàng
                </button>
                <div id="message-container" style="margin-top: 10px; text-align: center;"></div>


                <script>
                    // Khai báo biến toàn cục để lưu dữ liệu đơn hàng
                    var pendingOrderData;
                    const confirmBtn = document.getElementById('confirm-btn');
                    const messageContainer = document.getElementById('message-container');

                    // 3. Chạy ngay khi trang được tải xong
                    document.addEventListener('DOMContentLoaded', function () {
                        // Đọc dữ liệu từ sessionStorage
                        const dataString = sessionStorage.getItem('pendingOrder');

                        if (!dataString) {
                            // Nếu không có dữ liệu (ví dụ: user F5 trang), quay về giỏ hàng
                            alert('Không tìm thấy thông tin đơn hàng. Vui lòng thử lại.');
                            window.location.href = '/cart'; // (Hoặc trang giỏ hàng của bạn)
                            return;
                        }

                        // Chuyển chuỗi JSON thành object
                        pendingOrderData = JSON.parse(dataString);

                        // Hiển thị dữ liệu lên trang
                        renderOrderSummary(pendingOrderData);
                    });

                    function renderOrderSummary(data) {
                        const itemsListDiv = document.getElementById('order-items-list');
                        const totalDiv = document.getElementById('total');

                        // Xóa nội dung cũ (nếu có)
                        itemsListDiv.innerHTML = '';

                        // Lặp qua các sản phẩm và tạo HTML
                        data.orderItems.forEach(function (item) {
                            const itemDiv = document.createElement('div');
                            itemDiv.className = 'order-item';
                            itemDiv.innerHTML = `
                    <span>${item.productId} (x${item.quantity})</span>
                    <span>${(item.price * item.quantity).toLocaleString('vi-VN')} ₫</span>
                `;
                            itemsListDiv.appendChild(itemDiv);
                        });

                        // Hiển thị tổng tiền
                        totalDiv.innerHTML = `Tổng cộng: ${data.totalAmount.toLocaleString('vi-VN')} ₫`;
                    }

                    // 4. Hàm này được gọi khi nhấn nút "Xác nhận"
                    function confirmAndCreateOrder() {
                        if (!pendingOrderData) {
                            alert('Lỗi: Dữ liệu đơn hàng không tồn tại.');
                            return;
                        }

                        // Vô hiệu hóa nút
                        confirmBtn.disabled = true;
                        confirmBtn.textContent = 'Đang xử lý...';
                        showMessage('Đang tạo đơn hàng...', 'info');

                        // Cập nhật địa chỉ giao hàng từ ô input
                        pendingOrderData.shippingAddress = document.getElementById('shippingAddress').value;

                        // Đây là logic fetch GỐC của bạn, được chuyển về đây
                        fetch('/api/orders/create', {
                            method: 'POST',
                            headers: {
                                'Content-Type': 'application/json',
                                // QUAN TRỌNG: Thêm header Authorization nếu API của bạn yêu cầu (JWT)
                                'Authorization': 'Bearer ' + localStorage.getItem('accessToken')
                            },
                            credentials: 'include', // Gửi cookie (nếu bạn dùng session)
                            body: JSON.stringify(pendingOrderData)
                        })
                            .then(function (response) {
                                if (!response.ok) {
                                    if (response.status === 401) {
                                        window.location.href = '/login';
                                        throw new Error('Chưa đăng nhập');
                                    }
                                    throw new Error('Lỗi khi tạo đơn hàng');
                                }
                                return response.json();
                            })
                            .then(function (order) {
                                showMessage('Tạo đơn hàng thành công! Mã đơn: ' + order.orderId, 'success');

                                // Xóa dữ liệu tạm sau khi thành công
                                sessionStorage.removeItem('pendingOrder');

                                // Chuyển sang trang chi tiết đơn hàng (hoặc trang thanh toán)
                                window.location.href = '/order/' + order.orderId;
                            })
                            .catch(function (error) {
                                console.error('Error:', error);
                                showMessage('Lỗi khi tạo đơn hàng: ' + error.message, 'error');

                                // Kích hoạt lại nút
                                confirmBtn.disabled = false;
                                confirmBtn.textContent = 'Xác nhận và Tạo đơn hàng';
                            });
                    }

                    function showMessage(message, type) {
                        messageContainer.textContent = message;
                        messageContainer.className = type; // (Bạn có thể CSS .info, .success, .error)
                    }
                </script>
            </body>

            </html>
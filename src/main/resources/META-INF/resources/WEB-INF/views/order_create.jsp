<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Xác nhận đơn hàng - CellPhoneStore</title>
    <style>
/* Order Page Styles */
.order-title {
    color: #333;
    margin-bottom: 30px;
    font-size: 28px;
    font-weight: bold;
    text-align: center;
}

.order-form-section {
    background: white;
    border-radius: 8px;
    padding: 30px;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
    margin-bottom: 20px;
}

.form-section-title {
    font-size: 20px;
    font-weight: bold;
    margin-bottom: 20px;
    padding-bottom: 15px;
    border-bottom: 2px solid #e0e0e0;
    color: #333;
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
    width: 100%;
    padding: 12px 15px;
    border: 1px solid #ddd;
    border-radius: 6px;
    font-size: 14px;
    transition: border-color 0.3s;
    margin-top: 8px;
}

.user-info input[type="text"]:focus {
    outline: none;
    border-color: #d70018;
}

.user-info label {
    font-weight: 600;
    display: block;
    margin-bottom: 5px;
    margin-top: 15px;
    color: #555;
}

.order-summary {
    background: white;
    border-radius: 8px;
    padding: 25px;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
    position: sticky;
    top: 20px;
}

.order-summary-title {
    font-size: 20px;
    font-weight: bold;
    margin-bottom: 20px;
    padding-bottom: 15px;
    border-bottom: 2px solid #e0e0e0;
    color: #333;
}

.order-item {
    display: flex;
    gap: 15px;
    padding: 15px 0;
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
    color: #666;
    margin: 4px 0 0;
}

.item-price {
    font-weight: bold;
    color: #d70018;
    white-space: nowrap;
}

.total-summary {
    margin-top: 20px;
    border-top: 2px solid #e0e0e0;
    padding-top: 15px;
    font-size: 18px;
    font-weight: bold;
    color: #d70018;
    text-align: right;
}

.btn-place-order {
    width: 100%;
    padding: 15px;
    margin-top: 20px;
    background: linear-gradient(135deg, #d70018 0%, #f05423 100%);
    color: white;
    border: none;
    border-radius: 8px;
    font-size: 16px;
    font-weight: bold;
    cursor: pointer;
    transition: transform 0.2s;
}

.btn-place-order:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 12px rgba(215, 0, 24, 0.3);
}

.btn-place-order:disabled {
    background: #aaa;
    cursor: not-allowed;
    transform: none;
}

#message-container {
    text-align: center;
    padding: 15px;
    margin-bottom: 20px;
    font-weight: bold;
    border-radius: 6px;
}

.msg-success {
    background: #d4edda;
    color: #155724;
    border: 1px solid #c3e6cb;
}

.msg-error {
    background: #f8d7da;
    color: #721c24;
    border: 1px solid #f5c6cb;
}

.msg-info {
    background: #d1ecf1;
    color: #0c5460;
    border: 1px solid #bee5eb;
}
    </style>
</head>
<body>

<!-- BREADCRUMB -->
<div id="breadcrumb" class="section">
    <div class="container">
        <div class="row">
            <div class="col-md-12">
                <ul class="breadcrumb-tree">
                    <li><a href="${pageContext.request.contextPath}/">Trang chủ</a></li>
                    <li><a href="${pageContext.request.contextPath}/cart">Giỏ hàng</a></li>
                    <li class="active">Xác nhận đơn hàng</li>
                </ul>
            </div>
        </div>
    </div>
</div>
<!-- /BREADCRUMB -->

<!-- ORDER PAGE -->
<div class="section">
    <div class="container">
        <h1 class="order-title"><i class="fa fa-shopping-bag"></i> Xác nhận đơn hàng</h1>

        <div id="message-container"></div>

        <div class="row">
            <!-- Order Form - User Info -->
            <div class="col-md-8">
                <div class="order-form-section">
                    <div class="form-section-title"><i class="fa fa-truck"></i> Thông tin giao hàng</div>
                    
                    <div class="user-info">
                        <p><strong>Khách hàng:</strong> ${user.fullName}</p>
                        <p><strong>Email:</strong> ${user.email}</p>
                        <p><strong>Số điện thoại:</strong> ${user.phone}</p>
                        <div>
                            <label for="shippingAddress">Địa chỉ giao hàng:</label>
                            <input type="text" id="shippingAddress" value="${user.address}" placeholder="Nhập địa chỉ của bạn">
                        </div>
                    </div>
                </div>
            </div>

            <!-- Order Summary -->
            <div class="col-md-4">
                <div class="order-summary">
                    <div class="order-summary-title"><i class="fa fa-list-alt"></i> Tóm tắt đơn hàng</div>
                    
                    <div id="order-items-list"></div>
                    <div id="total" class="total-summary"></div>
                    
                    <button id="confirm-btn" class="btn-place-order" onclick="confirmAndCreateOrder()">
                        <i class="fa fa-check-circle"></i> Xác nhận và Tạo đơn hàng
                    </button>
                </div>
            </div>
        </div>
    </div>
</div>
<!-- /ORDER PAGE -->

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
            showMessage('Không tìm thấy thông tin đơn hàng. Vui lòng thử lại.', 'msg-error');
            setTimeout(function() {
                window.location.href = '${pageContext.request.contextPath}/cart';
            }, 2000);
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
            showMessage('Lỗi đọc dữ liệu đơn hàng. Vui lòng quay lại giỏ hàng.', 'msg-error');
        }
    });

    // HÀM RENDER ORDER SUMMARY
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

    // HÀM XÁC NHẬN VÀ TẠO ĐƠN HÀNG
    function confirmAndCreateOrder() {
        if (!pendingOrderData) {
            showMessage('Lỗi: Dữ liệu đơn hàng không tồn tại.', 'msg-error');
            return;
        }
        const shippingAddress = document.getElementById('shippingAddress').value.trim();
        if (!shippingAddress) {
            showMessage('Vui lòng nhập địa chỉ giao hàng.', 'msg-error');
            return;
        }
        
        confirmBtn.disabled = true;
        confirmBtn.innerHTML = '<i class="fa fa-spinner fa-spin"></i> Đang xử lý...';
        showMessage('Đang tạo đơn hàng...', 'msg-info');
        
        // Tạo orderRequest với đầy đủ thông tin
        var orderRequest = {
            orderItems: pendingOrderData.orderItems,
            totalAmount: pendingOrderData.totalAmount,
            shippingAddress: shippingAddress,
            fullName: '${user.fullName}',
            phone: '${user.phone}',
            notes: '' // Có thể thêm trường notes nếu cần
        };
        
        console.log('Sending orderRequest:', orderRequest);
        
        fetch('${pageContext.request.contextPath}/api/orders/create', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            credentials: 'include',
            body: JSON.stringify(orderRequest)
        })
            .then(function (response) {
                if (response.status === 401 || response.status === 403) {
                    window.location.href = '${pageContext.request.contextPath}/login';
                    throw new Error('Chưa đăng nhập hoặc không có quyền.');
                }
                if (!response.ok) {
                    return response.text().then(function(text) {
                        console.error('Server error response:', text);
                        throw new Error('Lỗi khi tạo đơn hàng. Mã lỗi: ' + response.status);
                    });
                }
                return response.json();
            })
            .then(function (order) {
                showMessage('Tạo đơn hàng thành công! Mã đơn: ' + order.orderId, 'msg-success');
                sessionStorage.removeItem('pendingOrder');
                
                // Update cart count
                if (typeof updateGlobalCartCount === 'function') {
                    updateGlobalCartCount();
                }
                
                setTimeout(function() {
                    window.location.href = '${pageContext.request.contextPath}/order/' + order.orderId;
                }, 1500);
            })
            .catch(function (error) {
                console.error('Error:', error);
                showMessage('Lỗi khi tạo đơn hàng: ' + error.message, 'msg-error');
                confirmBtn.disabled = false;
                confirmBtn.innerHTML = '<i class="fa fa-check-circle"></i> Xác nhận và Tạo đơn hàng';
            });
    }

    function showMessage(message, type) {
        messageContainer.textContent = message;
        messageContainer.className = type;
        messageContainer.style.display = 'block';
    }
</script>

</body>
</html>
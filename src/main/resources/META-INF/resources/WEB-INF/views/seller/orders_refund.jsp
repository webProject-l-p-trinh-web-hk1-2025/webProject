<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

            <html>

            <head>
                <title>Đơn hàng hoàn tiền</title>
                <style>
                    body {
                        font-family: Arial, sans-serif;
                        margin: 20px;
                        background: #f8f8f8;
                    }

                    .container {
                        max-width: 1200px;
                        margin: auto;
                        background: #fff;
                        padding: 20px;
                        border-radius: 8px;
                    }

                    h1 {
                        color: #d70018;
                    }

                    .order-card {
                        border: 1px solid #ddd;
                        border-radius: 8px;
                        margin-bottom: 20px;
                        padding: 15px;
                        background: #fafafa;
                    }

                    .order-header {
                        display: flex;
                        justify-content: space-between;
                        align-items: center;
                        margin-bottom: 10px;
                    }

                    .order-info div {
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

                    select,
                    button {
                        padding: 5px 10px;
                        margin: 2px;
                        border-radius: 4px;
                    }

                    .btn-refund {
                        background-color: #28a745;
                        color: #fff;
                        border: none;
                        cursor: pointer;
                    }

                    .btn-back {
                        background-color: #d70018;
                        color: #fff;
                        text-decoration: none;
                        padding: 8px 15px;
                        border-radius: 5px;
                        display: inline-block;
                        margin-bottom: 20px;
                    }

                    .message {
                        margin-top: 15px;
                        padding: 10px;
                        border-radius: 5px;
                        display: none;
                    }

                    .success {
                        background-color: #d4edda;
                        color: #155724;
                    }

                    .error {
                        background-color: #f8d7da;
                        color: #721c24;
                    }
                </style>
            </head>

            <body>
                <div class="container">
                    <h1>Danh sách đơn hàng hoàn tiền</h1>
                    <a href="/home" class="btn-back">Quay về trang chính</a>

                    <div id="messageContainer" class="message"></div>

                    <c:forEach var="order" items="${orders}">
                        <div class="order-card" id="order-card-${order.orderId}">
                            <div class="order-header">
                                <div>
                                    <strong>Order ID:</strong> ${order.orderId} &nbsp;|&nbsp;
                                    <strong>Status:</strong> <span id="status-${order.orderId}">${order.status}</span>
                                    &nbsp;|&nbsp;
                                    <strong>Payment:</strong> ${order.paymentMethod} - ${order.paymentStatus}
                                    &nbsp;|&nbsp;
                                    <strong>Total:</strong>
                                    <fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="₫" />
                                </div>
                            </div>

                            <div class="order-info">
                                <div><strong>Shipping Address:</strong> ${order.shippingAddress}</div>
                                <div><strong>Created At:</strong> ${order.createdAt}</div>
                            </div>

                            <h4>Sản phẩm trong đơn hàng</h4>
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
                                                <fmt:formatNumber value="${item.price * item.quantity}" type="currency"
                                                    currencySymbol="₫" />
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>

                            <div style="margin-top:10px;">
                                <c:if test="${order.status == 'ACCEPTED' || order.status == 'SHIPPED'}">
                                    <label>Trantype:</label>
                                    <select id="trantype-${order.orderId}">
                                        <option value="02">Hoàn toàn</option>
                                        <option value="03">Hoàn một phần</option>
                                    </select>
                                    <label>Percent:</label>
                                    <select id="percent-${order.orderId}">
                                        <option value="50">50%</option>
                                        <option value="100" selected>100%</option>
                                    </select>
                                    <button class="btn-refund" id="refund-btn-${order.orderId}"
                                        onclick="processRefund(${order.orderId})">Hoàn tiền</button>
                                </c:if>
                            </div>
                        </div>
                    </c:forEach>

                    <c:if test="${empty orders}">
                        <p>Không có đơn hàng hoàn tiền nào.</p>
                    </c:if>
                </div>

                <script>
                    function processRefund(orderId) {
                        debugger;
                        const btn = document.getElementById('refund-btn-' + orderId);
                        const trantypeEl = document.getElementById('trantype-' + orderId);
                        const percentEl = document.getElementById('percent-' + orderId);
                        console.log("Processing refund for orderId:", orderId);
                        console.log("Trantype element:", trantypeEl);
                        console.log("Percent element:", percentEl);
                        if (!trantypeEl || !percentEl) {
                            alert("Không tìm thấy các trường trantype/percent cho đơn hàng này.");
                            return;
                        }

                        const trantype = trantypeEl.value;
                        const percent = parseInt(percentEl.value);

                        btn.disabled = true;
                        btn.textContent = "Đang xử lý...";

                        fetch('/seller/orders-refund/' + orderId + '/process?trantype=' + trantype + '&percent=' + percent, {
                            method: 'POST'
                        })
                            .then(res => {
                                if (!res.ok) throw new Error("Hoàn tiền thất bại: " + res.status);
                                return res.text();
                            })
                            .then(msg => {
                                showMessage(msg, 'success');
                                document.getElementById(`status-${orderId}`).textContent = "REFUNDED";
                                btn.style.display = 'none';
                            })
                            .catch(err => {
                                console.error(err);
                                showMessage(err.message, 'error');
                                btn.disabled = false;
                                btn.textContent = "Hoàn tiền";
                            });
                    }


                    function showMessage(message, type) {
                        const container = document.getElementById('messageContainer');
                        container.textContent = message;
                        container.className = 'message ' + type;
                        container.style.display = 'block';
                        setTimeout(() => { container.style.display = 'none'; }, 5000);
                    }
                </script>
            </body>

            </html>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ page contentType="text/html;charset=UTF-8" language="java" %>
        <html>

        <head>
            <title>Danh sách đơn hàng</title>
            <style>
                table {
                    width: 100%;
                    border-collapse: collapse;
                    margin-top: 20px;
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

                .btn-view,
                .btn-cancel {
                    padding: 5px 10px;
                    margin: 2px;
                    cursor: pointer;
                }

                .btn-view {
                    background-color: #4CAF50;
                    color: white;
                    text-decoration: none;
                    border: none;
                    border-radius: 4px;
                }

                .btn-cancel {
                    background-color: #d70018;
                    color: white;
                    border: none;
                    border-radius: 4px;
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

            <h1>📝 Danh sách đơn hàng của bạn</h1>

            <div id="messageContainer" class="message"></div>

            <table>
                <thead>
                    <tr>
                        <th>Order ID</th>
                        <th>Ngày tạo</th>
                        <th>Tổng tiền</th>
                        <th>Trạng thái</th>
                        <th>Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="order" items="${orders}">
                        <tr id="order-row-${order.orderId}">
                            <td>${order.orderId}</td>
                            <td>${order.createdAt}</td>
                            <td>
                                ${order.totalAmount} ₫
                                <br />
                                <!-- Hiển thị ảnh từng sản phẩm -->
                                <c:forEach var="item" items="${order.items}">
                                    <div style="display:inline-block; margin:5px;">
                                        <img src="${item.productImageUrl}" alt="${item.productName}"
                                            style="width:50px; height:50px; object-fit:cover;"
                                            title="${item.productName}" />
                                    </div>
                                </c:forEach>
                            </td>
                            <td id="status-${order.orderId}">${order.status}</td>
                            <td>
                                <a class="btn-view" href="/order/${order.orderId}">Xem chi tiết</a>
                                <c:if test="${order.status == 'PENDING'}">
                                    <button class="btn-cancel" onclick="cancelOrder(${order.orderId})">Hủy</button>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>

                </tbody>
            </table>

            <script>
                function cancelOrder(orderId) {
                    if (!confirm("Bạn có chắc muốn hủy đơn hàng này?")) return;
                    debugger;
                    fetch('/api/orders/' + orderId + '/cancel', {
                        method: 'PUT',
                        credentials: 'include'
                    })
                        .then(response => {
                            if (!response.ok) throw new Error("Không thể hủy đơn hàng");
                            return response.json();
                        })
                        .then(data => {
                            showMessage(data.message, 'success');
                            // Cập nhật trạng thái hiển thị
                            const statusEl = document.getElementById('status-' + orderId);
                            if (statusEl) statusEl.textContent = 'CANCELLED';

                            const btn = document.querySelector('#order-row-' + orderId + ' .btn-cancel');
                            if (btn) btn.style.display = 'none';
                        })
                        .catch(error => {
                            console.error(error);
                            showMessage('Lỗi khi hủy đơn hàng hoặc hoàn tiền!', 'error');
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
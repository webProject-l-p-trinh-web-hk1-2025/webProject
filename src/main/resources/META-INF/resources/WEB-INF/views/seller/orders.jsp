<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

            <html>

            <head>
                <title>Danh sách đơn hàng của Seller</title>
                <style>
                    body {
                        font-family: Arial, sans-serif;
                        background: #f8f8f8;
                        margin: 20px;
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

                    .btn {
                        padding: 8px 15px;
                        border-radius: 5px;
                        text-decoration: none;
                        font-weight: bold;
                        cursor: pointer;
                        border: none;
                    }

                    .btn-accept {
                        background: #28a745;
                        color: #fff;
                    }

                    .btn-disabled {
                        background: #aaa;
                        color: #fff;
                        cursor: not-allowed;
                    }

                    .btn-back {
                        background: #d70018;
                        color: #fff;
                        text-decoration: none;
                        padding: 10px 20px;
                        border-radius: 5px;
                        display: inline-block;
                        margin-bottom: 20px;
                    }
                </style>
            </head>

            <body>
                <div class="container">
                    <h1>Danh sách đơn hàng</h1>
                    <a href="/home" class="btn-back">Quay về trang chính</a>

                    <c:forEach var="order" items="${orders}">
                        <div class="order-card">
                            <div class="order-header">
                                <div>
                                    <strong>Order ID:</strong> ${order.orderId} &nbsp;|&nbsp;
                                    <strong>Status:</strong> ${order.status} &nbsp;|&nbsp;
                                    <strong>Payment:</strong> ${order.paymentMethod} - ${order.paymentStatus}
                                    &nbsp;|&nbsp;
                                    <strong>Total:</strong>
                                    <fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="₫" />
                                </div>
                                <div>
                                    <c:if test="${order.status == 'PENDING'}">
                                        <form action="/seller/accept-order/${order.orderId}" method="post"
                                            style="display:inline;">
                                            <button type="submit" class="btn btn-accept">Accept Order</button>
                                        </form>
                                    </c:if>
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
                        </div>
                    </c:forEach>

                    <c:if test="${empty orders}">
                        <p>Không có đơn hàng nào.</p>
                    </c:if>
                </div>
            </body>

            </html>
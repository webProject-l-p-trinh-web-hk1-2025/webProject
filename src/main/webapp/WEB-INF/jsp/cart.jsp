<!-- filepath: src/main/webapp/WEB-INF/jsp/cart.jsp -->
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="header.jsp" %>
<html>
<head>
    <title>Giỏ hàng của bạn</title>
    <style>
        table { border-collapse: collapse; width: 60%; margin: 20px 0; }
        th, td { border: 1px solid #ccc; padding: 8px 12px; text-align: center; }
        th { background: #f5f5f5; }
    </style>
</head>
<body>
    <h2>Giỏ hàng của bạn</h2>
    <c:if test="${not empty cart.items}">
        <table>
            <tr>
                <th>STT</th>
                <th>Mã sản phẩm</th>
                <th>Số lượng</th>
            </tr>
            <c:forEach var="item" items="${cart.items}" varStatus="loop">
                <tr>
                    <td>${loop.index + 1}</td>
                    <td>${item.productId}</td>
                    <td>${item.quantity}</td>
                </tr>
            </c:forEach>
        </table>
    </c:if>
    <c:if test="${empty cart.items}">
        <p>Giỏ hàng của bạn đang trống.</p>
    </c:if>
</body>
</html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Lịch sử mua hàng</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; }
        .container { margin-top: 24px; }
        .order-item { border: 1px solid #e9ecef; padding: 12px; border-radius: 8px; background: #fff; }
    </style>
</head>
<body>
<div class="container">
    <h3 class="text-danger mb-4">Lịch sử mua hàng</h3>
    <c:if test="${empty orders}">
        <div class="alert alert-info">Bạn chưa có đơn hàng nào.</div>
    </c:if>

    <c:forEach var="o" items="${orders}">
        <div class="order-item mb-3">
            <div class="d-flex justify-content-between">
                <div>
                    <div><strong>Mã đơn:</strong> ${o.code}</div>
                    <div><strong>Ngày:</strong> ${o.date}</div>
                </div>
                <div class="text-end">
                    <div class="text-danger fw-bold">${o.total}</div>
                    <a href="${pageContext.request.contextPath}/order/${o.id}" class="btn btn-sm btn-outline-primary">Chi tiết</a>
                </div>
            </div>
        </div>
    </c:forEach>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
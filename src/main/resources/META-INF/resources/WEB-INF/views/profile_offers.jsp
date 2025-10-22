<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Ưu đãi & hạng thành viên</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; }
        .container { margin-top: 24px; }
        .card-custom { border-radius: 10px; background: #fff; padding: 16px; }
    </style>
</head>
<body>
<div class="container">
    <h3 class="text-danger mb-4">Ưu đãi & hạng thành viên</h3>

    <div class="card-custom mb-3">
        <h5>Hạng hiện tại: <span class="badge bg-success">S-MEM</span></h5>
        <p class="text-muted">Bạn đang ở hạng thành viên S-MEM. Tích điểm để nâng hạng và nhận thêm ưu đãi.</p>
    </div>

    <div class="card-custom">
        <h5>Ưu đãi hiện có</h5>
        <c:if test="${empty offers}">
            <p>Bạn hiện không có ưu đãi nào.</p>
        </c:if>
        <c:forEach var="off" items="${offers}">
            <div class="border p-2 mb-2">${off.title} - <small class="text-muted">${off.description}</small></div>
        </c:forEach>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
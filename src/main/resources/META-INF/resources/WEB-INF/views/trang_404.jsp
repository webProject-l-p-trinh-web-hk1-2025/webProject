<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <!DOCTYPE html>
    <html lang="vi">

    <head>
        <meta charset="UTF-8" />
        <title>404 - Trang không tìm thấy</title>
        <link rel="stylesheet"
            href="${pageContext.request.contextPath}/webjars/bootstrap/5.2.0/css/bootstrap.min.css" />
        <style>
            body {
                background: #f6f7fb
            }

            .card {
                max-width: 900px;
                margin: 40px auto
            }
        </style>
    </head>

    <body>
        <div class="container">
            <div class="card shadow-sm">
                <div class="card-header bg-danger text-white">
                    <h4 class="mb-0">404 — Trang không tìm thấy</h4>
                </div>
                <div class="card-body">
                    <p class="lead">Không tìm thấy: <strong>${path}</strong></p>
                    <c:if test="${not empty details}">
                        <pre>${details}</pre>
                    </c:if>
                    <div class="mt-3">
                        <a href="${pageContext.request.contextPath}/" class="btn btn-primary">Về trang chủ</a>
                        <a href="javascript:history.back()" class="btn btn-outline-secondary">Quay lại</a>
                    </div>
                </div>
            </div>
        </div>
        <script src="${pageContext.request.contextPath}/webjars/bootstrap/5.2.0/js/bootstrap.bundle.min.js"></script>
    </body>

    </html>
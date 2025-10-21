<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<!doctype html>
<html lang="vi">

<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Đặt lại mật khẩu - CellPhone Store</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- CSS riêng -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/reset.css" />
</head>

<body class="reset-page">
    <jsp:include page="/common/header.jsp" />

    <!-- MAIN CONTENT -->
    <div class="login-two-col">
        <!-- LEFT -->
        <div class="promo-col">
            <div class="promo-inner">
                <h1 class="promo-title">Lấy lại mật khẩu</h1>
                <p class="promo-sub">
                    Nhập email hoặc số điện thoại liên kết với tài khoản của bạn. 
                    Chúng tôi sẽ gửi hướng dẫn để đặt lại mật khẩu.
                </p>
                <ul class="promo-benefits">
                    <li>An toàn và nhanh chóng</li>
                    <li>Hướng dẫn bằng email hoặc SMS</li>
                    <li>Hỗ trợ 24/7</li>
                </ul>
            </div>
        </div>

        <!-- RIGHT -->
        <div class="form-col">
            <div class="form-wrap">
                <h2 class="form-title">Đặt lại mật khẩu</h2>

                <c:if test="${not empty error}">
                    <div class="auth-error text-danger">${error}</div>
                </c:if>

                <form action="${pageContext.request.contextPath}/doResetPassword" method="post">
                    <div class="form-group mb-3">
                        <label for="input">Email hoặc số điện thoại</label>
                        <input id="input" name="input" class="form-control" 
                               placeholder="Nhập email hoặc số điện thoại" required
                               value="${not empty input ? input : ''}" />
                    </div>

                    <button class="btn-login" type="submit">Gửi yêu cầu</button>
                </form>

                <div class="divider">Hoặc</div>
                <div class="register-link">
                    <a href="${pageContext.request.contextPath}/login">Trở về đăng nhập</a>
                </div>

                <c:if test="${not empty message}">
                    <div class="auth-message mt-3 text-success">${message}</div>
                </c:if>
            </div>
        </div>
    </div>

    <!-- JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>

</html>

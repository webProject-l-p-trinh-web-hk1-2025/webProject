<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <%@ page contentType="text/html;charset=UTF-8" %>
        <!doctype html>
        <html lang="vi">

        <head>
            <meta charset="utf-8" />
            <meta name="viewport" content="width=device-width, initial-scale=1" />
            <title>Đặt lại mật khẩu - CellPhone Store</title>

            <!-- Google Fonts -->
            <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;600;700;800&display=swap"
                rel="stylesheet" />

            <!-- Font Awesome -->
            <link rel="stylesheet"
                href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css" />

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
                        <h1 class="promo-title">
                            <i class="fa fa-lock"></i> Lấy lại mật khẩu
                        </h1>
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
                        <p class="form-subtitle">Nhập thông tin tài khoản của bạn để tiếp tục</p>

                        <c:if test="${not empty error}">
                            <div class="auth-error">
                                <i class="fa fa-exclamation-circle"></i> ${error}
                            </div>
                        </c:if>

                        <form action="${pageContext.request.contextPath}/doResetPassword" method="post">
                            <div class="form-group mb-3">
                                <label for="input">
                                    <i class="fa fa-envelope"></i> Email hoặc số điện thoại
                                </label>
                                <input id="input" name="input" class="form-control"
                                    placeholder="Nhập email hoặc số điện thoại" required
                                    value="${not empty input ? input : ''}" />
                            </div>

                            <button class="btn-login" type="submit">
                                <i class="fa fa-paper-plane"></i> Gửi yêu cầu
                            </button>
                        </form>

                        <div class="divider">Hoặc</div>
                        <div class="register-link">
                            <a href="${pageContext.request.contextPath}/login">
                                <i class="fa fa-arrow-left"></i> Trở về đăng nhập
                            </a>
                        </div>

                        <c:if test="${not empty message}">
                            <div class="auth-message">
                                <i class="fa fa-check-circle"></i> ${message}
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>

            <!-- JS -->
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
        </body>

        </html>
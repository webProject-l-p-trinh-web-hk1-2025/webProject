<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ page contentType="text/html;charset=UTF-8" language="java" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8" />
            <meta name="viewport" content="width=device-width, initial-scale=1" />
            <title>Hoàn tất đăng ký - CellPhoneStore</title>

            <!-- Google Fonts -->
            <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;600;700;800&display=swap"
                rel="stylesheet" />

            <!-- Font Awesome -->
            <link rel="stylesheet"
                href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css" />

            <!-- Bootstrap -->
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />

            <!-- CSS same as login -->
            <c:url value="/css/header.css" var="headerCss" />
            <c:url value="/css/login.css" var="loginCss" />
            <link rel="stylesheet" href="${headerCss}" />
            <link rel="stylesheet" href="${loginCss}" />
        </head>

        <body class="login-page">
            <jsp:include page="/common/header.jsp" />

            <div class="login-container">
                <div class="login-card">
                    <h2>Hoàn tất thông tin</h2>
                    <p class="subtitle">Vui lòng cung cấp thêm một số thông tin để hoàn tất đăng ký</p>

                    <form action="${pageContext.request.contextPath}/oauth2/complete" method="post">
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger">
                                <i class="fa fa-exclamation-circle"></i> ${error}
                            </div>
                        </c:if>
                        <c:if test="${not empty message}">
                            <div class="alert alert-success">
                                <i class="fa fa-check-circle"></i> ${message}
                            </div>
                        </c:if>

                        <div class="mb-3">
                            <label class="form-label">
                                <i class="fa fa-envelope"></i> Email
                                <span style="color:#28a745; font-size:12px; font-weight:500; margin-left:8px;">
                                    <i class="fa fa-check-circle"></i> Đã xác thực
                                </span>
                            </label>
                            <input type="email" name="email" class="form-control" value="${email}" readonly
                                style="background:#F8F9FA; cursor:not-allowed;" />
                            <small style="color:#8D99AE; font-size:12px; display:block; margin-top:5px;">
                                <i class="fa fa-info-circle"></i> Email từ tài khoản Google không thể thay đổi
                            </small>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">
                                <i class="fa fa-user"></i> Họ và tên
                            </label>
                            <input type="text" name="fullName" class="form-control" value="${name}"
                                placeholder="Nhập họ và tên đầy đủ" required />
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">
                                    <i class="fa fa-phone"></i> Số điện thoại
                                </label>
                                <input type="text" name="phone" class="form-control" placeholder="Nhập số điện thoại"
                                    required />
                            </div>

                            <div class="col-md-6 mb-3">
                                <label class="form-label">
                                    <i class="fa fa-map-marker"></i> Địa chỉ
                                    <span style="color:#8D99AE; font-size:12px; font-weight:400;">(không bắt
                                        buộc)</span>
                                </label>
                                <input type="text" name="address" class="form-control" placeholder="Nhập địa chỉ" />
                            </div>
                        </div>

                        <div style="display:flex; gap:15px; margin-top:20px;">
                            <a class="btn btn-google" href="${pageContext.request.contextPath}/login"
                                style="flex:1; text-align:center; text-decoration:none; display:flex; align-items:center; justify-content:center; gap:8px;">
                                <i class="fa fa-arrow-left"></i> Quay lại
                            </a>
                            <button type="submit" class="btn btn-login" style="flex:2;">
                                <i class="fa fa-check"></i> Hoàn tất và đăng nhập
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
        </body>

        </html>
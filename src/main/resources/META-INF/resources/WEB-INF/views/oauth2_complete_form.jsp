<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ page contentType="text/html;charset=UTF-8" language="java" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8" />
            <meta name="viewport" content="width=device-width, initial-scale=1" />
            <title>Hoàn tất đăng ký - CellPhoneStore</title>

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
                    <h2 class="text-center mb-4 text-danger">Hoàn tất thông tin</h2>

                    <form action="${pageContext.request.contextPath}/oauth2/complete" method="post" class="row g-3">
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger">${error}</div>
                        </c:if>
                        <c:if test="${not empty message}">
                            <div class="alert alert-success">${message}</div>
                        </c:if>


                        <div class="col-12">
                            <label class="form-label">Email</label>
                            <input type="email" name="email" class="form-control" value="${email}" readonly />
                        </div>

                        <div class="col-12">
                            <label class="form-label">Họ và tên</label>
                            <input type="text" name="fullName" class="form-control" value="${name}" required />
                        </div>

                        <div class="col-md-6">
                            <label class="form-label">Số điện thoại</label>
                            <input type="text" name="phone" class="form-control" placeholder="Nhập số điện thoại"
                                required />
                        </div>

                        <div class="col-md-6">
                            <label class="form-label">Địa chỉ (không bắt buộc)</label>
                            <input type="text" name="address" class="form-control" placeholder="Địa chỉ" />
                        </div>

                        <div class="col-12 d-flex justify-content-between">
                            <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/login">Quay
                                lại</a>
                            <button type="submit" class="btn btn-primary">Hoàn tất và đăng nhập</button>
                        </div>
                    </form>
                </div>
            </div>

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
        </body>

        </html>
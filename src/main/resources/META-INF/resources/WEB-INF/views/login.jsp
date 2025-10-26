<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
  <%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!doctype html>
    <html lang="vi">

    <head>
      <meta charset="UTF-8" />
      <meta name="viewport" content="width=device-width, initial-scale=1" />
      <title>Đăng nhập - CellPhoneStore</title>

      <!-- Bootstrap -->
      <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />

      <!-- CSS -->
      <c:url value="/css/header.css" var="headerCss" />
      <c:url value="/css/login.css" var="loginCss" />
      <link rel="stylesheet" href="${headerCss}" />
      <link rel="stylesheet" href="${loginCss}" />
    </head>

    <body class="login-page">
      <jsp:include page="/common/header.jsp" />

      <div class="login-container">
        <div class="login-card">
          <h2 class="text-center mb-4 text-danger">Đăng nhập </h2>

          <form action="<c:url value='/dologin' />" method="post">
            <c:if test="${not empty error}">
              <div class="alert alert-danger">${error}</div>
            </c:if>
            <c:if test="${not empty message}">
              <div class="alert alert-success">${message}</div>
            </c:if>

            <div class="mb-3">
              <label for="phone" class="form-label">Số điện thoại</label>
              <input type="text" class="form-control" id="phone" name="phone" placeholder="Nhập số điện thoại" />
            </div>

            <div class="mb-3">
              <label for="password" class="form-label">Mật khẩu</label>
              <input type="password" class="form-control" id="password" name="password" placeholder="Nhập mật khẩu" />
            </div>

            <div class="d-flex justify-content-between align-items-center mb-3">
              <div class="form-check">
                <input class="form-check-input" type="checkbox" id="rememberMe" name="rememberMe" />
                <label class="form-check-label" for="rememberMe">Ghi nhớ</label>
              </div>
              <a href="<c:url value='/resetPassword' />" class="text-link">Quên mật khẩu?</a>
            </div>

            <button type="submit" class="btn btn-login w-100 text-white py-2">Đăng nhập</button>
          </form>

          <hr />
          <div class="text-center mb-3">
            <a class="btn btn-outline-danger w-100 d-flex align-items-center justify-content-center gap-2"
              href="<c:url value='/oauth2/authorization/google' />">
              <!-- use official Google G logo -->
              <img src="https://developers.google.com/identity/images/g-logo.png" alt="Google"
                style="height:18px; width:18px;" />
              Đăng nhập bằng Google
            </a>
          </div>
          <p class="text-center mb-0">
            Chưa có tài khoản?
            <a href="<c:url value='/register' />" class="text-link">Đăng ký ngay</a>
          </p>
        </div>
      </div>

      <!-- Bootstrap JS -->
      <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    </body>

    </html>
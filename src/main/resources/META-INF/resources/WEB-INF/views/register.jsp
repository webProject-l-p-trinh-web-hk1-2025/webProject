<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
  <%@ page contentType="text/html;charset=UTF-8" %>
    <!doctype html>
    <html lang="vi">

    <head>
      <meta charset="UTF-8" />
      <meta name="viewport" content="width=device-width, initial-scale=1" />
      <title>Đăng ký thành viên - CellPhoneStore</title>

      <!-- Google Fonts -->
      <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;600;700;800&display=swap"
        rel="stylesheet" />

      <!-- Font Awesome -->
      <link rel="stylesheet"
        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css" />

      <c:url value="/css/register.css" var="registerCss" />
      <link rel="stylesheet" href="${registerCss}" />
    </head>

    <body class="register-page">
      <jsp:include page="/common/header.jsp" />
      <div class="register-container">
        <h1>Đăng ký tài khoản</h1>
        <p class="subtitle">Tạo tài khoản mới để trải nghiệm dịch vụ của chúng tôi</p>

        <c:if test="${not empty error}">
          <div class="auth-error">
            <i class="fa fa-exclamation-circle"></i> ${error}
          </div>
        </c:if>

        <c:if test="${not empty message}">
          <div class="auth-message">
            <i class="fa fa-check-circle"></i> ${message}
          </div>
        </c:if>

        <form id="registerForm" action="${pageContext.request.contextPath}/doregister" method="post">
          <h2 class="section-title">
            <i class="fa fa-user"></i> Thông tin cá nhân
          </h2>

          <div class="form-row">
            <div class="form-col-full">
              <label class="form-label">
                <i class="fa fa-id-card"></i> Họ và tên
              </label>
              <input type="text" class="form-control" name="fullName" placeholder="Nhập họ và tên đầy đủ" required
                value="${not empty fullName ? fullName : ''}" />
            </div>
          </div>

          <div class="form-row">
            <div class="form-col">
              <label class="form-label">
                <i class="fa fa-phone"></i> Số điện thoại
              </label>
              <input type="text" class="form-control" name="phone" placeholder="Nhập số điện thoại" required
                value="${not empty phone ? phone : ''}" />
            </div>
            <div class="form-col">
              <label class="form-label">
                <i class="fa fa-envelope"></i> Email
              </label>
              <input type="email" class="form-control" name="email" placeholder="Nhập địa chỉ email" required
                value="${not empty email ? email : ''}" />
            </div>
          </div>

          <div class="divider"></div>

          <h2 class="section-title">
            <i class="fa fa-lock"></i> Tạo mật khẩu
          </h2>

          <div class="form-row">
            <div class="form-col">
              <label class="form-label">
                <i class="fa fa-key"></i> Mật khẩu
              </label>
              <input type="password" class="form-control" name="password" placeholder="Nhập mật khẩu" required />
              <small class="text-muted">
                <i class="fa fa-info-circle"></i> Mật khẩu tối thiểu 6 ký tự, có ít nhất 1 chữ cái và 1 số
              </small>
            </div>
            <div class="form-col">
              <label class="form-label">
                <i class="fa fa-key"></i> Nhập lại mật khẩu
              </label>
              <input type="password" class="form-control" name="confirmPassword" placeholder="Xác nhận mật khẩu"
                required />
            </div>
          </div>
        </form>
      </div>

      <div class="footer-fixed">
        <a href="${pageContext.request.contextPath}/login" class="btn btn-outline-secondary">
          <i class="fa fa-arrow-left"></i> Quay lại đăng nhập
        </a>
        <button type="submit" form="registerForm" class="btn btn-primary-custom">
          <i class="fa fa-user-plus"></i> Hoàn tất đăng ký
        </button>
      </div>
    </body>

    </html>
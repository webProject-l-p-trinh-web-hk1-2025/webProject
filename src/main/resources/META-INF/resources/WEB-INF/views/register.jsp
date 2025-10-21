<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
  <%@ page contentType="text/html;charset=UTF-8" %>
    <!doctype html>
    <html lang="vi">

    <head>
      <meta charset="UTF-8" />
      <meta name="viewport" content="width=device-width, initial-scale=1" />
      <title>Đăng ký thành viên</title>
      <c:url value="/css/register.css" var="registerCss" />
      <link rel="stylesheet" href="${registerCss}" />
    </head>

    <body class="register-page">
      <jsp:include page="/common/header.jsp" />
      <div class="register-container">
        <h1>Đăng ký trở tài khoản</h1>

        <c:if test="${not empty error}">
          <div class="auth-error" style="color:#c0392b;margin-bottom:12px;">${error}</div>
        </c:if>

        <c:if test="${not empty message}">
          <div class="auth-message" style="color:#27ae60;margin-bottom:12px;">${message}</div>
        </c:if>

        <form id="registerForm" action="${pageContext.request.contextPath}/doregister" method="post">
          <h2 class="section-title">Thông tin cá nhân</h2>

          <div style="display:flex; flex-wrap:wrap; gap:20px;">
            <div style="flex:1 1 100%;">
              <label class="form-label">Họ và tên:</label>
              <input type="text" class="form-control" name="fullName" placeholder="Nhập họ và tên" required
                value="${not empty fullName ? fullName : ''}" />
            </div>
          </div>

          <div style="display:flex; flex-wrap:wrap; gap:20px;">
            <div style="flex:1 1 50%;">
              <label class="form-label">Số điện thoại:</label>
              <input type="text" class="form-control" name="phone" placeholder="Nhập số điện thoại" required
                value="${not empty phone ? phone : ''}" />
            </div>
            <div style="flex:1 1 50%;">
              <label class="form-label">Email:</label>
              <input type="email" class="form-control" name="email" placeholder="Nhập email" required
                value="${not empty email ? email : ''}" />
            </div>
          </div>

          <div class="divider"></div>

          <h2 class="section-title">Tạo mật khẩu</h2>

          <div style="display:flex; flex-wrap:wrap; gap:20px;">
            <div style="flex:1 1 50%;">
              <label class="form-label">Mật khẩu:</label>
              <input type="password" class="form-control" name="password" placeholder="Nhập mật khẩu" required />
              <small class="text-muted">Mật khẩu tối thiểu 6 ký tự, có ít nhất 1 chữ cái và 1 số</small>
            </div>
            <div style="flex:1 1 50%;">
              <label class="form-label">Nhập lại mật khẩu:</label>
              <input type="password" class="form-control" name="confirmPassword" placeholder="Nhập lại mật khẩu"
                required />
            </div>
          </div>
        </form>
      </div>

      <div class="footer-fixed">
        <a href="${pageContext.request.contextPath}/login" class="btn btn-outline-secondary">Quay lại đăng nhập</a>
        <button type="submit" form="registerForm" class="btn btn-primary-custom">Hoàn tất đăng ký</button>
      </div>
    </body>

    </html>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <%@ page contentType="text/html;charset=UTF-8" %>
        <html>

        <head>
            <title>Reset Password</title>
        </head>

        <body>
            <h2>Đặt lại mật khẩu</h2>
            <c:if test="${not empty error}">
                <div style="color: red;">${error}</div>
            </c:if>
            <form action="${pageContext.request.contextPath}/reset-password" method="post">
                <label for="phone">Số điện thoại:</label>
                <input type="text" id="phone" name="phone" required />
                <button type="submit">Reset</button>
            </form>
            <c:if test="${not empty message}">
                <div style="color: green;">${message}</div>
                <a href="${pageContext.request.contextPath}/login">Quay lại trang đăng nhập</a>
            </c:if>
        </body>

        </html>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Register</title>
</head>
<body>
            <h2>Đăng ký tài khoản</h2>

            <c:if test="${not empty error}">
                <p style="color:red">${error}</p>
            </c:if>

            <c:if test="${not empty message}">
                <p style="color:green">${message}</p>
            </c:if>

            <form action="${pageContext.request.contextPath}/doregister" method="post">
                <label>Họ và tên:</label><br>
                <input type="text" name="fullName" required /><br>

                <label>Số điện thoại:</label><br>
                <input type="text" name="phone" required /><br>

                <label>Mật khẩu:</label><br>
                <input type="password" name="password" required /><br>

                <label>Xác nhận mật khẩu:</label><br>
                <input type="password" name="confirmPassword" required /><br>

                <label>Email:</label><br>
                <input type="email" name="email" required /><br>

                <button type="submit">Đăng ký</button>
            </form>


            <p>Đã có tài khoản? <a href="/login">Đăng nhập</a></p>
        </body>

        </html>
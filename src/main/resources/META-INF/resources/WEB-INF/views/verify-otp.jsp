<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Xác thực OTP</title>
</head>
<body>
            <h2>OTP Verification</h2>

            <c:if test="${not empty error}">
                <p style="color:red;">${error}</p>
            </c:if>

            <c:if test="${not empty success}">
                <p style="color:green;">${success}</p>
            </c:if>

            <!-- Gửi OTP Email -->
            <form method="post" action="${pageContext.request.contextPath}/send-otp-email">
                <button type="submit">Gửi OTP qua Email</button>
            </form>
            <br />

            <!-- Gửi OTP Phone -->
            <form method="post" action="${pageContext.request.contextPath}/send-otp-phone">
                <button type="submit">Gửi OTP qua Số điện thoại</button>
            </form>
            <br />

            <!-- Nhập OTP để verify -->
            <form method="post" action="${pageContext.request.contextPath}/verify-otp">
                <label for="otp">Nhập OTP:</label>
                <input type="text" id="otp" name="otp" required />
                <button type="submit">Xác nhận OTP</button>
            </form>
        </body>

        </html>
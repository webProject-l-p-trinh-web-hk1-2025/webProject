<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đổi mật khẩu</title>
                <style>
                    body {
                        font-family: Arial, sans-serif;
                        margin: 20px;
                    }

                    .container {
                        max-width: 400px;
                        margin: auto;
                    }

                    .form-group {
                        margin-bottom: 15px;
                    }

                    label {
                        display: block;
                        margin-bottom: 5px;
                    }

                    input {
                        width: 100%;
                        padding: 8px;
                    }

                    button {
                        padding: 8px 16px;
                    }

                    .success {
                        color: green;
                        margin-top: 10px;
                    }

                    .error {
                        color: red;
                        margin-top: 10px;
                    }
                </style>
            </head>

            <body>
                <div class="container">
                    <h2>Đổi mật khẩu</h2>

                    <!-- Hiển thị thông báo -->
                    <c:if test="${not empty message}">
                        <div class="${message eq 'Đổi mật khẩu thành công!' ? 'success' : 'error'}">
                            ${message}
                        </div>
                    </c:if>

                    <!-- Form đổi mật khẩu -->
                    <form:form method="post" action="${pageContext.request.contextPath}/change-password"
                        modelAttribute="changePassRequest">
                        <div class="form-group">
                            <label for="password">Mật khẩu cũ</label>
                            <form:password path="password" id="password" required="true" />
                        </div>

                        <div class="form-group">
                            <label for="newPassword">Mật khẩu mới</label>
                            <form:password path="newPassword" id="newPassword" required="true" />
                        </div>

                        <div class="form-group">
                            <label for="confirmNewPassword">Xác nhận mật khẩu mới</label>
                            <form:password path="confirmNewPassword" id="confirmNewPassword" required="true" />
                        </div>

                        <button type="submit">Đổi mật khẩu</button>
                    </form:form>
                </div>
            </body>

            </html>
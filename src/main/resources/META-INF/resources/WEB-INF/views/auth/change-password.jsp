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
                <div id="profile-content">
                    <div class="container py-3">
                        <div class="card shadow-sm mx-auto" style="max-width:720px;">
                            <div class="card-body">
                                <h4 class="card-title mb-3">Đổi mật khẩu</h4>

                                <!-- Hiển thị thông báo -->
                                <c:if test="${not empty message}">
                                    <div class="alert ${message eq 'Đổi mật khẩu thành công!' ? 'alert-success' : 'alert-danger'}" role="alert">
                                        ${message}
                                    </div>
                                </c:if>

                                <!-- Form đổi mật khẩu -->
                                <form:form method="post" action="${pageContext.request.contextPath}/profile/change-password" modelAttribute="changePassRequest" id="changePasswordForm">
                                    <div class="mb-3">
                                        <label for="password" class="form-label">Mật khẩu cũ</label>
                                        <form:password path="password" id="password" cssClass="form-control" required="true" />
                                    </div>

                                    <div class="mb-3">
                                        <label for="newPassword" class="form-label">Mật khẩu mới</label>
                                        <form:password path="newPassword" id="newPassword" cssClass="form-control" required="true" />
                                    </div>

                                    <div class="mb-3">
                                        <label for="confirmNewPassword" class="form-label">Xác nhận mật khẩu mới</label>
                                        <form:password path="confirmNewPassword" id="confirmNewPassword" cssClass="form-control" required="true" />
                                        <div id="pwHelp" class="form-text text-danger mt-1" style="display:none">Mật khẩu xác nhận chưa khớp.</div>
                                    </div>

                                    <div class="d-flex gap-2">
                                        <button type="submit" id="changePassBtn" class="btn btn-primary">Đổi mật khẩu</button>
                                        <button type="button" class="btn btn-outline-secondary" onclick="history.back()">Hủy</button>
                                    </div>
                                </form:form>
                            </div>
                        </div>
                    </div>
                </div>

                <script>
                    (function(){
                        const newPw = document.getElementById('newPassword');
                        const confirmPw = document.getElementById('confirmNewPassword');
                        const help = document.getElementById('pwHelp');
                        const submitBtn = document.getElementById('changePassBtn');

                        function validateMatch(){
                            const a = newPw && newPw.value ? newPw.value : '';
                            const b = confirmPw && confirmPw.value ? confirmPw.value : '';
                            if(!a && !b){ help.style.display='none'; submitBtn.disabled=false; return; }
                            if(a !== b){ help.style.display='block'; submitBtn.disabled=true; }
                            else { help.style.display='none'; submitBtn.disabled=false; }
                        }

                        if(newPw) newPw.addEventListener('input', validateMatch);
                        if(confirmPw) confirmPw.addEventListener('input', validateMatch);

                        // ensure validation runs when form injected
                        document.addEventListener('DOMContentLoaded', validateMatch);
                    })();
                </script>
            </body>

            </html>
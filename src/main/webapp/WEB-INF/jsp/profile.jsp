<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <html>

        <head>
            <title>Thông tin cá nhân</title>
        </head>

        <body>
            <h2>Thông tin cá nhân</h2>

            <c:if test="${not empty error}">
                <p style="color:red">${error}</p>
            </c:if>

            <c:if test="${not empty success}">
                <p style="color:green">${success}</p>
            </c:if>

            <p><b>Họ tên:</b> ${user.fullname}</p>
            <p><b>Email:</b> ${user.email}</p>
            <p><b>Địa chỉ:</b> ${user.address}</p>
            <p><b>Số điện thoại:</b> ${user.phone}</p>

            <c:if test="${not empty user.avatarUrl}">
                <p><img src="${user.avatarUrl}" alt="Avatar" width="150" height="150"></p>
            </c:if>

            <p><a href="<c:url value='/update-profile'/>">Cập nhật thông tin</a></p>
        </body>

        </html>
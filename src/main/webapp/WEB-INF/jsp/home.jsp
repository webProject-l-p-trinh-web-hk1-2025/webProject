<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <html>

        <head>
            <title>Home</title>
        </head>

        <body>
            <h2>Trang Home</h2>
            <c:if test="${not empty message}">
                <p style="color:green">${message}</p>
            </c:if>

            <c:if test="${not empty username}">
                <p>Xin chào, <strong>${username}</strong></p>
                <p>Role: <strong>${role}</strong></p>
                <p>Phone: <strong>${phone}</strong></p>

                <form action="/dologout" method="post">
                    <button type="submit">Đăng xuất</button>
                </form>
            </c:if>

            <c:if test="${empty username}">
                <p>Bạn chưa đăng nhập.
                    <a href="<c:url value='/login' />">Đăng nhập</a>
                </p>
            </c:if>
        </body>

        </html>
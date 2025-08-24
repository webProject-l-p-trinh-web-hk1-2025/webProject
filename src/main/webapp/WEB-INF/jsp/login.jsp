<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ page contentType="text/html;charset=UTF-8" %>
        <html>

        <head>
            <title>Login</title>
        </head>

        <body>
            <h2>Đăng nhập</h2>
            <form method="post" action="<c:url value='/doLogin'/>">
                <label>Phone: <input type="text" name="phone" /></label>
                <label>Password: <input type="password" name="password" /></label>
                <button type="submit">Login</button>
            </form>


            <c:if test="${param.error != null}">
                <p style="color:red;">Sai tài khoản hoặc mật khẩu!</p>
            </c:if>
            <c:if test="${param.logout != null}">
                <p style="color:green;">Đăng xuất thành công!</p>
            </c:if>
        </body>

        </html>
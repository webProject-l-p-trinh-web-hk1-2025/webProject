<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ page contentType="text/html;charset=UTF-8" language="java" %>
        <html>

        <head>
            <title>Login Page</title>
        </head>

        <body>
            <h2>Login</h2>
            <form action="/dologin" method="post">
                <label for="phone">Phone:</label>
                <input type="text" id="phone" name="phone" required><br><br>

                <label for="password">Password:</label>
                <input type="password" id="password" name="password" required><br><br>

                <button type="submit">Login</button>
            </form>

            <c:if test="${not empty message}">
                <p style="color:green">${message}</p>
            </c:if>

            <c:if test="${not empty error}">
                <p style="color:red">${error}</p>
            </c:if>
            <p>Don't have an account? <a href="/register">Register here</a></p>
            <a href="/resetPassword">
                <p>Forget password</p>
            </a>
        </body>

        </html>
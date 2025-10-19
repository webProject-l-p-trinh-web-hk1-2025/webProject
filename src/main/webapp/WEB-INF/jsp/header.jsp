<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div style="background:#eee;padding:10px;">
    <a href="/home">Trang chủ</a> |
    <c:choose>
        <c:when test="${not empty username}">
            <a href="/cart">
                🛒 Giỏ hàng
                <span style="color:red;">
                    (${cartItemCount != null ? cartItemCount : 0})
                </span>
            </a>
            | Xin chào, <strong>${username}</strong>
            <form action="/dologout" method="post" style="display:inline;">
                <button type="submit">Đăng xuất</button>
            </form>
        </c:when>
        <c:otherwise>
            <a href="/login">Đăng nhập</a>
        </c:otherwise>
    </c:choose>
</div>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page import="org.springframework.security.core.context.SecurityContextHolder" %>
<%@ page import="org.springframework.security.core.Authentication" %>
<%@ page import="org.springframework.security.authentication.AnonymousAuthenticationToken" %>
<%
    Authentication auth = SecurityContextHolder.getContext().getAuthentication();
    boolean isAuthenticated = auth != null && auth.isAuthenticated() && !(auth instanceof AnonymousAuthenticationToken);
    request.setAttribute("isUserAuthenticated", isAuthenticated);
%>

<!-- HEADER -->
<header>
    <!-- TOP HEADER -->
    <div id="top-header">
        <div class="container">
            <ul class="header-links pull-left">
                <li><a href="https://zalo.me/0889251007" target="_blank"><i class="fa fa-phone"></i> +84 889-251-007</a></li>
                <li><a href="mailto:kietccc21@gmail.com"><i class="fa fa-envelope-o"></i> kietccc21@gmail.com</a></li>
                <li><a href="https://www.google.com/maps/place/Tr%C6%B0%E1%BB%9Dng+%C4%90%E1%BA%A1i+h%E1%BB%8Dc+S%C6%B0+ph%E1%BA%A1m+K%E1%BB%B9+thu%E1%BA%ADt+Th%C3%A0nh+ph%E1%BB%91+H%E1%BB%93+Ch%C3%AD+Minh/@10.8505683,106.7717721,17z/data=!4m6!3m5!1s0x31752763f23816ab:0x282f711441b6916f!8m2!3d10.8506324!4d106.7719131!16s%2Fm%2F02pz17z?entry=ttu&g_ep=EgoyMDI1MTAxNC4wIKXMDSoASAFQAw%3D%3D" target="_blank"><i class="fa fa-map-marker"></i> Trường ĐH Sư Phạm Kỹ Thuật - 1 Võ Văn Ngân, Linh Chiểu, Thủ Đức, TP.HCM</a></li>
            </ul>
            <ul class="header-links pull-right">
                <li><a href="#"><i class="fa fa-dollar"></i> VNĐ</a></li>
                <c:choose>
                    <c:when test="${isUserAuthenticated}">
                        <li><a href="${pageContext.request.contextPath}/profile">
                            <i class="fa fa-user-o"></i> Tài khoản của tôi
                        </a></li>
                        <li>
                            <form action="${pageContext.request.contextPath}/dologout" method="post" style="display: inline;">
                                <button type="submit" style="background: none; border: none; color: inherit; cursor: pointer;">
                                    <i class="fa fa-sign-out"></i> Đăng xuất
                                </button>
                            </form>
                        </li>
                    </c:when>
                    <c:otherwise>
                        <li><a href="${pageContext.request.contextPath}/login">
                            <i class="fa fa-user-o"></i> Đăng nhập
                        </a></li>
                        <li><a href="${pageContext.request.contextPath}/register">
                            <i class="fa fa-user-plus"></i> Đăng ký
                        </a></li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </div>
    </div>
    <!-- /TOP HEADER -->

    <!-- MAIN HEADER -->
    <div id="header">
        <div class="container">
            <div class="row">
                <!-- LOGO -->
                <div class="col-md-3">
                    <div class="header-logo">
                        <a href="${pageContext.request.contextPath}/" class="logo">
                            <h2 style="color: #D10024; margin: 15px 0;">PhoneStore</h2>
                        </a>
                    </div>
                </div>
                <!-- /LOGO -->

                <!-- SEARCH BAR -->
                <div class="col-md-6">
                    <div class="header-search">
                        <!-- Submit to the products page and use 'name' param to match product search JS -->
                        <form action="${pageContext.request.contextPath}/products" method="get">
                            <select class="input-select" name="category">
                                <option value="">Tất cả hãng điện thoại</option>
                                <c:forEach items="${categories}" var="cat">
                                    <option value="${cat.id}">${cat.name}</option>
                                </c:forEach>
                            </select>
                            <input class="input" name="name" placeholder="Tìm kiếm sản phẩm...">
                            <button class="search-btn" type="submit">Tìm kiếm</button>
                        </form>
                    </div>
                </div>
                <!-- /SEARCH BAR -->

                <!-- ACCOUNT -->
                <div class="col-md-3 clearfix">
                    <div class="header-ctn">
                        <!-- Wishlist -->
                        <div>
                            <a href="${pageContext.request.contextPath}/wishlist">
                                <i class="fa fa-heart-o"></i>
                                <span>Yêu thích</span>
                                <div class="qty" id="wishlist-qty">0</div>
                            </a>
                        </div>
                        <!-- /Wishlist -->

                        <!-- Cart -->
                        <div>
                            <%
                                org.springframework.security.core.Authentication cartAuth = org.springframework.security.core.context.SecurityContextHolder.getContext().getAuthentication();
                                boolean isCartAuthenticated = cartAuth != null && cartAuth.isAuthenticated() && !(cartAuth instanceof org.springframework.security.authentication.AnonymousAuthenticationToken);
                                String cartUrl = isCartAuthenticated ? request.getContextPath() + "/cart" : request.getContextPath() + "/login";
                            %>
                            <a href="<%= cartUrl %>">
                                <i class="fa fa-shopping-cart"></i>
                                <span>Giỏ hàng</span>
                                <div class="qty" id="cart-qty">0</div>
                            </a>
                        </div>
                        <!-- /Cart -->

                        <!-- Menu Toggle -->
                        <div class="menu-toggle">
                            <a href="#">
                                <i class="fa fa-bars"></i>
                                <span>Menu</span>
                            </a>
                        </div>
                        <!-- /Menu Toggle -->
                    </div>
                </div>
                <!-- /ACCOUNT -->
            </div>
        </div>
    </div>
    <!-- /MAIN HEADER -->
</header>
<!-- /HEADER -->

<!-- NAVIGATION -->
<nav id="navigation">
    <div class="container">
        <div id="responsive-nav">
            <ul class="main-nav nav navbar-nav">
                <li><a href="${pageContext.request.contextPath}/">Trang chủ</a></li>
                <li><a href="${pageContext.request.contextPath}/shop">Sản phẩm</a></li>
                <li><a href="${pageContext.request.contextPath}/deals">Khuyến mãi</a></li>
                <c:if test="${isUserAuthenticated}">
                    <%
                        Authentication navAuth = SecurityContextHolder.getContext().getAuthentication();
                        boolean isAdmin = navAuth.getAuthorities().stream()
                            .anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN"));
                        request.setAttribute("isAdmin", isAdmin);
                    %>
                    <c:if test="${isAdmin}">
                        <li><a href="${pageContext.request.contextPath}/admin">Quản trị</a></li>
                    </c:if>
                </c:if>
            </ul>
        </div>
    </div>
</nav>
<!-- /NAVIGATION -->

<script>
// Function to update cart count (global function)
function updateGlobalCartCount() {
    <%
        org.springframework.security.core.Authentication scriptAuth = org.springframework.security.core.context.SecurityContextHolder.getContext().getAuthentication();
        boolean isScriptAuthenticated = scriptAuth != null && scriptAuth.isAuthenticated() && !(scriptAuth instanceof org.springframework.security.authentication.AnonymousAuthenticationToken);
    %>
    var isLoggedIn = <%= isScriptAuthenticated %>;
    
    if (!isLoggedIn) return;
    
    fetch('${pageContext.request.contextPath}/api/cart', {
        method: 'GET',
        credentials: 'include',
        headers: {
            'Content-Type': 'application/json'
        }
    })
    .then(function(response) {
        if (response.ok) {
            return response.json();
        }
        return null;
    })
    .then(function(data) {
        if (data && data.items) {
            var totalItems = data.items.reduce(function(sum, item) { return sum + item.quantity; }, 0);
            var qtyElement = document.getElementById('cart-qty');
            if (qtyElement) {
                qtyElement.textContent = totalItems;
            }
        }
    })
    .catch(function(error) {
        console.error('Error updating cart count:', error);
    });
}

// Function to update wishlist count (global function)
function updateGlobalWishlistCount() {
    <%
        org.springframework.security.core.Authentication wishlistAuth = org.springframework.security.core.context.SecurityContextHolder.getContext().getAuthentication();
        boolean isWishlistAuthenticated = wishlistAuth != null && wishlistAuth.isAuthenticated() && !(wishlistAuth instanceof org.springframework.security.authentication.AnonymousAuthenticationToken);
    %>
    var isLoggedIn = <%= isWishlistAuthenticated %>;
    
    if (!isLoggedIn) return;
    
    fetch('${pageContext.request.contextPath}/api/favorite', {
        method: 'GET',
        credentials: 'include',
        headers: {
            'Content-Type': 'application/json'
        }
    })
    .then(function(response) {
        if (response.ok) {
            return response.json();
        }
        return null;
    })
    .then(function(data) {
        if (data) {
            var qtyElement = document.getElementById('wishlist-qty');
            if (qtyElement) {
                qtyElement.textContent = data.length;
            }
        }
    })
    .catch(function(error) {
        console.error('Error updating wishlist count:', error);
    });
}

// Update counts on page load
window.addEventListener('DOMContentLoaded', function() {
    updateGlobalCartCount();
    updateGlobalWishlistCount();
});
</script>

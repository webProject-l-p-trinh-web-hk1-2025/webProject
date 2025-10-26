<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8" %> <%@ taglib prefix="c" uri="jakarta.tags.core" %> <%@
page import="org.springframework.security.core.context.SecurityContextHolder" %>
<%@ page import="org.springframework.security.core.Authentication" %> <%@ page
import="org.springframework.security.authentication.AnonymousAuthenticationToken"
%> <% Authentication auth =
SecurityContextHolder.getContext().getAuthentication(); boolean isAuthenticated
= auth != null && auth.isAuthenticated() && !(auth instanceof
AnonymousAuthenticationToken); request.setAttribute("isUserAuthenticated",
isAuthenticated); %>

<!-- HEADER -->
<header>
  <!-- TOP HEADER -->
  <div id="top-header">
    <div class="container">
      <ul class="header-links pull-left">
        <li>
          <a href="#"><i class="fa fa-phone"></i> +84 123-456-789</a>
        </li>
        <li>
          <a href="#"><i class="fa fa-envelope-o"></i> contact@phonestore.vn</a>
        </li>
        <li>
          <a href="#"
            ><i class="fa fa-map-marker"></i> 268 Lý Thường Kiệt, Quận 10,
            TP.HCM</a
          >
        </li>
      </ul>
      <ul class="header-links pull-right">
        <c:choose>
          <c:when test="${isUserAuthenticated}">
            <li>
              <a href="${pageContext.request.contextPath}/profile">
                <i class="fa fa-user-o"></i> Tài khoản của tôi
              </a>
            </li>
            <li>
              <form
                action="${pageContext.request.contextPath}/dologout"
                method="post"
                style="display: inline"
              >
                <button
                  type="submit"
                  style="
                    background: none;
                    border: none;
                    color: inherit;
                    cursor: pointer;
                  "
                >
                  <i class="fa fa-sign-out"></i> Đăng xuất
                </button>
              </form>
            </li>
          </c:when>
          <c:otherwise>
            <li>
              <a href="${pageContext.request.contextPath}/login">
                <i class="fa fa-user-o"></i> Đăng nhập
              </a>
            </li>
            <li>
              <a href="${pageContext.request.contextPath}/register">
                <i class="fa fa-user-plus"></i> Đăng ký
              </a>
            </li>
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
              <h2 style="color: #d10024; margin: 15px 0">PhoneStore</h2>
              <h2 style="color: #ffffff; margin: 15px 0">Welcome, Admin</h2>
            </a>
          </div>
        </div>

        <!-- /LOGO -->

        <!-- SEARCH BAR -->
        <!-- <div class="col-md-6">
          <div class="header-search">
           
          </div>
        </div> -->
        <!-- /SEARCH BAR -->

        <!-- ACCOUNT -->
        <!-- <div class="col-md-3 clearfix">
          <div class="header-ctn"> -->
        <!-- Wishlist -->
        <!-- <div>
              <a href="${pageContext.request.contextPath}/wishlist">
                <i class="fa fa-heart-o"></i>
                <span>Yêu thích</span>
                <div class="qty" id="wishlist-qty">0</div>
              </a>
            </div> -->
        <!-- /Wishlist -->

        <!-- Cart -->
        <!-- <div>
              <% org.springframework.security.core.Authentication cartAuth =
              org.springframework.security.core.context.SecurityContextHolder.getContext().getAuthentication();
              boolean isCartAuthenticated = cartAuth != null &&
              cartAuth.isAuthenticated() && !(cartAuth instanceof
              org.springframework.security.authentication.AnonymousAuthenticationToken);
              String cartUrl = isCartAuthenticated ? request.getContextPath() +
              "/cart" : request.getContextPath() + "/login"; %>
              <a href="<%= cartUrl %>">
                <i class="fa fa-shopping-cart"></i>
                <span>Giỏ hàng</span>
                <div class="qty" id="cart-qty">0</div>
              </a>
            </div> -->
        <!-- /Cart -->

        <!-- Menu Toggle -->
        <!-- <div class="menu-toggle">
              <a href="#">
                <i class="fa fa-bars"></i>
                <span>Menu</span>
              </a>
            </div> -->
        <!-- /Menu Toggle -->
        <!-- </div>
        </div> -->
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
        <!-- <li>
          <a href="${pageContext.request.contextPath}/products">Sản phẩm</a>
        </li>
        <li>
          <a href="${pageContext.request.contextPath}/deals">Khuyến mãi</a>
        </li> -->
        <c:if test="${isUserAuthenticated}">
          <% Authentication navAuth =
          SecurityContextHolder.getContext().getAuthentication(); boolean
          isAdmin = navAuth.getAuthorities().stream() .anyMatch(a ->
          a.getAuthority().equals("ROLE_ADMIN"));
          request.setAttribute("isAdmin", isAdmin); %>
          <c:if test="${isAdmin}">
            <li>
              <a href="${pageContext.request.contextPath}/admin">Quản trị</a>
            </li>
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

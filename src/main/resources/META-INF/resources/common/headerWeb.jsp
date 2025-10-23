<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8" %> <%@ taglib prefix="c" uri="jakarta.tags.core" %> <%@
page import="org.springframework.security.core.context.SecurityContextHolder" %>
<%@ page import="org.springframework.security.core.Authentication" %> <%@ page
import="org.springframework.security.authentication.AnonymousAuthenticationToken"
%> <% Authentication
auth=SecurityContextHolder.getContext().getAuthentication(); boolean
isAuthenticated=auth !=null && auth.isAuthenticated() && !(auth instanceof
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
        <li>
          <a href="#"><i class="fa fa-dollar"></i> VNĐ</a>
        </li>
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
              <h2 style="color: #d10024; margin: 15px 0">CellPhoneStore</h2>
            </a>
          </div>
        </div>
        <!-- /LOGO -->

        <!-- SEARCH BAR -->
        <div class="col-md-6">
          <div class="header-search" style="position: relative">
            <!-- Submit to the shop page with name parameter for search -->
            <form
              action="${pageContext.request.contextPath}/shop"
              method="get"
              id="searchForm"
            >
              <select class="input-select" name="category" id="searchCategory">
                <option value="">Tất cả hãng điện thoại</option>
                <c:forEach items="${categories}" var="cat">
                  <option value="${cat.id}">${cat.name}</option>
                </c:forEach>
              </select>
              <input
                class="input"
                name="name"
                id="searchInput"
                placeholder="Tìm kiếm sản phẩm..."
                autocomplete="off"
              />
              <button class="search-btn" type="submit">Tìm kiếm</button>
            </form>
            <!-- Search Suggestions Dropdown -->
            <div
              id="searchSuggestions"
              style="
                position: absolute;
                top: 100%;
                left: 0;
                right: 0;
                background: white;
                border: 1px solid #ddd;
                border-top: none;
                max-height: 400px;
                overflow-y: auto;
                z-index: 9999;
                display: none;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
              "
            ></div>
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
              <% org.springframework.security.core.Authentication
              cartAuth=org.springframework.security.core.context.SecurityContextHolder.getContext().getAuthentication();
              boolean isCartAuthenticated=cartAuth !=null &&
              cartAuth.isAuthenticated() && !(cartAuth instanceof
              org.springframework.security.authentication.AnonymousAuthenticationToken);
              String cartUrl=isCartAuthenticated ? request.getContextPath() +
              "/cart" : request.getContextPath() + "/login" ; %>
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
        <li>
          <a href="${pageContext.request.contextPath}/shop">Sản phẩm</a>
        </li>
        <li>
          <a href="${pageContext.request.contextPath}/deals">Khuyến mãi</a>
        </li>
        <c:if test="${isUserAuthenticated}">
          <% Authentication
          navAuth=SecurityContextHolder.getContext().getAuthentication();
          boolean isAdmin=navAuth.getAuthorities().stream() .anyMatch(a ->
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
              .then(function (response) {
                if (response.ok) {
                  return response.json();
                }
                return null;
              })
              .then(function (data) {
                if (data && data.items) {
                  var totalItems = data.items.reduce(function (sum, item) { return sum + item.quantity; }, 0);
                  var qtyElement = document.getElementById('cart-qty');
                  if (qtyElement) {
                    qtyElement.textContent = totalItems;
                  }
                }
              })
              .catch(function (error) {
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
              .then(function (response) {
                if (response.ok) {
                  return response.json();
                }
                return null;
              })
              .then(function (data) {
                if (data) {
                  var qtyElement = document.getElementById('wishlist-qty');
                  if (qtyElement) {
                    qtyElement.textContent = data.length;
                  }
                }
              })
              .catch(function (error) {
                console.error('Error updating wishlist count:', error);
              });
          }

          // Update counts on page load
          window.addEventListener('DOMContentLoaded', function () {
            updateGlobalCartCount();
            updateGlobalWishlistCount();
            initSearchAutocomplete();
          });

          // ========== SEARCH AUTOCOMPLETE ==========
          function initSearchAutocomplete() {
            var searchInput = document.getElementById('searchInput');
            var suggestionsBox = document.getElementById('searchSuggestions');
            var searchForm = document.getElementById('searchForm');
            var debounceTimer;

            if (!searchInput || !suggestionsBox) return;

            // Debounce search to avoid too many API calls
            searchInput.addEventListener('input', function () {
              clearTimeout(debounceTimer);
              var query = searchInput.value.trim();

              if (query.length < 2) {
                suggestionsBox.style.display = 'none';
                return;
              }

              debounceTimer = setTimeout(function () {
                fetchSuggestions(query);
              }, 300); // Wait 300ms after user stops typing
            });

            // Close suggestions when clicking outside
            document.addEventListener('click', function (e) {
              if (!searchInput.contains(e.target) && !suggestionsBox.contains(e.target)) {
                suggestionsBox.style.display = 'none';
              }
            });

            // Show suggestions when input is focused and has value
            searchInput.addEventListener('focus', function () {
              if (searchInput.value.trim().length >= 2) {
                fetchSuggestions(searchInput.value.trim());
              }
            });
          }

          function fetchSuggestions(query) {
            var suggestionsBox = document.getElementById('searchSuggestions');

            fetch('${pageContext.request.contextPath}/api/products/search-suggestions?q=' + encodeURIComponent(query) + '&limit=5')
              .then(function (response) {
                if (!response.ok) throw new Error('Failed to fetch');
                return response.json();
              })
              .then(function (products) {
                displaySuggestions(products);
              })
              .catch(function (error) {
                console.error('Error fetching suggestions:', error);
                suggestionsBox.style.display = 'none';
              });
          }

          function displaySuggestions(products) {
            var suggestionsBox = document.getElementById('searchSuggestions');

            if (!products || products.length === 0) {
              suggestionsBox.innerHTML = '<div style="padding: 15px; text-align: center; color: #999;">Không tìm thấy sản phẩm</div>';
              suggestionsBox.style.display = 'block';
              return;
            }

            var html = '';
            products.forEach(function (product) {
              var imgSrc = product.imageUrl && product.imageUrl.trim() !== ''
                ? '${pageContext.request.contextPath}' + product.imageUrl
                : '${pageContext.request.contextPath}/images/no-image.png';

              var price = formatPrice(product.price);

              html += '<a href="${pageContext.request.contextPath}/product/' + product.id + '" style="display: block; padding: 10px; border-bottom: 1px solid #eee; text-decoration: none; color: inherit; transition: background 0.2s;" onmouseover="this.style.background=\'#f8f8f8\'" onmouseout="this.style.background=\'white\'">' +
                '<div style="display: flex; align-items: center; gap: 12px;">' +
                '<img src="' + imgSrc + '" alt="' + product.name + '" style="width: 50px; height: 50px; object-fit: contain; border: 1px solid #eee; border-radius: 4px;">' +
                '<div style="flex: 1; min-width: 0;">' +
                '<div style="font-weight: 500; color: #333; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">' + product.name + '</div>' +
                '<div style="color: #d70018; font-weight: bold; font-size: 14px; margin-top: 4px;">' + price + '</div>' +
                '</div>' +
                '</div>' +
                '</a>';
            });

            // Add "View all results" link
            var searchQuery = document.getElementById('searchInput').value;
            html += '<a href="${pageContext.request.contextPath}/shop?name=' + encodeURIComponent(searchQuery) + '" style="display: block; padding: 12px; text-align: center; background: #f5f5f5; color: #d70018; font-weight: 500; text-decoration: none; border-top: 2px solid #eee;">' +
              'Xem tất cả kết quả <i class="fa fa-arrow-right"></i>' +
              '</a>';

            suggestionsBox.innerHTML = html;
            suggestionsBox.style.display = 'block';
          }

          function formatPrice(price) {
            if (!price) return '0đ';
            return new Intl.NumberFormat('vi-VN').format(price) + 'đ';
          }

          // ========== STICKY HEADER ON SCROLL ==========
          window.addEventListener('DOMContentLoaded', function () {
            // Skip sticky header on order and cart pages
            var currentPath = window.location.pathname;
            if (currentPath.includes('/order/') || currentPath.includes('/cart')) {
              return; // Don't apply sticky header on order and cart pages
            }

            var header = document.querySelector('header');
            var navigation = document.getElementById('navigation');
            var headerHeight = header ? header.offsetHeight : 0;
            var stickyOffset = headerHeight;

            // Add placeholder to prevent content jump
            var placeholder = document.createElement('div');
            placeholder.id = 'header-placeholder';
            placeholder.style.display = 'none';

            if (header && header.parentNode) {
              header.parentNode.insertBefore(placeholder, header);
            }

            window.addEventListener('scroll', function () {
              var scrollTop = window.pageYOffset || document.documentElement.scrollTop;

              if (scrollTop > stickyOffset) {
                // Make header sticky
                if (header) {
                  header.style.position = 'fixed';
                  header.style.top = '0';
                  header.style.left = '0';
                  header.style.right = '0';
                  header.style.zIndex = '9999';
                  header.style.boxShadow = '0 2px 8px rgba(0,0,0,0.1)';
                  header.style.animation = 'slideDown 0.3s ease-out';
                }

                if (navigation) {
                  navigation.style.position = 'fixed';
                  navigation.style.top = header ? header.offsetHeight + 'px' : '0';
                  navigation.style.left = '0';
                  navigation.style.right = '0';
                  navigation.style.zIndex = '9998';
                  navigation.style.boxShadow = '0 2px 5px rgba(0,0,0,0.1)';
                }

                // Show placeholder to prevent content jump
                placeholder.style.display = 'block';
                placeholder.style.height = (headerHeight + (navigation ? navigation.offsetHeight : 0)) + 'px';
              } else {
                // Reset to normal
                if (header) {
                  header.style.position = 'relative';
                  header.style.boxShadow = 'none';
                  header.style.animation = 'none';
                }

                if (navigation) {
                  navigation.style.position = 'relative';
                  navigation.style.top = '0';
                  navigation.style.boxShadow = 'none';
                }

                placeholder.style.display = 'none';
              }
            });
          });
</script>

<style>
  @keyframes slideDown {
    from {
      transform: translateY(-100%);
      opacity: 0;
    }

    to {
      transform: translateY(0);
      opacity: 1;
    }
  }

  /* Ensure header transitions smoothly */
  header {
    transition: box-shadow 0.3s ease;
    background: white;
  }

  #navigation {
    transition: box-shadow 0.3s ease;
    background: white;
  }

  /* Adjust search suggestions z-index when header is sticky */
  #searchSuggestions {
    z-index: 10000 !important;
  }
</style>

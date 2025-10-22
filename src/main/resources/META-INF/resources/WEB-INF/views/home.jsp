<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="utf-8">
                <meta http-equiv="X-UA-Compatible" content="IE=edge">
                <meta name="viewport" content="width=device-width, initial-scale=1">
                <title>CellphoneZ - Trang chủ</title>
            </head>

            <body>
                <!-- SECTION -->
                <div class="section">
                    <!-- container -->
                    <div class="container">
                        <!-- row -->
                        <div class="row">
                            <c:forEach items="${categories}" var="cat" begin="0" end="2" varStatus="status">
                                <!-- shop -->
                                <div class="col-md-4 col-xs-6">
                                    <div class="shop">
                                        <div class="shop-img">
                                            <c:choose>
                                                <c:when test="${status.index == 0}">
                                                    <img src="${pageContext.request.contextPath}/uploads/products/banersamsung.jpg"
                                                        alt="${cat.name}"
                                                        style="width: 100%; height: 300px; object-fit: cover;">
                                                </c:when>
                                                <c:when test="${status.index == 1}">
                                                    <img src="${pageContext.request.contextPath}/uploads/products/bannerapple.jpg"
                                                        alt="${cat.name}"
                                                        style="width: 100%; height: 300px; object-fit: cover;">
                                                </c:when>
                                                <c:otherwise>
                                                    <img src="${pageContext.request.contextPath}/uploads/products/banerxiaomi.jpg"
                                                        alt="${cat.name}"
                                                        style="width: 100%; height: 300px; object-fit: cover;">
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div class="shop-body">
                                            <h3>${cat.name}<br>Collection</h3>
                                            <a href="${pageContext.request.contextPath}/shop?category=${cat.id}"
                                                class="cta-btn">Xem ngay <i class="fa fa-arrow-circle-right"></i></a>
                                        </div>
                                    </div>
                                </div>
                                <!-- /shop -->
                            </c:forEach>
                        </div>
                        <!-- /row -->
                    </div>
                    <!-- /container -->
                </div>
                <!-- /SECTION -->

                <!-- SECTION -->
                <div class="section">
                    <!-- container -->
                    <div class="container">
                        <!-- row -->
                        <div class="row">

                            <!-- section title -->
                            <div class="col-md-12">
                                <div class="section-title">
                                    <h3 class="title">Sản phẩm mới</h3>
                                    <div class="section-nav">
                                        <ul class="section-tab-nav tab-nav">
                                            <c:forEach items="${categories}" var="cat" varStatus="status">
                                                <li <c:if test="${status.first}">class="active"</c:if>>
                                                    <a data-toggle="tab" href="#tab-${cat.id}">${cat.name}</a>
                                                </li>
                                            </c:forEach>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                            <!-- /section title -->

                            <!-- Products tab & slick -->
                            <div class="col-md-12">
                                <div class="row">
                                    <div class="products-tabs">
                                        <c:forEach items="${categories}" var="cat" varStatus="status">
                                            <!-- tab -->
                                            <div id="tab-${cat.id}"
                                                class="tab-pane <c:if test='${status.first}'>active</c:if>">
                                                <div class="products-slick" data-nav="#slick-nav-${cat.id}">
                                                    <c:forEach items="${products}" var="product">
                                                        <c:if test="${product.category.id == cat.id}">
                                                            <!-- product -->
                                                            <div class="product">
                                                                <div class="product-img">
                                                                    <c:choose>
                                                                        <c:when test="${not empty product.imageUrl}">
                                                                            <img src="${pageContext.request.contextPath}${product.imageUrl}"
                                                                                alt="${product.name}"
                                                                                style="max-height: 250px; object-fit: contain;">
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <img src="${pageContext.request.contextPath}/img/product-placeholder.png"
                                                                                alt="${product.name}"
                                                                                style="max-height: 250px; object-fit: contain;">
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                    <c:if test="${product.stock == 0}">
                                                                        <div class="product-label">
                                                                            <span class="sale">HẾT HÀNG</span>
                                                                        </div>
                                                                    </c:if>
                                                                </div>
                                                                <div class="product-body">
                                                                    <p class="product-category">${product.category.name}
                                                                    </p>
                                                                    <h3 class="product-name">
                                                                        <a
                                                                            href="${pageContext.request.contextPath}/product/${product.id}">${product.name}</a>
                                                                    </h3>
                                                                    <h4 class="product-price">
                                                                        <fmt:formatNumber value="${product.price}"
                                                                            type="currency" currencySymbol="₫"
                                                                            maxFractionDigits="0" />
                                                                    </h4>
                                                                    <div class="product-rating">
                                                                        <i class="fa fa-star"></i>
                                                                        <i class="fa fa-star"></i>
                                                                        <i class="fa fa-star"></i>
                                                                        <i class="fa fa-star"></i>
                                                                        <i class="fa fa-star-o"></i>
                                                                    </div>
                                                                    <div class="product-btns">
                                                                        <button class="add-to-wishlist"
                                                                            data-product-id="${product.id}"
                                                                            onclick="toggleFavorite(${product.id}, this)">
                                                                            <i class="fa fa-heart-o"></i>
                                                                            <span class="tooltipp">Yêu thích</span>
                                                                        </button>
                                                                        <a href="${pageContext.request.contextPath}/product/${product.id}"
                                                                            class="quick-view">
                                                                            <i class="fa fa-eye"></i>
                                                                            <span class="tooltipp">Xem chi tiết</span>
                                                                        </a>
                                                                    </div>
                                                                </div>
                                                                <div class="add-to-cart">
                                                                    <c:choose>
                                                                        <c:when test="${product.stock > 0}">
                                                                            <button class="add-to-cart-btn"
                                                                                onclick="addToCart(${product.id})">
                                                                                <i class="fa fa-shopping-cart"></i> Thêm
                                                                                vào giỏ
                                                                            </button>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <button class="add-to-cart-btn" disabled
                                                                                style="background: #999;">
                                                                                <i class="fa fa-ban"></i> Hết hàng
                                                                            </button>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </div>
                                                            </div>
                                                            <!-- /product -->
                                                        </c:if>
                                                    </c:forEach>
                                                </div>
                                                <div id="slick-nav-${cat.id}" class="products-slick-nav"></div>
                                            </div>
                                            <!-- /tab -->
                                        </c:forEach>
                                    </div>
                                </div>
                            </div>
                            <!-- Products tab & slick -->
                        </div>
                        <!-- /row -->
                    </div>
                    <!-- /container -->
                </div>
                <!-- /SECTION -->

                <!-- HOT DEAL SECTION -->
                <div id="hot-deal" class="section">
                    <!-- container -->
                    <div class="container">
                        <!-- row -->
                        <div class="row">
                            <div class="col-md-12">
                                <div class="hot-deal">
                                    <ul class="hot-deal-countdown">
                                        <li>
                                            <div>
                                                <h3>02</h3>
                                                <span>Ngày</span>
                                            </div>
                                        </li>
                                        <li>
                                            <div>
                                                <h3>10</h3>
                                                <span>Giờ</span>
                                            </div>
                                        </li>
                                        <li>
                                            <div>
                                                <h3>34</h3>
                                                <span>Phút</span>
                                            </div>
                                        </li>
                                        <li>
                                            <div>
                                                <h3>60</h3>
                                                <span>Giây</span>
                                            </div>
                                        </li>
                                    </ul>
                                    <h2 class="text-uppercase">Flash Sale hôm nay</h2>
                                    <p>Giảm giá lên đến 50%</p>
                                    <a class="primary-btn cta-btn" href="${pageContext.request.contextPath}/shop">Mua
                                        ngay</a>
                                </div>
                            </div>
                        </div>
                        <!-- /row -->
                    </div>
                    <!-- /container -->
                </div>
                <!-- /HOT DEAL SECTION -->

                <!-- SECTION -->
                <div class="section">
                    <!-- container -->
                    <div class="container">
                        <!-- row -->
                        <div class="row">

                            <!-- section title -->
                            <div class="col-md-12">
                                <div class="section-title">
                                    <h3 class="title">Sản phẩm bán chạy</h3>
                                </div>
                            </div>
                            <!-- /section title -->

                            <!-- Products single -->
                            <c:forEach items="${products}" var="product" begin="0" end="11">
                                <div class="col-md-3 col-xs-6">
                                    <div class="product">
                                        <div class="product-img">
                                            <c:choose>
                                                <c:when test="${not empty product.imageUrl}">
                                                    <img src="${pageContext.request.contextPath}${product.imageUrl}"
                                                        alt="${product.name}"
                                                        style="max-height: 250px; object-fit: contain;">
                                                </c:when>
                                                <c:otherwise>
                                                    <img src="${pageContext.request.contextPath}/img/product-placeholder.png"
                                                        alt="${product.name}"
                                                        style="max-height: 250px; object-fit: contain;">
                                                </c:otherwise>
                                            </c:choose>
                                            <c:if test="${product.stock == 0}">
                                                <div class="product-label">
                                                    <span class="sale">HẾT HÀNG</span>
                                                </div>
                                            </c:if>
                                        </div>
                                        <div class="product-body">
                                            <p class="product-category">${product.category.name}</p>
                                            <h3 class="product-name">
                                                <a
                                                    href="${pageContext.request.contextPath}/product/${product.id}">${product.name}</a>
                                            </h3>
                                            <h4 class="product-price">
                                                <fmt:formatNumber value="${product.price}" type="currency"
                                                    currencySymbol="₫" maxFractionDigits="0" />
                                            </h4>
                                            <div class="product-rating">
                                                <i class="fa fa-star"></i>
                                                <i class="fa fa-star"></i>
                                                <i class="fa fa-star"></i>
                                                <i class="fa fa-star"></i>
                                                <i class="fa fa-star-o"></i>
                                            </div>
                                            <div class="product-btns">
                                                <button class="add-to-wishlist" data-product-id="${product.id}"
                                                    onclick="toggleFavorite(${product.id}, this)">
                                                    <i class="fa fa-heart-o"></i>
                                                    <span class="tooltipp">Yêu thích</span>
                                                </button>
                                                <a href="${pageContext.request.contextPath}/product/${product.id}"
                                                    class="quick-view">
                                                    <i class="fa fa-eye"></i>
                                                    <span class="tooltipp">Xem chi tiết</span>
                                                </a>
                                            </div>
                                        </div>
                                        <div class="add-to-cart">
                                            <c:choose>
                                                <c:when test="${product.stock > 0}">
                                                    <button class="add-to-cart-btn" onclick="addToCart(${product.id})">
                                                        <i class="fa fa-shopping-cart"></i> Thêm vào giỏ
                                                    </button>
                                                </c:when>
                                                <c:otherwise>
                                                    <button class="add-to-cart-btn" disabled style="background: #999;">
                                                        <i class="fa fa-ban"></i> Hết hàng
                                                    </button>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                            <!-- /Products single -->

                        </div>
                        <!-- /row -->
                    </div>
                    <!-- /container -->
                </div>
                <!-- /SECTION -->

                <!-- NEWSLETTER -->
                <div id="newsletter" class="section">
                    <!-- container -->
                    <div class="container">
                        <!-- row -->
                        <div class="row">
                            <div class="col-md-12">
                                <div class="newsletter">
                                    <p>Đăng ký nhận <strong>TIN TỨC MỚI</strong></p>
                                    <form>
                                        <input class="input" type="email" placeholder="Nhập email của bạn">
                                        <button class="newsletter-btn"><i class="fa fa-envelope"></i> Đăng ký</button>
                                    </form>
                                    <ul class="newsletter-follow">
                                        <li><a href="https://www.facebook.com/nhan.le.24813" target="_blank"><i
                                                    class="fa fa-facebook"></i></a></li>
                                        <li><a href="https://x.com/Apple" target="_blank"><i
                                                    class="fa fa-twitter"></i></a></li>
                                        <li><a href="https://www.instagram.com/apple/" target="_blank"><i
                                                    class="fa fa-instagram"></i></a></li>
                                        <li><a href="https://www.pinterest.com/apple/" target="_blank"><i
                                                    class="fa fa-pinterest"></i></a></li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                        <!-- /row -->
                    </div>
                    <!-- /container -->
                </div>
                <!-- /NEWSLETTER -->

                <script>
    <%
                        org.springframework.security.core.Authentication auth = org.springframework.security.core.context.SecurityContextHolder.getContext().getAuthentication();
        boolean isAuthenticated = auth != null && auth.isAuthenticated() && !(auth instanceof org.springframework.security.authentication.AnonymousAuthenticationToken);
    %>
    var IS_LOGGED_IN = <%= isAuthenticated %>;

                    function addToCart(productId) {
                        if (!IS_LOGGED_IN) {
                            alert('Vui lòng đăng nhập để thêm sản phẩm vào giỏ hàng!');
                            window.location.href = '${pageContext.request.contextPath}/login';
                            return;
                        }
                        fetch('${pageContext.request.contextPath}/api/cart/add', {
                            method: 'POST',
                            headers: { 'Content-Type': 'application/json' },
                            credentials: 'include',
                            body: JSON.stringify({ productId: productId, quantity: 1 })
                        })
                            .then(response => {
                                if (response.ok) return response.json();
                                else if (response.status === 401 || response.status === 403) throw new Error('Unauthorized');
                                else throw new Error('Có lỗi xảy ra');
                            })
                            .then(data => {
                                alert('Đã thêm sản phẩm vào giỏ hàng!');
                                if (typeof updateGlobalCartCount === 'function') updateGlobalCartCount();
                            })
                            .catch(error => {
                                if (error.message === 'Unauthorized') {
                                    alert('Phiên đăng nhập hết hạn. Vui lòng đăng nhập lại!');
                                    window.location.href = '${pageContext.request.contextPath}/login';
                                } else {
                                    alert('Có lỗi: ' + error.message);
                                }
                            });
                    }

                    function toggleFavorite(productId, button) {
                        if (!IS_LOGGED_IN) {
                            alert('Vui lòng đăng nhập để thêm vào danh sách yêu thích!');
                            window.location.href = '${pageContext.request.contextPath}/login';
                            return;
                        }
                        var icon = button.querySelector('i');
                        var isFavorited = icon.classList.contains('fa-heart');
                        var url = isFavorited ? '${pageContext.request.contextPath}/api/favorite/remove/' + productId : '${pageContext.request.contextPath}/api/favorite/add';
                        var method = isFavorited ? 'DELETE' : 'POST';
                        var body = isFavorited ? null : JSON.stringify({ productId: productId });

                        fetch(url, {
                            method: method,
                            credentials: 'include',
                            headers: { 'Content-Type': 'application/json' },
                            body: body
                        })
                            .then(response => {
                                if (response.ok) return response.json();
                                else if (response.status === 401 || response.status === 403) throw new Error('Unauthorized');
                                else throw new Error('Có lỗi xảy ra');
                            })
                            .then(data => {
                                if (isFavorited) {
                                    icon.classList.remove('fa-heart');
                                    icon.classList.add('fa-heart-o');
                                    button.style.color = '';
                                    alert('Đã xóa khỏi danh sách yêu thích!');
                                } else {
                                    icon.classList.remove('fa-heart-o');
                                    icon.classList.add('fa-heart');
                                    button.style.color = '#d70018';
                                    alert('Đã thêm vào danh sách yêu thích!');
                                }
                                if (typeof updateGlobalWishlistCount === 'function') updateGlobalWishlistCount();
                            })
                            .catch(error => {
                                if (error.message === 'Unauthorized') {
                                    alert('Phiên đăng nhập hết hạn. Vui lòng đăng nhập lại!');
                                    window.location.href = '${pageContext.request.contextPath}/login';
                                } else {
                                    alert('Có lỗi: ' + error.message);
                                }
                            });
                    }

                    function loadFavoriteStates() {
                        fetch('${pageContext.request.contextPath}/api/favorite', {
                            method: 'GET',
                            credentials: 'include',
                            headers: { 'Content-Type': 'application/json' }
                        })
                            .then(response => response.ok ? response.json() : [])
                            .then(favorites => {
                                favorites.forEach(function (favorite) {
                                    var buttons = document.querySelectorAll('.add-to-wishlist[data-product-id="' + favorite.productId + '"]');
                                    buttons.forEach(function (button) {
                                        var icon = button.querySelector('i');
                                        icon.classList.remove('fa-heart-o');
                                        icon.classList.add('fa-heart');
                                        button.style.color = '#d70018';
                                    });
                                });
                            })
                            .catch(error => console.error('Lỗi khi tải trạng thái yêu thích:', error));
                    }

                    if (IS_LOGGED_IN) {
                        window.addEventListener('DOMContentLoaded', function () {
                            loadFavoriteStates();
                        });
                    }
                </script>
            </body>

            </html>
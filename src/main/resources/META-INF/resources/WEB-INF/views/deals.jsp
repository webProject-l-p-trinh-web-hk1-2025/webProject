<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Khuyến mãi - CellPhoneStore</title>
    
    <style>
        /* Flash Sale Countdown Styling */
        .hot-deal-countdown {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 20px;
            margin: 30px 0;
            padding: 0;
        }

        .hot-deal-countdown li {
            list-style: none;
            display: flex;
            align-items: center;
        }

        .hot-deal-countdown li > div {
            background: linear-gradient(135deg, #fff 0%, #f8f9fa 100%);
            border-radius: 15px;
            padding: 25px 20px;
            width: 100px;
            height: 100px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
            position: relative;
            overflow: hidden;
            animation: pulse 2s ease-in-out infinite;
            border: 3px solid rgba(255, 255, 255, 0.3);
        }

        .hot-deal-countdown li > div::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: linear-gradient(
                45deg,
                transparent,
                rgba(215, 0, 24, 0.1),
                transparent
            );
            transform: rotate(45deg);
            animation: shine 3s infinite;
        }

        .hot-deal-countdown h3 {
            font-size: 42px;
            font-weight: 900;
            color: #cc0000;
            margin: 0;
            line-height: 1;
            text-shadow: 0 3px 10px rgba(204, 0, 0, 0.5);
            font-family: 'Arial Black', sans-serif;
            position: relative;
            z-index: 1;
        }

        .hot-deal-countdown span {
            display: block;
            color: #666;
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-top: 5px;
            font-weight: 600;
            position: relative;
            z-index: 1;
        }

        /* Animations */
        @keyframes pulse {
            0%, 100% {
                transform: scale(1);
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
            }
            50% {
                transform: scale(1.05);
                box-shadow: 0 15px 40px rgba(215, 0, 24, 0.4);
            }
        }

        @keyframes shine {
            0% {
                left: -50%;
                top: -50%;
            }
            100% {
                left: 150%;
                top: 150%;
            }
        }

        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @keyframes float {
            0%, 100% {
                transform: translateY(0);
            }
            50% {
                transform: translateY(-10px);
            }
        }

        /* Flash Sale Section */
        .hot-deal {
            text-align: center;
            padding: 60px 30px;
            position: relative;
            overflow: hidden;
            animation: fadeInUp 1s ease-out;
        }

        .hot-deal::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle, rgba(255,255,255,0.15) 0%, transparent 70%);
            animation: rotate 20s linear infinite;
        }

        @keyframes rotate {
            0% {
                transform: rotate(0deg);
            }
            100% {
                transform: rotate(360deg);
            }
        }

        .hot-deal h2 {
            color: #fff;
            font-size: 48px;
            font-weight: 900;
            text-shadow: 0 5px 20px rgba(0, 0, 0, 0.4);
            margin: 20px 0;
            position: relative;
            z-index: 1;
            animation: fadeInUp 1s ease-out 0.2s both, float 3s ease-in-out infinite;
        }

        .hot-deal p {
            color: rgba(255, 255, 255, 0.95);
            font-size: 24px;
            font-weight: 600;
            margin: 20px 0 30px;
            position: relative;
            z-index: 1;
            animation: fadeInUp 1s ease-out 0.4s both;
        }

        /* Deal Badge Animation */
        @keyframes badgePulse {
            0%, 100% {
                transform: scale(1) rotate(-10deg);
            }
            50% {
                transform: scale(1.1) rotate(-10deg);
            }
        }

        .shop-img > div {
            animation: badgePulse 2s ease-in-out infinite;
        }

        /* Category Card Hover Effect */
        .shop {
            transition: all 0.3s ease;
        }

        .shop:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 30px rgba(0,0,0,0.2) !important;
        }

        .cta-btn {
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .cta-btn::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 50%;
            width: 0;
            height: 0;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.3);
            transform: translate(-50%, -50%);
            transition: width 0.6s, height 0.6s;
        }

        .cta-btn:hover::before {
            width: 300px;
            height: 300px;
        }

        .cta-btn:hover {
            transform: scale(1.05);
            box-shadow: 0 10px 25px rgba(215, 0, 24, 0.4);
        }

        /* Responsive */
        @media (max-width: 768px) {
            .hot-deal-countdown {
                gap: 10px;
            }

            .hot-deal-countdown li > div {
                padding: 15px;
                min-width: 70px;
            }

            .hot-deal-countdown h3 {
                font-size: 32px;
            }

            .hot-deal h2 {
                font-size: 32px;
            }

            .hot-deal p {
                font-size: 18px;
            }
        }
    </style>
</head>

<body>
    <!-- HOT DEAL HERO SECTION -->
    <div id="hot-deal" class="section" style="background: linear-gradient(135deg, #d70018 0%, #ff6b6b 100%);">
        <div class="container">
            <div class="row">
                <div class="col-md-12">
                    <div class="hot-deal">
                        <ul class="hot-deal-countdown">
                            <li>
                                <div>
                                    <h3 id="days">02</h3>
                                    <span>Ngày</span>
                                </div>
                            </li>
                            <li>
                                <div>
                                    <h3 id="hours">10</h3>
                                    <span>Giờ</span>
                                </div>
                            </li>
                            <li>
                                <div>
                                    <h3 id="minutes">34</h3>
                                    <span>Phút</span>
                                </div>
                            </li>
                            <li>
                                <div>
                                    <h3 id="seconds">60</h3>
                                    <span>Giây</span>
                                </div>
                            </li>
                        </ul>
                        <h2 class="text-uppercase">🔥 FLASH SALE 🔥</h2>
                        <p>Giảm giá khủng lên đến 50% - Chỉ trong hôm nay!</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- /HOT DEAL HERO SECTION -->

    <!-- DEALS CATEGORIES -->
    <div class="section">
        <div class="container">
            <div class="row">
                <div class="col-md-12">
                    <div class="section-title">
                        <h3 class="title">🎯 Danh mục khuyến mãi</h3>
                    </div>
                </div>
            </div>
            <div class="row">
                <c:forEach items="${categories}" var="cat" varStatus="status">
                    <div class="col-md-4 col-xs-6" style="margin-bottom: 30px;">
                        <div class="shop" style="position: relative; overflow: hidden; border-radius: 10px; box-shadow: 0 5px 15px rgba(0,0,0,0.1);">
                            <div class="shop-img" style="position: relative;">
                                <c:choose>
                                    <c:when test="${status.index == 0}">
                                        <img src="${pageContext.request.contextPath}/uploads/products/banersamsung.jpg"
                                            alt="${cat.name}" style="width: 100%; height: 250px; object-fit: cover;">
                                        <div style="position: absolute; top: 10px; right: 10px; background: #ff4757; color: white; padding: 5px 10px; border-radius: 20px; font-weight: bold;">
                                            -50%
                                        </div>
                                    </c:when>
                                    <c:when test="${status.index == 1}">
                                        <img src="${pageContext.request.contextPath}/uploads/products/bannerapple.jpg"
                                            alt="${cat.name}" style="width: 100%; height: 250px; object-fit: cover;">
                                        <div style="position: absolute; top: 10px; right: 10px; background: #ff4757; color: white; padding: 5px 10px; border-radius: 20px; font-weight: bold;">
                                            -40%
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <img src="${pageContext.request.contextPath}/uploads/products/banerxiaomi.jpg"
                                            alt="${cat.name}" style="width: 100%; height: 250px; object-fit: cover;">
                                        <div style="position: absolute; top: 10px; right: 10px; background: #ff4757; color: white; padding: 5px 10px; border-radius: 20px; font-weight: bold;">
                                            -60%
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="shop-body" style="text-align: center; padding: 20px;">
                                <h3 style="color: #333; margin-bottom: 15px;">${cat.name}<br><span style="color: #d70018;">Hot Deals</span></h3>
                                <a href="javascript:void(0)" onclick="filterDealsByCategory('${cat.name}')"
                                   class="cta-btn" style="background: linear-gradient(45deg, #d70018, #ff6b6b); border: none; padding: 12px 25px; border-radius: 25px; cursor: pointer;">
                                   Xem ngay <i class="fa fa-arrow-circle-right"></i>
                                </a>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>
    <!-- /DEALS CATEGORIES -->

    <!-- FLASH DEALS PRODUCTS -->
    <div id="deals-products" class="section" style="background: #f8f9fa;">
        <div class="container">
            <div class="row">
                <div class="col-md-12">
                    <div class="section-title">
                        <h3 class="title" id="deals-section-title">⚡ Flash Sale - Giá sốc mỗi giờ</h3>
                        <p style="color: #666;">Cơ hội cuối cùng để sở hữu sản phẩm với giá không thể rẻ hơn!</p>
                        <div style="margin-top: 15px;">
                            <button class="btn btn-outline-secondary btn-sm" onclick="showAllDeals()" style="margin-right: 10px;">
                                <i class="fa fa-th"></i> Tất cả
                            </button>
                            <c:forEach items="${categories}" var="cat">
                                <button class="btn btn-outline-secondary btn-sm category-filter-btn" onclick="filterDealsByCategory('${cat.name}')" style="margin-right: 10px;">
                                    ${cat.name}
                                </button>
                            </c:forEach>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Products grid -->
            <div class="row" id="products-container">
                <c:forEach items="${products}" var="product" varStatus="status">
                    <div class="col-md-3 col-xs-6 product-item" 
                         data-category="${product.category != null ? product.category.name : ''}"
                         data-brand="${product.brand}"
                         style="margin-bottom: 30px;">
                        <div class="product" style="border-radius: 10px; overflow: hidden; box-shadow: 0 5px 15px rgba(0,0,0,0.1); transition: transform 0.3s ease; background: white;">
                            <div class="product-img" style="position: relative;">
                                <c:choose>
                                    <c:when test="${not empty product.imageUrl}">
                                        <img src="${pageContext.request.contextPath}${product.imageUrl}"
                                            alt="${product.name}"
                                            style="max-height: 250px; object-fit: contain; width: 100%;">
                                    </c:when>
                                    <c:otherwise>
                                        <img src="${pageContext.request.contextPath}/img/product-placeholder.png"
                                            alt="${product.name}"
                                            style="max-height: 250px; object-fit: contain; width: 100%;">
                                    </c:otherwise>
                                </c:choose>
                                
                                <!-- Deal labels -->
                                <div class="product-label">
                                    <c:if test="${product.dealPercentage != null && product.dealPercentage > 0}">
                                        <span class="sale" style="background: #ff4757;">-${product.dealPercentage}%</span>
                                        <span class="new" style="background: #ff6b6b;">HOT</span>
                                    </c:if>
                                </div>
                                
                                <!-- Flash sale countdown for first few products -->
                                <c:if test="${status.index < 6}">
                                    <div style="position: absolute; bottom: 10px; left: 10px; background: rgba(0,0,0,0.8); color: white; padding: 5px 10px; border-radius: 15px; font-size: 12px;">
                                        <i class="fa fa-clock-o"></i> <span class="flash-countdown">02:15:30</span>
                                    </div>
                                </c:if>
                            </div>
                            
                            <div class="product-body" style="padding: 20px;">
                                <p class="product-category" style="color: #d70018; font-weight: bold; margin-bottom: 10px;">
                                    ${product.category.name}
                                </p>
                                <h3 class="product-name" style="height: 50px; overflow: hidden; margin-bottom: 15px;">
                                    <a href="${pageContext.request.contextPath}/product/${product.id}" 
                                       style="color: #333; text-decoration: none; font-size: 14px; line-height: 1.4;">
                                       ${product.name}
                                    </a>
                                </h3>
                                
                                <!-- Price with original and discounted -->
                                <div style="margin-bottom: 15px;">
                                    <h4 class="product-price" style="margin: 0;">
                                        <c:if test="${product.dealPercentage != null && product.dealPercentage > 0}">
                                            <span style="color: #d70018; font-size: 18px; font-weight: bold;">
                                                <fmt:formatNumber value="${product.price * (100 - product.dealPercentage) / 100}" type="currency" currencySymbol="₫" maxFractionDigits="0" />
                                            </span>
                                            <del class="product-old-price" style="color: #999; font-size: 14px; margin-left: 10px;">
                                                <fmt:formatNumber value="${product.price}" type="currency" currencySymbol="₫" maxFractionDigits="0" />
                                            </del>
                                        </c:if>
                                    </h4>
                                    <c:if test="${product.dealPercentage != null && product.dealPercentage > 0}">
                                        <div style="color: #28a745; font-size: 12px; font-weight: bold;">
                                            Tiết kiệm: <fmt:formatNumber value="${product.price * product.dealPercentage / 100}" type="currency" currencySymbol="₫" maxFractionDigits="0" />
                                        </div>
                                    </c:if>
                                </div>
                                
                                <div class="product-rating" style="margin-bottom: 15px;">
                                    <i class="fa fa-star" style="color: #ffc107;"></i>
                                    <i class="fa fa-star" style="color: #ffc107;"></i>
                                    <i class="fa fa-star" style="color: #ffc107;"></i>
                                    <i class="fa fa-star" style="color: #ffc107;"></i>
                                    <i class="fa fa-star-o" style="color: #ddd;"></i>
                                    <span style="color: #666; font-size: 12px; margin-left: 5px;">
                                        (${50 + status.index * 3} đánh giá)
                                    </span>
                                </div>
                                
                                <div class="product-btns" style="margin-bottom: 15px;">
                                    <button class="add-to-wishlist" data-product-id="${product.id}"
                                        onclick="toggleFavorite(${product.id}, this)"
                                        style="background: none; border: 1px solid #ddd; padding: 8px; border-radius: 5px; margin-right: 5px;">
                                        <i class="fa fa-heart-o"></i>
                                        <span class="tooltipp">Yêu thích</span>
                                    </button>
                                    <a href="${pageContext.request.contextPath}/product/${product.id}"
                                       class="quick-view"
                                       style="background: none; border: 1px solid #ddd; padding: 8px; border-radius: 5px; color: #333; text-decoration: none;">
                                        <i class="fa fa-eye"></i>
                                        <span class="tooltipp">Xem chi tiết</span>
                                    </a>
                                </div>
                            </div>
                            
                            <div class="add-to-cart">
                                <c:choose>
                                    <c:when test="${product.stock > 0}">
                                        <button class="add-to-cart-btn" data-product-id="${product.id}"
                                            onclick="addToCart(${product.id})"
                                            style="width: 100%; background: linear-gradient(45deg, #d70018, #ff6b6b); border: none; color: white; padding: 12px; font-weight: bold; border-radius: 0;">
                                            <i class="fa fa-shopping-cart"></i> THÊM VÀO GIỎ
                                        </button>
                                    </c:when>
                                    <c:otherwise>
                                        <button class="add-to-cart-btn" disabled
                                            style="width: 100%; background: #999; border: none; color: white; padding: 12px; border-radius: 0;">
                                            <i class="fa fa-ban"></i> HẾT HÀNG
                                        </button>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>
    <!-- /FLASH DEALS PRODUCTS -->

    <!-- NEWSLETTER -->
    <div id="newsletter" class="section">
        <div class="container">
            <div class="row">
                <div class="col-md-12">
                    <div class="newsletter">
                        <p>Đăng ký nhận thông báo <strong>KHUYẾN MÃI MỚI</strong></p>
                        <form>
                            <input class="input" type="email" placeholder="Nhập email để nhận ưu đãi đặc biệt">
                            <button class="newsletter-btn"><i class="fa fa-envelope"></i> Đăng ký ngay</button>
                        </form>
                        <ul class="newsletter-follow">
                            <li><a href="https://www.facebook.com/nhan.le.24813" target="_blank"><i class="fa fa-facebook"></i></a></li>
                            <li><a href="https://x.com/Apple" target="_blank"><i class="fa fa-twitter"></i></a></li>
                            <li><a href="https://www.instagram.com/apple/" target="_blank"><i class="fa fa-instagram"></i></a></li>
                            <li><a href="https://www.pinterest.com/apple/" target="_blank"><i class="fa fa-pinterest"></i></a></li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- /NEWSLETTER -->

    <script>
        <%
            org.springframework.security.core.Authentication auth = org.springframework.security.core.context.SecurityContextHolder.getContext().getAuthentication();
            boolean isAuthenticated = auth != null && auth.isAuthenticated() && !(auth instanceof org.springframework.security.authentication.AnonymousAuthenticationToken);
        %>
        var IS_LOGGED_IN = <%= isAuthenticated %>;

        // Synchronized 24-hour countdown system
        function updateCountdown() {
            // Get or create countdown start time
            let startTime = localStorage.getItem('flashSaleStartTime');
            if (!startTime) {
                startTime = new Date().getTime();
                localStorage.setItem('flashSaleStartTime', startTime);
            } else {
                startTime = parseInt(startTime);
            }

            // Calculate 24-hour countdown
            const duration = 24 * 60 * 60 * 1000; // 24 hours in milliseconds
            const endTime = startTime + duration;

            const timer = setInterval(function() {
                const currentTime = new Date().getTime();
                const timeLeft = endTime - currentTime;

                if (timeLeft <= 0) {
                    // Reset countdown when it reaches 0
                    const newStartTime = new Date().getTime();
                    localStorage.setItem('flashSaleStartTime', newStartTime);
                    clearInterval(timer);
                    updateCountdown(); // Restart countdown
                    return;
                }

                const days = Math.floor(timeLeft / (1000 * 60 * 60 * 24));
                const hours = Math.floor((timeLeft % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
                const minutes = Math.floor((timeLeft % (1000 * 60 * 60)) / (1000 * 60));
                const seconds = Math.floor((timeLeft % (1000 * 60)) / 1000);

                // Update main countdown
                const daysEl = document.getElementById("days");
                const hoursEl = document.getElementById("hours");
                const minutesEl = document.getElementById("minutes");
                const secondsEl = document.getElementById("seconds");

                if (daysEl) daysEl.innerHTML = days.toString().padStart(2, '0');
                if (hoursEl) hoursEl.innerHTML = hours.toString().padStart(2, '0');
                if (minutesEl) minutesEl.innerHTML = minutes.toString().padStart(2, '0');
                if (secondsEl) secondsEl.innerHTML = seconds.toString().padStart(2, '0');

                // Update flash countdown for products
                updateFlashCountdown(hours, minutes, seconds);
            }, 1000);
        }

        // Flash sale countdown for individual products (synchronized)
        function updateFlashCountdown(hours, minutes, seconds) {
            const flashElements = document.querySelectorAll('.flash-countdown');
            flashElements.forEach((element, index) => {
                // Show synchronized time for all products
                element.innerHTML = hours.toString().padStart(2, '0') + ':' + 
                                  minutes.toString().padStart(2, '0') + ':' + 
                                  seconds.toString().padStart(2, '0');
            });
        }

        // Cart and favorite functions (same as in shop.jsp)
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
                alert('🎉 Đã thêm sản phẩm vào giỏ hàng với giá ưu đãi!');
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
                } else {
                    icon.classList.remove('fa-heart-o');
                    icon.classList.add('fa-heart');
                    button.style.color = '#d70018';
                }
                if (typeof updateGlobalWishlistCount === 'function') updateGlobalWishlistCount();
            })
            .catch(error => {
                if (error.message === 'Unauthorized') {
                    window.location.href = '${pageContext.request.contextPath}/login';
                } else {
                    alert('Có lỗi: ' + error.message);
                }
            });
        }

        // Load favorite states
        function loadFavoriteStates() {
            if (!IS_LOGGED_IN) return;
            
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

        // Hover effects for products
        function addHoverEffects() {
            const products = document.querySelectorAll('.product');
            products.forEach(product => {
                product.addEventListener('mouseenter', function() {
                    this.style.transform = 'translateY(-5px)';
                    this.style.boxShadow = '0 10px 25px rgba(215,0,24,0.2)';
                });
                
                product.addEventListener('mouseleave', function() {
                    this.style.transform = 'translateY(0)';
                    this.style.boxShadow = '0 5px 15px rgba(0,0,0,0.1)';
                });
            });
        }

        // Initialize everything when page loads
        document.addEventListener('DOMContentLoaded', function() {
            updateCountdown();
            updateFlashCountdown();
            addHoverEffects();
            if (IS_LOGGED_IN) loadFavoriteStates();
        });

        // Filter products by category/brand
        function filterDealsByCategory(categoryName) {
            const products = document.querySelectorAll('.product-item');
            let visibleCount = 0;
            
            products.forEach(product => {
                const productCategory = product.getAttribute('data-category');
                const productBrand = product.getAttribute('data-brand');
                
                // Match by category name or brand name
                if (productCategory === categoryName || productBrand === categoryName) {
                    product.style.display = 'block';
                    visibleCount++;
                } else {
                    product.style.display = 'none';
                }
            });
            
            // Update section title
            const title = document.getElementById('deals-section-title');
            if (title) {
                title.innerHTML = '🎯 ' + categoryName + ' Hot Deals';
            }
            
            // Scroll to products section
            document.getElementById('deals-products').scrollIntoView({ behavior: 'smooth', block: 'start' });
            
            // No message needed - just show empty state
        }
        
        function showAllDeals() {
            const products = document.querySelectorAll('.product-item');
            products.forEach(product => {
                product.style.display = 'block';
            });
            
            // Reset section title
            const title = document.getElementById('deals-section-title');
            if (title) {
                title.innerHTML = '⚡ Flash Sale - Giá sốc mỗi giờ';
            }
        }
    </script>

    <style>
        /* Additional styles for deals page */
        .product {
            transition: all 0.3s ease;
        }
        
        .product:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(215,0,24,0.2) !important;
        }
        
        .hot-deal h2 {
            text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
        }
        
        .flash-countdown {
            font-family: 'Courier New', monospace;
            font-weight: bold;
        }
        
        .product-label span {
            animation: pulse 2s infinite;
        }
        
        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.05); }
            100% { transform: scale(1); }
        }
        
        .cta-btn:hover {
            transform: scale(1.05);
            transition: all 0.3s ease;
        }
        
        .category-filter-btn {
            border: 2px solid #d70018 !important;
            color: #d70018 !important;
            background: white !important;
            transition: all 0.3s ease;
        }
        
        .category-filter-btn:hover {
            background: #d70018 !important;
            color: white !important;
        }
        
        @media (max-width: 768px) {
            .hot-deal-countdown {
                justify-content: center;
            }
            
            .hot-deal-countdown li {
                margin: 0 10px;
            }
        }
    </style>

</body>

</html>
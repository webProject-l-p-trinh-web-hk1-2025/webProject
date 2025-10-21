<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Cửa hàng điện thoại - Trang chủ</title>
</head>
<body>

<!-- BREADCRUMB -->
<div id="breadcrumb" class="section">
    <div class="container">
        <div class="row">
            <div class="col-md-12">
                <ul class="breadcrumb-tree">
                    <li class="active"><a href="${pageContext.request.contextPath}/">Trang chủ</a></li>
                </ul>
            </div>
        </div>
    </div>
</div>
<!-- /BREADCRUMB -->

<!-- SECTION -->
<div class="section">
    <div class="container">
        <div class="row">
            <!-- ASIDE -->
            <div id="aside" class="col-md-3">
                <!-- Categories Widget -->
                <div class="aside">
                    <h3 class="aside-title">Danh mục</h3>
                    <div class="checkbox-filter">
                        <c:forEach items="${categories}" var="cat">
                            <div class="input-checkbox">
                                <input type="checkbox" id="category-${cat.id}">
                                <label for="category-${cat.id}">
                                    <span></span>
                                    ${cat.name}
                                </label>
                            </div>
                        </c:forEach>
                    </div>
                </div>
                <!-- /Categories Widget -->

                <!-- Brand Widget -->
                <div class="aside">
                    <h3 class="aside-title">Thương hiệu</h3>
                    <div class="checkbox-filter">
                        <c:forEach items="${brands}" var="brand" varStatus="status">
                            <div class="input-checkbox">
                                <input type="checkbox" id="brand-${status.index}">
                                <label for="brand-${status.index}">
                                    <span></span>
                                    ${brand}
                                </label>
                            </div>
                        </c:forEach>
                    </div>
                </div>
                <!-- /Brand Widget -->
            </div>
            <!-- /ASIDE -->

            <!-- STORE -->
            <div id="store" class="col-md-9">
                <!-- store top filter -->
                <div class="store-filter clearfix">
                    <div class="store-sort">
                        <label>
                            Sắp xếp theo:
                            <select class="input-select">
                                <option value="0">Phổ biến</option>
                                <option value="1">Giá thấp đến cao</option>
                                <option value="2">Giá cao đến thấp</option>
                            </select>
                        </label>

                        <label>
                            Hiển thị:
                            <select class="input-select">
                                <option value="0">20</option>
                                <option value="1">50</option>
                            </select>
                        </label>
                    </div>
                    <ul class="store-grid">
                        <li class="active"><i class="fa fa-th"></i></li>
                        <li><a href="#"><i class="fa fa-th-list"></i></a></li>
                    </ul>
                </div>
                <!-- /store top filter -->

                <!-- store products -->
                <div class="row">
                    <c:forEach items="${products}" var="product">
                        <!-- product -->
                        <div class="col-md-4 col-xs-6">
                            <div class="product">
                                <div class="product-img">
                                    <c:choose>
                                        <c:when test="${not empty product.imageUrl}">
                                            <img src="${pageContext.request.contextPath}${product.imageUrl}" 
                                                 alt="${product.name}" style="max-height: 250px; object-fit: contain;">
                                        </c:when>
                                        <c:otherwise>
                                            <img src="${pageContext.request.contextPath}/img/product-placeholder.png" 
                                                 alt="${product.name}" style="max-height: 250px; object-fit: contain;">
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
                                        <a href="${pageContext.request.contextPath}/product/${product.id}">${product.name}</a>
                                    </h3>
                                    <h4 class="product-price">
                                        <fmt:formatNumber value="${product.price}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                                    </h4>
                                    <div class="product-rating">
                                        <i class="fa fa-star"></i>
                                        <i class="fa fa-star"></i>
                                        <i class="fa fa-star"></i>
                                        <i class="fa fa-star"></i>
                                        <i class="fa fa-star-o"></i>
                                    </div>
                                    <div class="product-btns">
                                        <button class="add-to-wishlist" data-product-id="${product.id}" onclick="toggleFavorite(${product.id}, this)">
                                            <i class="fa fa-heart-o"></i>
                                            <span class="tooltipp">Yêu thích</span>
                                        </button>
                                        <a href="${pageContext.request.contextPath}/product/${product.id}" class="quick-view">
                                            <i class="fa fa-eye"></i>
                                            <span class="tooltipp">Xem chi tiết</span>
                                        </a>
                                    </div>
                                </div>
                                <div class="add-to-cart">
                                    <c:choose>
                                        <c:when test="${product.stock > 0}">
                                            <button class="add-to-cart-btn" data-product-id="${product.id}" onclick="addToCart(${product.id})">
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
                        <!-- /product -->
                    </c:forEach>
                </div>
                <!-- /store products -->

                <!-- store bottom filter -->
                <div class="store-filter clearfix">
                    <span class="store-qty">Hiển thị ${products.size()} sản phẩm</span>
                    <ul class="store-pagination">
                        <li class="active">1</li>
                        <li><a href="#">2</a></li>
                        <li><a href="#">3</a></li>
                        <li><a href="#"><i class="fa fa-angle-right"></i></a></li>
                    </ul>
                </div>
                <!-- /store bottom filter -->
            </div>
            <!-- /STORE -->
        </div>
    </div>
</div>
<!-- /SECTION -->

<!-- NEWSLETTER -->
<div id="newsletter" class="section">
    <div class="container">
        <div class="row">
            <div class="col-md-12">
                <div class="newsletter">
                    <p>Đăng ký nhận <strong>TIN TỨC MỚI</strong></p>
                    <form>
                        <input class="input" type="email" placeholder="Nhập email của bạn">
                        <button class="newsletter-btn"><i class="fa fa-envelope"></i> Đăng ký</button>
                    </form>
                    <ul class="newsletter-follow">
                        <li><a href="#"><i class="fa fa-facebook"></i></a></li>
                        <li><a href="#"><i class="fa fa-twitter"></i></a></li>
                        <li><a href="#"><i class="fa fa-instagram"></i></a></li>
                        <li><a href="#"><i class="fa fa-pinterest"></i></a></li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</div>
<!-- /NEWSLETTER -->

<script>
// Kiểm tra đăng nhập từ server-side
<%
    org.springframework.security.core.Authentication auth = org.springframework.security.core.context.SecurityContextHolder.getContext().getAuthentication();
    boolean isAuthenticated = auth != null && auth.isAuthenticated() && !(auth instanceof org.springframework.security.authentication.AnonymousAuthenticationToken);
%>
var IS_LOGGED_IN = <%= isAuthenticated %>;

function addToCart(productId) {
    if (!IS_LOGGED_IN) {
        // Chưa đăng nhập, chuyển về trang login
        alert('Vui lòng đăng nhập để thêm sản phẩm vào giỏ hàng!');
        window.location.href = '${pageContext.request.contextPath}/login';
        return;
    }
    
    // Đã đăng nhập, gọi API thêm vào giỏ hàng
    fetch('${pageContext.request.contextPath}/api/cart/add', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        credentials: 'include', // Tự động gửi cookies (JWT token)
        body: JSON.stringify({
            productId: productId,
            quantity: 1
        })
    })
    .then(response => {
        if (response.ok) {
            return response.json();
        } else if (response.status === 401 || response.status === 403) {
            throw new Error('Unauthorized');
        } else {
            throw new Error('Có lỗi xảy ra');
        }
    })
    .then(data => {
        alert('Đã thêm sản phẩm vào giỏ hàng!');
        // Cập nhật số lượng giỏ hàng trong header
        if (typeof updateGlobalCartCount === 'function') {
            updateGlobalCartCount();
        }
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

// Function cập nhật số lượng giỏ hàng
function updateCartCount() {
    fetch('${pageContext.request.contextPath}/api/cart', {
        method: 'GET',
        headers: {
            'Content-Type': 'application/json'
        },
        credentials: 'include' // Tự động gửi cookies
    })
    .then(response => {
        if (response.ok) {
            return response.json();
        }
        return null;
    })
    .then(data => {
        if (data && data.items) {
            const totalItems = data.items.reduce((sum, item) => sum + item.quantity, 0);
            const qtyElement = document.getElementById('cart-qty');
            if (qtyElement) {
                qtyElement.textContent = totalItems;
            }
        }
    })
    .catch(error => {
        console.error('Lỗi khi cập nhật số lượng giỏ hàng:', error);
    });
}

// Load số lượng giỏ hàng khi trang được tải
if (IS_LOGGED_IN) {
    window.addEventListener('DOMContentLoaded', function() {
        updateCartCount();
        loadFavoriteStates(); // Load trạng thái yêu thích
    });
}

// Toggle favorite (thêm/xóa yêu thích)
function toggleFavorite(productId, button) {
    if (!IS_LOGGED_IN) {
        alert('Vui lòng đăng nhập để thêm vào danh sách yêu thích!');
        window.location.href = '${pageContext.request.contextPath}/login';
        return;
    }
    
    var icon = button.querySelector('i');
    var isFavorited = icon.classList.contains('fa-heart');
    
    if (isFavorited) {
        // Xóa khỏi yêu thích
        fetch('${pageContext.request.contextPath}/api/favorite/remove/' + productId, {
            method: 'DELETE',
            credentials: 'include',
            headers: {
                'Content-Type': 'application/json'
            }
        })
        .then(response => {
            if (response.ok) {
                return response.json();
            } else if (response.status === 401 || response.status === 403) {
                throw new Error('Unauthorized');
            } else {
                throw new Error('Có lỗi xảy ra');
            }
        })
        .then(data => {
            icon.classList.remove('fa-heart');
            icon.classList.add('fa-heart-o');
            button.style.color = '';
            alert('Đã xóa khỏi danh sách yêu thích!');
            // Cập nhật số lượng wishlist trong header
            if (typeof updateGlobalWishlistCount === 'function') {
                updateGlobalWishlistCount();
            }
        })
        .catch(error => {
            if (error.message === 'Unauthorized') {
                alert('Phiên đăng nhập hết hạn. Vui lòng đăng nhập lại!');
                window.location.href = '${pageContext.request.contextPath}/login';
            } else {
                alert('Có lỗi: ' + error.message);
            }
        });
    } else {
        // Thêm vào yêu thích
        fetch('${pageContext.request.contextPath}/api/favorite/add', {
            method: 'POST',
            credentials: 'include',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                productId: productId
            })
        })
        .then(response => {
            if (response.ok) {
                return response.json();
            } else if (response.status === 401 || response.status === 403) {
                throw new Error('Unauthorized');
            } else {
                throw new Error('Có lỗi xảy ra');
            }
        })
        .then(data => {
            icon.classList.remove('fa-heart-o');
            icon.classList.add('fa-heart');
            button.style.color = '#d70018';
            alert('Đã thêm vào danh sách yêu thích!');
            // Cập nhật số lượng wishlist trong header
            if (typeof updateGlobalWishlistCount === 'function') {
                updateGlobalWishlistCount();
            }
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
}

// Load trạng thái yêu thích cho tất cả sản phẩm
function loadFavoriteStates() {
    fetch('${pageContext.request.contextPath}/api/favorite', {
        method: 'GET',
        credentials: 'include',
        headers: {
            'Content-Type': 'application/json'
        }
    })
    .then(response => {
        if (response.ok) {
            return response.json();
        }
        return [];
    })
    .then(favorites => {
        // Đánh dấu các sản phẩm đã yêu thích
        favorites.forEach(function(favorite) {
            var button = document.querySelector('.add-to-wishlist[data-product-id="' + favorite.productId + '"]');
            if (button) {
                var icon = button.querySelector('i');
                icon.classList.remove('fa-heart-o');
                icon.classList.add('fa-heart');
                button.style.color = '#d70018';
            }
        });
    })
    .catch(error => {
        console.error('Lỗi khi tải trạng thái yêu thích:', error);
    });
}
</script>

</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sản phẩm yêu thích - CellphoneZ</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f5f5f5;
        }

        .header {
            background: linear-gradient(135deg, #d70018 0%, #f05423 100%);
            color: white;
            padding: 15px 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }

        .header-container {
            max-width: 1200px;
            margin: 0 auto;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .header-logo {
            font-size: 24px;
            font-weight: bold;
            text-decoration: none;
            color: white;
        }

        .btn-back {
            background: rgba(255,255,255,0.2);
            border: none;
            padding: 10px 20px;
            border-radius: 8px;
            color: white;
            cursor: pointer;
            text-decoration: none;
        }

        .btn-back:hover {
            background: rgba(255,255,255,0.3);
        }

        .container {
            max-width: 1200px;
            margin: 30px auto;
            padding: 0 20px;
        }

        h1 {
            color: #333;
            margin-bottom: 30px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        h1 i {
            color: #d70018;
        }

        .wishlist-items {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 20px;
        }

        .wishlist-item {
            background: white;
            border-radius: 8px;
            padding: 15px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            position: relative;
        }

        .wishlist-item:hover {
            transform: translateY(-5px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        }

        .wishlist-item-image {
            width: 100%;
            height: 200px;
            object-fit: contain;
            border-radius: 8px;
            margin-bottom: 15px;
        }

        .wishlist-item-name {
            font-weight: bold;
            color: #333;
            margin-bottom: 10px;
            font-size: 16px;
            min-height: 40px;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }

        .wishlist-item-price {
            color: #d70018;
            font-size: 18px;
            font-weight: bold;
            margin-bottom: 15px;
        }

        .wishlist-item-actions {
            display: flex;
            gap: 10px;
        }

        .btn-add-cart {
            flex: 1;
            background: #d70018;
            color: white;
            border: none;
            padding: 10px;
            border-radius: 8px;
            cursor: pointer;
            font-weight: bold;
        }

        .btn-add-cart:hover {
            background: #b8001a;
        }

        .btn-add-cart:disabled {
            background: #999;
            cursor: not-allowed;
        }

        .btn-remove {
            background: white;
            color: #d70018;
            border: 1px solid #d70018;
            padding: 10px 15px;
            border-radius: 8px;
            cursor: pointer;
        }

        .btn-remove:hover {
            background: #d70018;
            color: white;
        }

        .empty-wishlist {
            text-align: center;
            padding: 60px 20px;
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .empty-wishlist-icon {
            font-size: 80px;
            margin-bottom: 20px;
        }

        .empty-wishlist h2 {
            color: #666;
            margin-bottom: 10px;
        }

        .empty-wishlist a {
            display: inline-block;
            margin-top: 20px;
            padding: 12px 30px;
            background: #d70018;
            color: white;
            text-decoration: none;
            border-radius: 8px;
        }

        .empty-wishlist a:hover {
            background: #b8001a;
        }

        .stock-status {
            font-size: 12px;
            padding: 4px 8px;
            border-radius: 4px;
            display: inline-block;
            margin-bottom: 10px;
        }

        .in-stock {
            background: #d4edda;
            color: #155724;
        }

        .out-of-stock {
            background: #f8d7da;
            color: #721c24;
        }

        .message {
            position: fixed;
            top: 20px;
            right: 20px;
            padding: 15px 25px;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
            z-index: 1000;
            animation: slideIn 0.3s ease;
        }

        @keyframes slideIn {
            from {
                transform: translateX(400px);
                opacity: 0;
            }
            to {
                transform: translateX(0);
                opacity: 1;
            }
        }

        .message.success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .message.error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        .message.info {
            background: #d1ecf1;
            color: #0c5460;
            border: 1px solid #bee5eb;
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="header-container">
            <a href="/" class="header-logo">CellphoneZ</a>
            <a href="/" class="btn-back">← Về trang chủ</a>
        </div>
    </div>

    <div class="container">
        <h1><i class="fa fa-heart"></i> Sản phẩm yêu thích</h1>
        
        <div id="wishlistItemsContainer" class="wishlist-items">
            <!-- Wishlist items will be loaded here by JavaScript -->
        </div>
    </div>

    <script>
        var wishlist = [];

        function showMessage(message, type) {
            var messageDiv = document.createElement('div');
            messageDiv.className = 'message ' + type;
            messageDiv.textContent = message;
            document.body.appendChild(messageDiv);

            setTimeout(function() {
                messageDiv.remove();
            }, 3000);
        }

        function loadWishlist() {
            fetch('${pageContext.request.contextPath}/api/favorite', {
                method: 'GET',
                credentials: 'include',
                headers: {
                    'Content-Type': 'application/json'
                }
            })
            .then(function(response) {
                if (!response.ok) {
                    if (response.status === 401) {
                        window.location.href = '${pageContext.request.contextPath}/login';
                        throw new Error('Chưa đăng nhập');
                    }
                    throw new Error('Không thể tải danh sách yêu thích');
                }
                return response.json();
            })
            .then(function(data) {
                wishlist = data;
                renderWishlist();
            })
            .catch(function(error) {
                console.error('Error:', error);
                if (!error.message.includes('Chưa đăng nhập')) {
                    showMessage('Lỗi khi tải danh sách yêu thích: ' + error.message, 'error');
                }
            });
        }

        function renderWishlist() {
            var container = document.getElementById('wishlistItemsContainer');

            if (wishlist.length === 0) {
                container.innerHTML = 
                    '<div class="empty-wishlist">' +
                        '<div class="empty-wishlist-icon">💔</div>' +
                        '<h2>Chưa có sản phẩm yêu thích</h2>' +
                        '<p style="margin-top: 10px; color: #999;">Hãy thêm sản phẩm yêu thích để theo dõi!</p>' +
                        '<a href="/">Khám phá sản phẩm</a>' +
                    '</div>';
                return;
            }

            var html = '';
            wishlist.forEach(function(item) {
                var imgSrc = item.productImageUrl && item.productImageUrl.trim() !== '' 
                    ? item.productImageUrl 
                    : 'data:image/svg+xml,%3Csvg xmlns=%22http://www.w3.org/2000/svg%22 width=%22100%22 height=%22100%22%3E%3Crect fill=%22%23f0f0f0%22 width=%22100%22 height=%22100%22/%3E%3Ctext x=%2250%25%22 y=%2250%25%22 dominant-baseline=%22middle%22 text-anchor=%22middle%22 font-family=%22Arial%22 font-size=%2212%22 fill=%22%23999%22%3ENo Image%3C/text%3E%3C/svg%3E';
                
                var stockStatus = item.productStock > 0 
                    ? '<span class="stock-status in-stock">Còn hàng</span>'
                    : '<span class="stock-status out-of-stock">Hết hàng</span>';

                var addCartButton = item.productStock > 0
                    ? '<button class="btn-add-cart" onclick="addToCart(' + item.productId + ')">Thêm vào giỏ</button>'
                    : '<button class="btn-add-cart" disabled>Hết hàng</button>';

                html += 
                    '<div class="wishlist-item">' +
                        '<img class="wishlist-item-image" src="' + imgSrc + '" alt="' + item.productName + '">' +
                        stockStatus +
                        '<div class="wishlist-item-name">' + item.productName + '</div>' +
                        '<div class="wishlist-item-price">' + formatPrice(item.productPrice) + '</div>' +
                        '<div class="wishlist-item-actions">' +
                            addCartButton +
                            '<button class="btn-remove" onclick="removeFromWishlist(' + item.productId + ')"><i class="fa fa-trash"></i></button>' +
                        '</div>' +
                    '</div>';
            });

            container.innerHTML = html;
        }

        function addToCart(productId) {
            fetch('${pageContext.request.contextPath}/api/cart/add', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                credentials: 'include',
                body: JSON.stringify({
                    productId: productId,
                    quantity: 1
                })
            })
            .then(function(response) {
                if (response.ok) {
                    return response.json();
                } else if (response.status === 401 || response.status === 403) {
                    throw new Error('Unauthorized');
                } else {
                    throw new Error('Có lỗi xảy ra');
                }
            })
            .then(function(data) {
                showMessage('Đã thêm sản phẩm vào giỏ hàng!', 'success');
            })
            .catch(function(error) {
                if (error.message === 'Unauthorized') {
                    showMessage('Phiên đăng nhập hết hạn. Vui lòng đăng nhập lại!', 'error');
                    window.location.href = '${pageContext.request.contextPath}/login';
                } else {
                    showMessage('Có lỗi: ' + error.message, 'error');
                }
            });
        }

        function removeFromWishlist(productId) {
            if (!confirm('Bạn có chắc muốn xóa sản phẩm này khỏi danh sách yêu thích?')) return;

            fetch('${pageContext.request.contextPath}/api/favorite/remove/' + productId, {
                method: 'DELETE',
                credentials: 'include',
                headers: {
                    'Content-Type': 'application/json'
                }
            })
            .then(function(response) {
                if (!response.ok) throw new Error('Không thể xóa');
                return response.json();
            })
            .then(function(data) {
                showMessage('Đã xóa sản phẩm khỏi danh sách yêu thích!', 'success');
                loadWishlist();
            })
            .catch(function(error) {
                console.error('Error:', error);
                showMessage('Lỗi khi xóa sản phẩm: ' + error.message, 'error');
            });
        }

        function formatPrice(price) {
            return new Intl.NumberFormat('vi-VN', {
                style: 'currency',
                currency: 'VND'
            }).format(price);
        }

        // Load wishlist when page loads
        window.addEventListener('DOMContentLoaded', function() {
            loadWishlist();
        });
    </script>

    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
</body>
</html>

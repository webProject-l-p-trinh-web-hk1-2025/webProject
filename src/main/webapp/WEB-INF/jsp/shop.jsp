<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cửa Hàng - Test Giỏ Hàng & Đặt Hàng</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        html {
            scroll-behavior: smooth;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f5f5f5;
            -webkit-font-smoothing: antialiased;
            -moz-osx-font-smoothing: grayscale;
        }

        /* Header */
        .header {
            background: linear-gradient(135deg, #d70018 0%, #f05423 100%);
            color: white;
            padding: 15px 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            position: sticky;
            top: 0;
            z-index: 100;
        }

        .header-container {
            max-width: 1400px;
            margin: 0 auto;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .header-logo {
            font-size: 24px;
            font-weight: bold;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .header-actions {
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .cart-icon-btn {
            position: relative;
            background: rgba(255,255,255,0.2);
            border: none;
            padding: 10px 15px;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            gap: 8px;
            color: white;
            font-size: 16px;
            text-decoration: none;
        }

        .cart-icon-btn:hover {
            background: rgba(255,255,255,0.3);
            transform: translateY(-2px);
        }

        .cart-badge {
            position: absolute;
            top: -5px;
            right: -5px;
            background: #ff6b35;
            color: white;
            border-radius: 50%;
            width: 22px;
            height: 22px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 12px;
            font-weight: bold;
            border: 2px solid white;
        }

        .container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 20px;
        }

        h1 {
            text-align: center;
            color: #333;
            margin-bottom: 30px;
        }

        /* Products Section */
        .products-section {
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .products-section h2 {
            color: #333;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #4CAF50;
        }

        .products-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 20px;
        }

        .product-card {
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 15px;
            background: white;
            transition: transform 0.2s ease-out, box-shadow 0.2s ease-out;
            will-change: transform;
        }

        .product-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.15);
        }

        .product-image {
            width: 100%;
            height: 200px;
            object-fit: cover;
            border-radius: 4px;
            margin-bottom: 10px;
            background-color: #f0f0f0;
            transform: translateZ(0);
            backface-visibility: hidden;
            image-rendering: auto;
            image-rendering: crisp-edges;
            image-rendering: -webkit-optimize-contrast;
        }

        .product-name {
            font-size: 16px;
            font-weight: bold;
            color: #333;
            margin-bottom: 8px;
        }

        .product-price {
            font-size: 18px;
            color: #e91e63;
            font-weight: bold;
            margin-bottom: 8px;
        }

        .product-stock {
            font-size: 14px;
            color: #666;
            margin-bottom: 10px;
        }

        .product-actions {
            display: flex;
            gap: 10px;
            align-items: center;
        }

        .quantity-input {
            width: 60px;
            padding: 5px;
            border: 1px solid #ddd;
            border-radius: 4px;
            text-align: center;
        }

        .btn-add-cart {
            flex: 1;
            padding: 8px 16px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-weight: bold;
            transition: background-color 0.2s;
        }

        .btn-add-cart:hover {
            background-color: #45a049;
        }

        .btn-add-cart:disabled {
            background-color: #ccc;
            cursor: not-allowed;
        }





        .message {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 4px;
            text-align: center;
        }

        .message.success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .message.error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        .message.info {
            background-color: #d1ecf1;
            color: #0c5460;
            border: 1px solid #bee5eb;
        }

        @media (max-width: 768px) {
            .header-logo {
                font-size: 18px;
            }

            .products-grid {
                grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
            }
        }
    </style>
</head>
<body>
    <!-- Header -->
    <div class="header">
        <div class="header-container">
            <div class="header-logo">
                📱 CellphoneZ
            </div>
            <div class="header-actions">
                <a href="/cart" class="cart-icon-btn" id="cartLink">
                    🛒 Giỏ hàng
                    <span class="cart-badge" id="cartBadge">0</span>
                </a>
            </div>
        </div>
    </div>

    <div class="container">
        <h1>🛍️ Danh Sách Sản Phẩm</h1>

        <div id="messageContainer"></div>

        <!-- Products Section -->
        <div class="products-section">
            <div class="products-grid" id="productsGrid">
                <p style="text-align: center; color: #999;">Đang tải sản phẩm...</p>
            </div>
        </div>
    </div>

    <script>
        let products = [];
        let cart = [];
        let isLoadingProducts = false;
        let isLoadingCart = false;
        let lastCartLoadTime = 0;
        let cartLoadThrottle = 1000;

        // Load products
        function loadProducts() {
            if (isLoadingProducts) return;
            isLoadingProducts = true;

            fetch('/api/products')
                .then(function(response) {
                    if (!response.ok) {
                        throw new Error('Không thể tải danh sách sản phẩm');
                    }
                    return response.json();
                })
                .then(function(data) {
                    products = data;
                    renderProducts();
                })
                .catch(function(error) {
                    console.error('Error:', error);
                    showMessage('Lỗi khi tải sản phẩm: ' + error.message, 'error');
                })
                .finally(function() {
                    isLoadingProducts = false;
                });
        }

        // Render products (với Fragment để giảm reflow)
        function renderProducts() {
            var grid = document.getElementById('productsGrid');
            
            if (products.length === 0) {
                grid.innerHTML = '<p style="text-align: center; color: #999;">Không có sản phẩm nào</p>';
                return;
            }

            var fragment = document.createDocumentFragment();
            
            products.forEach(function(product) {
                var card = document.createElement('div');
                card.className = 'product-card';
                
                var inStock = product.stock > 0;
                var stockText = inStock ? 'Còn hàng: ' + product.stock : 'Hết hàng';
                var stockColor = inStock ? '#4CAF50' : '#f44336';
                
                var imgSrc = product.imageUrl && product.imageUrl.trim() !== '' ? product.imageUrl : 'data:image/svg+xml,%3Csvg xmlns=%22http://www.w3.org/2000/svg%22 width=%22200%22 height=%22200%22%3E%3Crect fill=%22%23f0f0f0%22 width=%22200%22 height=%22200%22/%3E%3Ctext x=%2250%25%22 y=%2250%25%22 dominant-baseline=%22middle%22 text-anchor=%22middle%22 font-family=%22Arial%22 font-size=%2216%22 fill=%22%23999%22%3ENo Image%3C/text%3E%3C/svg%3E';
                
                card.innerHTML = 
                    '<img class="product-image" src="' + imgSrc + '" alt="' + product.name + '" loading="lazy">' +
                    '<div class="product-name">' + product.name + '</div>' +
                    '<div class="product-price">' + formatPrice(product.price) + '</div>' +
                    '<div class="product-stock" style="color: ' + stockColor + '">' + stockText + '</div>' +
                    '<div class="product-actions">' +
                        '<input type="number" class="quantity-input" value="1" min="1" max="' + product.stock + '" id="qty-' + product.id + '" ' + (inStock ? '' : 'disabled') + '>' +
                        '<button class="btn-add-cart" onclick="addToCart(' + product.id + ')" ' + (inStock ? '' : 'disabled') + '>Thêm vào giỏ</button>' +
                    '</div>';
                
                fragment.appendChild(card);
            });
            
            grid.innerHTML = '';
            grid.appendChild(fragment);
        }

        // Add to cart
        function addToCart(productId) {
            var qtyInput = document.getElementById('qty-' + productId);
            var quantity = parseInt(qtyInput.value);
            
            if (quantity <= 0) {
                showMessage('Số lượng phải lớn hơn 0', 'error');
                return;
            }

            var product = products.find(function(p) { return p.id === productId; });
            if (!product) {
                showMessage('Không tìm thấy sản phẩm', 'error');
                return;
            }

            if (quantity > product.stock) {
                showMessage('Số lượng vượt quá tồn kho', 'error');
                return;
            }

            fetch('/api/cart/add', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                credentials: 'include',
                body: JSON.stringify({
                    productId: productId,
                    quantity: quantity
                })
            })
            .then(function(response) {
                if (!response.ok) {
                    if (response.status === 401 || response.status === 403) {
                        showMessage('Vui lòng đăng nhập để thêm vào giỏ hàng', 'error');
                        setTimeout(function() {
                            window.location.href = '/login';
                        }, 1500);
                        throw new Error('Chưa đăng nhập');
                    }
                    throw new Error('Không thể thêm sản phẩm vào giỏ hàng');
                }
                return response.json();
            })
            .then(function(data) {
                showMessage('✅ Đã thêm ' + product.name + ' vào giỏ hàng!', 'success');
                qtyInput.value = '1';
                setTimeout(function() { loadCartCount(); }, 500);
            })
            .catch(function(error) {
                console.error('Error:', error);
                if (!error.message.includes('Chưa đăng nhập')) {
                    showMessage('Lỗi: ' + error.message, 'error');
                }
            });
        }

        // Load cart count for badge
        function loadCartCount() {
            var now = Date.now();
            if (isLoadingCart || (now - lastCartLoadTime < cartLoadThrottle)) {
                return;
            }
            isLoadingCart = true;
            lastCartLoadTime = now;

            fetch('/api/cart', {
                method: 'GET',
                credentials: 'include'
            })
            .then(function(response) {
                if (!response.ok) {
                    throw new Error('Không thể tải giỏ hàng');
                }
                return response.json();
            })
            .then(function(data) {
                var items = data.items || [];
                var totalItems = items.reduce(function(sum, item) {
                    return sum + item.quantity;
                }, 0);
                updateCartBadge(totalItems);
            })
            .catch(function(error) {
                console.error('Error:', error);
                updateCartBadge(0);
            })
            .finally(function() {
                isLoadingCart = false;
            });
        }

        // Update cart badge
        function updateCartBadge(count) {
            var badge = document.getElementById('cartBadge');
            if (badge) {
                badge.textContent = count;
                if (count > 0) {
                    badge.style.display = 'flex';
                } else {
                    badge.style.display = 'none';
                }
            }
        }



        // Format price
        function formatPrice(price) {
            return new Intl.NumberFormat('vi-VN', {
                style: 'currency',
                currency: 'VND'
            }).format(price);
        }

        // Show message
        function showMessage(message, type) {
            var container = document.getElementById('messageContainer');
            var msgDiv = document.createElement('div');
            msgDiv.className = 'message ' + type;
            msgDiv.textContent = message;
            
            container.appendChild(msgDiv);
            
            setTimeout(function() {
                msgDiv.remove();
            }, 5000);
        }

        // Initialize (chỉ load 1 lần khi trang tải)
        window.addEventListener('DOMContentLoaded', function() {
            loadProducts();
            loadCartCount();
        });
    </script>
</body>
</html>

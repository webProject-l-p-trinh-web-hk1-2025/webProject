<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Giỏ Hàng - CellphoneZ</title>
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
        }

        .cart-content {
            display: grid;
            grid-template-columns: 1fr 400px;
            gap: 20px;
        }

        .cart-items-section {
            background: white;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .select-all-container {
            display: flex;
            align-items: center;
            padding: 15px;
            background: #fff3cd;
            border-radius: 8px;
            margin-bottom: 20px;
            border: 1px solid #ffc107;
        }

        .select-all-checkbox {
            width: 20px;
            height: 20px;
            margin-right: 12px;
            cursor: pointer;
        }

        .select-all-label {
            font-weight: bold;
            color: #856404;
            cursor: pointer;
            user-select: none;
        }

        .cart-item {
            display: flex;
            padding: 20px;
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            margin-bottom: 15px;
            background: white;
            transition: all 0.3s;
        }

        .cart-item:hover {
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }

        .cart-item-checkbox {
            width: 20px;
            height: 20px;
            margin-right: 15px;
            cursor: pointer;
            flex-shrink: 0;
        }

        .cart-item-image {
            width: 100px;
            height: 100px;
            object-fit: cover;
            border-radius: 8px;
            margin-right: 20px;
            background-color: #f0f0f0;
        }

        .cart-item-details {
            flex: 1;
        }

        .cart-item-name {
            font-size: 16px;
            font-weight: bold;
            color: #333;
            margin-bottom: 10px;
        }

        .cart-item-price {
            font-size: 18px;
            color: #d70018;
            font-weight: bold;
            margin-bottom: 10px;
        }

        .cart-item-quantity {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 10px;
        }

        .quantity-btn {
            width: 30px;
            height: 30px;
            border: 1px solid #ddd;
            background: white;
            cursor: pointer;
            border-radius: 4px;
            font-size: 18px;
        }

        .quantity-btn:hover {
            background: #f5f5f5;
        }

        .quantity-input {
            width: 60px;
            text-align: center;
            border: 1px solid #ddd;
            padding: 5px;
            border-radius: 4px;
        }

        .cart-item-subtotal {
            color: #666;
            font-size: 14px;
        }

        .cart-item-actions {
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            align-items: flex-end;
        }

        .btn-remove {
            padding: 8px 16px;
            background: #dc3545;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
        }

        .btn-remove:hover {
            background: #c82333;
        }

        .cart-summary {
            background: white;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            position: sticky;
            top: 20px;
            height: fit-content;
        }

        .summary-title {
            font-size: 20px;
            font-weight: bold;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 2px solid #e0e0e0;
        }

        .summary-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 15px;
            font-size: 15px;
        }

        .summary-row.total {
            font-size: 20px;
            font-weight: bold;
            color: #d70018;
            padding-top: 15px;
            border-top: 2px solid #e0e0e0;
            margin-top: 15px;
        }

        .btn-checkout {
            width: 100%;
            padding: 15px;
            background: #d70018;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            margin-top: 20px;
            transition: all 0.3s;
        }

        .btn-checkout:hover {
            background: #b8001a;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(215,0,24,0.3);
        }

        .btn-checkout:disabled {
            background: #ccc;
            cursor: not-allowed;
            transform: none;
        }

        .empty-cart {
            text-align: center;
            padding: 60px 20px;
            color: #999;
        }

        .empty-cart-icon {
            font-size: 80px;
            margin-bottom: 20px;
        }

        .message {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 8px;
            text-align: center;
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

        @media (max-width: 768px) {
            .cart-content {
                grid-template-columns: 1fr;
            }

            .cart-summary {
                position: static;
            }

            .cart-item {
                flex-direction: column;
            }

            .cart-item-image {
                margin-bottom: 15px;
            }
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="header-container">
            <a href="/shop" class="header-logo">📱 CellphoneZ</a>
            <a href="/shop" class="btn-back">← Tiếp tục mua sắm</a>
        </div>
    </div>

    <div class="container">
        <h1>🛒 Giỏ Hàng Của Bạn</h1>

        <div id="messageContainer"></div>

        <div class="cart-content">
            <div class="cart-items-section">
                <div id="selectAllContainer" class="select-all-container" style="display: none;">
                    <input type="checkbox" id="selectAllCheckbox" class="select-all-checkbox">
                    <label for="selectAllCheckbox" class="select-all-label">Chọn tất cả sản phẩm</label>
                </div>

                <div id="cartItemsContainer">
                    <div class="empty-cart">
                        <div class="empty-cart-icon">🛒</div>
                        <h2>Giỏ hàng trống</h2>
                        <p style="margin-top: 10px;">Hãy thêm sản phẩm vào giỏ hàng để tiếp tục!</p>
                        <a href="/shop" style="display: inline-block; margin-top: 20px; padding: 10px 30px; background: #d70018; color: white; text-decoration: none; border-radius: 8px;">
                            Xem sản phẩm
                        </a>
                    </div>
                </div>
            </div>

            <div class="cart-summary" id="cartSummary" style="display: none;">
                <div class="summary-title">Thông tin đơn hàng</div>
                
                <div class="summary-row">
                    <span>Tổng số sản phẩm:</span>
                    <span id="totalItems">0</span>
                </div>
                
                <div class="summary-row">
                    <span>Sản phẩm đã chọn:</span>
                    <span id="selectedCount">0</span>
                </div>
                
                <div class="summary-row total">
                    <span>Tổng cộng:</span>
                    <span id="totalPrice">0 ₫</span>
                </div>

                <button class="btn-checkout" id="btnCheckout" onclick="proceedToOrder()">
                    Mua hàng (<span id="checkoutCount">0</span>)
                </button>

                <p style="margin-top: 15px; font-size: 13px; color: #666; text-align: center;">
                    Bạn sẽ điền thông tin giao hàng ở bước tiếp theo
                </p>
            </div>
        </div>
    </div>

    <script>
        let cart = [];

        function loadCart() {
            fetch('/api/cart', {
                method: 'GET',
                credentials: 'include'
            })
            .then(function(response) {
                if (!response.ok) {
                    if (response.status === 401 || response.status === 403) {
                        window.location.href = '/login';
                        throw new Error('Chua dang nhap');
                    }
                    throw new Error('Khong the tai gio hang');
                }
                return response.json();
            })
            .then(function(data) {
                cart = (data.items || []).map(function(item) {
                    return {
                        id: item.cartItemId,
                        productId: item.productId,
                        name: item.productName,
                        price: item.productPrice,
                        quantity: item.quantity,
                        imageUrl: item.productImageUrl,
                        stock: 999,
                        selected: false
                    };
                });
                renderCart();
            })
            .catch(function(error) {
                console.error('Error:', error);
                if (!error.message.includes('Chua dang nhap')) {
                    showMessage('Loi khi tai gio hang: ' + error.message, 'error');
                }
            });
        }

        function renderCart() {
            var container = document.getElementById('cartItemsContainer');
            var selectAllContainer = document.getElementById('selectAllContainer');
            var summaryDiv = document.getElementById('cartSummary');

            if (cart.length === 0) {
                container.innerHTML = 
                    '<div class="empty-cart">' +
                        '<div class="empty-cart-icon">🛒</div>' +
                        '<h2>Gio hang trong</h2>' +
                        '<p style="margin-top: 10px;">Hay them san pham vao gio hang de tiep tuc!</p>' +
                        '<a href="/shop" style="display: inline-block; margin-top: 20px; padding: 10px 30px; background: #d70018; color: white; text-decoration: none; border-radius: 8px;">' +
                            'Xem san pham' +
                        '</a>' +
                    '</div>';
                selectAllContainer.style.display = 'none';
                summaryDiv.style.display = 'none';
                return;
            }

            selectAllContainer.style.display = 'flex';
            summaryDiv.style.display = 'block';

            var fragment = document.createDocumentFragment();

            cart.forEach(function(item) {
                var itemDiv = document.createElement('div');
                itemDiv.className = 'cart-item';
                
                var imgSrc = item.imageUrl && item.imageUrl.trim() !== '' ? item.imageUrl : 'data:image/svg+xml,%3Csvg xmlns=%22http://www.w3.org/2000/svg%22 width=%22100%22 height=%22100%22%3E%3Crect fill=%22%23f0f0f0%22 width=%22100%22 height=%22100%22/%3E%3Ctext x=%2250%25%22 y=%2250%25%22 dominant-baseline=%22middle%22 text-anchor=%22middle%22 font-family=%22Arial%22 font-size=%2212%22 fill=%22%23999%22%3ENo Image%3C/text%3E%3C/svg%3E';
                
                itemDiv.innerHTML =
                    '<input type="checkbox" class="cart-item-checkbox" id="item-' + item.id + '" ' +
                    (item.selected ? 'checked' : '') + ' onchange="toggleSelection(' + item.id + ')">' +
                    '<img class="cart-item-image" src="' + imgSrc + '" alt="' + item.name + '">' +
                    '<div class="cart-item-details">' +
                        '<div class="cart-item-name">' + item.name + '</div>' +
                        '<div class="cart-item-price">' + formatPrice(item.price) + '</div>' +
                        '<div class="cart-item-quantity">' +
                            '<button class="quantity-btn" onclick="updateQuantity(' + item.id + ', -1)">−</button>' +
                            '<input type="number" class="quantity-input" value="' + item.quantity + '" min="1" max="' + item.stock + '" ' +
                            'onchange="setQuantity(' + item.id + ', this.value)" id="qty-' + item.id + '">' +
                            '<button class="quantity-btn" onclick="updateQuantity(' + item.id + ', 1)">+</button>' +
                        '</div>' +
                        '<div class="cart-item-subtotal">Thanh tien: ' + formatPrice(item.price * item.quantity) + '</div>' +
                    '</div>' +
                    '<div class="cart-item-actions">' +
                        '<button class="btn-remove" onclick="removeItem(' + item.id + ')">Xoa</button>' +
                    '</div>';

                fragment.appendChild(itemDiv);
            });

            container.innerHTML = '';
            container.appendChild(fragment);

            updateSummary();
        }

        function toggleSelection(itemId) {
            var item = cart.find(function(i) { return i.id === itemId; });
            if (item) {
                item.selected = !item.selected;
                updateSummary();
                updateSelectAllCheckbox();
            }
        }

        document.addEventListener('DOMContentLoaded', function() {
            var selectAllCheckbox = document.getElementById('selectAllCheckbox');
            if (selectAllCheckbox) {
                selectAllCheckbox.addEventListener('change', function() {
                    var isChecked = this.checked;
                    cart.forEach(function(item) {
                        item.selected = isChecked;
                        var checkbox = document.getElementById('item-' + item.id);
                        if (checkbox) checkbox.checked = isChecked;
                    });
                    updateSummary();
                });
            }

            loadCart();
        });

        function updateSelectAllCheckbox() {
            var selectAllCheckbox = document.getElementById('selectAllCheckbox');
            if (selectAllCheckbox && cart.length > 0) {
                var allSelected = cart.every(function(item) { return item.selected; });
                selectAllCheckbox.checked = allSelected;
            }
        }

        function updateSummary() {
            var selectedItems = cart.filter(function(item) { return item.selected; });
            var totalItems = cart.length;
            var selectedCount = selectedItems.length;
            var subtotal = selectedItems.reduce(function(sum, item) {
                return sum + (item.price * item.quantity);
            }, 0);

            document.getElementById('totalItems').textContent = totalItems;
            document.getElementById('selectedCount').textContent = selectedCount;
            document.getElementById('totalPrice').textContent = formatPrice(subtotal);
            document.getElementById('checkoutCount').textContent = selectedCount;

            var btnCheckout = document.getElementById('btnCheckout');
            btnCheckout.disabled = selectedCount === 0;
        }

        function updateQuantity(itemId, delta) {
            var item = cart.find(function(i) { return i.id === itemId; });
            if (!item) return;

            var newQty = item.quantity + delta;
            if (newQty < 1 || newQty > item.stock) {
                if (newQty > item.stock) {
                    showMessage('So luong khong duoc vuot qua ' + item.stock, 'error');
                }
                return;
            }

            updateCartItem(itemId, newQty);
        }

        function setQuantity(itemId, value) {
            var item = cart.find(function(i) { return i.id === itemId; });
            if (!item) return;

            var newQty = parseInt(value);
            if (isNaN(newQty) || newQty < 1) {
                newQty = 1;
            } else if (newQty > item.stock) {
                newQty = item.stock;
                showMessage('So luong khong duoc vuot qua ' + item.stock, 'error');
            }

            document.getElementById('qty-' + itemId).value = newQty;
            updateCartItem(itemId, newQty);
        }

        function updateCartItem(itemId, quantity) {
            fetch('/api/cart/update/' + itemId, {
                method: 'PUT',
                headers: {
                    'Content-Type': 'application/json'
                },
                credentials: 'include',
                body: JSON.stringify({ quantity: quantity })
            })
            .then(function(response) {
                if (!response.ok) throw new Error('Khong the cap nhat');
                return response.json();
            })
            .then(function() {
                var item = cart.find(function(i) { return i.id === itemId; });
                if (item) {
                    item.quantity = quantity;
                    renderCart();
                }
            })
            .catch(function(error) {
                console.error('Error:', error);
                showMessage('Loi khi cap nhat so luong', 'error');
                loadCart();
            });
        }

        function removeItem(itemId) {
            if (!confirm('Ban co chac muon xoa san pham nay?')) return;

            fetch('/api/cart/remove/' + itemId, {
                method: 'DELETE',
                credentials: 'include'
            })
            .then(function(response) {
                if (!response.ok) throw new Error('Khong the xoa');
                showMessage('Da xoa san pham khoi gio hang', 'success');
                loadCart();
            })
            .catch(function(error) {
                console.error('Error:', error);
                showMessage('Loi khi xoa san pham', 'error');
            });
        }

        function proceedToOrder() {
            var selectedItems = cart.filter(function(item) { return item.selected; });
            
            if (selectedItems.length === 0) {
                showMessage('Vui long chon it nhat 1 san pham de tiep tuc', 'info');
                return;
            }

            sessionStorage.setItem('selectedCartItems', JSON.stringify(selectedItems));
            window.location.href = '/order';
        }

        function formatPrice(price) {
            return new Intl.NumberFormat('vi-VN', {
                style: 'currency',
                currency: 'VND'
            }).format(price);
        }

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
    </script>
</body>
</html>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sản phẩm yêu thích - CellPhoneStore</title>
</head>
<body>

<!-- BREADCRUMB -->
<div id="breadcrumb" class="section">
    <div class="container">
        <div class="row">
            <div class="col-md-12">
                <ul class="breadcrumb-tree">
                    <li><a href="${pageContext.request.contextPath}/">Trang chủ</a></li>
                    <li class="active">Sản phẩm yêu thích</li>
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
            <div class="col-md-12">
                <div class="section-title">
                    <h3 class="title"><i class="fa fa-heart"></i> Sản phẩm yêu thích của bạn</h3>
                </div>
            </div>
        </div>

        <!-- Select All Box -->
        <div class="row" id="selectAllContainer" style="display: none;">
            <div class="col-md-12">
                <div style="background: #fff3cd; border: 1px solid #ffc107; border-radius: 8px; padding: 15px; margin-bottom: 20px; display: flex; justify-content: space-between; align-items: center;">
                    <label style="margin: 0; cursor: pointer; font-weight: 500; color: #856404;">
                        <input type="checkbox" id="selectAllCheckbox" style="width: 20px; height: 20px; margin-right: 10px; cursor: pointer;">
                        Chọn tất cả sản phẩm
                    </label>
                    <button id="btnDeleteSelected" class="primary-btn" style="background: #dc3545; padding: 8px 20px; display: none;" onclick="deleteSelectedItems()">
                        <i class="fa fa-trash"></i> Xóa đã chọn
                    </button>
                </div>
            </div>
        </div>

        <!-- Wishlist Items -->
        <div class="row" id="wishlistContainer">
            <!-- Items will be loaded by JavaScript -->
            <div class="col-md-12 text-center" style="padding: 40px 0;">
                <i class="fa fa-spinner fa-spin" style="font-size: 48px; color: #D10024;"></i>
                <p style="margin-top: 20px; color: #999;">Đang tải...</p>
            </div>
        </div>
        <!-- /Wishlist Items -->

        <!-- Empty State -->
        <div class="row" id="emptyWishlist" style="display: none;">
            <div class="col-md-12">
                <div style="text-align: center; padding: 80px 20px; background: #f9f9f9; border-radius: 8px;">
                    <i class="fa fa-heart-o" style="font-size: 80px; color: #ddd; margin-bottom: 20px;"></i>
                    <h3 style="color: #666; margin-bottom: 10px;">Chưa có sản phẩm yêu thích</h3>
                    <p style="color: #999; margin-bottom: 30px;">Hãy thêm sản phẩm yêu thích để theo dõi!</p>
                    <a href="${pageContext.request.contextPath}/shop" class="primary-btn">Khám phá sản phẩm</a>
                </div>
            </div>
        </div>
        <!-- /Empty State -->
    </div>
</div>
<!-- /SECTION -->

<script>
const ctx = '${pageContext.request.contextPath}';
let wishlistData = [];

// Load wishlist on page load
window.addEventListener('DOMContentLoaded', function() {
    loadWishlist();
});

function loadWishlist() {
    fetch(ctx + '/api/favorite', {
        method: 'GET',
        credentials: 'include',
        headers: {
            'Content-Type': 'application/json'
        }
    })
    .then(function(response) {
        if (!response.ok) {
            if (response.status === 401 || response.status === 403) {
                window.location.href = ctx + '/login';
                throw new Error('Unauthorized');
            }
            throw new Error('Không thể tải danh sách');
        }
        return response.json();
    })
    .then(function(data) {
        wishlistData = data;
        renderWishlist();
    })
    .catch(function(error) {
        console.error('Error loading wishlist:', error);
        if (!error.message.includes('Unauthorized')) {
            document.getElementById('wishlistContainer').innerHTML = 
                '<div class="col-md-12 text-center" style="padding: 40px 0;">' +
                    '<p style="color: #d70018;">Có lỗi xảy ra khi tải danh sách yêu thích</p>' +
                '</div>';
        }
    });
}

function renderWishlist() {
    const container = document.getElementById('wishlistContainer');
    const emptyState = document.getElementById('emptyWishlist');
    const selectAllContainer = document.getElementById('selectAllContainer');

    if (!wishlistData || wishlistData.length === 0) {
        container.style.display = 'none';
        emptyState.style.display = 'block';
        selectAllContainer.style.display = 'none';
        return;
    }

    container.style.display = 'flex';
    emptyState.style.display = 'none';
    selectAllContainer.style.display = 'block';

    let html = '';
    wishlistData.forEach(function(item) {
        const imgSrc = item.productImageUrl && item.productImageUrl.trim() !== '' 
            ? ctx + item.productImageUrl 
            : ctx + '/images/no-image.png';
        
        const stockLabel = item.productStock > 0 
            ? '<div class="product-label"><span class="new">Còn hàng</span></div>'
            : '<div class="product-label"><span class="sale">Hết hàng</span></div>';

        const addCartBtn = item.productStock > 0
            ? '<button class="add-to-cart-btn" onclick="addToCartFromWishlist(' + item.productId + ')"><i class="fa fa-shopping-cart"></i> Thêm vào giỏ</button>'
            : '<button class="add-to-cart-btn" disabled style="background: #999; cursor: not-allowed;"><i class="fa fa-ban"></i> Hết hàng</button>';

        html += 
            '<div class="col-md-3 col-xs-6">' +
                '<div class="product" style="position: relative;">' +
                    '<div style="position: absolute; top: 10px; left: 10px; z-index: 10; background: white; border-radius: 4px; padding: 5px;">' +
                        '<input type="checkbox" class="wishlist-checkbox" data-product-id="' + item.productId + '" onchange="updateDeleteButton()" style="width: 20px; height: 20px; cursor: pointer;">' +
                    '</div>' +
                    '<div class="product-img">' +
                        '<img src="' + imgSrc + '" alt="' + item.productName + '" style="max-height: 250px; object-fit: contain;">' +
                        stockLabel +
                    '</div>' +
                    '<div class="product-body">' +
                        '<p class="product-category">' + (item.productCategory || 'Chưa phân loại') + '</p>' +
                        '<h3 class="product-name">' +
                            '<a href="' + ctx + '/product/' + item.productId + '">' + item.productName + '</a>' +
                        '</h3>' +
                        '<h4 class="product-price">' + formatPrice(item.productPrice) + '</h4>' +
                        '<div class="product-btns">' +
                            '<a href="' + ctx + '/product/' + item.productId + '" class="quick-view">' +
                                '<i class="fa fa-eye"></i>' +
                                '<span class="tooltipp">Xem chi tiết</span>' +
                            '</a>' +
                        '</div>' +
                    '</div>' +
                    '<div class="add-to-cart">' +
                        addCartBtn +
                    '</div>' +
                '</div>' +
            '</div>';
    });

    container.innerHTML = html;
    
    // Setup select all checkbox
    const selectAllCheckbox = document.getElementById('selectAllCheckbox');
    if (selectAllCheckbox) {
        selectAllCheckbox.onchange = function() {
            const checkboxes = document.querySelectorAll('.wishlist-checkbox');
            checkboxes.forEach(function(cb) {
                cb.checked = selectAllCheckbox.checked;
            });
            updateDeleteButton();
        };
    }
}

function addToCartFromWishlist(productId) {
    fetch(ctx + '/api/cart/add', {
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
            window.location.href = ctx + '/login';
            throw new Error('Unauthorized');
        } else {
            throw new Error('Có lỗi xảy ra');
        }
    })
    .then(function(data) {
        // Update cart count in header
        if (typeof updateGlobalCartCount === 'function') {
            updateGlobalCartCount();
        }
    })
    .catch(function(error) {
        if (error.message !== 'Unauthorized') {
            alert('Có lỗi: ' + error.message);
        }
    });
}

function updateDeleteButton() {
    const checkboxes = document.querySelectorAll('.wishlist-checkbox:checked');
    const deleteBtn = document.getElementById('deleteSelectedBtn');
    const selectAllCheckbox = document.getElementById('selectAllCheckbox');
    
    if (deleteBtn) {
        deleteBtn.style.display = checkboxes.length > 0 ? 'inline-block' : 'none';
    }
    
    // Update select all checkbox state
    if (selectAllCheckbox) {
        const allCheckboxes = document.querySelectorAll('.wishlist-checkbox');
        selectAllCheckbox.checked = allCheckboxes.length > 0 && checkboxes.length === allCheckboxes.length;
    }
}

function deleteSelectedItems() {
    const checkboxes = document.querySelectorAll('.wishlist-checkbox:checked');
    if (checkboxes.length === 0) {
        return;
    }

    const productIds = [];
    checkboxes.forEach(function(cb) {
        productIds.push(cb.getAttribute('data-product-id'));
    });

    // Delete all selected items
    const deletePromises = productIds.map(function(productId) {
        return fetch(ctx + '/api/favorite/remove/' + productId, {
            method: 'DELETE',
            credentials: 'include',
            headers: {
                'Content-Type': 'application/json'
            }
        });
    });

    Promise.all(deletePromises)
        .then(function(responses) {
            const allOk = responses.every(function(response) {
                return response.ok;
            });
            if (!allOk) {
                throw new Error('Một số sản phẩm không thể xóa');
            }
            // Update wishlist count in header
            if (typeof updateGlobalWishlistCount === 'function') {
                updateGlobalWishlistCount();
            }
            // Reload wishlist
            loadWishlist();
        })
        .catch(function(error) {
            alert('Có lỗi: ' + error.message);
        });
}

function removeFromWishlist(productId, button) {
    fetch(ctx + '/api/favorite/remove/' + productId, {
        method: 'DELETE',
        credentials: 'include',
        headers: {
            'Content-Type': 'application/json'
        }
    })
    .then(function(response) {
        if (!response.ok) {
            throw new Error('Không thể xóa');
        }
        return response.json();
    })
    .then(function(data) {
        // Update wishlist count in header
        if (typeof updateGlobalWishlistCount === 'function') {
            updateGlobalWishlistCount();
        }
        // Reload wishlist
        loadWishlist();
    })
    .catch(function(error) {
        console.error('Error removing from wishlist:', error);
        alert('Lỗi khi xóa sản phẩm: ' + error.message);
    });
}

function formatPrice(price) {
    if (!price) return '0 ₫';
    return new Intl.NumberFormat('vi-VN').format(price) + ' ₫';
}
</script>

</body>
</html>

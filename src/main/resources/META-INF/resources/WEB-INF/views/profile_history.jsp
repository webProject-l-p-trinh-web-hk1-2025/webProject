<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<div id="profile-content">
    <style>
        /* Profile History Styles - Optimized for profile sidebar layout */
        .profile-orders-title {
            color: #333;
            margin-bottom: 25px;
            font-size: 22px;
            font-weight: bold;
            text-align: left;
            border-bottom: 2px solid #d10024;
            padding-bottom: 12px;
        }

        .order-card {
            background: white;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 15px;
            box-shadow: 0 1px 4px rgba(0, 0, 0, 0.1);
            transition: box-shadow 0.3s ease;
        }

        .order-card:hover {
            box-shadow: 0 3px 10px rgba(0, 0, 0, 0.15);
        }

        .order-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-bottom: 12px;
            border-bottom: 1px solid #f0f0f0;
            margin-bottom: 12px;
            flex-wrap: wrap;
            gap: 8px;
        }

        .order-id {
            font-size: 16px;
            font-weight: bold;
            color: #333;
        }

        .order-date {
            color: #666;
            font-size: 13px;
            margin-top: 3px;
        }

        .order-status-badge {
            display: inline-block;
            padding: 5px 12px;
            border-radius: 15px;
            font-weight: 600;
            font-size: 11px;
            text-transform: uppercase;
        }

        .status-PENDING {
            background: #fff3cd;
            color: #856404;
        }

        .status-PROCESSING {
            background: #cfe2ff;
            color: #084298;
        }

        .status-SHIPPED {
            background: #d1ecf1;
            color: #0c5460;
        }

        .status-DELIVERED {
            background: #d4edda;
            color: #155724;
        }

        .status-CANCELLED {
            background: #f8d7da;
            color: #721c24;
        }

        .order-body {
            padding: 12px 0;
        }

        .order-items {
            display: flex;
            gap: 8px;
            margin-bottom: 12px;
            flex-wrap: wrap;
            max-width: 100%;
        }

        .order-item-image {
            width: 50px;
            height: 50px;
            object-fit: contain;
            border: 1px solid #e0e0e0;
            border-radius: 4px;
            padding: 3px;
            background: #ffffff;
            flex-shrink: 0;
        }

        .order-total {
            font-size: 17px;
            font-weight: bold;
            color: #d70018;
            margin-top: 10px;
        }

        .order-footer {
            display: flex;
            gap: 8px;
            padding-top: 12px;
            border-top: 1px solid #f0f0f0;
            margin-top: 10px;
            flex-wrap: wrap;
        }

        .btn-order {
            padding: 8px 16px;
            border: none;
            border-radius: 5px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-block;
            font-size: 13px;
        }

        .btn-view {
            background: linear-gradient(135deg, #d70018 0%, #f05423 100%);
            color: white;
        }

        .btn-view:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(215, 0, 24, 0.3);
            color: white;
        }

        .btn-cancel {
            background: #6c757d;
            color: white;
        }

        .btn-cancel:hover {
            background: #5a6268;
        }

        .btn-cancel:disabled {
            background: #ccc;
            cursor: not-allowed;
        }

        .empty-state {
            text-align: center;
            padding: 40px 20px;
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }

        .empty-state i {
            font-size: 60px;
            color: #ccc;
            margin-bottom: 15px;
        }

        .empty-state h3 {
            color: #666;
            margin-bottom: 10px;
            font-size: 18px;
        }

        .empty-state p {
            color: #999;
            font-size: 14px;
        }

        .empty-state a {
            display: inline-block;
            margin-top: 15px;
            padding: 10px 25px;
            background: linear-gradient(135deg, #d70018 0%, #f05423 100%);
            color: white;
            text-decoration: none;
            border-radius: 5px;
            font-weight: 600;
            transition: all 0.3s;
        }

        .empty-state a:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(215, 0, 24, 0.3);
        }

        .alert-message {
            padding: 12px 15px;
            border-radius: 6px;
            margin-bottom: 15px;
            font-weight: 600;
            display: none;
            font-size: 14px;
        }

        .alert-success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .alert-error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        .orders-count {
            text-align: center;
            margin-bottom: 15px;
            font-size: 14px;
            color: #666;
            font-weight: 600;
        }

        .orders-count i {
            color: #28a745;
        }

        #pagination {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 10px;
            margin-top: 20px;
            flex-wrap: wrap;
        }

        #pagination button {
            padding: 8px 16px;
            background: #d70018;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-weight: 600;
            font-size: 13px;
            transition: all 0.3s;
        }

        #pagination button:hover:not(:disabled) {
            background: #b3001a;
            transform: translateY(-1px);
        }

        #pagination button:disabled {
            background: #ccc;
            cursor: not-allowed;
            opacity: 0.6;
        }

        #pageInfo {
            font-weight: 600;
            color: #333;
            font-size: 14px;
        }

        @media (max-width: 768px) {
            .order-header {
                flex-direction: column;
                align-items: flex-start;
            }

            .order-item-image {
                width: 45px;
                height: 45px;
            }

            .order-footer {
                flex-direction: column;
            }

            .btn-order {
                width: 100%;
                text-align: center;
            }
        }
    </style>

    <h1 class="profile-orders-title">
        <i class="fa fa-list-alt"></i> Lịch sử mua hàng
    </h1>

    <div id="messageContainer" class="alert-message"></div>

    <!-- Orders List -->
    <c:choose>
        <c:when test="${empty orders}">
            <!-- Empty State -->
            <div class="empty-state">
                <i class="fa fa-shopping-bag"></i>
                <h3>Bạn chưa có đơn hàng nào</h3>
                <p>Hãy khám phá các sản phẩm của chúng tôi và đặt hàng ngay!</p>
                <a href="${pageContext.request.contextPath}/shop">
                    <i class="fa fa-shopping-cart"></i> Mua sắm ngay
                </a>
            </div>
        </c:when>
        <c:otherwise>
            <!-- Orders count -->
            <div class="orders-count">
                <i class="fa fa-check-circle"></i>
                Tổng số: <span id="totalOrdersCount">${fn:length(orders)}</span> đơn hàng
                <span style="margin: 0 10px;">|</span>
                Đang hiển thị: <span id="displayCount">5</span> đơn hàng
            </div>

            <!-- Order Cards -->
            <div id="orders-container">
                <c:forEach var="order" items="${orders}" varStatus="loop">
                    <div class="order-card" data-order-index="${loop.index}">
                        <!-- Order Header -->
                        <div class="order-header">
                            <div>
                                <div class="order-id">
                                    <i class="fa fa-shopping-bag"></i> Đơn hàng #${order.orderId}
                                </div>
                                <div class="order-date">
                                    <i class="fa fa-calendar"></i> ${order.createdAt}
                                </div>
                            </div>
                            <div>
                                <span class="order-status-badge status-${order.status}" id="status-${order.orderId}">
                                    ${order.status}
                                </span>
                            </div>
                        </div>

                        <!-- Order Body -->
                        <div class="order-body">
                            <!-- Product Images -->
                            <div class="order-items">
                                <c:forEach var="item" items="${order.items}" varStatus="status">
                                    <c:if test="${status.index < 4}">
                                        <c:choose>
                                            <c:when test="${fn:startsWith(item.productImageUrl, '/uploads/')}">
                                                <img src="${pageContext.request.contextPath}${item.productImageUrl}"
                                                    alt="${item.productName}" class="order-item-image"
                                                    title="${item.productName}" 
                                                    onerror="this.src='${pageContext.request.contextPath}/static/image/no-image.png'"/>
                                            </c:when>
                                            <c:otherwise>
                                                <img src="${pageContext.request.contextPath}/uploads/products/${item.productImageUrl}"
                                                    alt="${item.productName}" class="order-item-image"
                                                    title="${item.productName}"
                                                    onerror="this.src='${pageContext.request.contextPath}/static/image/no-image.png'"/>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:if>
                                </c:forEach>
                                <c:if test="${fn:length(order.items) > 4}">
                                    <div class="order-item-image"
                                        style="display: flex; align-items: center; justify-content: center; background: #e9ecef; font-weight: bold; color: #666; font-size: 12px;">
                                        +${fn:length(order.items) - 4}
                                    </div>
                                </c:if>
                            </div>

                            <!-- Total Amount -->
                            <div class="order-total">
                                <i class="fa fa-money"></i> Tổng tiền:
                                <fmt:formatNumber value="${order.totalAmount}" pattern="#,###" /> ₫
                            </div>
                        </div>

                        <!-- Order Footer -->
                        <div class="order-footer">
                            <a class="btn-order btn-view"
                                href="${pageContext.request.contextPath}/order/${order.orderId}">
                                <i class="fa fa-eye"></i> Xem chi tiết
                            </a>
                            <c:if test="${order.status == 'PENDING'}">
                                <button class="btn-order btn-cancel" data-order-id="${order.orderId}">
                                    <i class="fa fa-times-circle"></i> Hủy đơn hàng
                                </button>
                            </c:if>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <!-- Pagination -->
            <div id="pagination">
                <button id="prevBtn" onclick="changePage(-1)">
                    <i class="fa fa-chevron-left"></i> Trước
                </button>
                <span id="pageInfo"></span>
                <button id="nextBtn" onclick="changePage(1)">
                    Sau <i class="fa fa-chevron-right"></i>
                </button>
            </div>
        </c:otherwise>
    </c:choose>

    <script>
        // Pagination variables
        const ORDERS_PER_PAGE = 5;
        let currentPage = 1;
        let totalOrders = 0;

        function initOrderHistory() {
            const orderCards = document.querySelectorAll('#profile-content .order-card');
            totalOrders = orderCards.length;

            const totalSpan = document.getElementById('totalOrdersCount');
            if (totalSpan) {
                totalSpan.textContent = totalOrders;
            }

            if (totalOrders > 0) {
                showPage(1);
            } else {
                const displayCountElement = document.getElementById('displayCount');
                if (displayCountElement) displayCountElement.textContent = '0';
                const pageInfo = document.getElementById('pageInfo');
                if (pageInfo) pageInfo.textContent = 'Trang 0 / 0';
                const prevBtn = document.getElementById('prevBtn');
                const nextBtn = document.getElementById('nextBtn');
                if (prevBtn) prevBtn.disabled = true;
                if (nextBtn) nextBtn.disabled = true;
            }

            // Attach cancel button handlers
            document.querySelectorAll('#profile-content .btn-cancel').forEach(function (btn) {
                btn.addEventListener('click', function () {
                    const id = this.getAttribute('data-order-id');
                    if (id) cancelOrder(id);
                });
            });
        }

        // Run on DOMContentLoaded and also expose for AJAX loading
        document.addEventListener('DOMContentLoaded', initOrderHistory);
        
        // If already loaded (for AJAX case), run immediately
        if (document.readyState === 'complete' || document.readyState === 'interactive') {
            setTimeout(initOrderHistory, 1);
        }

        function showPage(page) {
            const orderCards = document.querySelectorAll('#profile-content .order-card');
            totalOrders = orderCards.length;
            const totalPages = Math.max(1, Math.ceil(totalOrders / ORDERS_PER_PAGE));

            if (page < 1) page = 1;
            if (page > totalPages) page = totalPages;

            currentPage = page;

            // Hide all orders
            orderCards.forEach(card => {
                card.style.display = 'none';
            });

            // Show orders for current page
            const start = (page - 1) * ORDERS_PER_PAGE;
            const end = start + ORDERS_PER_PAGE;

            let displayedCount = 0;
            for (let i = start; i < end && i < orderCards.length; i++) {
                orderCards[i].style.display = 'block';
                displayedCount++;
            }

            // Update display count
            const displayCountElement = document.getElementById('displayCount');
            if (displayCountElement) {
                displayCountElement.textContent = displayedCount;
            }

            // Update pagination UI
            const pageInfoEl = document.getElementById('pageInfo');
            if (pageInfoEl) pageInfoEl.textContent = 'Trang ' + currentPage + ' / ' + totalPages;

            const prevBtn = document.getElementById('prevBtn');
            const nextBtn = document.getElementById('nextBtn');
            if (prevBtn) prevBtn.disabled = currentPage === 1;
            if (nextBtn) nextBtn.disabled = currentPage === totalPages;

            // Scroll to top
            const titleEl = document.querySelector('.profile-orders-title');
            if (titleEl) {
                try { titleEl.scrollIntoView({ behavior: 'smooth' }); } catch (e) { }
            }
        }

        function changePage(direction) {
            showPage(currentPage + direction);
        }

        function cancelOrder(orderId) {
            if (!confirm("Bạn có chắc muốn hủy đơn hàng này?")) return;

            fetch('/api/orders/' + orderId + '/cancel', {
                method: 'PUT',
                credentials: 'include'
            })
            .then(response => {
                if (!response.ok) throw new Error("Không thể hủy đơn hàng");
                return response.json();
            })
            .then(data => {
                showMessage(data.message, 'success');
                const statusEl = document.getElementById('status-' + orderId);
                if (statusEl) {
                    statusEl.textContent = 'CANCELLED';
                    statusEl.className = 'order-status-badge status-CANCELLED';
                }

                const btn = document.querySelector('[data-order-id="' + orderId + '"]');
                if (btn) btn.style.display = 'none';
            })
            .catch(error => {
                console.error(error);
                showMessage('Lỗi khi hủy đơn hàng!', 'error');
            });
        }

        function showMessage(message, type) {
            var container = document.getElementById('messageContainer');
            container.textContent = message;
            container.className = 'alert-message alert-' + type;
            container.style.display = 'block';

            container.scrollIntoView({ behavior: 'smooth', block: 'nearest' });

            setTimeout(function () {
                container.style.display = 'none';
            }, 5000);
        }
    </script>
</div>

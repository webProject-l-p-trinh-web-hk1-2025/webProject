<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <title>Trang cá nhân - Member</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <c:url value="/css/profile.css" var="profileCss" />
    <link rel="stylesheet" href="${profileCss}" />
    <style>
        /* Highlight/raise selected menu item */
        .left-sidebar .menu a {
            display:block;
            padding:10px 12px;
            border-radius:6px;
            transition: transform 180ms ease, box-shadow 180ms ease, background-color 180ms ease;
        }
        .left-sidebar .menu a.active {
            background: #fff;
            transform: translateY(-6px);
            box-shadow: 0 10px 30px rgba(0,0,0,0.12);
            color: #111 !important;
        }
        .left-sidebar .menu a:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 18px rgba(0,0,0,0.06);
        }
    </style>
</head>

<body class="profile-page">
    <div class="profile-wrapper">
        <div class="profile-top">
            <div style="display:flex;align-items:center;gap:12px">
                <div class="profile-avatar">
                    <c:choose>
                        <c:when test="${not empty user.avatarUrl}">
                            <img src="${pageContext.request.contextPath}${user.avatarUrl}" alt="avatar" style="width:100%;height:100%;object-fit:cover;border-radius:50%" />
                        </c:when>
                        <c:otherwise>
                            <img src="/image/default-avatar.png" alt="avatar" style="width:100%;height:100%;object-fit:cover;border-radius:50%" />
                        </c:otherwise>
                    </c:choose>
                </div>
                <div>
                    <h4 style="margin:0">${user.fullname}</h4>
                    <div class="profile-badges mt-1">
                        <span class="badge-role">Thường</span>
                    </div>
                </div>
            </div>

            <div class="profile-stats">
                <div class="card-sm text-center">
                    <div style="font-size:18px;font-weight:600">${totalOrders}</div>
                    <div class="text-muted" style="font-size:14px">Tổng số đơn hàng đã mua</div>
                </div>
                <div class="card-sm text-center">
                    <div style="font-size:18px;font-weight:600">
                        <fmt:formatNumber value="${totalSpent}" pattern="#,###"/>đ
                    </div>
                    <div class="text-muted" style="font-size:14px">Tổng tiền tích luỹ</div>
                </div>
            </div>
        </div>

    <div style="display:flex;gap:12px;margin-top:18px;align-items:stretch">
            <aside class="left-sidebar">
                <div class="menu">
                    <a href="${pageContext.request.contextPath}/profile" class="active">Tổng quan</a>
                    <a href="${pageContext.request.contextPath}/profile/orders">Lịch sử mua hàng</a>
                    <a href="${pageContext.request.contextPath}/profile/offers">Hạng thành viên và ưu đãi</a>
                    <a href="${pageContext.request.contextPath}/profile/update">Thông tin tài khoản</a>
                    <a href="${pageContext.request.contextPath}/">Trang chủ</a>
                </div>
            </aside>

            <main class="main-area">
                <div id="profile-content">
                    <!-- Flash messages -->
                    <c:if test="${not empty success}">
                        <div class="alert alert-success">${success}</div>
                    </c:if>
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger">${error}</div>
                    </c:if>

                    <div class="grid">
                        <div class="left-col">
                            <div class="profile-card p-3">
                                <div class="d-flex justify-content-between align-items-start mb-3">
                                    <h6 class="mb-0">Thông tin cá nhân</h6>
                                    <a href="${pageContext.request.contextPath}/profile/update" class="btn btn-sm btn-outline-secondary">Chỉnh sửa</a>
                                </div>

                                <div class="row mb-2 align-items-center">
                                    <div class="col-4 text-muted">Họ và tên</div>
                                    <div class="col-8">${user.fullname}</div>
                                </div>

                                <div class="row mb-2 align-items-center">
                                    <div class="col-4 text-muted">Địa chỉ</div>
                                    <div class="col-8">
                                        <c:choose>
                                            <c:when test="${not empty user.address}">${user.address}</c:when>
                                            <c:otherwise>-</c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>

                                <div class="row mb-2 align-items-center">
                                    <div class="col-4 text-muted">Số điện thoại</div>
                                    <div class="col-8">
                                        ${user.phone}
                                        <c:choose>
                                            <c:when test="${verifyPhone}">
                                                <span class="badge bg-success ms-2">Đã xác nhận</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="ms-2 text-warning small verify-toggle" data-target="#phone-otp-area" style="cursor:pointer">Chưa xác nhận</span>
                                                <div id="phone-otp-area" style="display:none; margin-top:6px;">
                                                    <form method="post" action="${pageContext.request.contextPath}/send-otp-phone" style="display:inline">
                                                        <button type="submit" class="btn btn-sm btn-outline-danger">Gửi mã</button>
                                                    </form>
                                                    <form method="post" action="${pageContext.request.contextPath}/verify-otp" style="display:inline; margin-left:8px;">
                                                        <input type="text" name="otp" placeholder="Nhập mã OTP" class="form-control form-control-sm d-inline-block" style="width:160px; vertical-align:middle;" />
                                                        <button type="submit" class="btn btn-sm btn-danger ms-2">Xác nhận</button>
                                                    </form>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>

                                <div class="row mb-2 align-items-center">
                                    <div class="col-4 text-muted">Email</div>
                                    <div class="col-8">
                                        ${user.email}
                                        <c:choose>
                                            <c:when test="${verifyEmail}">
                                                <span class="badge bg-success ms-2">Đã xác nhận</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="ms-2 text-warning small verify-toggle" data-target="#email-otp-area" style="cursor:pointer">Chưa xác nhận</span>
                                                <div id="email-otp-area" style="display:none; margin-top:6px;">
                                                    <form method="post" action="${pageContext.request.contextPath}/send-otp-email" style="display:inline">
                                                        <button type="submit" class="btn btn-sm btn-outline-danger">Gửi mã</button>
                                                    </form>
                                                    <form method="post" action="${pageContext.request.contextPath}/verify-otp" style="display:inline; margin-left:8px;">
                                                        <input type="text" name="otp" placeholder="Nhập mã OTP" class="form-control form-control-sm d-inline-block" style="width:160px; vertical-align:middle;" />
                                                        <button type="submit" class="btn btn-sm btn-danger ms-2">Xác nhận</button>
                                                    </form>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="right-col">
                            <div class="card-sm">
                                <h6>Mật khẩu</h6>
                                <div id="password-last-updated" class="text-muted">Cập nhật lần cuối: 13/11/2024 08:53</div>
                                <a href="${pageContext.request.contextPath}/profile/change-password" class="btn btn-sm btn-outline-primary mt-2 profile-ajax">Thay đổi mật khẩu</a>
                            </div>
                            <div class="card-sm">
                                <h6>Ưu đãi của bạn</h6>
                                <p class="text-muted">Hiện bạn chưa có ưu đãi nào. Hãy mua sắm để nhận nhiều khuyến mãi hấp dẫn!</p>
                            </div>
                        </div>
                    </div>

                    <!-- Orders and offers sections below -->
                    <div class="mt-4">
                        <div class="profile-card mb-3">
                            <h6 class="mb-3 text-danger">Đơn hàng gần đây</h6>
                            <c:if test="${empty orders}">
                                <p>Bạn chưa có đơn hàng nào.</p>
                            </c:if>
                            <c:forEach var="o" items="${orders}">
                                <div class="border rounded p-3 mb-3">
                                    <div class="d-flex justify-content-between">
                                        <div>
                                            <p class="mb-1"><b>Mã đơn:</b> #${o.orderId}</p>
                                            <p class="mb-1"><b>Ngày đặt:</b> ${o.createdAt}</p>
                                            <p class="mb-1"><b>Tổng tiền:</b>
                                                <span class="text-danger fw-bold">
                                                    <fmt:formatNumber value="${o.totalAmount}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                                                </span>
                                            </p>
                                        </div>
                                        <span class="badge bg-success align-self-start">${o.status}</span>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>

                        <!-- Favorites placed horizontally under orders -->
                        <div class="profile-card mb-3">
                            <h6 class="mb-3">Yêu thích</h6>
                            <div id="favorites-list" class="favorites-horizontal text-muted">Đang tải...</div>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    (function() {
    const navLinks = document.querySelectorAll('.sidebar a, .left-sidebar .menu a');
    // additionally intercept links marked for profile AJAX
    const ajaxLinks = document.querySelectorAll('a.profile-ajax');
    const contentEl = document.getElementById('profile-content');

    function setActiveLink(element){
        try{
            document.querySelectorAll('.left-sidebar .menu a').forEach(a=>a.classList.remove('active'));
            if(element && element.classList) element.classList.add('active');
        }catch(e){/* ignore */}
    }

    function setActiveByPath(path){
        try{
            const links = document.querySelectorAll('.left-sidebar .menu a');
            links.forEach(a=>{
                const aPath = new URL(a.getAttribute('href'), location.href).pathname;
                if(aPath === path || path.startsWith(aPath)){
                    a.classList.add('active');
                } else {
                    a.classList.remove('active');
                }
            });
        }catch(e){/* ignore */}
    }

    // Hàm nạp nội dung động (chỉ phần #profile-content)
    async function loadProfileUrl(url, push = true) {
        try {
            // Hiển thị trạng thái loading
            contentEl.innerHTML = `
                <div class="text-center p-5 text-muted">
                    <div class="spinner-border text-danger" role="status"></div>
                    <p class="mt-3">Đang tải nội dung...</p>
                </div>
            `;

            const resp = await fetch(url, { credentials: 'include' });
            const text = await resp.text();
            const parser = new DOMParser();
            const doc = parser.parseFromString(text, 'text/html');

            // ✅ Chỉ lấy phần #profile-content trong file con
            const fetchedSection = doc.querySelector('#profile-content');
            if (fetchedSection) {
                contentEl.innerHTML = fetchedSection.innerHTML;
            } else {
                contentEl.innerHTML = text;
            }

            // Re-attach dynamic handlers (verify toggles etc.) after injection
            if (window.attachVerifyToggleHandlers) {
                try { window.attachVerifyToggleHandlers(); } catch(e) { console.warn(e); }
            }

            if (push) {
                history.pushState({ url: url }, '', url);
            }

            // Nếu có script trong nội dung động thì chạy lại
            contentEl.querySelectorAll('script').forEach(oldScript => {
                const newScript = document.createElement('script');
                if (oldScript.src) newScript.src = oldScript.src;
                else newScript.textContent = oldScript.textContent;
                document.body.appendChild(newScript).parentNode.removeChild(newScript);
            });

        } catch (err) {
            console.error('Không thể tải nội dung:', err);
            contentEl.innerHTML = `
                <div class="text-center text-danger p-4">
                    <p><b>Lỗi khi tải trang.</b></p>
                </div>
            `;
        }
    }

    document.addEventListener('click', function (e) {
        const a = e.target.closest('a');
        if (!a) return;
        const href = a.getAttribute('href');
        if (!href || href.startsWith('http') || href.startsWith('mailto:') || href.startsWith('#')) return;

        const targetPath = new URL(href, location.href).pathname;
        const profileBase = '${pageContext.request.contextPath}/profile';

        // Handle links that point to the profile area or explicitly marked for profile AJAX
        if (a.classList.contains('profile-ajax') || targetPath.startsWith(profileBase)) {
            e.preventDefault();
            // visually mark the clicked link active
            setActiveLink(a);
            if (location.pathname === targetPath) return;
            loadProfileUrl(href);
        }
    }, true);

    
    document.addEventListener('submit', function (e) {
        const form = e.target;

        if (!form) return;
        if (!form.closest('#profile-content')) return;

        e.preventDefault();
        const submitBtn = form.querySelector('[type="submit"]');
        const origText = submitBtn ? submitBtn.innerHTML : null;
        if (submitBtn) { submitBtn.disabled = true; submitBtn.innerHTML = 'Đang gửi...'; }

        (async function(){
            try {
                const fd = new FormData(form);
                const resp = await fetch(form.action, { method: (form.method || 'POST').toUpperCase(), body: fd, credentials: 'include' });
                const text = await resp.text();
                const parser = new DOMParser();
                const doc = parser.parseFromString(text, 'text/html');
                const newSection = doc.querySelector('#profile-content') || doc.body;
                if (contentEl) {
                    contentEl.innerHTML = newSection.innerHTML;
                    if (window.attachVerifyToggleHandlers) try { window.attachVerifyToggleHandlers(); } catch(e) {}
                    document.dispatchEvent(new Event('DOMContentLoaded'));

                    // If this was a change-password submission and the response was OK, update the last-updated timestamp
                    try {
                        if (form.action && form.action.includes('/profile/change-password') && resp && resp.ok) {
                            const el = document.getElementById('password-last-updated');
                            if (el) {
                                const now = new Date();
                                const pad = function(n) { return n.toString().padStart(2,'0'); };
                                const formatted = pad(now.getDate()) + '/' + pad(now.getMonth()+1) + '/' + now.getFullYear() + ' ' + pad(now.getHours()) + ':' + pad(now.getMinutes());
                                el.textContent = 'Cập nhật lần cuối: ' + formatted;
                            }
                        }
                    } catch (e) {
                        console.warn('Không thể cập nhật timestamp mật khẩu:', e);
                    }
                } else {
                    document.open(); document.write(text); document.close();
                }
            } catch (err) {
                console.error('Lỗi khi gửi form nội bộ profile:', err);
                alert('Đã có lỗi khi gửi yêu cầu. Vui lòng thử lại.');
            } finally {
                if (submitBtn) { submitBtn.disabled = false; submitBtn.innerHTML = origText || 'Gửi'; }
            }
        })();
    }, true);

    // Xử lý nút Back / Forward của trình duyệt
    window.addEventListener('popstate', function(e) {
        const stateUrl = (e.state && e.state.url) || location.pathname;
        loadProfileUrl(stateUrl, false);
        // update active link according to new location
        setActiveByPath(new URL(stateUrl, location.href).pathname);
    });
    // ensure initial active state on first load
    try{ setActiveByPath(location.pathname); }catch(e){}
})();
</script>

<script>
// Favorites widget loader
async function loadProfileFavorites(containerId) {
    const listEl = document.getElementById('favorites-list');
    if (!listEl) return;
    listEl.innerHTML = 'Đang tải...';
    try {
        const res = await fetch('${pageContext.request.contextPath}/api/favorite', { credentials: 'include' });
        if (!res.ok) {
            listEl.innerHTML = '<div class="text-muted">Không thể tải yêu thích</div>';
            return;
        }
        const items = await res.json();
        if (!items || items.length === 0) {
            listEl.innerHTML = '<div class="text-muted">Bạn chưa có sản phẩm yêu thích.</div>';
            return;
        }
        // render compact list (max 4) showing only image + name
        const max = 4;
        const ctx = '${pageContext.request.contextPath}';
        const html = items.slice(0, max).map(function(f){
            // support multiple possible field names returned by backend
            const imageUrl = f.productImageUrl || f.imageUrl || f.image || '';
            const name = f.productName || f.name || f.title || '';
            const productId = f.productId || f.id || '';
            let imgTag = '<div class="fav-thumb empty"></div>';
            if (imageUrl && imageUrl.trim() !== '') {
                const url = imageUrl.trim();
                const final = url.startsWith('/') ? (ctx + url) : (/^https?:\/\//i.test(url) ? url : (ctx + '/' + url));
                imgTag = '<img src="' + final + '" class="fav-thumb" />';
            }
            // Wrap in link to product detail
            const productLink = ctx + '/product/' + productId;
            return '<a href="' + productLink + '" class="fav-row" style="text-decoration: none; color: inherit; display: block; transition: all 0.3s ease;">' + 
                   imgTag + 
                   '<div class="fav-meta"><div class="fav-name">' + (name ? escapeHtml(name) : '-') + '</div></div>' + 
                   '</a>';
        }).join('');
        listEl.innerHTML = html;

        // small helper to escape HTML in product names
        function escapeHtml(str) {
            return String(str).replace(/[&<>"']/g, function (s) {
                return ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'})[s];
            });
        }
    } catch (e) {
        listEl.innerHTML = '<div class="text-muted">Lỗi tải yêu thích</div>';
    }
}

// Try to load favorites on initial page load and after profile fragment injection
document.addEventListener('DOMContentLoaded', function(){ loadProfileFavorites(); });
document.addEventListener('DOMContentLoaded', function(){ if (window.attachVerifyToggleHandlers) window.attachVerifyToggleHandlers(); });
</script>
<script>
// Handle verify-toggle: fetch /verify-otp into #verify-otp-container or toggle small areas
window.attachVerifyToggleHandlers = function attachVerifyToggleHandlers() {
    document.querySelectorAll('.verify-toggle').forEach(function(el) {
        // Remove previous handlers to avoid duplicate bindings
        el.replaceWith(el.cloneNode(true));
    });

    document.querySelectorAll('.verify-toggle').forEach(function(el) {
        el.addEventListener('click', async function () {
            var target = this.getAttribute('data-target');
            if (target === '#email-otp-area' || target === '#phone-otp-area') {
                var node = document.querySelector(target);
                if (!node) return;
                node.style.display = node.style.display === 'none' ? 'block' : 'none';
                return;
            }

            // otherwise load full verify-otp inline
            try {
                const resp = await fetch('${pageContext.request.contextPath}/verify-otp', { credentials: 'include' });
                const text = await resp.text();
                const parser = new DOMParser();
                const doc = parser.parseFromString(text, 'text/html');
                const body = doc.querySelector('body');
                const container = document.getElementById('verify-otp-container');
                container.style.display = 'block';
                container.innerHTML = body ? body.innerHTML : text;
            } catch (e) {
                console.error('Lỗi khi tải form xác thực:', e);
            }
        });
    });
};

document.addEventListener('DOMContentLoaded', function () {
    if (window.attachVerifyToggleHandlers) window.attachVerifyToggleHandlers();
});
</script>

</body>

</html>

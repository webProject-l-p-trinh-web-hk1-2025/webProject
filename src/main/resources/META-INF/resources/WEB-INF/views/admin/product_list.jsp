<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
  <%@ page contentType="text/html; charset=UTF-8" %>
    <html>

    <head>
      <title>Danh sách sản phẩm</title>
      <meta name="viewport" content="width=device-width,initial-scale=1" />
      <link rel="stylesheet" href="<c:url value='/css/admin-dashboard.css'/>" />
      <link rel="stylesheet" href="<c:url value='/css/products_admin.css'/>" />
      <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" />
      <style>
        table {
          width: 100%;
          border-collapse: collapse;
        }

        table th,
        table td {
          padding: 8px;
          border: 1px solid #ddd;
        }

        .thumb {
          max-width: 70px;
          max-height: 70px;
          object-fit: contain;
        }

        .btn {
          margin-right: 5px;
          display: inline-block;
          padding: 6px 12px;
          text-decoration: none;
          border-radius: 4px;
          border: none;
          cursor: pointer;
          font-size: 14px;
        }

        .btn-view {
          background-color: #17a2b8;
          color: white;
        }

        .btn-view:hover {
          background-color: #138496;
        }

        .btn-edit {
          background-color: #ffc107;
          color: #000;
        }

        .btn-edit:hover {
          background-color: #e0a800;
        }

        .btn-delete {
          background-color: #dc3545;
          color: white;
        }

        .btn-delete:hover {
          background-color: #c82333;
        }
      </style>
    </head>

    <body>
      <!-- app layout with collapsible sidebar -->
      <div class="app-layout">
        <!-- Metismenu-style sidebar -->
        <div class="quixnav sidebar" id="sidebar">
          <div class="quixnav-scroll">
            <button id="navToggle" class="nav-toggle-btn" title="Toggle sidebar">☰</button>
            <ul class="metismenu" id="menu">
              <li>
                <a href="${pageContext.request.contextPath}/admin"><i class="icon icon-home"></i><span
                    class="nav-text">Dashboard</span></a>
              </li>
              <li>
                <a href="${pageContext.request.contextPath}/admin/users"><i class="fas fa-users"></i><span
                    class="nav-text">Users</span></a>
              </li>
              <li class="active">
                <a href="${pageContext.request.contextPath}/admin/products"><i class="fas fa-box"></i><span
                    class="nav-text">Products</span></a>
              </li>
              <li>
                <a href="${pageContext.request.contextPath}/admin/categories"><i class="fas fa-tag"></i><span
                    class="nav-text">Categories</span></a>
              </li>
              <li>
                <a href="${pageContext.request.contextPath}/admin/document"><i class="fas fa-file-alt"></i><span
                    class="nav-text">Documents</span></a>
              </li>
              <li>
                <a href="${pageContext.request.contextPath}/admin/chat" style="position: relative;">
                  <i class="fas fa-comments"></i>
                  <span class="nav-text">Chat</span>
                  <span id="chat-notification-badge"
                    style="display:none; position:absolute; top:8px; right:12px; background:#e53935; color:white; border-radius:50%; padding:2px 6px; font-size:10px; min-width:18px; text-align:center;"></span>
                </a>
              </li>
            </ul>
          </div>
        </div>
        <div class="main-content">
          <div class="container">
            <div class="page-title">
              <h2>Quản lý sản phẩm</h2>
              <div>
                <a href="${pageContext.request.contextPath}/admin/products/new" class="btn btn-primary">
                  <i class="fas fa-plus"></i> Thêm sản phẩm
                </a>
                <button class="btn btn-outline" id="showAllBtn">
                  <i class="fas fa-list"></i>
                </button>
              </div>
            </div>

            <!-- Bộ lọc -->
            <div class="filter-container">
              <div class="filter-group">
                <label>Hãng</label>
                <select id="brand" class="filter-input">
                  <option value="">-- Tất cả hãng --</option>
                </select>
              </div>
              <div class="filter-group">
                <label>Tên sản phẩm</label>
                <input id="name" class="filter-input" placeholder="Tìm theo tên (VD: iP)" type="text"
                  autocomplete="off">
                <!-- suggestion dropdown (custom typeahead) -->
                <div id="suggestions" class="position-absolute"
                  style="z-index:1200; width:100%; display:none; max-height:320px; overflow:auto;"></div>
              </div>
              <div class="filter-group">
                <label>Giá từ</label>
                <input id="minPrice" class="filter-input" placeholder="Giá từ" type="number">
              </div>
              <div class="filter-group">
                <label>Giá đến</label>
                <input id="maxPrice" class="filter-input" placeholder="Giá đến" type="number">
              </div>
              <div class="filter-group">
                <label>Sắp xếp</label>
                <select id="sort" class="filter-input">
                  <option value="createdAt,desc">Mới nhất</option>
                  <option value="price,asc">Giá: thấp → cao</option>
                  <option value="price,desc">Giá: cao → thấp</option>
                </select>
              </div>
              <div class="filter-group" style="justify-content: flex-end;">
                <button id="searchBtn" class="btn btn-primary" style="margin-top: auto;">
                  <i class="fas fa-search"></i> Tìm kiếm
                </button>
              </div>
            </div>

            <!-- Bảng sản phẩm -->
            <div class="card">
              <div class="card-header">
                <div class="card-title">Danh sách sản phẩm</div>
              </div>
              <div class="card-body">
                <table class="table table-striped">
                  <thead>
                    <tr>
                      <th style="width:80px;">Ảnh</th>
                      <th>Tên</th>
                      <th>Hãng</th>
                      <th>Giá</th>
                      <th>Tồn</th>
                      <th>Ngày tạo</th>
                      <th style="width:120px;">Khuyến mãi</th>
                      <th style="width:250px;">Thao tác</th>
                    </tr>
                  </thead>
                  <tbody id="tbody"></tbody>
                </table>
              </div>
            </div>

            <div id="status" class="text-muted text-center py-2"></div>
            <nav aria-label="Page navigation">
              <ul id="pagination" class="pagination justify-content-center"></ul>
            </nav>
          </div>

          <!-- ========== =============================================================================================== -->
          <!-- Deal Percentage Modal -->
          <div id="dealModal" class="deal-modal" style="display: none;">
            <div class="deal-modal-content">
              <div class="deal-modal-header">
                <h3> Thiết lập khuyến mãi</h3>
                <button class="deal-modal-close" onclick="closeDealModal()">&times;</button>
              </div>
              <div class="deal-modal-body">
                <p style="margin-bottom: 20px; color: #666;">Nhập phần trăm giảm giá cho sản phẩm này:</p>
                <div class="percentage-input-group">
                  <input type="number" id="dealPercentageInput" min="0" max="100" value="10" class="percentage-input"
                    oninput="document.getElementById('dealPercentageSlider').value = this.value" />
                  <span class="percentage-symbol">%</span>
                </div>
                <div class="percentage-presets">
                  <button onclick="setPercentage(10)" class="preset-btn">10%</button>
                  <button onclick="setPercentage(20)" class="preset-btn">20%</button>
                  <button onclick="setPercentage(30)" class="preset-btn">30%</button>
                  <button onclick="setPercentage(50)" class="preset-btn">50%</button>
                </div>
                <div class="percentage-slider">
                  <input type="range" id="dealPercentageSlider" min="0" max="100" value="10"
                    oninput="document.getElementById('dealPercentageInput').value = this.value" class="slider-input" />
                  <div class="slider-labels">
                    <span>0%</span>
                    <span>50%</span>
                    <span>100%</span>
                  </div>
                </div>
              </div>
              <div class="deal-modal-footer">
                <button onclick="closeDealModal()" class="btn-cancel">Hủy</button>
                <button onclick="confirmDeal()" class="btn-confirm">✓ Xác nhận</button>
              </div>
            </div>
          </div>

          <div id="status" class="text-muted text-center py-2"></div>
          <nav aria-label="Page navigation">
            <ul id="pagination" class="pagination justify-content-center"></ul>
          </nav>
        </div>
      </div>
    </div>

    <!-- ========== =============================================================================================== -->
    <!-- ========== SCRIPT ========== -->
    <c:set var="ctx" value="${pageContext.request.contextPath}" />

        <!-- WebSocket libraries for chat notifications -->
        <script src="https://cdn.jsdelivr.net/npm/sockjs-client@1.5.0/dist/sockjs.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/stompjs@2.3.3/lib/stomp.min.js"></script>
        <script src="<c:url value='/js/admin-chat-notifications.js'/>"></script>

        <script>
          const ctx = '${ctx}';
          const api = ctx + "/api/products";
          const adminApi = ctx + "/admin/products"; // Admin endpoint

          let currentPage = 0;
          const pageSize = 5; // 5 products per page

          // Read filters from inputs into an object
          function getFilters() {
            return {
              brand: document.getElementById('brand').value,
              name: document.getElementById('name').value,
              minPrice: document.getElementById('minPrice').value,
              maxPrice: document.getElementById('maxPrice').value,
              sort: document.getElementById('sort').value
            };
          }

          function buildQueryParams(page) {
            const f = getFilters();
            const params = new URLSearchParams({ page: page, size: pageSize, sort: f.sort });
            if (f.brand) params.append('brand', f.brand);
            if (f.name) params.append('name', f.name);
            if (f.minPrice) params.append('minPrice', f.minPrice);
            if (f.maxPrice) params.append('maxPrice', f.maxPrice);
            return params;
          }

          function updateUrl(page) {
            // reflect current filters and page in the browser URL (so reload/back preserves state)
            try {
              const params = buildQueryParams(page);
              const listPath = ctx + '/admin/products';
              const newUrl = listPath + '?' + params.toString();
              history.replaceState(null, '', newUrl);
            } catch (e) {
              // ignore history errors on older browsers
              console.warn(e);
            }
          }

          async function search(page = 0) {
            const tbody = document.getElementById("tbody");
            const status = document.getElementById("status");
            tbody.innerHTML = "";
            status.textContent = "Đang tải dữ liệu...";

            const params = buildQueryParams(page);

            try {
              const res = await fetch(api + '/search?' + params.toString());
              if (!res.ok) {
                const txt = await res.text().catch(() => '');
                throw new Error('HTTP ' + res.status + ' - ' + res.statusText + '\n' + txt);
              }
              const data = await res.json();
              const list = data.content || [];
              render(list);
              // keep brands in select from server-side distinct list (do not populate from current page)
              status.textContent = list.length ? "" : "Không có sản phẩm phù hợp.";
              // pagination
              currentPage = data.number || page;
              renderPagination(data.totalPages || 0, currentPage);
              // update browser URL to include current filters + page
              updateUrl(currentPage);
            } catch (e) {
              console.error(e);
              // show server error details (status + body) to help debugging
              status.textContent = "Lỗi tải danh sách sản phẩm: " + (e.message || e.toString());
            }
          }

          // Cart functionality has been removed

          function renderPagination(totalPages, current) {
            const container = document.getElementById('pagination');
            container.innerHTML = '';
            if (totalPages <= 1) return;

            const makePageItem = (label, page, disabled, active) => {
              const li = document.createElement('li');
              li.className = 'page-item' + (disabled ? ' disabled' : '') + (active ? ' active' : '');
              const a = document.createElement('a');
              a.className = 'page-link';
              // build href containing current filters so links are shareable / reload-preserving
              try {
                a.href = ctx + '/admin/products?' + buildQueryParams(page).toString();
              } catch (e) {
                a.href = '#';
              }
              a.textContent = label;
              a.addEventListener('click', (ev) => { ev.preventDefault(); if (!disabled && current !== page) search(page); });
              li.appendChild(a);
              return li;
            };

            // Prev
            container.appendChild(makePageItem('Prev', Math.max(0, current - 1), current <= 0, false));

            // show up to 7 page numbers centered around current
            const maxButtons = 7;
            let start = Math.max(0, current - Math.floor(maxButtons / 2));
            let end = Math.min(totalPages - 1, start + maxButtons - 1);
            if (end - start + 1 < maxButtons) start = Math.max(0, end - maxButtons + 1);

            for (let i = start; i <= end; i++) {
              container.appendChild(makePageItem((i + 1).toString(), i, false, i === current));
            }

            // Next
            container.appendChild(makePageItem('Next', Math.min(totalPages - 1, current + 1), current >= totalPages - 1, false));
          }

          function render(list) {
            const tbody = document.getElementById("tbody");
            tbody.innerHTML = list.map(function (p) {
              var imgSrc = ctx + (p.imageUrl || '/images/no-image.png');
              var name = p.name || '';
              var brand = p.brand || '';
              var price = p.price != null ? p.price.toLocaleString('vi-VN') + ' ₫' : '';
              var stock = p.stock != null ? p.stock : '';
              var createdAt = p.createdAt ? new Date(p.createdAt).toLocaleDateString('vi-VN') : '';
              return (
                '<tr>' +
                '<td class="text-center"><img src="' + imgSrc + '" class="thumb" style="max-width:70px; max-height:70px;"></td>' +
                '<td>' + name + '</td>' +
                '<td>' + brand + '</td>' +
                '<td class="text-end">' + price + '</td>' +
                '<td class="text-center">' + stock + '</td>' +
                '<td class="text-center">' + createdAt + '</td>' +
                '<td class="text-center">' +
                (p.onDeal ? '<span class="badge bg-success">Áp dụng -' + (p.dealPercentage || 0) + '%</span>' : '<span class="text-muted">Không</span>') +
                '</td>' +
                '<td>' +
                '<a href="' + ctx + '/product/' + p.id + '" class="btn btn-view" title="Xem chi tiết"><i class="fas fa-eye"></i></a>' +
                '<a href="' + ctx + '/admin/products/edit/' + p.id + '" class="btn btn-edit" title="Sửa"><i class="fas fa-edit"></i></a>' +
                '<button class="btn btn-delete" onclick="deleteProduct(' + p.id + ')" title="Xóa"><i class="fas fa-trash"></i></button>' +
                '<label style="margin:0; display:flex; align-items:center; gap:4px; white-space:nowrap;">' +
                '<input type="checkbox" onchange="toggleDeal(' + p.id + ', this.checked)"' + (p.onDeal ? ' checked' : '') + '> Deal' +
                '</label>' +
                '</td>' +
                '</tr>'
              );
            }).join('');
          }

          function populateBrands(list) {
            // deprecated: brand list now loaded from backend
          }

          // Load brand options from server (distinct brands in DB)
          async function loadBrands() {
            try {
              const res = await fetch(ctx + '/api/products/brands');
              if (!res.ok) throw new Error(res.status);
              const brands = await res.json();
              const select = document.getElementById('brand');
              // reset to default option
              select.options.length = 1;
              brands.forEach(b => select.append(new Option(b, b)));
            } catch (e) {
              console.warn('Không thể tải danh sách hãng:', e);
              // show minimal message in status if no products loaded yet
              const status = document.getElementById('status');
              if (status && !status.textContent) status.textContent = 'Không thể tải danh sách hãng: ' + (e.message || e.toString());
              // Fallback: try to fetch the first page of products and extract brands from it so the select is usable
              try {
                const fallbackRes = await fetch(api + '/search?page=0&size=' + pageSize);
                if (fallbackRes.ok) {
                  const dd = await fallbackRes.json();
                  const list = dd.content || [];
                  const brands = [...new Set(list.map(p => p.brand))].filter(Boolean).sort();
                  const select = document.getElementById('brand');
                  select.options.length = 1;
                  brands.forEach(b => select.append(new Option(b, b)));
                }
              } catch (e2) {
                // ignore fallback failure
              }
              // leave only the default option
            }
          }

          async function deleteProduct(id) {
            if (!confirm('Xóa sản phẩm #' + id + '?')) return;
            const res = await fetch(api + '/' + id, { method: "DELETE" });
            if (res.ok) {
              alert("Đã xóa sản phẩm thành công!");
              // refresh current page
              search(currentPage);
            } else {
              alert("Lỗi xóa sản phẩm.");
            }
          }

          // Deal modal management
          let currentDealProductId = null;
          let currentDealCheckbox = null;

          async function toggleDeal(id, checked) {
            if (checked) {
              // Show modal for percentage input
              currentDealProductId = id;
              currentDealCheckbox = event.target;
              document.getElementById('dealPercentageInput').value = 10;
              document.getElementById('dealPercentageSlider').value = 10;
              document.getElementById('dealModal').style.display = 'flex';
            } else {
              // Turn off deal directly
              await saveDealStatus(id, false, 0);
            }
          }

          function setPercentage(value) {
            document.getElementById('dealPercentageInput').value = value;
            document.getElementById('dealPercentageSlider').value = value;
          }

          function closeDealModal() {
            document.getElementById('dealModal').style.display = 'none';
            // Uncheck the checkbox if user cancelled
            if (currentDealCheckbox) {
              currentDealCheckbox.checked = false;
            }
            currentDealProductId = null;
            currentDealCheckbox = null;
          }

          async function confirmDeal() {
            const dealPercentage = parseInt(document.getElementById('dealPercentageInput').value) || 0;
            document.getElementById('dealModal').style.display = 'none';

            if (currentDealProductId) {
              await saveDealStatus(currentDealProductId, true, dealPercentage);
            }
            currentDealProductId = null;
            currentDealCheckbox = null;
          }

          async function saveDealStatus(id, onDeal, dealPercentage) {
            try {
              // Use admin endpoint instead of API endpoint
              const res = await fetch(adminApi + '/' + id + '/deal-toggle', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ onDeal: onDeal, dealPercentage: dealPercentage })
              });
              if (!res.ok) {
                const txt = await res.text().catch(() => '');
                throw new Error('HTTP ' + res.status + ' - ' + txt);
              }
              // refresh current page to reflect changes
              search(currentPage);
            } catch (e) {
              console.error('Lỗi cập nhật deal:', e);
              alert('Lỗi cập nhật trạng thái Deal: ' + (e.message || e.toString()));
              // reload list to restore checkbox state
              search(currentPage);
            }
          }

          document.getElementById('searchBtn').onclick = () => search(0);
          document.getElementById('showAllBtn').onclick = () => {
            // clear filters then search first page
            document.getElementById('brand').value = '';
            document.getElementById('name').value = '';
            document.getElementById('minPrice').value = '';
            document.getElementById('maxPrice').value = '';
            document.getElementById('sort').value = 'createdAt,desc';
            search(0);
          };
          // If URL contains query params, populate inputs accordingly and search that page
          function readUrlParamsAndApply() {
            const params = new URLSearchParams(location.search);
            const maybeSet = (id, key) => {
              const v = params.get(key);
              if (v !== null) document.getElementById(id).value = v;
            };
            maybeSet('brand', 'brand');
            maybeSet('name', 'name');
            maybeSet('minPrice', 'minPrice');
            maybeSet('maxPrice', 'maxPrice');
            maybeSet('sort', 'sort');
            const p = parseInt(params.get('page')) || 0;
            return p;
          }

          const initialPage = readUrlParamsAndApply();
          // populate brands from DB, then perform initial search
          loadBrands().then(() => search(initialPage));

          // --- Rich typeahead suggestions (name + price) ---
          let suggestTimer = null;
          const SUGGEST_LIMIT = 8;
          const nameInput = document.getElementById('name');
          const suggestionBox = document.getElementById('suggestions');
          let highlightedIndex = -1;

          async function fetchSuggestions(q) {
            if (!q || q.length < 1) return [];
            try {
              const url = api + '/search?name=' + encodeURIComponent(q) + '&page=0&size=' + SUGGEST_LIMIT;
              const res = await fetch(url);
              if (!res.ok) return [];
              const data = await res.json();
              return data.content || [];
            } catch (e) {
              return [];
            }
          }


          function renderSuggestions(items) {
            suggestionBox.innerHTML = '';
            if (!items || items.length === 0) { suggestionBox.style.display = 'none'; highlightedIndex = -1; return; }
            items.forEach((p, idx) => {
              const priceVal = p.price != null ? Number(p.price) : null;
              const priceText = priceVal != null ? priceVal.toLocaleString('vi-VN') + ' ₫' : 'Liên hệ';
              // detect possible old price fields if present in response
              const oldCandidates = ['oldPrice', 'listPrice', 'originalPrice', 'previousPrice', 'comparePrice', 'retailPrice'];
              let oldVal = null;
              for (const k of oldCandidates) { if (p[k] != null) { oldVal = Number(p[k]); break; } }
              const oldText = oldVal != null ? oldVal.toLocaleString('vi-VN') + ' ₫' : null;

              // determine thumbnail URL: prefer p.imageUrl, then first of p.images
              let thumb = null;
              if (p.imageUrl) thumb = p.imageUrl;
              else if (p.images && p.images.length && p.images[0].url) thumb = p.images[0].url;
              // normalize URL with ctx if it starts with '/'
              if (thumb && thumb.startsWith('/')) thumb = ctx + thumb;

              const el = document.createElement('a');
              el.href = '#';
              el.className = 'list-group-item list-group-item-action d-flex align-items-center';
              el.dataset.index = idx;
              el.dataset.name = p.name || '';
              el.dataset.id = p.id;

              const imgHtml = thumb ? '<img src="' + thumb + '" style="width:64px;height:48px;object-fit:cover;border-radius:6px;margin-right:10px;">' : '<div style="width:64px;height:48px;margin-right:10px;background:#f5f5f5;border-radius:6px;"></div>';
              // Two-line name (title + subtitle) and prices (current bold red, old struck-through muted) with thumbnail
              el.innerHTML = imgHtml + '<div style="flex:1;min-width:0;">' +
                '<div class="fw-semibold text-truncate">' + (p.name || '') + '</div>' +
                '<div class="text-muted small text-truncate">' + (p.name || '') + '</div>' +
                '<div class="pt-1">' +
                '<span class="text-danger fw-bold me-2">' + priceText + '</span>' +
                (oldText ? '<span class="text-muted small text-decoration-line-through">' + oldText + '</span>' : '') +
                '</div>' +
                '</div>';
              el.addEventListener('click', (ev) => { ev.preventDefault(); pickSuggestion(p); });
              suggestionBox.appendChild(el);
            });
            suggestionBox.style.display = 'block';
            highlightedIndex = -1;
          }

          function pickSuggestion(p) {
            nameInput.value = p.name || '';
            suggestionBox.style.display = 'none';
            search(0);
          }

          function highlightAt(idx) {
            const children = suggestionBox.children;
            if (!children || children.length === 0) return;
            if (highlightedIndex >= 0 && highlightedIndex < children.length) children[highlightedIndex].classList.remove('active');
            highlightedIndex = idx;
            if (highlightedIndex >= 0 && highlightedIndex < children.length) children[highlightedIndex].classList.add('active');
          }

          if (nameInput) {
            nameInput.addEventListener('input', (ev) => {
              const q = ev.target.value;
              if (suggestTimer) clearTimeout(suggestTimer);
              suggestTimer = setTimeout(async () => {
                const items = await fetchSuggestions(q);
                renderSuggestions(items);
              }, 200);
            });

            nameInput.addEventListener('keydown', (ev) => {
              const children = suggestionBox.children;
              if (ev.key === 'ArrowDown') {
                ev.preventDefault();
                if (children.length === 0) return;
                const next = Math.min(children.length - 1, highlightedIndex + 1);
                highlightAt(next);
              } else if (ev.key === 'ArrowUp') {
                ev.preventDefault();
                if (children.length === 0) return;
                const prev = Math.max(0, highlightedIndex - 1);
                highlightAt(prev);
              } else if (ev.key === 'Enter') {
                // if suggestion highlighted, pick it; otherwise perform search
                if (highlightedIndex >= 0 && highlightedIndex < suggestionBox.children.length) {
                  ev.preventDefault();
                  const el = suggestionBox.children[highlightedIndex];
                  const id = el.dataset.id;
                  const name = el.dataset.name;
                  nameInput.value = name;
                  suggestionBox.style.display = 'none';
                  search(0);
                } else {
                  // let form search handler run
                  // we explicitly call search to ensure page 0
                  ev.preventDefault();
                  suggestionBox.style.display = 'none';
                  search(0);
                }
              } else if (ev.key === 'Escape') {
                suggestionBox.style.display = 'none';
              }
            });

            // hide suggestions when input loses focus (with small delay to allow click)
            nameInput.addEventListener('blur', () => setTimeout(() => { suggestionBox.style.display = 'none'; }, 150));
          }
        </script>
        
        <!-- Script để toggle sidebar -->
        <script>
          (function () {
            const sidebar = document.getElementById('sidebar');
            const toggle = document.getElementById('navToggle');
            if (!sidebar || !toggle) return;

            function isCollapsed() {
              return localStorage.getItem('admin_sidebar_collapsed') === '1';
            }

            function apply() {
              const collapsed = isCollapsed();
              if (window.innerWidth <= 800) {
                sidebar.classList.toggle('open', collapsed);
                sidebar.classList.remove('collapsed');
              } else {
                sidebar.classList.toggle('collapsed', collapsed);
                sidebar.classList.remove('open');
              }
            }

            apply();
            toggle.addEventListener('click', function () {
              const current = isCollapsed();
              localStorage.setItem('admin_sidebar_collapsed', current ? '0' : '1');
              apply();
            });
            window.addEventListener('resize', apply);
          })();
        </script>

        <style>
          /* Deal Modal Styles */
          .deal-modal {
            display: none;
            position: fixed;
            z-index: 10000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
            align-items: center;
            justify-content: center;
            animation: fadeIn 0.3s ease;
          }

          @keyframes fadeIn {
            from {
              opacity: 0;
            }

            to {
              opacity: 1;
            }
          }

          .deal-modal-content {
            background: white;
            border-radius: 16px;
            width: 90%;
            max-width: 500px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            animation: slideUp 0.3s ease;
            overflow: hidden;
          }

          @keyframes slideUp {
            from {
              transform: translateY(50px);
              opacity: 0;
            }

            to {
              transform: translateY(0);
              opacity: 1;
            }
          }

          .deal-modal-header {
            background: linear-gradient(135deg, #d70018 0%, #ff6b6b 100%);
            color: white;
            padding: 20px 25px;
            display: flex;
            justify-content: space-between;
            align-items: center;
          }

          .deal-modal-header h3 {
            margin: 0;
            font-size: 22px;
            font-weight: 600;
          }

          .deal-modal-close {
            background: none;
            border: none;
            color: white;
            font-size: 32px;
            cursor: pointer;
            line-height: 1;
            padding: 0;
            width: 32px;
            height: 32px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
            transition: background 0.2s;
          }

          .deal-modal-close:hover {
            background: rgba(255, 255, 255, 0.2);
          }

          .deal-modal-body {
            padding: 30px 25px;
          }

          .percentage-input-group {
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 25px;
            gap: 10px;
          }

          .percentage-input {
            width: 120px;
            font-size: 48px;
            font-weight: bold;
            text-align: center;
            border: 3px solid #d70018;
            border-radius: 12px;
            padding: 15px;
            color: #d70018;
            outline: none;
            transition: all 0.3s;
          }

          .percentage-input:focus {
            border-color: #ff6b6b;
            box-shadow: 0 0 0 4px rgba(215, 0, 24, 0.1);
          }

          .percentage-symbol {
            font-size: 36px;
            font-weight: bold;
            color: #d70018;
          }

          .percentage-presets {
            display: flex;
            gap: 10px;
            justify-content: center;
            margin-bottom: 25px;
            flex-wrap: wrap;
          }

          .preset-btn {
            padding: 10px 20px;
            border: 2px solid #e0e0e0;
            background: white;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
            color: #666;
          }

          .preset-btn:hover {
            border-color: #d70018;
            color: #d70018;
            background: #fff5f5;
            transform: translateY(-2px);
          }

          .preset-btn:active {
            transform: translateY(0);
          }

          .percentage-slider {
            margin-top: 20px;
          }

          .slider-input {
            width: 100%;
            height: 8px;
            border-radius: 4px;
            outline: none;
            -webkit-appearance: none;
            appearance: none;
            background: linear-gradient(to right, #d70018 0%, #ff6b6b 100%);
            cursor: pointer;
          }

          .slider-input::-webkit-slider-thumb {
            -webkit-appearance: none;
            appearance: none;
            width: 24px;
            height: 24px;
            border-radius: 50%;
            background: white;
            border: 3px solid #d70018;
            cursor: pointer;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.2);
            transition: transform 0.2s;
          }

          .slider-input::-webkit-slider-thumb:hover {
            transform: scale(1.2);
          }

          .slider-input::-moz-range-thumb {
            width: 24px;
            height: 24px;
            border-radius: 50%;
            background: white;
            border: 3px solid #d70018;
            cursor: pointer;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.2);
          }

          .slider-labels {
            display: flex;
            justify-content: space-between;
            margin-top: 8px;
            font-size: 12px;
            color: #999;
          }

          .deal-modal-footer {
            padding: 20px 25px;
            background: #f8f9fa;
            display: flex;
            gap: 12px;
            justify-content: flex-end;
          }

          .btn-cancel,
          .btn-confirm {
            padding: 12px 30px;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
          }

          .btn-cancel {
            background: #e0e0e0;
            color: #666;
          }

          .btn-cancel:hover {
            background: #d0d0d0;
          }

          .btn-confirm {
            background: linear-gradient(135deg, #d70018 0%, #ff6b6b 100%);
            color: white;
            box-shadow: 0 4px 12px rgba(215, 0, 24, 0.3);
          }

          .btn-confirm:hover {
            box-shadow: 0 6px 16px rgba(215, 0, 24, 0.4);
            transform: translateY(-2px);
          }

          .btn-confirm:active {
            transform: translateY(0);
          }

          /* Mobile responsive */
          @media (max-width: 576px) {
            .deal-modal-content {
              width: 95%;
              margin: 10px;
            }

            .percentage-input {
              width: 100px;
              font-size: 36px;
              padding: 10px;
            }

            .percentage-symbol {
              font-size: 28px;
            }

            .preset-btn {
              padding: 8px 16px;
              font-size: 14px;
            }

            .deal-modal-footer {
              flex-direction: column;
            }

            .btn-cancel,
            .btn-confirm {
              width: 100%;
            }
          }
        </style>
    </body>

    </html>
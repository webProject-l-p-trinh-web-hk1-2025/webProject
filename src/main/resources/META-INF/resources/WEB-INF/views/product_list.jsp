<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>Danh sách sản phẩm</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
  <style>
    .thumb { width: 70px; height: 70px; object-fit: cover; border-radius: 8px; border: 1px solid #ddd; }
  </style>
</head>
<body class="bg-light">

<div class="container py-4">
  <div class="d-flex justify-content-between align-items-center mb-3">
    <h3 class="m-0">📱 Danh sách sản phẩm</h3>
    <div>
      <a href="${pageContext.request.contextPath}/admin/products/new" class="btn btn-primary btn-sm">+ Thêm sản phẩm</a>
      <button class="btn btn-outline-secondary btn-sm ms-1" id="showAllBtn">Hiển thị tất cả</button>
    </div>
  </div>

  <!-- Bộ lọc -->
  <div class="row g-2 align-items-end mb-3">
    <div class="col-md-2">
      <select id="brand" class="form-select">
        <option value="">-- Tất cả hãng --</option>
      </select>
    </div>
    <div class="col-md-3 position-relative">
      <input id="name" class="form-control" placeholder="Tìm theo tên (VD: iP)" type="text" autocomplete="off">
      <!-- suggestion dropdown (custom typeahead) -->
      <div id="suggestions" class="list-group position-absolute" style="z-index:1200; width:100%; display:none; max-height:320px; overflow:auto;"></div>
    </div>
    <div class="col-md-2">
      <input id="minPrice" class="form-control" placeholder="Giá từ" type="number">
    </div>
    <div class="col-md-2">
      <input id="maxPrice" class="form-control" placeholder="Giá đến" type="number">
    </div>
    <div class="col-md-2">
      <select id="sort" class="form-select form-select-sm">
        <option value="createdAt,desc">Mới nhất</option>
        <option value="price,asc">Giá: thấp → cao</option>
        <option value="price,desc">Giá: cao → thấp</option>
      </select>
    </div>
    <div class="col-md-1 text-end">
      <button id="searchBtn" class="btn btn-primary">Tìm</button>
    </div>
  </div>

  <!-- Bảng sản phẩm -->
  <table class="table table-striped table-bordered align-middle">
    <thead class="table-light">
      <tr class="text-center">
        <th style="width:80px;">Ảnh</th>
        <th>Tên</th>
        <th>Hãng</th>
        <th>Giá</th>
        <th>Tồn</th>
        <th>Ngày tạo</th>
        <th style="width:180px;">Thao tác</th>
      </tr>
    </thead>
    <tbody id="tbody"></tbody>
  </table>

  <div id="status" class="text-muted text-center py-2"></div>
  <nav aria-label="Page navigation">
    <ul id="pagination" class="pagination justify-content-center"></ul>
  </nav>
</div>

<!-- ========== SCRIPT ========== -->
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<script>
const ctx = '${ctx}';
const api = ctx + "/api/products";

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
  let start = Math.max(0, current - Math.floor(maxButtons/2));
  let end = Math.min(totalPages - 1, start + maxButtons - 1);
  if (end - start + 1 < maxButtons) start = Math.max(0, end - maxButtons + 1);

  for (let i = start; i <= end; i++) {
    container.appendChild(makePageItem((i+1).toString(), i, false, i === current));
  }

  // Next
  container.appendChild(makePageItem('Next', Math.min(totalPages-1, current + 1), current >= totalPages-1, false));
}

function render(list) {
  const tbody = document.getElementById("tbody");
  tbody.innerHTML = list.map(function(p) {
    var imgSrc = ctx + (p.imageUrl || '/images/no-image.png');
    var name = p.name || '';
    var brand = p.brand || '';
    var price = p.price != null ? p.price.toLocaleString('vi-VN') + ' ₫' : '';
    var stock = p.stock != null ? p.stock : '';
    var createdAt = p.createdAt ? new Date(p.createdAt).toLocaleDateString('vi-VN') : '';
    return (
      '<tr>' +
      '<td class="text-center"><img src="' + imgSrc + '" class="thumb"></td>' +
      '<td>' + name + '</td>' +
      '<td>' + brand + '</td>' +
      '<td class="text-end">' + price + '</td>' +
      '<td class="text-center">' + stock + '</td>' +
      '<td class="text-center">' + createdAt + '</td>' +
      '<td class="text-center">' +
      '<a href="' + ctx + '/product_detail?id=' + p.id + '" class="btn btn-sm btn-outline-secondary me-1">Xem</a>' +
      '<a href="' + ctx + '/admin/products/edit/' + p.id + '" class="btn btn-sm btn-outline-primary me-1">Sửa</a>' +
      '<button class="btn btn-sm btn-outline-danger" onclick="deleteProduct(' + p.id + ')">Xóa</button>' +
      '</td>' +
      '</tr>'
    );
  }).join("");
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
    const oldCandidates = ['oldPrice','listPrice','originalPrice','previousPrice','comparePrice','retailPrice'];
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
</body>
</html>

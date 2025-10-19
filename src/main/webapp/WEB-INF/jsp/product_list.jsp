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
    <div class="col-md-3">
      <select id="brand" class="form-select">
        <option value="">-- Tất cả hãng --</option>
      </select>
    </div>
    <div class="col-md-2">
      <input id="minPrice" class="form-control" placeholder="Giá từ" type="number">
    </div>
    <div class="col-md-2">
      <input id="maxPrice" class="form-control" placeholder="Giá đến" type="number">
    </div>
    <div class="col-md-3">
      <select id="sort" class="form-select form-select-sm">
        <option value="createdAt,desc">Mới nhất</option>
        <option value="price,asc">Giá: thấp → cao</option>
        <option value="price,desc">Giá: cao → thấp</option>
      </select>
    </div>
    <div class="col-md-2 text-end">
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
</div>

<!-- ========== SCRIPT ========== -->
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<script>
const ctx = '${ctx}';
const api = ctx + "/api/products";

async function search() {
  const tbody = document.getElementById("tbody");
  const status = document.getElementById("status");
  tbody.innerHTML = "";
  status.textContent = "Đang tải dữ liệu...";

  const brand = document.getElementById('brand').value;
  const minPrice = document.getElementById('minPrice').value;
  const maxPrice = document.getElementById('maxPrice').value;
  const sort = document.getElementById('sort').value;

  const params = new URLSearchParams({ page: 0, size: 100, sort });
  if (brand) params.append('brand', brand);
  if (minPrice) params.append('minPrice', minPrice);
  if (maxPrice) params.append('maxPrice', maxPrice);

  try {
    const res = await fetch(api + '/search?' + params.toString());
    if (!res.ok) throw new Error(res.status);
    const data = await res.json();
    const list = data.content || [];
    render(list);
    populateBrands(list);
    status.textContent = list.length ? "" : "Không có sản phẩm phù hợp.";
  } catch (e) {
    console.error(e);
    status.textContent = "Lỗi tải danh sách sản phẩm.";
  }
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
  const brands = [...new Set(list.map(p => p.brand))].filter(Boolean).sort();
  const select = document.getElementById('brand');
  if (select.options.length === 1) {
    brands.forEach(b => select.append(new Option(b, b)));
  }
}

async function deleteProduct(id) {
  if (!confirm('Xóa sản phẩm #' + id + '?')) return;
  const res = await fetch(api + '/' + id, { method: "DELETE" });
  if (res.ok) {
    alert("Đã xóa sản phẩm thành công!");
    search();
  } else {
    alert("Lỗi xóa sản phẩm.");
  }
}

document.getElementById('searchBtn').onclick = search;
document.getElementById('showAllBtn').onclick = search;
search();
</script>
</body>
</html>

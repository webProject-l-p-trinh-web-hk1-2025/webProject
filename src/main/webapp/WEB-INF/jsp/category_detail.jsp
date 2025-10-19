<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Chi tiết danh mục</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet"/>
  <style>
    .thumb { width:70px; height:70px; object-fit:cover; border-radius:8px; border:1px solid #ddd; }
  </style>
</head>
<body class="bg-light">
<div class="container py-4">
  <div class="d-flex justify-content-between align-items-center mb-4">
    <h3 class="m-0">
      <i class="bi bi-folder2-open"></i> Chi tiết danh mục
    </h3>
    <a href="${pageContext.request.contextPath}/admin/categories" class="text-decoration-none">
      <i class="bi bi-arrow-left"></i> Quay lại danh sách
    </a>
  </div>

  <div class="row g-4">
    <div class="col-md-4">
      <div class="card">
        <div class="card-body">
          <h5 id="name" class="card-title"></h5>
          <p id="description" class="text-muted mb-4"></p>
          <div class="d-flex gap-2">
            <a id="editBtn" class="btn btn-outline-primary">
              <i class="bi bi-pencil"></i> Sửa
            </a>
            <button onclick="deleteCategory()" class="btn btn-outline-danger">
              <i class="bi bi-trash"></i> Xóa
            </button>
          </div>
        </div>
      </div>
    </div>

    <div class="col-md-8">
      <div class="card">
        <div class="card-header d-flex justify-content-between align-items-center">
          <h6 class="card-title m-0">Sản phẩm trong danh mục</h6>
          <span id="productCount" class="badge bg-primary"></span>
        </div>
        <div class="table-responsive">
          <table class="table table-hover align-middle mb-0">
            <thead class="table-light">
              <tr>
                <th>Sản phẩm</th>
                <th class="text-end">Giá</th>
                <th class="text-center">Tồn kho</th>
                <th></th>
              </tr>
            </thead>
            <tbody id="productList">
              <tr><td colspan="4" class="text-center py-3 text-muted">Đang tải...</td></tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </div>
</div>

<script>
const ctx = "<%=request.getContextPath()%>";
const api = ctx + '/api/categories';

// Get category ID from URL
const params = new URLSearchParams(location.search);
const id = params.get('id');
if (!id) {
  document.getElementById('name').textContent = 'Không tìm thấy danh mục';
  document.getElementById('productList').innerHTML = '<tr><td colspan="4" class="text-center py-3 text-muted">Không có dữ liệu</td></tr>';
} else {
  // Load category details
  Promise.all([
    fetch(api + '/' + id).then(r => r.json()),
    fetch(ctx + '/api/products').then(r => r.json())
  ])
  .then(([category, allProducts]) => {
    // Update category info
    document.getElementById('name').textContent = category.name || '';
    document.getElementById('description').textContent = category.description || 'Không có mô tả';
    document.getElementById('editBtn').href = ctx + '/admin/categories/edit/' + category.id;
    document.title = category.name + ' - Chi tiết danh mục';

    // Filter products by category
    const products = allProducts.filter(p => p.category && p.category.id === category.id);
    document.getElementById('productCount').textContent = products.length + ' sản phẩm';

    // Render products
    const tbody = document.getElementById('productList');
    if (products.length === 0) {
      tbody.innerHTML = '<tr><td colspan="4" class="text-center py-3 text-muted">Chưa có sản phẩm nào trong danh mục này</td></tr>';
    } else {
      tbody.innerHTML = products.map(p => `
        <tr>
          <td>
            <div class="d-flex align-items-center gap-2">
              <img src="${ctx}${p.imageUrl || '/images/no-image.png'}" class="thumb">
              <div>
                <div class="fw-medium">${p.name}</div>
                <small class="text-muted">${p.brand}</small>
              </div>
            </div>
          </td>
          <td class="text-end fw-medium">${formatPrice(p.price)}</td>
          <td class="text-center">${p.stock}</td>
          <td class="text-end">
            <a href="${ctx}/product_detail?id=${p.id}" class="btn btn-sm btn-outline-secondary">
              <i class="bi bi-eye"></i>
            </a>
          </td>
        </tr>
      `).join('');
    }
  })
  .catch(e => {
    console.error(e);
    document.getElementById('name').textContent = 'Lỗi tải dữ liệu';
    document.getElementById('description').textContent = 'Vui lòng thử lại sau';
    document.getElementById('productList').innerHTML = '<tr><td colspan="4" class="text-center py-3 text-danger">Lỗi tải dữ liệu</td></tr>';
  });
}

function formatPrice(price) {
  return price ? Number(price).toLocaleString('vi-VN', {style:'currency', currency:'VND'}) : '';
}

async function deleteCategory() {
  if (!confirm('Bạn có chắc muốn xóa danh mục này? Tất cả sản phẩm sẽ bị xóa danh mục.')) return;
  try {
    const res = await fetch(api + '/' + id, { method: 'DELETE' });
    if (res.ok) {
      alert('Đã xóa danh mục thành công!');
      location.href = ctx + '/admin/categories';
    } else {
      alert('Không thể xóa danh mục (HTTP ' + res.status + ')');
    }
  } catch (e) {
    console.error(e);
    alert('Lỗi khi xóa danh mục');
  }
}
</script>
</body>
</html>
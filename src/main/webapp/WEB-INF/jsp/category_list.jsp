<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Danh sách danh mục</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet"/>
</head>
<body class="bg-light">
<div class="container py-4">
  <div class="d-flex justify-content-between align-items-center mb-3">
    <h3 class="m-0">📂 Danh sách danh mục</h3>
    <div>
      <a href="${pageContext.request.contextPath}/product_list" class="btn btn-outline-secondary btn-sm me-2">
        <i class="bi bi-phone"></i> Sản phẩm
      </a>
      <a href="${pageContext.request.contextPath}/admin/categories/new" class="btn btn-primary btn-sm">
        <i class="bi bi-plus-lg"></i> Thêm danh mục
      </a>
    </div>
  </div>

  <div class="card">
    <div class="card-body p-0">
      <div id="status" class="text-muted p-3 text-center">Đang tải danh mục...</div>
      <table class="table table-hover align-middle mb-0">
        <thead class="table-light">
          <tr>
            <th class="text-center" style="width:60px;">#</th>
            <th>Tên danh mục</th>
            <th>Mô tả</th>
            <th class="text-center" style="width:100px;">Số SP</th>
            <th class="text-center" style="width:160px;">Thao tác</th>
          </tr>
        </thead>
        <tbody id="tbody"></tbody>
      </table>
    </div>
  </div>
</div>

<script>
const ctx = "<%=request.getContextPath()%>";
const api = ctx + '/api/categories';

async function loadCategories() {
  const tbody = document.getElementById('tbody');
  const status = document.getElementById('status');
  tbody.innerHTML = '';
  status.textContent = 'Đang tải danh mục...';
  try {
    const res = await fetch(api);
    if (!res.ok) throw new Error('HTTP ' + res.status);
    const list = await res.json();
    if (Array.isArray(list) && list.length > 0) {
      status.textContent = '';
      render(list);
    } else {
      status.textContent = 'Không có danh mục.';
    }
  } catch (e) {
    console.error(e);
    status.textContent = 'Lỗi khi tải danh mục.';
  }
}

function render(list) {
  const tbody = document.getElementById('tbody');
  tbody.innerHTML = '';
  
  // First load product counts
  fetch(ctx + '/api/products')
    .then(r => r.json())
    .then(products => {
      const counts = {};
      products.forEach(p => {
        if (p.category) {
          counts[p.category.id] = (counts[p.category.id] || 0) + 1;
        }
      });
      
      // Then render categories with counts
      list.forEach((c, idx) => {
        const tr = document.createElement('tr');
        const cid = (c.id != null ? c.id : '');
        const cname = (c.name != null ? c.name : '');
        const cdesc = (c.description != null ? c.description : '');
        const count = counts[cid] || 0;
        
        tr.innerHTML =
          '<td class="text-center">' + (idx+1) + '</td>' +
          '<td><strong>' + cname + '</strong></td>' +
          '<td class="text-muted">' + cdesc + '</td>' +
          '<td class="text-center">' +
            '<span class="badge bg-info">' + count + '</span>' +
          '</td>' +
          '<td class="text-center">' +
            '<a href="' + ctx + '/admin/categories/edit/' + cid + '" class="btn btn-sm btn-outline-primary me-1" title="Sửa">' +
              '<i class="bi bi-pencil"></i>' +
            '</a>' +
            '<button class="btn btn-sm btn-outline-danger" onclick="deleteCategory(' + cid + ')" title="Xóa">' +
              '<i class="bi bi-trash"></i>' +
            '</button>' +
          '</td>';
        tbody.appendChild(tr);
      });
    });
}

async function deleteCategory(id) {
  if (!confirm('Bạn có chắc muốn xóa danh mục #' + id + ' ?')) return;
  try {
    const res = await fetch(api + '/' + id, { method: 'DELETE' });
    if (res.ok) {
      alert('Đã xóa danh mục!');
      loadCategories();
    } else {
      alert('Không thể xóa danh mục (HTTP ' + res.status + ')');
    }
  } catch (e) {
    console.error(e);
    alert('Lỗi khi xóa danh mục');
  }
}

loadCategories();
</script>
</body>
</html>
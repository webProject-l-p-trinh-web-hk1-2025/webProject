<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
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

    .btn-edit {
      background-color: #ffc107;
      color: #000;
    }

    .btn-delete {
      background-color: #dc3545;
      color: white;
    }
  </style>
</head>

<body>
  <div class="app-layout">
    <!-- Sidebar -->
    <div class="quixnav sidebar" id="sidebar">
      <div class="quixnav-scroll">
        <button id="navToggle" class="nav-toggle-btn" title="Toggle sidebar">☰</button>
        <ul class="metismenu" id="menu">
          <li>
            <a href="${pageContext.request.contextPath}/admin"><i class="icon icon-home"></i><span class="nav-text">Dashboard</span></a>
          </li>
          <li>
            <a href="${pageContext.request.contextPath}/admin/users"><i class="fas fa-users"></i><span class="nav-text">Users</span></a>
          </li>
          <li class="active">
            <a href="${pageContext.request.contextPath}/admin/products"><i class="fas fa-box"></i><span class="nav-text">Products</span></a>
          </li>
          <li>
            <a href="${pageContext.request.contextPath}/admin/categories"><i class="fas fa-tag"></i><span class="nav-text">Categories</span></a>
          </li>
          <li>
            <a href="${pageContext.request.contextPath}/admin/document"><i class="fas fa-file-alt"></i><span class="nav-text">Documents</span></a>
          </li>
          <li>
            <a href="${pageContext.request.contextPath}/admin/chat" style="position: relative;">
              <i class="fas fa-comments"></i>
              <span class="nav-text">Chat</span>
              <span id="chat-notification-badge" style="display:none; position:absolute; top:8px; right:12px; background:#e53935; color:white; border-radius:50%; padding:2px 6px; font-size:10px; min-width:18px; text-align:center;"></span>
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
            <button class="btn btn-outline" onclick="window.location.href='${pageContext.request.contextPath}/admin/products?page=0&size=10&sort=id,asc'">
              <i class="fas fa-list"></i> Hiển thị tất cả
            </button>
          </div>
        </div>

        <!-- Bộ lọc -->
        <div class="filter-container">
          <div class="filter-group">
            <label>Hãng</label>
            <input id="brand" class="filter-input" placeholder="Tìm theo hãng" type="text" value="${filterBrand}">
          </div>
          <div class="filter-group">
            <label>Tên sản phẩm</label>
            <input id="name" class="filter-input" placeholder="Tìm theo tên" type="text" value="${filterName}">
          </div>
          <div class="filter-group">
            <label>Giá từ</label>
            <input id="minPrice" class="filter-input" placeholder="Giá từ" type="number" value="${filterMinPrice}">
          </div>
          <div class="filter-group">
            <label>Giá đến</label>
            <input id="maxPrice" class="filter-input" placeholder="Giá đến" type="number" value="${filterMaxPrice}">
          </div>
          <div class="filter-group">
            <label>Sắp xếp</label>
            <select id="sort" class="filter-input">
              <option value="id,asc" ${filterSort == 'id,asc' ? 'selected' : ''}>ID: Thấp → Cao</option>
              <option value="id,desc" ${filterSort == 'id,desc' ? 'selected' : ''}>ID: Cao → Thấp</option>
              <option value="price,asc" ${filterSort == 'price,asc' ? 'selected' : ''}>Giá: Thấp → Cao</option>
              <option value="price,desc" ${filterSort == 'price,desc' ? 'selected' : ''}>Giá: Cao → Thấp</option>
            </select>
          </div>
          <div class="filter-group" style="justify-content: flex-end;">
            <button id="searchBtn" class="btn btn-primary" style="margin-top: auto;" onclick="applyFilters()">
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
                  <th style="width:250px;">Thao tác</th>
                </tr>
              </thead>
              <tbody>
                <c:forEach var="product" items="${products.content}">
                  <tr>
                    <td class="text-center">
                      <img src="${pageContext.request.contextPath}${product.imageUrl}" class="thumb" alt="${product.name}">
                    </td>
                    <td>${product.name}</td>
                    <td>${product.brand}</td>
                    <td class="text-end">${product.price} ₫</td>
                    <td class="text-center">${product.stock}</td>
                    <td>
                      <a href="${pageContext.request.contextPath}/product/${product.id}" class="btn btn-view" title="Xem"><i class="fas fa-eye"></i></a>
                      <a href="${pageContext.request.contextPath}/admin/products/edit/${product.id}" class="btn btn-edit" title="Sửa"><i class="fas fa-edit"></i></a>
                      <form action="${pageContext.request.contextPath}/admin/products/${product.id}/delete" method="post" style="display:inline;" onsubmit="return confirm('Bạn có chắc muốn xóa sản phẩm này?');">
                        <button type="submit" class="btn btn-delete" title="Xóa"><i class="fas fa-trash"></i></button>
                      </form>
                    </td>
                  </tr>
                </c:forEach>
              </tbody>
            </table>
            
            <!-- Pagination -->
            <c:set var="page" value="${products}" scope="request"/>
            <c:set var="additionalParams" value="${filterBrand != null ? '&brand='.concat(filterBrand) : ''}${filterName != null ? '&name='.concat(filterName) : ''}${filterMinPrice != null ? '&minPrice='.concat(filterMinPrice) : ''}${filterMaxPrice != null ? '&maxPrice='.concat(filterMaxPrice) : ''}${filterSort != null ? '&sort='.concat(filterSort) : ''}" scope="request"/>
            <jsp:include page="/common/pagination.jsp"/>
          </div>
        </div>
      </div>
    </div>
  </div>

  <!-- WebSocket libraries for chat notifications -->
  <script src="https://cdn.jsdelivr.net/npm/sockjs-client@1.5.0/dist/sockjs.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/stompjs@2.3.3/lib/stomp.min.js"></script>
  <script src="<c:url value='/js/admin-chat-notifications.js'/>"></script>

  <script>
    // Toggle sidebar
    const navToggle = document.getElementById("navToggle");
    const sidebar = document.getElementById("sidebar");

    if (navToggle) {
      navToggle.addEventListener("click", function () {
        sidebar.classList.toggle("collapsed");
      });
    }

    // Filter functionality
    function applyFilters() {
      const brand = document.getElementById('brand').value.trim();
      const name = document.getElementById('name').value.trim();
      const minPrice = document.getElementById('minPrice').value.trim();
      const maxPrice = document.getElementById('maxPrice').value.trim();
      const sort = document.getElementById('sort').value;
      
      const url = new URL(window.location);
      url.searchParams.set('page', '0'); // Reset to first page
      url.searchParams.set('size', url.searchParams.get('size') || '10');
      
      if (brand) url.searchParams.set('brand', brand);
      else url.searchParams.delete('brand');
      
      if (name) url.searchParams.set('name', name);
      else url.searchParams.delete('name');
      
      if (minPrice) url.searchParams.set('minPrice', minPrice);
      else url.searchParams.delete('minPrice');
      
      if (maxPrice) url.searchParams.set('maxPrice', maxPrice);
      else url.searchParams.delete('maxPrice');
      
      url.searchParams.set('sort', sort);
      
      window.location.href = url.toString();
    }
    
    // Enter key to search
    ['brand', 'name', 'minPrice', 'maxPrice'].forEach(id => {
      const el = document.getElementById(id);
      if (el) {
        el.addEventListener('keypress', function(e) {
          if (e.key === 'Enter') {
            applyFilters();
          }
        });
      }
    });
  </script>
</body>
</html>

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
  <title>Thêm sản phẩm mới</title>
  <meta name="viewport" content="width=device-width,initial-scale=1" />
  <link rel="stylesheet" href="<c:url value='/css/admin-dashboard.css'/>" />
  <link rel="stylesheet" href="<c:url value='/css/products_admin.css'/>" />
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" />
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
            <a href="${pageContext.request.contextPath}/admin/dashboard"><i class="icon icon-home"></i><span class="nav-text">Dashboard</span></a>
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
            <a href="${pageContext.request.contextPath}/admin/chat"><i class="fas fa-comments"></i><span class="nav-text">Chat</span></a>
          </li>
        </ul>
      </div>
    </div>

    <div class="main-content">
      <div class="container">
        <div class="page-title">
          <h2><i class="fas fa-plus-circle"></i> Thêm sản phẩm mới</h2>
          <a href="${pageContext.request.contextPath}/admin/products" class="btn btn-outline">
            <i class="fas fa-arrow-left"></i> Quay lại danh sách
          </a>
        </div>
        
        <div class="card">
          <div class="card-header">
            <div class="card-title">Thông tin sản phẩm</div>
          </div>
          <div class="card-body">
            <form id="createForm" class="form-container">
    <div class="form-group">
      <div class="form-control">
        <label>Tên sản phẩm*</label>
        <input name="name" required>
      </div>
      <div class="form-control">
        <label>Hãng*</label>
        <input name="brand" required>
      </div>
    </div>
    
    <div class="form-group">
      <div class="form-control">
        <label>Giá*</label>
        <input name="price" type="number" step="0.01" required>
      </div>
      <div class="form-control">
        <label>Tồn kho*</label>
        <input name="stock" type="number" required>
      </div>
      <div class="form-control">
        <label>Danh mục*</label>
        <select name="categoryId" required></select>
      </div>
    </div>
    <hr>
    <h5>Thông số kỹ thuật (tùy chọn)</h5>
    <div class="specs-container">
      <div class="form-group">
        <div class="form-control">
          <label>Screen size</label>
          <input name="screenSize">
        </div>
        <div class="form-control">
          <label>Display tech</label>
          <input name="displayTech">
        </div>
        <div class="form-control">
          <label>Resolution</label>
          <input name="resolution">
        </div>
        <div class="form-control">
          <label>Display features</label>
          <input name="displayFeatures">
        </div>
      </div>
      
      <div class="form-group">
        <div class="form-control">
          <label>Rear camera</label>
          <input name="rearCamera">
        </div>
        <div class="form-control">
          <label>Front camera</label>
          <input name="frontCamera">
        </div>
        <div class="form-control">
          <label>Chipset</label>
          <input name="chipset">
        </div>
        <div class="form-control">
          <label>CPU specs</label>
          <input name="cpuSpecs">
        </div>
      </div>
      
      <div class="form-group">
        <div class="form-control">
          <label>RAM</label>
          <input name="ram">
        </div>
        <div class="form-control">
          <label>Storage</label>
          <input name="storage">
        </div>
        <div class="form-control">
          <label>Battery</label>
          <input name="battery">
        </div>
        <div class="form-control">
          <label>SIM type</label>
          <input name="simType">
        </div>
      </div>
      
      <div class="form-group">
        <div class="form-control">
          <label>OS</label>
          <input name="os">
        </div>
        <div class="form-control">
          <label>NFC support</label>
          <input name="nfcSupport">
        </div>
      </div>
    </div>
    <div class="form-group">
      <div class="form-control">
        <label>Ảnh sản phẩm (có thể chọn nhiều ảnh)</label>
        <input type="file" id="imagesInputCreate" name="image" accept="image/*" multiple>
      </div>
    </div>
    
    <div class="form-actions">
      <button class="btn primary-btn" type="submit">Lưu sản phẩm</button>
    </div>
    <a href="${pageContext.request.contextPath}/product_list" class="btn btn-outline-secondary">Hủy</a>
  </form>
</div>

<script>
const ctx = "${pageContext.request.contextPath}";

// Load danh mục
(async () => {
  const sel = document.querySelector('select[name="categoryId"]');
  const res = await fetch(ctx + '/api/categories');
  const cats = await res.json();
  cats.forEach(c => sel.append(new Option(c.name, c.id)));
})();

document.getElementById("createForm").addEventListener("submit", async e => {
  e.preventDefault();
  const f = e.target;
  const data = {
    name: f.name.value,
    brand: f.brand.value,
    price: parseFloat(f.price.value),
    stock: parseInt(f.stock.value),
    categoryId: parseInt(f.categoryId.value),
    // specs fields
    screenSize: f.screenSize?.value || null,
    displayTech: f.displayTech?.value || null,
    resolution: f.resolution?.value || null,
    displayFeatures: f.displayFeatures?.value || null,
    rearCamera: f.rearCamera?.value || null,
    frontCamera: f.frontCamera?.value || null,
    chipset: f.chipset?.value || null,
    cpuSpecs: f.cpuSpecs?.value || null,
    ram: f.ram?.value || null,
    storage: f.storage?.value || null,
    battery: f.battery?.value || null,
    simType: f.simType?.value || null,
    os: f.os?.value || null,
    nfcSupport: f.nfcSupport?.value || null
  };
  const res = await fetch(ctx + '/api/products', {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(data)
  });
  if (!res.ok) return alert("Lỗi tạo sản phẩm!");
  const p = await res.json();

  const imgs = document.getElementById('imagesInputCreate').files;
  if (imgs && imgs.length > 0) {
    const fd = new FormData();
    for (let i = 0; i < imgs.length; i++) fd.append('images', imgs[i]);
    await fetch(ctx + '/api/products/' + p.id + '/images', { method: 'POST', body: fd });
  }
  alert("Thêm sản phẩm thành công!");
  location.href = ctx + '/product_list';
});
</script>
</body>
</html>

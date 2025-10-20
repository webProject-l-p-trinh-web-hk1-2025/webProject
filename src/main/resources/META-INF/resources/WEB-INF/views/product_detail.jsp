<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Chi tiết sản phẩm</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
  <style>
    .product-image { max-width: 250px; max-height: 250px; border-radius: 8px; border: 1px solid #ccc; object-fit: contain; }
    .spec-label { color: #6c757d; font-weight: 500; }
    .price-tag { font-size: 1.5rem; font-weight: 600; color: #dc3545; }
  </style>
</head>
<body class="bg-light">
<div class="container py-4" style="max-width:900px;">
  <div id="alertBox" class="alert alert-danger d-none"></div>
  <nav aria-label="breadcrumb">
    <ol class="breadcrumb">
      <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/product_list">Sản phẩm</a></li>
      <li class="breadcrumb-item active">Chi tiết</li>
    </ol>
  </nav>

  <div id="productCard" class="card d-none">
    <div class="card-body">
      <div class="row g-4">
        <div class="col-md-4 text-center">
          <img id="image" class="product-image" src="">
          <div id="thumbs" class="d-flex flex-wrap justify-content-center gap-2 mt-2"></div>
        </div>
        <div class="col-md-8">
          <h3 id="name"></h3>
          <div class="mb-2"><span class="badge bg-primary" id="brand"></span> <span class="badge bg-info" id="category"></span></div>
          <div id="price" class="price-tag mb-3"></div>
          <div><strong>Tồn kho:</strong> <span id="stock"></span></div>
          <div><strong>Ngày tạo:</strong> <span id="createdAt"></span></div>
          <a id="editBtn" class="btn btn-outline-primary mt-3" href="#"><i class="bi bi-pencil-square me-1"></i>Sửa</a>
        </div>
      </div>
    </div>
  </div>

  <div id="specsCard" class="card mt-3 d-none">
    <div class="card-header"><h5 class="mb-0">Thông số kỹ thuật</h5></div>
    <div class="card-body">
      <dl class="row mb-0" id="specList"></dl>
    </div>
  </div>
</div>

<script>
const ctx = "${pageContext.request.contextPath}";
const id = new URLSearchParams(window.location.search).get("id");
const api = ctx + '/api/products/' + id;

(async function load() {
  try {
    const res = await fetch(api);
    if (!res.ok) throw new Error("Không tìm thấy sản phẩm");
    const p = await res.json();
    document.getElementById("productCard").classList.remove("d-none");
    fill(p);
  } catch (e) {
    showError(e.message);
  }
})();

function showError(msg) {
  const a = document.getElementById("alertBox");
  a.textContent = msg;
  a.classList.remove("d-none");
}

function fill(p) {
  document.getElementById("name").textContent = p.name;
  document.getElementById("brand").textContent = p.brand;
  document.getElementById("category").textContent = p.category?.name || "Chưa phân loại";
  document.getElementById("price").textContent = p.price?.toLocaleString('vi-VN') + " ₫";
  document.getElementById("stock").textContent = p.stock;
  document.getElementById("createdAt").textContent = new Date(p.createdAt).toLocaleDateString('vi-VN');
  document.getElementById("image").src = p.imageUrl ? ctx + p.imageUrl : ctx + "/images/no-image.png";

  // if there are multiple images, render thumbnails and allow switching
  const thumbs = document.getElementById('thumbs');
  const imgs = p.imageUrls && p.imageUrls.length ? p.imageUrls : (p.imageUrl ? [p.imageUrl] : []);
  if (imgs.length > 0) {
    thumbs.innerHTML = '';
    imgs.forEach((u, i) => {
      // u may be a string url or an object {id, url}
      const idVal = typeof u === 'string' ? null : u.id;
      const url = typeof u === 'string' ? u : u.url;
      const wrap = document.createElement('div');
      wrap.style.position = 'relative';
      const imgEl = document.createElement('img');
      imgEl.src = url.startsWith('/') ? ctx + url : url;
      imgEl.className = 'product-image';
      imgEl.style.maxWidth = '60px';
      imgEl.style.maxHeight = '60px';
      imgEl.style.cursor = 'pointer';
      imgEl.addEventListener('click', () => { document.getElementById('image').src = imgEl.src; });

      // delete button
      if (idVal) {
        const btn = document.createElement('button');
        btn.className = 'btn btn-sm btn-danger';
        btn.style.position = 'absolute';
        btn.style.top = '-6px';
        btn.style.right = '-6px';
        btn.innerHTML = '<i class="bi bi-x"></i>';
        btn.title = 'Xóa ảnh';
        btn.addEventListener('click', async (ev) => {
          ev.stopPropagation();
          if (!confirm('Bạn có chắc muốn xóa ảnh này?')) return;
          const dres = await fetch(ctx + '/api/products/images/' + idVal, { method: 'DELETE' });
          if (dres.ok) {
            // refresh product
            const newP = await (await fetch(api)).json();
            fill(newP);
          } else {
            alert('Xóa ảnh thất bại');
          }
        });
        wrap.appendChild(btn);
      }

      wrap.appendChild(imgEl);
      thumbs.appendChild(wrap);
    });
  }

  const editBtn = document.getElementById("editBtn");
  editBtn.href = ctx + '/admin/products/edit/' + p.id;

  // specs
  const specListEl = document.getElementById("specList");
  const rows = [];

  // top-level technical fields on the product
  if (p.screenSize) rows.push({ key: 'Screen size', value: p.screenSize });
  if (p.displayTech) rows.push({ key: 'Display tech', value: p.displayTech });
  if (p.resolution) rows.push({ key: 'Resolution', value: p.resolution });
  if (p.displayFeatures) rows.push({ key: 'Display features', value: p.displayFeatures });
  if (p.rearCamera) rows.push({ key: 'Rear camera', value: p.rearCamera });
  if (p.frontCamera) rows.push({ key: 'Front camera', value: p.frontCamera });
  if (p.chipset) rows.push({ key: 'Chipset', value: p.chipset });
  if (p.cpuSpecs) rows.push({ key: 'CPU specs', value: p.cpuSpecs });
  if (p.ram) rows.push({ key: 'RAM', value: p.ram });
  if (p.storage) rows.push({ key: 'Storage', value: p.storage });
  if (p.battery) rows.push({ key: 'Battery', value: p.battery });
  if (p.simType) rows.push({ key: 'SIM type', value: p.simType });
  if (p.os) rows.push({ key: 'OS', value: p.os });
  if (p.nfcSupport) rows.push({ key: 'NFC support', value: p.nfcSupport });

  // custom specs (key/value)
  const customSpecs = p.specs || [];
  customSpecs.forEach(s => {
    if (s && s.key) rows.push({ key: s.key, value: s.value });
  });

  if (rows.length > 0) {
    document.getElementById("specsCard").classList.remove("d-none");
    var html = '';
    for (var i = 0; i < rows.length; i++) {
      var r = rows[i];
      html += '<dt class="col-sm-4 spec-label">' + (r.key || '') + '</dt>';
      html += '<dd class="col-sm-8">' + (r.value || '') + '</dd>';
    }
    specListEl.innerHTML = html;
  }
}
</script>
</body>
</html>

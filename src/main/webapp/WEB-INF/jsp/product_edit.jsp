<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Chỉnh sửa sản phẩm</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
</head>
<body class="bg-light">
<div class="container py-4" style="max-width:800px;">
  <h3><i class="bi bi-pencil-square me-2"></i>Chỉnh sửa sản phẩm</h3>
  <form id="editForm">
    <input type="hidden" id="productId" value="${product.id}">
    <div class="mb-3">
      <label>Tên</label>
      <input name="name" class="form-control" value="${product.name}" required>
    </div>
    <div class="mb-3">
      <label>Hãng</label>
      <input name="brand" class="form-control" value="${product.brand}" required>
    </div>
    <div class="mb-3">
      <label>Giá</label>
      <input name="price" type="number" step="0.01" class="form-control" value="${product.price}" required>
    </div>
    <div class="mb-3">
      <label>Tồn kho</label>
      <input name="stock" type="number" class="form-control" value="${product.stock}" required>
    </div>
    <div class="mb-3">
      <label>Danh mục</label>
      <select name="categoryId" class="form-select" required></select>
    </div>

    <hr>
    <h5>Thông số kỹ thuật (tùy chọn)</h5>
    <div class="row">
      <div class="col-md-6 mb-3"><label>Screen size</label><input name="screenSize" class="form-control" value="${product.screenSize}"></div>
      <div class="col-md-6 mb-3"><label>Display tech</label><input name="displayTech" class="form-control" value="${product.displayTech}"></div>
      <div class="col-md-6 mb-3"><label>Resolution</label><input name="resolution" class="form-control" value="${product.resolution}"></div>
      <div class="col-md-6 mb-3"><label>Display features</label><input name="displayFeatures" class="form-control" value="${product.displayFeatures}"></div>
      <div class="col-md-6 mb-3"><label>Rear camera</label><input name="rearCamera" class="form-control" value="${product.rearCamera}"></div>
      <div class="col-md-6 mb-3"><label>Front camera</label><input name="frontCamera" class="form-control" value="${product.frontCamera}"></div>
      <div class="col-md-6 mb-3"><label>Chipset</label><input name="chipset" class="form-control" value="${product.chipset}"></div>
      <div class="col-md-6 mb-3"><label>CPU specs</label><input name="cpuSpecs" class="form-control" value="${product.cpuSpecs}"></div>
      <div class="col-md-6 mb-3"><label>RAM</label><input name="ram" class="form-control" value="${product.ram}"></div>
      <div class="col-md-6 mb-3"><label>Storage</label><input name="storage" class="form-control" value="${product.storage}"></div>
      <div class="col-md-6 mb-3"><label>Battery</label><input name="battery" class="form-control" value="${product.battery}"></div>
      <div class="col-md-6 mb-3"><label>SIM type</label><input name="simType" class="form-control" value="${product.simType}"></div>
      <div class="col-md-6 mb-3"><label>OS</label><input name="os" class="form-control" value="${product.os}"></div>
      <div class="col-md-6 mb-3"><label>NFC support</label><input name="nfcSupport" class="form-control" value="${product.nfcSupport}"></div>
    </div>

    <div class="mb-3">
      <label>Ảnh mới (tùy chọn)</label>
      <input type="file" name="image" accept="image/*" class="form-control">
    </div>

    <button class="btn btn-primary" type="submit">Lưu thay đổi</button>
    <a href="${pageContext.request.contextPath}/product_detail?id=${product.id}" class="btn btn-outline-secondary">Quay lại</a>
  </form>
</div>

<script>
const ctx = "${pageContext.request.contextPath}";
const id = document.getElementById("productId").value;

// Load danh mục
(async () => {
  const sel = document.querySelector('select[name="categoryId"]');
  const res = await fetch(ctx + '/api/categories');
  const cats = await res.json();
  cats.forEach(c => {
    const opt = document.createElement("option");
    opt.value = c.id;
    opt.textContent = c.name;
    if (c.id == "${product.category.id}") opt.selected = true;
    sel.append(opt);
  });
})();

// Submit update
document.getElementById("editForm").addEventListener("submit", async e => {
  e.preventDefault();
  const form = e.target;
  const formData = new FormData();
  const data = {
    name: form.name.value,
    brand: form.brand.value,
    price: parseFloat(form.price.value),
    stock: parseInt(form.stock.value),
    categoryId: parseInt(form.categoryId.value)
  };
  data.screenSize = form.screenSize?.value || null;
  data.displayTech = form.displayTech?.value || null;
  data.resolution = form.resolution?.value || null;
  data.displayFeatures = form.displayFeatures?.value || null;
  data.rearCamera = form.rearCamera?.value || null;
  data.frontCamera = form.frontCamera?.value || null;
  data.chipset = form.chipset?.value || null;
  data.cpuSpecs = form.cpuSpecs?.value || null;
  data.ram = form.ram?.value || null;
  data.storage = form.storage?.value || null;
  data.battery = form.battery?.value || null;
  data.simType = form.simType?.value || null;
  data.os = form.os?.value || null;
  data.nfcSupport = form.nfcSupport?.value || null;

  console.log('Update payload', data);
  formData.append("data", new Blob([JSON.stringify(data)], { type: "application/json" }));
  if (form.image.files.length > 0) formData.append("image", form.image.files[0]);

  try {
    const res = await fetch(ctx + '/api/products/' + id, { method: "PUT", body: formData });
    if (res.ok) {
      const body = await res.json().catch(() => null);
      console.log('Update success', body);
      alert("Cập nhật thành công!");
      location.href = ctx + '/product_detail?id=' + id;
      return;
    }

    // Read response body for debugging (JSON or text)
    let errBody;
    try { errBody = await res.json(); } catch (e) { errBody = await res.text(); }
    console.error('Update failed', res.status, errBody);
    alert('Lỗi cập nhật sản phẩm: ' + (typeof errBody === 'string' ? errBody : JSON.stringify(errBody)));
  } catch (e) {
    console.error('Network or client error during update', e);
    alert('Lỗi mạng hoặc server: ' + e.message);
  }
});
</script>
</body>
</html>

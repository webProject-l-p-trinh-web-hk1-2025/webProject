<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Thêm sản phẩm mới</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
</head>
<body class="bg-light">
<div class="container py-4" style="max-width:800px;">
  <h3><i class="bi bi-plus-circle me-2"></i>Thêm sản phẩm mới</h3>

  <form id="createForm">
    <div class="mb-3"><label>Tên sản phẩm*</label><input name="name" class="form-control" required></div>
    <div class="mb-3"><label>Hãng*</label><input name="brand" class="form-control" required></div>
    <div class="mb-3"><label>Giá*</label><input name="price" type="number" step="0.01" class="form-control" required></div>
    <div class="mb-3"><label>Tồn kho*</label><input name="stock" type="number" class="form-control" required></div>
    <div class="mb-3">
      <label>Danh mục*</label>
      <select name="categoryId" class="form-select" required></select>
    </div>
    <hr>
    <h5>Thông số kỹ thuật (tùy chọn)</h5>
    <div class="row">
      <div class="col-md-6 mb-3"><label>Screen size</label><input name="screenSize" class="form-control"></div>
      <div class="col-md-6 mb-3"><label>Display tech</label><input name="displayTech" class="form-control"></div>
      <div class="col-md-6 mb-3"><label>Resolution</label><input name="resolution" class="form-control"></div>
      <div class="col-md-6 mb-3"><label>Display features</label><input name="displayFeatures" class="form-control"></div>
      <div class="col-md-6 mb-3"><label>Rear camera</label><input name="rearCamera" class="form-control"></div>
      <div class="col-md-6 mb-3"><label>Front camera</label><input name="frontCamera" class="form-control"></div>
      <div class="col-md-6 mb-3"><label>Chipset</label><input name="chipset" class="form-control"></div>
      <div class="col-md-6 mb-3"><label>CPU specs</label><input name="cpuSpecs" class="form-control"></div>
      <div class="col-md-6 mb-3"><label>RAM</label><input name="ram" class="form-control"></div>
      <div class="col-md-6 mb-3"><label>Storage</label><input name="storage" class="form-control"></div>
      <div class="col-md-6 mb-3"><label>Battery</label><input name="battery" class="form-control"></div>
      <div class="col-md-6 mb-3"><label>SIM type</label><input name="simType" class="form-control"></div>
      <div class="col-md-6 mb-3"><label>OS</label><input name="os" class="form-control"></div>
      <div class="col-md-6 mb-3"><label>NFC support</label><input name="nfcSupport" class="form-control"></div>
    </div>
    <div class="mb-3">
      <label>Ảnh sản phẩm</label>
      <input type="file" name="image" class="form-control" accept="image/*">
    </div>
    <button class="btn btn-primary" type="submit">Lưu sản phẩm</button>
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

  const img = f.image.files[0];
  if (img) {
    const fd = new FormData();
    fd.append("image", img);
  await fetch(ctx + '/api/products/' + p.id + '/image', { method: "POST", body: fd });
  }
  alert("Thêm sản phẩm thành công!");
  location.href = ctx + '/product_list';
});
</script>
</body>
</html>

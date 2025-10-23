<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> <%@ page
contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
  <head>
    <title>Chi tiết danh mục</title>
    <meta name="viewport" content="width=device-width,initial-scale=1" />
    <link rel="stylesheet" href="<c:url value='/css/admin-dashboard.css'/>" />
    <link rel="stylesheet" href="<c:url value='/css/categories_admin.css'/>" />
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css"
    />
  </head>
  <body>
    <!-- app layout with collapsible sidebar -->
    <div class="app-layout">
      <!-- Metismenu-style sidebar -->
      <div class="quixnav sidebar" id="sidebar">
        <div class="quixnav-scroll">
          <button id="navToggle" class="nav-toggle-btn" title="Toggle sidebar">
            ☰
          </button>
          <ul class="metismenu" id="menu">
            <li>
              <a href="${pageContext.request.contextPath}/admin/dashboard"
                ><i class="icon icon-home"></i
                ><span class="nav-text">Dashboard</span></a
              >
            </li>
            <li>
              <a href="${pageContext.request.contextPath}/admin/users"
                ><i class="fas fa-users"></i
                ><span class="nav-text">Users</span></a
              >
            </li>
            <li>
              <a href="${pageContext.request.contextPath}/admin/products"
                ><i class="fas fa-box"></i
                ><span class="nav-text">Products</span></a
              >
            </li>
            <li class="active">
              <a href="${pageContext.request.contextPath}/admin/categories"
                ><i class="fas fa-tag"></i
                ><span class="nav-text">Categories</span></a
              >
            </li>
            <li>
              <a href="${pageContext.request.contextPath}/admin/chat"
                ><i class="fas fa-comments"></i
                ><span class="nav-text">Chat</span></a
              >
            </li>
          </ul>
        </div>
      </div>

      <div class="main-content">
        <div class="container">
          <div class="page-title">
            <h2><i class="fas fa-folder-open"></i> Chi tiết danh mục</h2>
            <a
              href="${pageContext.request.contextPath}/admin/categories"
              class="btn btn-outline"
            >
              <i class="fas fa-arrow-left"></i> Quay lại danh sách
            </a>
          </div>

          <div class="row">
            <div class="col-md-4">
              <div class="card">
                <div class="card-header">
                  <div class="card-title">Thông tin danh mục</div>
                </div>
                <div class="card-body">
                  <h3 id="name"></h3>
                  <p id="description" class="text-muted"></p>
                  <div class="d-flex gap-2">
                    <a id="editBtn" class="btn btn-outline-primary">
                      <i class="bi bi-pencil"></i> Sửa
                    </a>
                    <button
                      onclick="deleteCategory()"
                      class="btn btn-outline-danger"
                    >
                      <i class="bi bi-trash"></i> Xóa
                    </button>
                  </div>
                </div>
              </div>
            </div>

            <div class="col-md-8">
              <div class="card">
                <div
                  class="card-header d-flex justify-content-between align-items-center"
                >
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
                      <tr>
                        <td colspan="4" class="text-center py-3 text-muted">
                          Đang tải...
                        </td>
                      </tr>
                    </tbody>
                  </table>
                </div>
              </div>
            </div>
          </div>
        </div>

        <script>
          const ctx = "<%=request.getContextPath()%>";
          const api = ctx + "/api/categories";

          // Get category ID from URL
          const params = new URLSearchParams(location.search);
          const id = params.get("id");
          if (!id) {
            document.getElementById("name").textContent =
              "Không tìm thấy danh mục";
            document.getElementById("productList").innerHTML =
              '<tr><td colspan="4" class="text-center py-3 text-muted">Không có dữ liệu</td></tr>';
          } else {
            // Load category details
            Promise.all([
              fetch(api + "/" + id).then((r) => r.json()),
              fetch(ctx + "/api/products").then((r) => r.json()),
            ])
              .then(([category, allProducts]) => {
                // Update category info
                document.getElementById("name").textContent =
                  category.name || "";
                document.getElementById("description").textContent =
                  category.description || "Không có mô tả";
                document.getElementById("editBtn").href =
                  ctx + "/admin/categories/edit/" + category.id;
                document.title = category.name + " - Chi tiết danh mục";

                // Filter products by category
                const products = allProducts.filter(
                  (p) => p.category && p.category.id === category.id
                );
                document.getElementById("productCount").textContent =
                  products.length + " sản phẩm";

                // Render products
                const tbody = document.getElementById("productList");
                if (products.length === 0) {
                  tbody.innerHTML =
                    '<tr><td colspan="4" class="text-center py-3 text-muted">Chưa có sản phẩm nào trong danh mục này</td></tr>';
                } else {
                  tbody.innerHTML = products
                    .map(
                      (p) => `
        <tr>
          <td>
            <div class="d-flex align-items-center gap-2">
              <img src="${ctx}${
                        p.imageUrl || "/images/no-image.png"
                      }" class="thumb">
              <div>
                <div class="fw-medium">${p.name}</div>
                <small class="text-muted">${p.brand}</small>
              </div>
            </div>
          </td>
          <td class="text-end fw-medium">${formatPrice(p.price)}</td>
          <td class="text-center">${p.stock}</td>
          <td class="text-end">
            <a href="${ctx}/product_detail?id=${
                        p.id
                      }" class="btn btn-sm btn-outline-secondary">
              <i class="bi bi-eye"></i>
            </a>
          </td>
        </tr>
      `
                    )
                    .join("");
                }
              })
              .catch((e) => {
                console.error(e);
                document.getElementById("name").textContent = "Lỗi tải dữ liệu";
                document.getElementById("description").textContent =
                  "Vui lòng thử lại sau";
                document.getElementById("productList").innerHTML =
                  '<tr><td colspan="4" class="text-center py-3 text-danger">Lỗi tải dữ liệu</td></tr>';
              });
          }

          function formatPrice(price) {
            return price
              ? Number(price).toLocaleString("vi-VN", {
                  style: "currency",
                  currency: "VND",
                })
              : "";
          }

          async function deleteCategory() {
            if (
              !confirm(
                "Bạn có chắc muốn xóa danh mục này? Tất cả sản phẩm sẽ bị xóa danh mục."
              )
            )
              return;
            try {
              const res = await fetch(api + "/" + id, { method: "DELETE" });
              if (res.ok) {
                alert("Đã xóa danh mục thành công!");
                location.href = ctx + "/admin/categories";
              } else {
                alert("Không thể xóa danh mục (HTTP " + res.status + ")");
              }
            } catch (e) {
              console.error(e);
              alert("Lỗi khi xóa danh mục");
            }
          }
        </script>
        <!-- Script để toggle sidebar -->
        <script>
          document
            .getElementById("navToggle")
            .addEventListener("click", function () {
              document.getElementById("sidebar").classList.toggle("minimized");
              document
                .querySelector(".main-content")
                .classList.toggle("expanded");
            });
        </script>
      </div>
    </div>
  </body>
</html>

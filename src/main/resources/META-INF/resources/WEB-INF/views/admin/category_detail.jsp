<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> <%@ page
contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
  <head>
    <title>Chi tiết danh mục</title>
    <meta name="viewport" content="width=device-width,initial-scale=1" />
    <link rel="stylesheet" href="<c:url value='/css/admin-dashboard.css'/>" />
    <link rel="stylesheet" href="<c:url value='/css/categories_admin.css'/>" />
    <link rel="stylesheet" href="<c:url value='/css/category_detail.css'/>" />
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
              <a href="${pageContext.request.contextPath}/admin"
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
              <a href="${pageContext.request.contextPath}/admin/document"
                ><i class="fas fa-file-alt"></i
                ><span class="nav-text">Documents</span></a
              >
            </li>
            <li>
              <a
                href="${pageContext.request.contextPath}/admin/chat"
                style="position: relative"
              >
                <i class="fas fa-comments"></i>
                <span class="nav-text">Chat</span>
                <span
                  id="chat-notification-badge"
                  style="
                    display: none;
                    position: absolute;
                    top: 8px;
                    right: 12px;
                    background: #e53935;
                    color: white;
                    border-radius: 50%;
                    padding: 2px 6px;
                    font-size: 10px;
                    min-width: 18px;
                    text-align: center;
                  "
                ></span>
              </a>
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

          <div class="card" style="margin-bottom: 20px">
            <div class="card-header">
              <div class="card-title">Thông tin danh mục</div>
            </div>
            <div class="card-body">
              <h3 id="name"></h3>
              <p id="description" style="color: #6c757d"></p>
              <div style="display: flex; gap: 10px; margin-top: 15px">
                <a id="editBtn" class="btn btn-primary">
                  <i class="fas fa-edit"></i> Sửa
                </a>
                <button onclick="deleteCategory()" class="btn btn-danger">
                  <i class="fas fa-trash"></i> Xóa
                </button>
              </div>
            </div>
          </div>

          <div class="card">
            <div class="card-header">
              <div class="card-title">
                Sản phẩm trong danh mục
                <span
                  id="productCount"
                  style="
                    background: #007bff;
                    color: white;
                    padding: 2px 8px;
                    border-radius: 10px;
                    font-size: 12px;
                    margin-left: 10px;
                  "
                ></span>
              </div>
            </div>
            <div class="card-body">
              <table style="width: 100%; border-collapse: collapse">
                <thead>
                  <tr>
                    <th
                      style="
                        padding: 12px 8px;
                        border: 1px solid #ddd;
                        background: #f8f9fa;
                        text-align: left;
                      "
                    >
                      Sản phẩm
                    </th>
                    <th
                      style="
                        padding: 12px 8px;
                        border: 1px solid #ddd;
                        background: #f8f9fa;
                        text-align: right;
                      "
                    >
                      Giá
                    </th>
                    <th
                      style="
                        padding: 12px 8px;
                        border: 1px solid #ddd;
                        background: #f8f9fa;
                        text-align: center;
                      "
                    >
                      Tồn kho
                    </th>
                    <th
                      style="
                        padding: 12px 8px;
                        border: 1px solid #ddd;
                        background: #f8f9fa;
                        width: 100px;
                      "
                    ></th>
                  </tr>
                </thead>
                <tbody id="productList">
                  <tr>
                    <td
                      colspan="4"
                      style="
                        padding: 20px;
                        border: 1px solid #ddd;
                        text-align: center;
                        color: #6c757d;
                      "
                    >
                      Đang tải...
                    </td>
                  </tr>
                </tbody>
              </table>
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
                    '<tr><td colspan="4" style="padding: 20px; border: 1px solid #ddd; text-align: center; color: #6c757d;">Chưa có sản phẩm nào trong danh mục này</td></tr>';
                } else {
                  tbody.innerHTML = products
                    .map(
                      (p) => `
        <tr style="border-bottom: 1px solid #ddd;">
          <td style="padding: 12px 8px; border: 1px solid #ddd;">
            <div style="display: flex; align-items: center; gap: 10px;">
              <img src="${ctx}${p.imageUrl || "/images/no-image.png"}" 
                   style="width: 50px; height: 50px; object-fit: cover; border-radius: 4px;">
              <div>
                <div style="font-weight: 500;">${p.name}</div>
                <small style="color: #6c757d;">${p.brand}</small>
              </div>
            </div>
          </td>
          <td style="padding: 12px 8px; border: 1px solid #ddd; text-align: right; font-weight: 500;">${formatPrice(
            p.price
          )}</td>
          <td style="padding: 12px 8px; border: 1px solid #ddd; text-align: center;">${
            p.stock
          }</td>
          <td style="padding: 12px 8px; border: 1px solid #ddd; text-align: center;">
            <a href="${ctx}/product_detail?id=${
                        p.id
                      }" class="btn btn-primary" style="padding: 6px 12px; font-size: 14px;">
              <i class="fas fa-eye"></i>
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
                  '<tr><td colspan="4" style="padding: 20px; border: 1px solid #ddd; text-align: center; color: #dc3545;">Lỗi tải dữ liệu</td></tr>';
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
          (function () {
            const sidebar = document.getElementById("sidebar");
            const toggle = document.getElementById("navToggle");
            if (!sidebar || !toggle) return;

            function isCollapsed() {
              return localStorage.getItem("admin_sidebar_collapsed") === "1";
            }

            function apply() {
              const collapsed = isCollapsed();
              if (window.innerWidth <= 800) {
                sidebar.classList.toggle("open", collapsed);
                sidebar.classList.remove("collapsed");
              } else {
                sidebar.classList.toggle("collapsed", collapsed);
                sidebar.classList.remove("open");
              }
            }

            apply();
            toggle.addEventListener("click", function () {
              const current = isCollapsed();
              localStorage.setItem(
                "admin_sidebar_collapsed",
                current ? "0" : "1"
              );
              apply();
            });
            window.addEventListener("resize", apply);
          })();
        </script>

        <!-- Admin chat notification script -->
        <script src="${pageContext.request.contextPath}/js/admin-chat-notifications.js"></script>
      </div>
    </div>
  </body>
</html>

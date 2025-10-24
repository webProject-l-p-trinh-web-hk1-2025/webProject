<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> <%@ page
contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
  <head>
    <title>Danh sách danh mục</title>
    <meta name="viewport" content="width=device-width,initial-scale=1" />
    <link rel="stylesheet" href="<c:url value='/css/admin-dashboard.css'/>" />
    <link rel="stylesheet" href="<c:url value='/css/categories_admin.css'/>" />
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css"
    />
    <style>
      table {
        width: 100%;
        border-collapse: collapse;
      }
      table th,
      table td {
        padding: 12px 8px;
        border: 1px solid #ddd;
        text-align: left;
      }
      table th {
        background-color: #f8f9fa;
        font-weight: 600;
      }
      .btn {
        margin-right: 5px;
        display: inline-block;
        padding: 6px 12px;
        text-decoration: none;
        border-radius: 4px;
        border: 1px solid transparent;
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
      .text-center {
        text-align: center;
      }
    </style>
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
            <h2>Quản lý danh mục</h2>
            <div>
              <!-- <a
                href="${pageContext.request.contextPath}/admin/products"
                class="btn btn-outline"
              >
                <i class="fas fa-box"></i> Sản phẩm
              </a> -->
              <a
                href="${pageContext.request.contextPath}/admin/categories/new"
                class="btn btn-primary"
              >
                <i class="fas fa-plus"></i> Thêm danh mục
              </a>
              <button class="btn btn-outline" id="showAllBtn">
                <i class="fas fa-list"></i> Hiển thị tất cả
              </button>
            </div>
          </div>

          <!-- Bộ lọc -->
          <div class="filter-container">
            <div class="filter-group">
              <label>Tên danh mục</label>
              <input
                id="name"
                class="filter-input"
                placeholder="Tìm theo tên"
                type="text"
                autocomplete="off"
              />
              <div
                id="suggestions"
                class="position-absolute"
                style="
                  z-index: 1200;
                  width: 100%;
                  display: none;
                  max-height: 320px;
                  overflow: auto;
                "
              ></div>
            </div>
            <div class="filter-group">
              <label>Sắp xếp</label>
              <select id="sort" class="filter-input">
                <option value="createdAt,desc">Mới nhất</option>
                <option value="name,asc">Tên: A → Z</option>
                <option value="name,desc">Tên: Z → A</option>
              </select>
            </div>
          </div>

          <div class="card">
            <div class="card-header">
              <div class="card-title">Danh mục sản phẩm</div>
            </div>
            <div class="card-body">
              <div id="status" class="text-muted text-center">
                Đang tải danh mục...
              </div>
              <table>
                <thead>
                  <tr>
                    <th style="width: 60px">#</th>
                    <th>Tên danh mục</th>
                    <th>Danh mục cha</th>
                    <th>Mô tả</th>
                    <th style="width: 100px">Số SP</th>
                    <th style="width: 160px">Thao tác</th>
                  </tr>
                </thead>
                <tbody id="tbody"></tbody>
              </table>
            </div>
          </div>
        </div>

        <script>
          const ctx = "<%=request.getContextPath()%>";
          const api = ctx + "/api/categories";
          let allCategories = []; // Store all categories for filtering

          async function loadCategories() {
            const tbody = document.getElementById("tbody");
            const status = document.getElementById("status");
            tbody.innerHTML = "";
            status.textContent = "Đang tải danh mục...";
            try {
              const res = await fetch(api);
              if (!res.ok) throw new Error("HTTP " + res.status);
              const list = await res.json();
              allCategories = list; // Store for filtering
              if (Array.isArray(list) && list.length > 0) {
                status.textContent = "";
                applyFiltersAndRender();
              } else {
                status.textContent = "Không có danh mục.";
              }
            } catch (e) {
              console.error(e);
              status.textContent = "Lỗi khi tải danh mục.";
            }
          }

          function applyFiltersAndRender() {
            let filtered = [...allCategories];

            // Filter by name
            const nameFilter = document
              .getElementById("name")
              .value.trim()
              .toLowerCase();
            if (nameFilter) {
              filtered = filtered.filter((c) =>
                (c.name || "").toLowerCase().includes(nameFilter)
              );
            }

            // Sort
            const sortValue = document.getElementById("sort").value;
            const [sortField, sortOrder] = sortValue.split(",");

            filtered.sort((a, b) => {
              let valA = a[sortField];
              let valB = b[sortField];

              if (sortField === "name") {
                valA = (valA || "").toLowerCase();
                valB = (valB || "").toLowerCase();
              }

              if (valA < valB) return sortOrder === "asc" ? -1 : 1;
              if (valA > valB) return sortOrder === "asc" ? 1 : -1;
              return 0;
            });

            render(filtered);
          }

          function render(list) {
            const tbody = document.getElementById("tbody");
            tbody.innerHTML = "";

            // First load product counts
            fetch(ctx + "/api/products")
              .then((r) => r.json())
              .then((products) => {
                const counts = {};
                products.forEach((p) => {
                  if (p.category) {
                    counts[p.category.id] = (counts[p.category.id] || 0) + 1;
                  }
                });

                // Then render categories with counts
                list.forEach((c, idx) => {
                  const tr = document.createElement("tr");
                  const cid = c.id != null ? c.id : "";
                  const cname = c.name != null ? c.name : "";
                  const cdesc = c.description != null ? c.description : "";
                  const count = counts[cid] || 0;

                  // Find parent category name
                  let parentName = "-";
                  if (c.parentId) {
                    const parent = allCategories.find(
                      (cat) => cat.id === c.parentId
                    );
                    if (parent) {
                      parentName = parent.name;
                    }
                  }

                  tr.innerHTML =
                    '<td class="text-center">' +
                    (idx + 1) +
                    "</td>" +
                    "<td><strong>" +
                    cname +
                    "</strong></td>" +
                    '<td class="text-muted">' +
                    parentName +
                    "</td>" +
                    '<td class="text-muted">' +
                    cdesc +
                    "</td>" +
                    '<td class="text-center">' +
                    count +
                    "</td>" +
                    '<td class="text-center">' +
                    '<a href="' +
                    ctx +
                    "/admin/categories/" +
                    cid +
                    '" class="btn btn-view" title="Xem chi tiết">' +
                    '<i class="fas fa-eye"></i>' +
                    "</a>" +
                    '<a href="' +
                    ctx +
                    "/admin/categories/edit/" +
                    cid +
                    '" class="btn btn-edit" title="Sửa">' +
                    '<i class="fas fa-edit"></i>' +
                    "</a>" +
                    '<button class="btn btn-delete" onclick="deleteCategory(' +
                    cid +
                    ')" title="Xóa">' +
                    '<i class="fas fa-trash"></i>' +
                    "</button>" +
                    "</td>";
                  tbody.appendChild(tr);
                });
              });
          }

          async function deleteCategory(id) {
            if (!confirm("Bạn có chắc muốn xóa danh mục #" + id + " ?")) return;
            try {
              const res = await fetch(api + "/" + id, { method: "DELETE" });
              if (res.ok) {
                alert("Đã xóa danh mục!");
                loadCategories();
              } else {
                alert("Không thể xóa danh mục (HTTP " + res.status + ")");
              }
            } catch (e) {
              console.error(e);
              alert("Lỗi khi xóa danh mục");
            }
          }

          loadCategories();

          // Add event listeners for filters
          document
            .getElementById("name")
            .addEventListener("input", applyFiltersAndRender);
          document
            .getElementById("sort")
            .addEventListener("change", applyFiltersAndRender);
          document
            .getElementById("showAllBtn")
            .addEventListener("click", () => {
              document.getElementById("name").value = "";
              document.getElementById("sort").value = "createdAt,desc";
              applyFiltersAndRender();
            });
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

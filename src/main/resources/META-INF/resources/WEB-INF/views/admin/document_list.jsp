<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ taglib
prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
  <head>
    <title>Danh sách tài liệu</title>
    <meta name="viewport" content="width=device-width,initial-scale=1" />
    <link rel="stylesheet" href="<c:url value='/css/admin-dashboard.css'/>" />
    <link rel="stylesheet" href="<c:url value='/css/documents_admin.css'/>" />
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
            <li>
              <a href="${pageContext.request.contextPath}/admin/categories"
                ><i class="fas fa-tag"></i
                ><span class="nav-text">Categories</span></a
              >
            </li>
            <li class="active">
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
            <h2>Quản lý tài liệu</h2>
            <div>
              <a
                href="${pageContext.request.contextPath}/admin/document/new"
                class="btn btn-primary"
              >
                <i class="fas fa-plus"></i> Thêm tài liệu
              </a>
              <button class="btn btn-outline" id="showAllBtn">
                <i class="fas fa-list"></i> Hiển thị tất cả
              </button>
            </div>
          </div>

          <!-- Bộ lọc -->
          <div class="filter-container">
            <div class="filter-group">
              <label>Tiêu đề</label>
              <input
                id="title"
                class="filter-input"
                placeholder="Tìm theo tiêu đề"
                type="text"
                autocomplete="off"
              />
            </div>
            <div class="filter-group">
              <label>Sắp xếp</label>
              <select id="sort" class="filter-input">
                <option value="createdAt,desc">Mới nhất</option>
                <option value="title,asc">Tiêu đề: A → Z</option>
                <option value="title,desc">Tiêu đề: Z → A</option>
              </select>
            </div>
          </div>

          <c:if test="${not empty success}">
            <div class="alert alert-success">${success}</div>
          </c:if>
          <c:if test="${not empty error}">
            <div class="alert alert-danger">${error}</div>
          </c:if>

          <div class="card">
            <div class="card-header">
              <div class="card-title">Danh sách tài liệu</div>
            </div>
            <div class="card-body">
              <table>
                <thead>
                  <tr>
                    <th style="width: 60px">ID</th>
                    <th>Tiêu đề</th>
                    <th>Mô tả</th>
                    <th>ID Sản phẩm</th>
                    <th>Hình ảnh</th>
                    <th style="width: 120px">Thao tác</th>
                  </tr>
                </thead>
                <tbody>
                  <c:forEach var="doc" items="${documents}">
                    <tr>
                      <td>${doc.id}</td>
                      <td>${doc.title}</td>
                      <td>
                        <div style="max-height: 100px; overflow: auto">
                          <c:out value="${doc.description}" escapeXml="false" />
                        </div>
                      </td>
                      <td>${doc.productId}</td>
                      <td>
                        <div class="img-gallery">
                          <c:forEach
                            var="img"
                            items="${doc.images}"
                            begin="0"
                            end="2"
                          >
                            <img
                              src="${pageContext.request.contextPath}${img.imageUrl}"
                              alt="Image"
                            />
                          </c:forEach>
                          <c:if test="${doc.images.size() > 3}">
                            <div class="more-images">
                              +${doc.images.size() - 3}
                            </div>
                          </c:if>
                        </div>
                      </td>
                      <td>
                        <a
                          href="${pageContext.request.contextPath}/admin/document/${doc.id}"
                          class="btn btn-view"
                        >
                          <i class="fas fa-eye"></i>
                        </a>
                        <a
                          href="${pageContext.request.contextPath}/admin/document/edit/${doc.id}"
                          class="btn btn-edit"
                        >
                          <i class="fas fa-edit"></i>
                        </a>
                        <a href="#" class="btn btn-delete" data-id="${doc.id}">
                          <i class="fas fa-trash"></i>
                        </a>
                      </td>
                    </tr>
                  </c:forEach>
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Script for document list handling -->
    <script>
      // Document ready handler
      document.addEventListener("DOMContentLoaded", function () {
        // Toggle sidebar
        const navToggle = document.getElementById("navToggle");
        const sidebar = document.getElementById("sidebar");

        if (navToggle) {
          navToggle.addEventListener("click", function () {
            sidebar.classList.toggle("collapsed");
          });
        }

        // Filter functionality
        const titleInput = document.getElementById("title");
        const sortSelect = document.getElementById("sort");
        const showAllBtn = document.getElementById("showAllBtn");

        // Add filtering logic here
        if (titleInput && sortSelect) {
          titleInput.addEventListener("input", applyFilters);
          sortSelect.addEventListener("change", applyFilters);
        }

        if (showAllBtn) {
          showAllBtn.addEventListener("click", function () {
            if (titleInput) titleInput.value = "";
            if (sortSelect) sortSelect.value = "createdAt,desc";
            applyFilters();
          });
        }

        function applyFilters() {
          const titleFilter = (titleInput?.value || "").toLowerCase().trim();
          const sortValue = sortSelect?.value || "createdAt,desc";
          const [sortField, sortOrder] = sortValue.split(",");

          const table = document.querySelector("table tbody");
          if (!table) return;

          const rows = Array.from(table.querySelectorAll("tr"));

          // Filter rows
          rows.forEach((row) => {
            if (!titleFilter) {
              row.style.display = "";
              return;
            }

            const titleCell = row.cells[1]; // Tiêu đề is column 2
            const titleText = (titleCell?.textContent || "").toLowerCase();

            if (titleText.includes(titleFilter)) {
              row.style.display = "";
            } else {
              row.style.display = "none";
            }
          });

          // Sort visible rows
          const visibleRows = rows.filter(
            (row) => row.style.display !== "none"
          );
          visibleRows.sort((a, b) => {
            let valA, valB;

            if (sortField === "title") {
              valA = (a.cells[1]?.textContent || "").toLowerCase();
              valB = (b.cells[1]?.textContent || "").toLowerCase();
            } else if (sortField === "createdAt") {
              // Assuming column 3 or similar has date - adjust as needed
              valA = a.cells[0]?.textContent || "0"; // ID as proxy for creation order
              valB = b.cells[0]?.textContent || "0";
            }

            if (valA < valB) return sortOrder === "asc" ? -1 : 1;
            if (valA > valB) return sortOrder === "asc" ? 1 : -1;
            return 0;
          });

          // Re-append sorted rows
          visibleRows.forEach((row) => table.appendChild(row));
        }

        // Delete confirmation
        const deleteButtons = document.querySelectorAll(".btn-delete");
        deleteButtons.forEach((button) => {
          button.addEventListener("click", function (e) {
            e.preventDefault();
            const id = this.getAttribute("data-id");
            if (confirm("Bạn có chắc chắn muốn xóa tài liệu này?")) {
              // Perform delete action, typically with AJAX or form submission
              window.location.href =
                `${pageContext.request.contextPath}/admin/document/delete/` +
                id;
            }
          });
        });
      });
    </script>
  </body>
</html>

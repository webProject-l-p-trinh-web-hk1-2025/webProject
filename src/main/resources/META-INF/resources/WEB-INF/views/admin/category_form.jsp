<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> <%@ page
contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
  <head>
    <title>Thêm / Sửa danh mục</title>
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
            <h2><span id="formTitle">Thêm danh mục mới</span></h2>
            <a
              href="${pageContext.request.contextPath}/admin/categories"
              class="btn btn-outline"
            >
              <i class="fas fa-arrow-left"></i> Quay lại
            </a>
          </div>

          <div class="card">
            <div class="card-header">
              <div class="card-title">Thông tin danh mục</div>
            </div>
            <div class="card-body">
              <form id="categoryForm" class="form-container">
                <input type="hidden" id="id" name="id" />

                <div class="form-group">
                  <div class="form-control">
                    <label for="name">Tên danh mục *</label>
                    <input
                      type="text"
                      id="name"
                      name="name"
                      placeholder="Tên danh mục"
                      required
                      pattern=".{2,}"
                      title="Tên danh mục phải có ít nhất 2 ký tự"
                    />
                    <div class="invalid-feedback">
                      Vui lòng nhập tên danh mục (ít nhất 2 ký tự)
                    </div>
                  </div>
                </div>

                <div class="form-group">
                  <div class="form-control">
                    <label for="description">Mô tả (không bắt buộc)</label>
                    <textarea
                      id="description"
                      name="description"
                      placeholder="Mô tả chi tiết về danh mục"
                      style="height: 120px"
                    ></textarea>
                  </div>
                </div>

                <div class="form-actions">
                  <button
                    type="button"
                    class="btn btn-outline"
                    onclick="history.back()"
                  >
                    <i class="fas fa-times"></i> Hủy
                  </button>
                  <button type="submit" class="btn btn-primary">
                    <i class="fas fa-save"></i> Lưu
                  </button>
                </div>
              </form>
            </div>
          </div>

          <div id="status" class="alert mt-3 d-none"></div>
        </div>
      </div>
    </div>

    <script>
      const ctx = "<%=request.getContextPath()%>";
      const api = ctx + "/api/categories";
      const form = document.getElementById("categoryForm");
      const status = document.getElementById("status");

      // Bootstrap validation
      form.addEventListener("submit", (event) => {
        if (!form.checkValidity()) {
          event.preventDefault();
          event.stopPropagation();
        }
        form.classList.add("was-validated");
      });

      // If URL contains /edit/{id} we will fetch existing
      const path = location.pathname;
      const editMatch = path.match(/\/admin\/categories\/edit\/(\d+)/);
      const isEdit = !!editMatch;

      // Update title for edit mode
      if (isEdit) {
        document.getElementById("formTitle").textContent = "Chỉnh sửa danh mục";
        document.title = "Chỉnh sửa danh mục";

        const id = editMatch[1];
        fetch(api + "/" + id)
          .then((r) => {
            if (!r.ok) throw new Error("HTTP " + r.status);
            return r.json();
          })
          .then((c) => {
            document.getElementById("id").value = c.id || "";
            document.getElementById("name").value = c.name || "";
            document.getElementById("description").value = c.description || "";
          })
          .catch((e) => {
            console.error(e);
            showError(
              "Không thể tải thông tin danh mục. Vui lòng thử lại sau."
            );
          });
      }

      form.addEventListener("submit", async (ev) => {
        ev.preventDefault();
        if (!form.checkValidity()) return;

        const id = document.getElementById("id").value;
        const payload = {
          name: document.getElementById("name").value.trim(),
          description: document.getElementById("description").value.trim(),
        };

        // Validate
        if (payload.name.length < 2) {
          showError("Tên danh mục phải có ít nhất 2 ký tự");
          return;
        }

        try {
          showStatus("Đang lưu...");
          const method = id ? "PUT" : "POST";
          const url = id ? api + "/" + id : api;
          const res = await fetch(url, {
            method,
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify(payload),
          });

          if (res.ok) {
            showSuccess("Đã lưu thành công!");
            setTimeout(() => (location.href = ctx + "/admin/categories"), 800);
          } else {
            const error = await res.text();
            showError("Lỗi khi lưu: " + error);
          }
        } catch (e) {
          console.error(e);
          showError("Lỗi khi lưu danh mục. Vui lòng thử lại sau.");
        }
      });

      function showStatus(message) {
        status.className = "alert alert-info mt-3";
        status.innerHTML = '<i class="bi bi-info-circle"></i> ' + message;
        status.classList.remove("d-none");
      }

      function showError(message) {
        status.className = "alert alert-danger mt-3";
        status.innerHTML =
          '<i class="bi bi-exclamation-triangle"></i> ' + message;
        status.classList.remove("d-none");
      }

      function showSuccess(message) {
        status.className = "alert alert-success mt-3";
        status.innerHTML = '<i class="fas fa-check-circle"></i> ' + message;
        status.classList.remove("d-none");
      }
    </script>
    <!-- Script để toggle sidebar -->
    <script>
      document
        .getElementById("navToggle")
        .addEventListener("click", function () {
          document.getElementById("sidebar").classList.toggle("minimized");
          document.querySelector(".main-content").classList.toggle("expanded");
        });
    </script>
  </body>
</html>

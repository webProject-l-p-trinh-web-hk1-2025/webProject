<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
  <%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
      <meta charset="UTF-8">
      <title>Thêm / Sửa danh mục</title>
      <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
      <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet" />
      <style>
        .form-floating>.form-control {
          height: calc(3.5rem + 2px);
        }

        .form-floating>textarea.form-control {
          height: 100px;
        }
      </style>
    </head>

    <body class="bg-light">
      <div class="container py-4" style="max-width: 680px;">
        <div class="d-flex justify-content-between align-items-center mb-4">
          <h3 class="m-0">
            <i class="bi bi-folder-plus"></i>
            <span id="formTitle">Thêm danh mục mới</span>
          </h3>
          <a href="${pageContext.request.contextPath}/admin/categories" class="text-decoration-none">
            <i class="bi bi-arrow-left"></i> Quay lại
          </a>
        </div>

        <div class="card">
          <div class="card-body">
            <form id="categoryForm" class="needs-validation" novalidate>
              <input type="hidden" id="id" name="id" />

              <div class="form-floating mb-3">
                <input type="text" class="form-control" id="name" name="name" placeholder="Tên danh mục" required
                  pattern=".{2,}" title="Tên danh mục phải có ít nhất 2 ký tự" />
                <label for="name">Tên danh mục</label>
                <div class="invalid-feedback">Vui lòng nhập tên danh mục (ít nhất 2 ký tự)</div>
              </div>

              <div class="form-floating mb-3">
                <textarea class="form-control" id="description" name="description"
                  placeholder="Mô tả chi tiết về danh mục" style="height:120px;"></textarea>
                <label for="description">Mô tả (không bắt buộc)</label>
              </div>

              <!-- ✅ NEW: chọn danh mục cha -->
              <div class="mb-3">
                <label for="parentId" class="form-label fw-semibold">Danh mục cha (nếu có)</label>
                <select id="parentId" name="parentId" class="form-select">
                  <option value="">-- Không có (Danh mục gốc) --</option>
                </select>
              </div>

              <div class="text-end">
                <button type="button" class="btn btn-outline-secondary me-2" onclick="history.back()">
                  Hủy
                </button>
                <button type="submit" class="btn btn-primary px-4">
                  <i class="bi bi-save"></i> Lưu
                </button>
              </div>
            </form>
          </div>
        </div>

        <div id="status" class="alert mt-3 d-none"></div>
      </div>

      <script>
        const ctx = "<%=request.getContextPath()%>";
        const api = ctx + '/api/categories';
        const form = document.getElementById('categoryForm');
        const status = document.getElementById('status');
        const parentSelect = document.getElementById('parentId');

        // Bootstrap validation
        form.addEventListener('submit', event => {
          if (!form.checkValidity()) {
            event.preventDefault();
            event.stopPropagation();
          }
          form.classList.add('was-validated');
        });

        // Fetch all categories to fill parent dropdown
        async function loadParentCategories(selectedId = null) {
          try {
            const res = await fetch(api);
            if (!res.ok) throw new Error('Không thể tải danh sách danh mục cha');
            const data = await res.json();
            data.forEach(cat => {
              const opt = document.createElement('option');
              opt.value = cat.id;
              opt.textContent = cat.name;
              parentSelect.appendChild(opt);
            });

            if (selectedId) {
              parentSelect.value = selectedId;
            }
          } catch (e) {
            console.error(e);
            showError('Không thể tải danh mục cha.');
          }
        }

        // If URL contains /edit/{id} → edit mode
        const path = location.pathname;
        const editMatch = path.match(/\/admin\/categories\/edit\/(\d+)/);
        const isEdit = !!editMatch;

        if (isEdit) {
          document.getElementById('formTitle').textContent = 'Chỉnh sửa danh mục';
          document.title = 'Chỉnh sửa danh mục';
          const id = editMatch[1];

          fetch(api + '/' + id)
            .then(r => r.json())
            .then(c => {
              document.getElementById('id').value = c.id || '';
              document.getElementById('name').value = c.name || '';
              document.getElementById('description').value = c.description || '';
              loadParentCategories(c.parentId);
            })
            .catch(e => {
              console.error(e);
              showError('Không thể tải thông tin danh mục.');
            });
        } else {
          // Nếu là thêm mới
          loadParentCategories();
        }

        // Xử lý lưu form
        form.addEventListener('submit', async (ev) => {
          ev.preventDefault();
          if (!form.checkValidity()) return;

          const id = document.getElementById('id').value;
          const payload = {
            name: document.getElementById('name').value.trim(),
            description: document.getElementById('description').value.trim(),
            parentId: parentSelect.value || null
          };

          if (payload.name.length < 2) {
            showError('Tên danh mục phải có ít nhất 2 ký tự');
            return;
          }

          try {
            showStatus('Đang lưu...');
            const method = id ? 'PUT' : 'POST';
            const url = id ? api + '/' + id : api;
            const res = await fetch(url, {
              method,
              headers: { 'Content-Type': 'application/json' },
              body: JSON.stringify(payload)
            });

            if (res.ok) {
              showSuccess('Đã lưu thành công!');
              setTimeout(() => location.href = ctx + '/admin/categories', 800);
            } else {
              const error = await res.text();
              showError('Lỗi khi lưu: ' + error);
            }
          } catch (e) {
            console.error(e);
            showError('Lỗi khi lưu danh mục. Vui lòng thử lại sau.');
          }
        });

        // Hiển thị thông báo
        function showStatus(message) {
          status.className = 'alert alert-info mt-3';
          status.innerHTML = '<i class="bi bi-info-circle"></i> ' + message;
          status.classList.remove('d-none');
        }

        function showError(message) {
          status.className = 'alert alert-danger mt-3';
          status.innerHTML = '<i class="bi bi-exclamation-triangle"></i> ' + message;
          status.classList.remove('d-none');
        }

        function showSuccess(message) {
          status.className = 'alert alert-success mt-3';
          status.innerHTML = '<i class="bi bi-check-circle"></i> ' + message;
          status.classList.remove('d-none');
        }
      </script>
    </body>

    </html>
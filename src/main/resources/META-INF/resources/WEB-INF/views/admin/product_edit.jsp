<%@ page contentType="text/html;charset=UTF-8" %> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <title>Chỉnh sửa sản phẩm</title>
    <meta name="viewport" content="width=device-width,initial-scale=1" />
    <link rel="stylesheet" href="<c:url value='/css/admin-dashboard.css'/>" />
    <link rel="stylesheet" href="<c:url value='/css/products_admin.css'/>" />
    <link rel="stylesheet" href="<c:url value='/css/product_edit.css'/>" />
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
            <li class="active">
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
            <h2><i class="fas fa-pencil-alt me-2"></i>Chỉnh sửa sản phẩm</h2>
            <div>
              <a
                href="${pageContext.request.contextPath}/admin/products"
                class="btn btn-outline"
              >
                <i class="fas fa-arrow-left"></i> Quay lại danh sách
              </a>
            </div>
          </div>

          <div class="card">
            <div class="card-header">
              <div class="card-title">Thông tin sản phẩm</div>
            </div>
            <div class="card-body">
              <form id="editForm">
                <input type="hidden" id="productId" value="${product.id}" />

                <div class="row">
                  <div class="col-md-6">
                    <div class="form-group">
                      <label>Tên sản phẩm*</label>
                      <input
                        name="name"
                        class="form-control"
                        value="${product.name}"
                        required
                      />
                    </div>
                  </div>

                  <div class="col-md-6">
                    <div class="form-group">
                      <label>Hãng*</label>
                      <input
                        name="brand"
                        class="form-control"
                        value="${product.brand}"
                        required
                      />
                    </div>
                  </div>

                  <div class="col-md-4">
                    <div class="form-group">
                      <label>Giá*</label>
                      <input
                        name="price"
                        type="number"
                        step="0.01"
                        class="form-control"
                        value="${product.price}"
                        required
                      />
                    </div>
                  </div>

                  <div class="col-md-4">
                    <div class="form-group">
                      <label>Tồn kho*</label>
                      <input
                        name="stock"
                        type="number"
                        class="form-control"
                        value="${product.stock}"
                        required
                      />
                    </div>
                  </div>

                  <div class="col-md-4">
                    <div class="form-group">
                      <label>Danh mục*</label>
                      <select
                        name="categoryId"
                        class="form-select"
                        required
                      ></select>
                    </div>
                  </div>

                  <div class="col-md-4">
                    <div class="form-group">
                      <label>Áp dụng khuyến mãi (Deal)</label>
                      <div class="form-check">
                        <input type="checkbox" name="onDeal" id="onDealCheckbox"
                        class="form-check-input" ${product.onDeal ? 'checked' :
                        ''} />
                        <label class="form-check-label" for="onDealCheckbox">
                          Sản phẩm đang giảm giá
                        </label>
                      </div>
                    </div>
                  </div>

                  <div class="col-md-4">
                    <div class="form-group">
                      <label>Phần trăm giảm giá (%)</label>
                      <input
                        type="number"
                        name="dealPercentage"
                        class="form-control"
                        min="0"
                        max="100"
                        value="${product.dealPercentage != null ? product.dealPercentage : 0}"
                      />
                    </div>
                  </div>
                </div>

                <div class="card mt-4">
                  <div class="card-header">
                    <div class="card-title">Thông số kỹ thuật (tùy chọn)</div>
                  </div>
                  <div class="card-body">
                    <div class="row">
                      <div class="col-md-6">
                        <div class="form-group">
                          <label>Screen size</label>
                          <input
                            name="screenSize"
                            class="form-control"
                            value="${product.screenSize}"
                          />
                        </div>
                      </div>
                      <div class="col-md-6">
                        <div class="form-group">
                          <label>Display tech</label>
                          <input
                            name="displayTech"
                            class="form-control"
                            value="${product.displayTech}"
                          />
                        </div>
                      </div>
                      <div class="col-md-6">
                        <div class="form-group">
                          <label>Resolution</label>
                          <input
                            name="resolution"
                            class="form-control"
                            value="${product.resolution}"
                          />
                        </div>
                      </div>
                      <div class="col-md-6">
                        <div class="form-group">
                          <label>Display features</label>
                          <input
                            name="displayFeatures"
                            class="form-control"
                            value="${product.displayFeatures}"
                          />
                        </div>
                      </div>
                      <div class="col-md-6">
                        <div class="form-group">
                          <label>Rear camera</label>
                          <input
                            name="rearCamera"
                            class="form-control"
                            value="${product.rearCamera}"
                          />
                        </div>
                      </div>
                      <div class="col-md-6">
                        <div class="form-group">
                          <label>Front camera</label>
                          <input
                            name="frontCamera"
                            class="form-control"
                            value="${product.frontCamera}"
                          />
                        </div>
                      </div>
                      <div class="col-md-6">
                        <div class="form-group">
                          <label>Chipset</label>
                          <input
                            name="chipset"
                            class="form-control"
                            value="${product.chipset}"
                          />
                        </div>
                      </div>
                      <div class="col-md-6">
                        <div class="form-group">
                          <label>CPU specs</label>
                          <input
                            name="cpuSpecs"
                            class="form-control"
                            value="${product.cpuSpecs}"
                          />
                        </div>
                      </div>
                      <div class="col-md-6">
                        <div class="form-group">
                          <label>RAM</label>
                          <input
                            name="ram"
                            class="form-control"
                            value="${product.ram}"
                          />
                        </div>
                      </div>
                      <div class="col-md-6">
                        <div class="form-group">
                          <label>Storage</label>
                          <input
                            name="storage"
                            class="form-control"
                            value="${product.storage}"
                          />
                        </div>
                      </div>
                      <div class="col-md-6">
                        <div class="form-group">
                          <label>Battery</label>
                          <input
                            name="battery"
                            class="form-control"
                            value="${product.battery}"
                          />
                        </div>
                      </div>
                      <div class="col-md-6">
                        <div class="form-group">
                          <label>SIM type</label>
                          <input
                            name="simType"
                            class="form-control"
                            value="${product.simType}"
                          />
                        </div>
                      </div>
                      <div class="col-md-6">
                        <div class="form-group">
                          <label>OS</label>
                          <input
                            name="os"
                            class="form-control"
                            value="${product.os}"
                          />
                        </div>
                      </div>
                      <div class="col-md-6">
                        <div class="form-group">
                          <label>NFC support</label>
                          <input
                            name="nfcSupport"
                            class="form-control"
                            value="${product.nfcSupport}"
                          />
                        </div>
                      </div>
                    </div>
                  </div>
                </div>

                <div class="card mt-4">
                  <div class="card-header">
                    <div class="card-title">Quản lý hình ảnh</div>
                  </div>
                  <div class="card-body">
                    <div class="form-group">
                      <label>Ảnh mới (tùy chọn, có thể chọn nhiều ảnh)</label>
                      <input
                        type="file"
                        id="imagesInputEdit"
                        name="images"
                        accept="image/*"
                        class="form-control"
                        multiple
                      />
                    </div>

                    <!-- Existing uploaded images -->
                    <div class="form-group mt-4">
                      <label>Ảnh đã upload</label>
                      <div id="existingImages" class="mt-2"></div>
                    </div>
                  </div>
                </div>

                <div class="row mt-4">
                  <div class="col-12">
                    <button class="btn btn-primary" type="submit">
                      <i class="fas fa-save"></i> Lưu thay đổi
                    </button>
                    <a
                      href="${pageContext.request.contextPath}/admin/products/edit/${product.id}"
                      class="btn btn-outline-secondary"
                      ><i class="fas fa-times"></i> Hủy</a
                    >
                  </div>
                </div>
              </form>
            </div>
          </div>
        </div>
      </div>
    </div>

    <script>
      const ctx = "${pageContext.request.contextPath}";
      const id = document.getElementById("productId").value;

      // Load danh mục
      (async () => {
        const sel = document.querySelector('select[name="categoryId"]');
        const res = await fetch(ctx + "/api/categories");
        const cats = await res.json();
        cats.forEach((c) => {
          const opt = document.createElement("option");
          opt.value = c.id;
          opt.textContent = c.name;
          if (c.id == "${product.category.id}") opt.selected = true;
          sel.append(opt);
        });
        // after categories, load existing product images to display and allow delete
        try {
          const p = await (await fetch(ctx + "/api/products/" + id)).json();
          renderExistingImages(p);
        } catch (e) {
          /* ignore */
        }
      })();

      // Submit update
      document
        .getElementById("editForm")
        .addEventListener("submit", async (e) => {
          e.preventDefault();
          const form = e.target;
          const formData = new FormData();
          const data = {
            name: form.name.value,
            brand: form.brand.value,
            price: parseFloat(form.price.value),
            stock: parseInt(form.stock.value),
            categoryId: parseInt(form.categoryId.value),
            onDeal: form.onDeal?.checked || false,
            dealPercentage: form.onDeal?.checked
              ? parseInt(form.dealPercentage?.value) || 0
              : null,
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

          console.log("Update payload", data);
          formData.append(
            "data",
            new Blob([JSON.stringify(data)], { type: "application/json" })
          );

          try {
            const res = await fetch(ctx + "/api/products/" + id, {
              method: "PUT",
              body: formData,
            });
            if (res.ok) {
              const body = await res.json().catch(() => null);
              console.log("Update success", body);
              // if multiple images selected, upload them via the images endpoint
              const imgs = document.getElementById("imagesInputEdit").files;
              if (imgs && imgs.length > 0) {
                const fd = new FormData();
                for (let i = 0; i < imgs.length; i++)
                  fd.append("images", imgs[i]);
                await fetch(ctx + "/api/products/" + id + "/images", {
                  method: "POST",
                  body: fd,
                });
              }
              alert("Cập nhật thành công!");
              location.href = ctx + "/admin/products/edit/" + id;
              return;
            }

            // Read response body for debugging (JSON or text)
            let errBody;
            try {
              errBody = await res.json();
            } catch (e) {
              errBody = await res.text();
            }
            console.error("Update failed", res.status, errBody);
            alert(
              "Lỗi cập nhật sản phẩm: " +
                (typeof errBody === "string"
                  ? errBody
                  : JSON.stringify(errBody))
            );
          } catch (e) {
            console.error("Network or client error during update", e);
            alert("Lỗi mạng hoặc server: " + e.message);
          }
        });

      function renderExistingImages(p) {
        const container = document.getElementById("existingImages");
        container.innerHTML = "";
        const imgs =
          p.images && p.images.length
            ? p.images
            : p.imageUrls && p.imageUrls.length
            ? p.imageUrls.map((u) => ({ id: null, url: u }))
            : p.imageUrl
            ? [{ id: null, url: p.imageUrl }]
            : [];

        if (imgs.length === 0) {
          container.innerHTML = '<div class="text-muted">Không có ảnh</div>';
          return;
        }

        const imageGrid = document.createElement("div");
        imageGrid.className = "image-preview";

        imgs.forEach((it) => {
          const wrap = document.createElement("div");
          wrap.className = "image-item";

          const img = document.createElement("img");
          img.src = (it.url || "").startsWith("/") ? ctx + it.url : it.url;
          img.style.objectFit = "cover";
          img.style.width = "100%";
          img.style.height = "100%";
          wrap.appendChild(img);

          if (it.id) {
            const del = document.createElement("button");
            del.type = "button";
            del.className = "delete-img";
            del.innerHTML = '<i class="fas fa-trash"></i>';
            del.title = "Xóa ảnh";
            del.addEventListener("click", async (ev) => {
              ev.stopPropagation();
              if (!confirm("Bạn có chắc muốn xóa ảnh này?")) return;
              const d = await fetch(ctx + "/api/products/images/" + it.id, {
                method: "DELETE",
              });
              if (d.ok) {
                wrap.remove();
              } else {
                alert("Xóa ảnh thất bại");
              }
            });
            wrap.appendChild(del);
          }

          imageGrid.appendChild(wrap);
        });

        container.appendChild(imageGrid);
      }
    </script>

    <script>
      // Sidebar toggle
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
          localStorage.setItem("admin_sidebar_collapsed", current ? "0" : "1");
          apply();
        });
        window.addEventListener("resize", apply);
      })();
    </script>
  </body>
</html>

<%@ page contentType="text/html;charset=UTF-8" %> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %>
<html>
  <head>
    <title>Chỉnh sửa sản phẩm</title>
    <meta name="viewport" content="width=device-width,initial-scale=1" />
    <link rel="stylesheet" href="<c:url value='/css/admin-dashboard.css'/>" />
    <link rel="stylesheet" href="<c:url value='/css/products_admin.css'/>" />
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
            <h2><i class="fas fa-pencil-alt"></i> Chỉnh sửa sản phẩm</h2>
            <a
              href="${pageContext.request.contextPath}/admin/products"
              class="btn btn-outline"
            >
              <i class="fas fa-arrow-left"></i> Quay lại danh sách
            </a>
          </div>

          <div class="card">
            <div class="card-header">
              <div class="card-title">Thông tin sản phẩm</div>
            </div>
            <div class="card-body">
              <form id="editForm" class="form-container">
                <input type="hidden" id="productId" value="${product.id}" />
                <div class="form-group">
                  <div class="form-control">
                    <label>Tên sản phẩm*</label>
                    <input name="name" value="${product.name}" required />
                  </div>
                  <div class="form-control">
                    <label>Hãng*</label>
                    <input name="brand" value="${product.brand}" required />
                  </div>
                </div>

                <div class="form-group">
                  <div class="form-control">
                    <label>Giá*</label>
                    <input
                      name="price"
                      type="number"
                      step="0.01"
                      value="${product.price}"
                      required
                    />
                  </div>
                  <div class="form-control">
                    <label>Tồn kho*</label>
                    <input
                      name="stock"
                      type="number"
                      value="${product.stock}"
                      required
                    />
                  </div>
                  <div class="form-control">
                    <label>Danh mục*</label>
                    <select name="categoryId" required></select>
                  </div>
                </div>

                <hr />
                <h5>Thông số kỹ thuật (tùy chọn)</h5>
                <div class="specs-container">
                  <div class="form-group">
                    <div class="form-control">
                      <label>Screen size</label>
                      <input name="screenSize" value="${product.screenSize}" />
                    </div>
                    <div class="form-control">
                      <label>Display tech</label>
                      <input
                        name="displayTech"
                        value="${product.displayTech}"
                      />
                    </div>
                    <div class="form-control">
                      <label>Resolution</label>
                      <input name="resolution" value="${product.resolution}" />
                    </div>
                    <div class="form-control">
                      <label>Display features</label>
                      <input
                        name="displayFeatures"
                        value="${product.displayFeatures}"
                      />
                    </div>
                  </div>

                  <div class="form-group">
                    <div class="form-control">
                      <label>Rear camera</label>
                      <input name="rearCamera" value="${product.rearCamera}" />
                    </div>
                    <div class="form-control">
                      <label>Front camera</label>
                      <input
                        name="frontCamera"
                        value="${product.frontCamera}"
                      />
                    </div>
                    <div class="form-control">
                      <label>Chipset</label>
                      <input name="chipset" value="${product.chipset}" />
                    </div>
                    <div class="form-control">
                      <label>CPU specs</label>
                      <input name="cpuSpecs" value="${product.cpuSpecs}" />
                    </div>
                  </div>

                  <div class="form-group">
                    <div class="form-control">
                      <label>RAM</label>
                      <input name="ram" value="${product.ram}" />
                    </div>
                    <div class="form-control">
                      <label>Storage</label>
                      <input name="storage" value="${product.storage}" />
                    </div>
                    <div class="form-control">
                      <label>Battery</label>
                      <input name="battery" value="${product.battery}" />
                    </div>
                    <div class="form-control">
                      <label>SIM type</label>
                      <input name="simType" value="${product.simType}" />
                    </div>
                  </div>

                  <div class="form-group">
                    <div class="form-control">
                      <label>OS</label>
                      <input name="os" value="${product.os}" />
                    </div>
                    <div class="form-control">
                      <label>NFC support</label>
                      <input name="nfcSupport" value="${product.nfcSupport}" />
                    </div>
                  </div>
                </div>

                <div class="form-group">
                  <div class="form-control">
                    <label>Ảnh mới (tùy chọn, có thể chọn nhiều ảnh)</label>
                    <input
                      type="file"
                      id="imagesInputEdit"
                      name="images"
                      accept="image/*"
                      multiple
                    />
                  </div>
                </div>

                <!-- Existing uploaded images -->
                <div class="form-group">
                  <div class="form-control">
                    <label>Ảnh đã upload</label>
                    <div id="existingImages" class="image-gallery"></div>
                  </div>
                </div>

                <div class="form-actions">
                  <button class="btn primary-btn" type="submit">
                    Lưu thay đổi
                  </button>
                  <a
                    href="${pageContext.request.contextPath}/admin/products"
                    class="btn btn-outline"
                    >Quay lại</a
                  >
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
      // Add sidebar toggle functionality
      document
        .getElementById("navToggle")
        .addEventListener("click", function () {
          document.getElementById("sidebar").classList.toggle("collapsed");
          document.querySelector(".main-content").classList.toggle("expanded");
        });

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
              location.href = ctx + "/product_detail?id=" + id;
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
        imgs.forEach((it) => {
          const wrap = document.createElement("div");
          wrap.className = "image-item";
          wrap.style.position = "relative";

          const img = document.createElement("img");
          img.src = (it.url || "").startsWith("/") ? ctx + it.url : it.url;
          img.className = "product-thumbnail";
          wrap.appendChild(img);

          if (it.id) {
            const del = document.createElement("button");
            del.type = "button";
            del.className = "delete-btn";
            del.innerHTML = '<i class="fas fa-trash-alt"></i>';
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

          container.appendChild(wrap);
        });
      }
    </script>
  </body>
</html>

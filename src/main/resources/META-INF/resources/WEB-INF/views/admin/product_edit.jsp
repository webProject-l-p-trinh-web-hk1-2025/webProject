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
                      <select
                        name="brandCategoryId"
                        id="brandCategorySelect"
                        class="form-select"
                        required
                      >
                        <option value="">-- Chọn hãng --</option>
                      </select>
                      <input
                        type="hidden"
                        name="brand"
                        id="brandHidden"
                        value="${product.brand}"
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
                      <label>Dòng sản phẩm*</label>
                      <select
                        name="categoryId"
                        id="productSeriesSelect"
                        class="form-select"
                        required
                        disabled
                      >
                        <option value="">-- Chọn hãng trước --</option>
                      </select>
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
                    <div class="card-title">Quản lý hình ảnh theo màu sắc</div>
                  </div>
                  <div class="card-body">
                    <!-- Color selector for new images -->
                    <div class="form-group">
                      <label><i class="fas fa-palette"></i> Chọn màu để upload ảnh</label>
                      <div class="row">
                        <div class="col-md-8">
                          <select id="colorSelectEdit" class="form-control">
                            <option value="">-- Chọn màu --</option>
                          </select>
                        </div>
                        <div class="col-md-4">
                          <button type="button" id="addNewColorBtnEdit" class="btn btn-success btn-block">
                            <i class="fas fa-plus"></i> Thêm màu mới
                          </button>
                        </div>
                      </div>
                      
                      <!-- New color input (hidden by default) -->
                      <div id="newColorGroupEdit" style="display: none; margin-top: 10px;">
                        <div class="input-group">
                          <input type="text" id="newColorInputEdit" class="form-control" placeholder="Nhập tên màu (vd: Đen Titan, Trắng Bạc...)">
                          <div class="input-group-append">
                            <button type="button" id="saveNewColorBtnEdit" class="btn btn-primary">
                              <i class="fas fa-check"></i> Lưu
                            </button>
                            <button type="button" id="cancelNewColorBtnEdit" class="btn btn-secondary">
                              <i class="fas fa-times"></i> Hủy
                            </button>
                          </div>
                        </div>
                      </div>
                      
                      <!-- Selected color display -->
                      <div class="mt-2">
                        <small class="text-muted">
                          Màu đang chọn: <strong id="currentColorLabelEdit">Chưa chọn</strong>
                        </small>
                      </div>
                    </div>

                    <!-- Image upload input (disabled until color selected) -->
                    <div class="form-group">
                      <label>Ảnh mới cho màu đã chọn</label>
                      <input
                        type="file"
                        id="imagesInputEdit"
                        name="images"
                        accept="image/*"
                        class="form-control"
                        multiple
                        disabled
                        title="Vui lòng chọn màu trước khi upload ảnh"
                      />
                      <small class="form-text text-muted">
                        <i class="fas fa-info-circle"></i> Chọn màu ở trên trước khi upload ảnh
                      </small>
                    </div>

                    <!-- Existing images grouped by color -->
                    <div class="form-group mt-4">
                      <label>Ảnh đã upload (theo màu sắc)</label>
                      <div id="existingImagesByColor" class="mt-2"></div>
                    </div>

                    <!-- New images preview (grouped by color) -->
                    <div class="form-group mt-4" id="newImagesSection" style="display: none;">
                      <label>Ảnh mới sẽ được upload</label>
                      <div id="newImagesByColor" class="mt-2"></div>
                    </div>
                  </div>
                </div>

                <div class="row mt-4">
                  <div class="col-12">
                    <button class="btn btn-primary" type="submit">
                      <i class="fas fa-save"></i> Lưu thay đổi
                    </button>
                    <a
                      href="${pageContext.request.contextPath}/admin/products"
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

      // Load danh mục cha (Hãng: Apple, Samsung, Xiaomi...)
      let currentProductCategoryParentId = null;
      (async () => {
        const brandSelect = document.getElementById("brandCategorySelect");
        const seriesSelect = document.getElementById("productSeriesSelect");

        // Load parent categories (Hãng)
        const res = await fetch(ctx + "/api/categories/parents");
        const parentCategories = await res.json();

        parentCategories.forEach((c) => {
          const opt = document.createElement("option");
          opt.value = c.id;
          opt.textContent = c.name;
          brandSelect.append(opt);
        });

        // Load sản phẩm hiện tại để set giá trị
        try {
          const p = await (await fetch(ctx + "/api/products/" + id)).json();

          // Nếu có category, tìm parent của nó
          if (p.category && p.category.id) {
            const allCats = await (await fetch(ctx + "/api/categories")).json();
            const currentCat = allCats.find((cat) => cat.id === p.category.id);

            if (currentCat && currentCat.parentId) {
              // Set hãng (parent category)
              brandSelect.value = currentCat.parentId;
              currentProductCategoryParentId = currentCat.parentId;

              // Load dòng sản phẩm của hãng này
              await loadProductSeries(currentCat.parentId, p.category.id);
            }
          }

          // Load existing images
          renderExistingImages(p);
        } catch (e) {
          console.error("Error loading product:", e);
        }
      })();

      // Function để load dòng sản phẩm khi chọn hãng
      async function loadProductSeries(parentId, selectedCategoryId = null) {
        const seriesSelect = document.getElementById("productSeriesSelect");
        const brandSelect = document.getElementById("brandCategorySelect");
        const brandHidden = document.getElementById("brandHidden");

        // Clear old options
        seriesSelect.innerHTML =
          '<option value="">-- Chọn dòng sản phẩm --</option>';

        if (!parentId) {
          seriesSelect.disabled = true;
          return;
        }

        // Load child categories (Dòng sản phẩm)
        const res = await fetch(ctx + "/api/categories/children/" + parentId);
        const childCategories = await res.json();

        childCategories.forEach((c) => {
          const opt = document.createElement("option");
          opt.value = c.id;
          opt.textContent = c.name;
          if (selectedCategoryId && c.id === selectedCategoryId) {
            opt.selected = true;
          }
          seriesSelect.append(opt);
        });

        seriesSelect.disabled = false;

        // Update hidden brand field với tên hãng đã chọn
        const selectedBrandOption =
          brandSelect.options[brandSelect.selectedIndex];
        if (selectedBrandOption && selectedBrandOption.value) {
          brandHidden.value = selectedBrandOption.textContent;
        }
      }

      // Event listener cho khi chọn hãng
      document
        .getElementById("brandCategorySelect")
        .addEventListener("change", function () {
          loadProductSeries(this.value);
        });

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
              
              // Upload new images by color
              const colors = Object.keys(newImagesByColor);
              if (colors.length > 0) {
                for (const color of colors) {
                  const files = newImagesByColor[color];
                  if (files && files.length > 0) {
                    const fd = new FormData();
                    for (let i = 0; i < files.length; i++) {
                      fd.append("images", files[i]);
                    }
                    fd.append("color", color); // Add color to request
                    
                    const uploadRes = await fetch(ctx + "/api/products/" + id + "/images", {
                      method: "POST",
                      body: fd,
                    });
                    
                    if (!uploadRes.ok) {
                      alert("Lỗi upload ảnh cho màu: " + color);
                      return;
                    }
                  }
                }
              }

              alert("Cập nhật sản phẩm thành công!");
              location.href = ctx + "/admin/products";
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

      // Color and image management for EDIT page
      let newImagesByColor = {}; // New images to upload { "Đen": [File, File] }
      let availableColors = []; // All colors (existing + new)
      let currentSelectedColor = "";
      let productData = null; // Store product data

      const colorSelectEdit = document.getElementById("colorSelectEdit");
      const currentColorLabelEdit = document.getElementById("currentColorLabelEdit");
      const imageInputEdit = document.getElementById("imagesInputEdit");
      const addNewColorBtnEdit = document.getElementById("addNewColorBtnEdit");
      const newColorGroupEdit = document.getElementById("newColorGroupEdit");
      const newColorInputEdit = document.getElementById("newColorInputEdit");
      const saveNewColorBtnEdit = document.getElementById("saveNewColorBtnEdit");
      const cancelNewColorBtnEdit = document.getElementById("cancelNewColorBtnEdit");

      // Add new color button
      addNewColorBtnEdit.addEventListener("click", function() {
        newColorGroupEdit.style.display = "block";
        newColorInputEdit.focus();
      });

      // Save new color
      saveNewColorBtnEdit.addEventListener("click", function() {
        const colorName = newColorInputEdit.value.trim();
        if (!colorName) {
          alert("Vui lòng nhập tên màu!");
          return;
        }
        
        if (availableColors.includes(colorName)) {
          alert("Màu này đã tồn tại!");
          return;
        }
        
        // Add new color to list
        availableColors.push(colorName);
        const opt = document.createElement("option");
        opt.value = colorName;
        opt.textContent = colorName;
        colorSelectEdit.appendChild(opt);
        
        // Select the new color
        colorSelectEdit.value = colorName;
        currentSelectedColor = colorName;
        currentColorLabelEdit.textContent = colorName;
        imageInputEdit.disabled = false;
        
        // Hide new color input
        newColorGroupEdit.style.display = "none";
        newColorInputEdit.value = "";
      });

      // Cancel new color
      cancelNewColorBtnEdit.addEventListener("click", function() {
        newColorGroupEdit.style.display = "none";
        newColorInputEdit.value = "";
      });

      // Color selection change
      colorSelectEdit.addEventListener("change", function() {
        currentSelectedColor = this.value;
        if (currentSelectedColor) {
          currentColorLabelEdit.textContent = currentSelectedColor;
          imageInputEdit.disabled = false;
        } else {
          currentColorLabelEdit.textContent = "Chưa chọn";
          imageInputEdit.disabled = true;
        }
      });

      // Handle new image selection
      imageInputEdit.addEventListener("change", function(e) {
        const files = Array.from(e.target.files);
        
        if (!currentSelectedColor) {
          alert("Vui lòng chọn màu trước khi upload ảnh!");
          this.value = "";
          return;
        }
        
        // Add files to current color
        if (!newImagesByColor[currentSelectedColor]) {
          newImagesByColor[currentSelectedColor] = [];
        }
        newImagesByColor[currentSelectedColor].push(...files);
        
        // Clear input
        this.value = "";
        
        // Show and render new images section
        document.getElementById("newImagesSection").style.display = "block";
        renderNewImagesByColor();
      });

      function renderNewImagesByColor() {
        const container = document.getElementById("newImagesByColor");
        container.innerHTML = "";

        const colors = Object.keys(newImagesByColor);
        if (colors.length === 0) {
          document.getElementById("newImagesSection").style.display = "none";
          return;
        }

        colors.forEach(color => {
          const colorSection = document.createElement("div");
          colorSection.className = "color-section mb-3";
          colorSection.style.border = "1px solid #28a745";
          colorSection.style.borderRadius = "8px";
          colorSection.style.padding = "15px";
          colorSection.style.backgroundColor = "#f0fff4";

          const colorHeader = document.createElement("div");
          colorHeader.style.marginBottom = "10px";
          colorHeader.style.fontWeight = "bold";
          colorHeader.style.color = "#28a745";
          colorHeader.innerHTML = `
            <i class="fas fa-palette"></i> ${color} 
            <span class="badge badge-success">${newImagesByColor[color].length} ảnh mới</span>
            <button type="button" class="btn btn-sm btn-danger float-right" onclick="removeNewColorImages('${color}')">
              <i class="fas fa-trash"></i> Xóa tất cả
            </button>
          `;
          colorSection.appendChild(colorHeader);

          const imageGrid = document.createElement("div");
          imageGrid.className = "image-preview";

          newImagesByColor[color].forEach((file, index) => {
            const wrap = document.createElement("div");
            wrap.className = "image-item";

            const img = document.createElement("img");
            img.style.objectFit = "cover";
            img.style.width = "100%";
            img.style.height = "100%";

            const reader = new FileReader();
            reader.onload = function(e) {
              img.src = e.target.result;
            };
            reader.readAsDataURL(file);

            wrap.appendChild(img);

            const del = document.createElement("button");
            del.type = "button";
            del.className = "delete-img";
            del.innerHTML = '<i class="fas fa-trash"></i>';
            del.title = "Xóa ảnh";

            del.addEventListener("click", function(ev) {
              ev.stopPropagation();
              newImagesByColor[color].splice(index, 1);
              if (newImagesByColor[color].length === 0) {
                delete newImagesByColor[color];
              }
              renderNewImagesByColor();
            });

            wrap.appendChild(del);
            imageGrid.appendChild(wrap);
          });

          colorSection.appendChild(imageGrid);
          container.appendChild(colorSection);
        });
      }

      // Helper function to remove all new images of a color
      window.removeNewColorImages = function(color) {
        if (confirm(`Xóa tất cả ảnh mới màu "${color}"?`)) {
          delete newImagesByColor[color];
          renderNewImagesByColor();
        }
      };

      function renderExistingImages(p) {
        productData = p; // Store for later use
        const container = document.getElementById("existingImagesByColor");
        container.innerHTML = "";
        
        const imgs = p.images && p.images.length ? p.images : [];

        // Extract colors from existing images and populate color selector
        const existingColors = [...new Set(imgs.map(img => img.color).filter(c => c))];
        availableColors = [...existingColors];
        
        // Populate color select
        colorSelectEdit.innerHTML = '<option value="">-- Chọn màu --</option>';
        availableColors.forEach(color => {
          const opt = document.createElement("option");
          opt.value = color;
          opt.textContent = color;
          colorSelectEdit.appendChild(opt);
        });

        if (imgs.length === 0) {
          container.innerHTML = '<div class="text-muted">Chưa có ảnh nào</div>';
          return;
        }

        // Group images by color
        const imagesByColor = {};
        const noColorImages = [];
        
        imgs.forEach(img => {
          const color = img.color || null;
          if (color) {
            if (!imagesByColor[color]) {
              imagesByColor[color] = [];
            }
            imagesByColor[color].push(img);
          } else {
            noColorImages.push(img);
          }
        });

        // Render images without color first (legacy images)
        if (noColorImages.length > 0) {
          const noColorSection = document.createElement("div");
          noColorSection.className = "color-section mb-4";
          noColorSection.style.border = "1px solid #6c757d";
          noColorSection.style.borderRadius = "8px";
          noColorSection.style.padding = "15px";
          noColorSection.style.backgroundColor = "#f8f9fa";

          const header = document.createElement("div");
          header.style.marginBottom = "10px";
          header.style.fontWeight = "bold";
          header.style.color = "#6c757d";
          header.innerHTML = `
            <i class="fas fa-images"></i> Ảnh chưa có màu 
            <span class="badge badge-secondary">${noColorImages.length} ảnh</span>
          `;
          noColorSection.appendChild(header);

          const imageGrid = document.createElement("div");
          imageGrid.className = "image-preview";

          noColorImages.forEach(img => {
            imageGrid.appendChild(createImageElement(img));
          });

          noColorSection.appendChild(imageGrid);
          container.appendChild(noColorSection);
        }

        // Render images grouped by color
        Object.keys(imagesByColor).sort().forEach(color => {
          const colorSection = document.createElement("div");
          colorSection.className = "color-section mb-4";
          colorSection.style.border = "1px solid #007bff";
          colorSection.style.borderRadius = "8px";
          colorSection.style.padding = "15px";
          colorSection.style.backgroundColor = "#f0f8ff";

          const colorHeader = document.createElement("div");
          colorHeader.style.marginBottom = "10px";
          colorHeader.style.fontWeight = "bold";
          colorHeader.style.fontSize = "16px";
          colorHeader.style.color = "#007bff";
          colorHeader.innerHTML = `
            <i class="fas fa-palette"></i> ${color} 
            <span class="badge badge-primary">${imagesByColor[color].length} ảnh</span>
          `;
          colorSection.appendChild(colorHeader);

          const imageGrid = document.createElement("div");
          imageGrid.className = "image-preview";

          imagesByColor[color].forEach(img => {
            imageGrid.appendChild(createImageElement(img));
          });

          colorSection.appendChild(imageGrid);
          container.appendChild(colorSection);
        });
      }

      function createImageElement(img) {
        const wrap = document.createElement("div");
        wrap.className = "image-item";

        const imgEl = document.createElement("img");
        imgEl.src = (img.url || "").startsWith("/") ? ctx + img.url : img.url;
        imgEl.style.objectFit = "cover";
        imgEl.style.width = "100%";
        imgEl.style.height = "100%";
        wrap.appendChild(imgEl);

        if (img.id) {
          const del = document.createElement("button");
          del.type = "button";
          del.className = "delete-img";
          del.innerHTML = '<i class="fas fa-trash"></i>';
          del.title = "Xóa ảnh";

          del.addEventListener("click", async (ev) => {
            ev.stopPropagation();

            const d = await fetch(ctx + "/api/products/images/" + img.id, {
              method: "DELETE",
            });

            if (d.ok) {
              wrap.remove();
              // Reload product to update colors if needed
              const p = await (await fetch(ctx + "/api/products/" + id)).json();
              renderExistingImages(p);
            } else {
              console.error("Lỗi khi xóa ảnh từ server.");
              alert("Đã xảy ra lỗi khi xóa ảnh. Vui lòng thử lại.");
            }
          });

          wrap.appendChild(del);
        }

        return wrap;
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

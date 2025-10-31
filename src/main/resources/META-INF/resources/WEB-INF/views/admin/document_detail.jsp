<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ taglib
prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
  <head>
    <title>Chi tiết tài liệu</title>
    <meta name="viewport" content="width=device-width,initial-scale=1" />
    <link rel="stylesheet" href="<c:url value='/css/admin-dashboard.css'/>" />
    <link rel="stylesheet" href="<c:url value='/css/documents_admin.css'/>" />
    <link rel="stylesheet" href="<c:url value='/css/document_detail.css'/>" />
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
            <h2>Chi tiết tài liệu</h2>
            <div>
              <a
                href="${pageContext.request.contextPath}/admin/document"
                class="btn btn-outline"
              >
                <i class="fas fa-arrow-left"></i> Quay lại
              </a>
              <a
                href="${pageContext.request.contextPath}/admin/document/edit/${document.id}"
                class="btn btn-edit"
              >
                <i class="fas fa-edit"></i> Chỉnh sửa
              </a>
            </div>
          </div>

          <div class="document-detail">
            <div class="section-title">Thông tin tài liệu</div>

            <div class="field">
              <div class="field-label">ID:</div>
              <div class="field-value">${document.id}</div>
            </div>

            <div class="field">
              <div class="field-label">Tiêu đề:</div>
              <div class="field-value">${document.title}</div>
            </div>

            <div class="field">
              <div class="field-label">ID Sản phẩm:</div>
              <div class="field-value">${document.productId}</div>
            </div>

            <div class="field">
              <div class="field-label">Mô tả:</div>
              <div class="field-value">
                <div class="document-content">
                  <c:out value="${document.description}" escapeXml="false" />
                </div>
              </div>
            </div>

            <div class="field">
              <div class="field-label">Hình ảnh:</div>
              <div class="field-value">
                <div class="images">
                  <c:forEach var="img" items="${document.images}">
                    <img
                      src="${pageContext.request.contextPath}${img.imageUrl}"
                      alt="Document Image"
                      data-lightbox="document-gallery"
                    />
                  </c:forEach>
                </div>
              </div>
            </div>

            <div class="meta-info">
              <div class="meta-item">
                <span class="meta-label">Tạo ngày:</span>
                <span class="meta-value">${document.createdAt}</span>
              </div>
              <c:if test="${document.updatedAt != null}">
                <div class="meta-item">
                  <span class="meta-label">Cập nhật:</span>
                  <span class="meta-value">${document.updatedAt}</span>
                </div>
              </c:if>
            </div>
          </div>

          <div class="actions">
            <a
              href="${pageContext.request.contextPath}/admin/document/edit/${document.id}"
              class="btn btn-edit"
            >
              <i class="fas fa-edit"></i> Chỉnh sửa
            </a>
            <a
              href="#"
              id="deleteBtn"
              class="btn btn-delete"
              data-id="${document.id}"
            >
              <i class="fas fa-trash"></i> Xóa
            </a>
          </div>
        </div>
      </div>
    </div>

    <!-- Lightbox for image gallery -->
    <div class="lightbox" id="lightbox">
      <span class="lightbox-close">&times;</span>
      <img class="lightbox-content" id="lightbox-img" />
      <div class="lightbox-nav">
        <button class="prev-btn">&lt;</button>
        <button class="next-btn">&gt;</button>
      </div>
    </div>

    <script>
      document.addEventListener("DOMContentLoaded", function () {
        // Toggle sidebar
        const navToggle = document.getElementById("navToggle");
        const sidebar = document.getElementById("sidebar");

        if (navToggle) {
          navToggle.addEventListener("click", function () {
            sidebar.classList.toggle("collapsed");
          });
        }

        // Image lightbox
        const images = document.querySelectorAll(".images img");
        const lightbox = document.getElementById("lightbox");
        const lightboxImg = document.getElementById("lightbox-img");
        const close = document.querySelector(".lightbox-close");
        let currentIndex = 0;

        images.forEach((img, index) => {
          img.addEventListener("click", function () {
            currentIndex = index;
            lightboxImg.src = this.src;
            lightbox.classList.add("active");
          });
        });

        if (close) {
          close.addEventListener("click", function () {
            lightbox.classList.remove("active");
          });
        }

        // Previous and next buttons
        const prevBtn = document.querySelector(".prev-btn");
        const nextBtn = document.querySelector(".next-btn");

        if (prevBtn) {
          prevBtn.addEventListener("click", function () {
            currentIndex = (currentIndex - 1 + images.length) % images.length;
            lightboxImg.src = images[currentIndex].src;
          });
        }

        if (nextBtn) {
          nextBtn.addEventListener("click", function () {
            currentIndex = (currentIndex + 1) % images.length;
            lightboxImg.src = images[currentIndex].src;
          });
        }

        // Delete confirmation
        const deleteBtn = document.getElementById("deleteBtn");
        if (deleteBtn) {
          deleteBtn.addEventListener("click", function (e) {
            e.preventDefault();
            const id = this.getAttribute("data-id");
            if (confirm("Bạn có chắc chắn muốn xóa tài liệu này?")) {
              window.location.href =
                `${pageContext.request.contextPath}/admin/document/delete/` +
                id;
            }
          });
        }
      });
    </script>
  </body>
</html>

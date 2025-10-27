<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <title>Danh sách danh mục</title>
  <meta name="viewport" content="width=device-width,initial-scale=1" />
  <link rel="stylesheet" href="<c:url value='/css/admin-dashboard.css'/>" />
  <link rel="stylesheet" href="<c:url value='/css/categories_admin.css'/>" />
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" />
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
        <button id="navToggle" class="nav-toggle-btn" title="Toggle sidebar">☰</button>
        <ul class="metismenu" id="menu">
          <li>
            <a href="${pageContext.request.contextPath}/admin"><i class="icon icon-home"></i><span class="nav-text">Dashboard</span></a>
          </li>
          <li>
            <a href="${pageContext.request.contextPath}/admin/users"><i class="fas fa-users"></i><span class="nav-text">Users</span></a>
          </li>
          <li>
            <a href="${pageContext.request.contextPath}/admin/products"><i class="fas fa-box"></i><span class="nav-text">Products</span></a>
          </li>
          <li class="active">
            <a href="${pageContext.request.contextPath}/admin/categories"><i class="fas fa-tag"></i><span class="nav-text">Categories</span></a>
          </li>
          <li>
            <a href="${pageContext.request.contextPath}/admin/document"><i class="fas fa-file-alt"></i><span class="nav-text">Documents</span></a>
          </li>
          <li>
            <a href="${pageContext.request.contextPath}/admin/chat" style="position: relative;">
              <i class="fas fa-comments"></i>
              <span class="nav-text">Chat</span>
              <span id="chat-notification-badge" style="display:none; position:absolute; top:8px; right:12px; background:#e53935; color:white; border-radius:50%; padding:2px 6px; font-size:10px; min-width:18px; text-align:center;"></span>
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
            <a href="${pageContext.request.contextPath}/admin/categories/new" class="btn btn-primary">
              <i class="fas fa-plus"></i> Thêm danh mục
            </a>
           
          </div>
        </div>

        <!-- Thông báo -->
        <c:if test="${not empty success}">
          <div class="alert alert-success" style="padding: 12px; background: #d4edda; color: #155724; margin-bottom: 15px; border-radius: 4px; border: 1px solid #c3e6cb;">
            <i class="fas fa-check-circle"></i> ${success}
          </div>
        </c:if>
        
        <c:if test="${not empty error}">
          <div class="alert alert-danger" style="padding: 12px; background: #f8d7da; color: #721c24; margin-bottom: 15px; border-radius: 4px; border: 1px solid #f5c6cb;">
            <i class="fas fa-exclamation-circle"></i> ${error}
          </div>
        </c:if>

        <!-- Bộ lọc -->
        <div class="filter-container">
          <div class="filter-group">
            <label>Tên danh mục</label>
            <input id="name" class="filter-input" placeholder="Tìm theo tên" type="text" value="${filterName}" autocomplete="off">
          </div>
          <div class="filter-group">
            <label>Sắp xếp</label>
            <select id="sort" class="filter-input">
              <option value="id,asc" ${filterSort == 'id,asc' ? 'selected' : ''}>ID: Thấp → Cao</option>
              <option value="id,desc" ${filterSort == 'id,desc' ? 'selected' : ''}>ID: Cao → Thấp</option>
              <option value="name,asc" ${filterSort == 'name,asc' ? 'selected' : ''}>Tên: A → Z</option>
              <option value="name,desc" ${filterSort == 'name,desc' ? 'selected' : ''}>Tên: Z → A</option>
              <option value="createdAt,desc" ${filterSort == 'createdAt,desc' ? 'selected' : ''}>Mới nhất</option>
            </select>
          </div>
          <div class="filter-group" style="justify-content: flex-end;">
            <button id="searchBtn" class="btn btn-primary" style="margin-top: auto;" onclick="applyFilters()">
              <i class="fas fa-search"></i> Tìm kiếm
            </button>
          </div>
        </div>

        <div class="card">
          <div class="card-header">
            <div class="card-title">Danh sách danh mục</div>
          </div>
          <div class="card-body">
            <table>
              <thead>
                <tr>
                  <th style="width: 60px">#</th>
                  <th>Tên danh mục</th>
                  <th>Danh mục cha</th>
                  <th>Mô tả</th>
                  <th style="width: 160px">Thao tác</th>
                </tr>
              </thead>
              <tbody id="tbody">
                <c:choose>
                  <c:when test="${not empty categories.content}">
                    <c:forEach var="category" items="${categories.content}" varStatus="status">
                      <tr>
                        <td class="text-center">${categories.number * categories.size + status.index + 1}</td>
                        <td><strong>${category.name}</strong></td>
                        <td class="text-muted">
                          <c:choose>
                            <c:when test="${not empty category.parentId}">
                              <!-- Find parent name from all categories -->
                              <c:set var="parentFound" value="false" />
                              <c:forEach var="cat" items="${allCategories}">
                                <c:if test="${cat.id == category.parentId && !parentFound}">
                                  ${cat.name}
                                  <c:set var="parentFound" value="true" />
                                </c:if>
                              </c:forEach>
                              <c:if test="${!parentFound}">-</c:if>
                            </c:when>
                            <c:otherwise>-</c:otherwise>
                          </c:choose>
                        </td>
                        <td class="text-muted">${category.description}</td>
                        <td class="text-center">
                          
                          <a href="${pageContext.request.contextPath}/admin/categories/edit/${category.id}" 
                             class="btn btn-edit" title="Sửa">
                            <i class="fas fa-edit"></i>
                          </a>
                          <form action="${pageContext.request.contextPath}/admin/categories/${category.id}/delete" 
                                method="post" style="display:inline;" 
                              >
                            <button type="submit" class="btn btn-delete" title="Xóa">
                              <i class="fas fa-trash"></i>
                            </button>
                          </form>
                        </td>
                      </tr>
                    </c:forEach>
                  </c:when>
                  <c:otherwise>
                    <tr>
                      <td colspan="5" class="text-center text-muted">Không có danh mục nào.</td>
                    </tr>
                  </c:otherwise>
                </c:choose>
              </tbody>
            </table>
            
            <!-- Pagination -->
            <c:set var="page" value="${categories}" scope="request"/>
            <c:set var="additionalParams" value="${filterName != null ? '&name='.concat(filterName) : ''}${filterSort != null ? '&sort='.concat(filterSort) : ''}" scope="request"/>
            <jsp:include page="/common/pagination.jsp"/>
          </div>
        </div>
      </div>
    </div>
  </div>

  <!-- WebSocket libraries for chat notifications -->
  <script src="https://cdn.jsdelivr.net/npm/sockjs-client@1.5.0/dist/sockjs.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/stompjs@2.3.3/lib/stomp.min.js"></script>
  <script src="<c:url value='/js/admin-chat-notifications.js'/>"></script>

  <script>
    // Toggle sidebar
    const navToggle = document.getElementById("navToggle");
    const sidebar = document.getElementById("sidebar");

    if (navToggle) {
      navToggle.addEventListener("click", function () {
        const collapsed = sidebar.classList.toggle("collapsed");
        localStorage.setItem("admin_sidebar_collapsed", collapsed ? "1" : "0");
      });
    }

    // Apply saved sidebar state
    if (localStorage.getItem("admin_sidebar_collapsed") === "1") {
      sidebar.classList.add("collapsed");
    }

    // Filter functionality
    function applyFilters() {
      const name = document.getElementById('name').value.trim();
      const sort = document.getElementById('sort').value;
      
      const url = new URL(window.location);
      url.searchParams.set('page', '0'); // Reset to first page
      url.searchParams.set('size', url.searchParams.get('size') || '10');
      
      if (name) url.searchParams.set('name', name);
      else url.searchParams.delete('name');
      
      url.searchParams.set('sort', sort);
      
      window.location.href = url.toString();
    }
    
    // Enter key to search
    document.getElementById('name').addEventListener('keypress', function(e) {
      if (e.key === 'Enter') {
        applyFilters();
      }
    });
  </script>
</body>
</html>

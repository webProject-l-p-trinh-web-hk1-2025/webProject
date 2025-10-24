<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="org.springframework.security.core.context.SecurityContextHolder" %>
<%@ page import="org.springframework.security.core.Authentication" %>
<%@ page import="org.springframework.security.authentication.AnonymousAuthenticationToken" %>
<% 
Authentication auth = SecurityContextHolder.getContext().getAuthentication(); 
boolean isAuthenticated = auth != null && auth.isAuthenticated() && !(auth instanceof AnonymousAuthenticationToken); 
request.setAttribute("isUserAuthenticated", isAuthenticated); 
%>
<html>
<head>
  <title>Chi tiết sản phẩm - <c:out value="${product.name}" default="Sản phẩm"/></title>
  <meta name="viewport" content="width=device-width,initial-scale=1" />
  <link rel="stylesheet" href="<c:url value='/css/admin-dashboard.css'/>" />
  <link rel="stylesheet" href="<c:url value='/css/products_admin.css'/>" />
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" />
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
          <li class="active">
            <a href="${pageContext.request.contextPath}/admin/products"><i class="fas fa-box"></i><span class="nav-text">Products</span></a>
          </li>
          <li>
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
          <h2><i class="fas fa-box-open"></i> Chi tiết sản phẩm</h2>
          <div>
            <a href="${pageContext.request.contextPath}/admin/products/edit?id=${product.id}" class="btn btn-edit">
              <i class="fas fa-edit"></i> Chỉnh sửa
            </a>
            <a href="${pageContext.request.contextPath}/admin/products" class="btn btn-outline">
              <i class="fas fa-arrow-left"></i> Quay lại danh sách
            </a>
          </div>
        </div>
        
        <div class="card">
          <div class="card-header">
            <div class="card-title" id="productName">Chi tiết sản phẩm</div>
          </div>
          <div class="card-body">
            <div class="product-detail">
              <div class="product-images">
                <img id="productMainImage" class="product-main-image" src="" alt="Product image">
                <div id="product-imgs" class="product-image-gallery">
                  <!-- Thumbnails will be inserted here -->
                </div>
              </div>
              
              <div class="product-info">
                <div class="product-info-section">
                  <h3 id="productName">Loading...</h3>
                  <div class="product-meta">
                    <div class="product-price" id="productPrice">$0.00</div>
                    <div class="product-stock">
                      <span class="stock-label">Tồn kho:</span>
                      <span id="productStock" class="stock-value">0</span>
                    </div>
                  </div>
                  
                  <div class="product-category">
                    <span class="category-label">Danh mục:</span>
                    <span id="productCategory">Loading...</span>
                  </div>
                  
                  <div class="product-description">
                    <h4>Mô tả</h4>
                    <p id="productDescription">Loading product description...</p>
                  </div>
                </div>
                
                <div class="product-info-section">
                  <h4>Thông số kỹ thuật</h4>
                  <div id="specsContent" class="product-specs">
                    <!-- Specs will be inserted here -->
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>


                          <li>
                            <div class="rating-stars">
                              <i class="fa fa-star"></i>
                              <i class="fa fa-star"></i>
                              <i class="fa fa-star"></i>
                              <i class="fa fa-star"></i>
                              <i class="fa fa-star-o"></i>
                            </div>
                            <div class="rating-progress">
                              <div style="width: 60%"></div>
                            </div>
                            <span class="sum">2</span>
                          </li>
                        </ul>
                      </div>
                    </div>
                    <!-- /Rating -->

                    <!-- Reviews -->
                    <div class="col-md-6">
                      <div id="reviews">
                        <ul class="reviews">
                          <li>
                            <div class="review-heading">
                              <h5 class="name">John</h5>
                              <p class="date">27 DEC 2018, 8:0 PM</p>
                              <div class="review-rating">
                                <i class="fa fa-star"></i>
                                <i class="fa fa-star"></i>
                                <i class="fa fa-star"></i>
                                <i class="fa fa-star"></i>
                                <i class="fa fa-star-o empty"></i>
                              </div>
                            </div>
                            <div class="review-body">
                              <p>Sản phẩm rất tốt, chất lượng xuất sắc!</p>
                            </div>
                          </li>
                        </ul>
                      </div>
                    </div>
                    <!-- /Reviews -->

                    <!-- Review Form -->
                    <div class="col-md-3">
                      <div id="review-form">
                        <form class="review-form">
                          <input
                            class="input"
                            type="text"
                            placeholder="Tên của bạn"
                          />
                          <input
                            class="input"
                            type="email"
                            placeholder="Email"
                          />
                          <textarea
                            class="input"
                            placeholder="Đánh giá của bạn"
                          ></textarea>
                          <div class="input-rating">
                            <span>Xếp hạng: </span>
                            <div class="stars">
                              <input
                                id="star5"
                                name="rating"
                                value="5"
                                type="radio"
                              /><label for="star5"></label>
                              <input
                                id="star4"
                                name="rating"
                                value="4"
                                type="radio"
                              /><label for="star4"></label>
                              <input
                                id="star3"
                                name="rating"
                                value="3"
                                type="radio"
                              /><label for="star3"></label>
                              <input
                                id="star2"
                                name="rating"
                                value="2"
                                type="radio"
                              /><label for="star2"></label>
                              <input
                                id="star1"
                                name="rating"
                                value="1"
                                type="radio"
                              /><label for="star1"></label>
                            </div>
                          </div>
                          <button class="primary-btn">Gửi</button>
                        </form>
                      </div>
                    </div>
                    <!-- /Review Form -->
                  </div>
                </div>
                <!-- /tab3 -->
              </div>
              <!-- /product tab content -->
            </div>
          </div>
          <!-- /product tab -->
        </div>
      </div>
    </div>
    <!-- /SECTION -->

        <div class="card">
          <div class="card-header">
            <div class="card-title">Sản phẩm liên quan</div>
          </div>
          <div class="card-body">
            <div id="relatedProducts" class="related-products-grid">
              <!-- Related products will be inserted here -->
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>

<script>
      const ctx = "${pageContext.request.contextPath}";
      const isUserLoggedIn = ${isUserAuthenticated};

      // Sử dụng data từ server thay vì fetch API
      <c:if test="${not empty product}">
      var productData = {
        id: <c:out value="${product.id}"/>,
        name: "<c:out value='${product.name}'/>",
        price: <c:out value="${product.price}" default="0"/>,
        stock: <c:out value="${product.stock}" default="0"/>,
        brand: "<c:out value='${product.brand}'/>",
        imageUrl: "<c:out value='${product.imageUrl}'/>",
        imageUrls: [
          <c:forEach items="${product.imageUrls}" var="imgUrl" varStatus="status">
            "<c:out value='${imgUrl}'/>"<c:if test="${!status.last}">,</c:if>
          </c:forEach>
        ],
        <c:choose>
        <c:when test="${not empty product.category}">
        category: {
          id: <c:out value="${product.category.id}"/>,
          name: "<c:out value='${product.category.name}'/>"
        },
        </c:when>
        <c:otherwise>
        category: null,
        </c:otherwise>
        </c:choose>
        screenSize: "<c:out value='${product.screenSize}'/>",
        displayTech: "<c:out value='${product.displayTech}'/>",
        resolution: "<c:out value='${product.resolution}'/>",
        displayFeatures: "<c:out value='${product.displayFeatures}'/>",
        rearCamera: "<c:out value='${product.rearCamera}'/>",
        frontCamera: "<c:out value='${product.frontCamera}'/>",
        chipset: "<c:out value='${product.chipset}'/>",
        cpuSpecs: "<c:out value='${product.cpuSpecs}'/>",
        ram: "<c:out value='${product.ram}'/>",
        storage: "<c:out value='${product.storage}'/>",
        battery: "<c:out value='${product.battery}'/>",
        simType: "<c:out value='${product.simType}'/>",
        os: "<c:out value='${product.os}'/>",
        nfcSupport: "<c:out value='${product.nfcSupport}'/>"
      };

      console.log('Product data from server:', productData);

      // Load product ngay lập tức
      displayProduct(productData);

      // Check if product is in wishlist
      checkWishlistStatus(productData.id);

      // Load related products nếu có category
      if (productData.category && productData.category.id) {
        loadRelatedProducts(productData.category.id);
      }
      </c:if>

      <c:if test="${empty product}">
      alert("Không tìm thấy sản phẩm");
      window.location.href = ctx + '/shop';
      </c:if>

      // Add sidebar toggle functionality
      (function () {
        const sidebar = document.getElementById('sidebar');
        const toggle = document.getElementById('navToggle');
        if (!sidebar || !toggle) return;

        function isCollapsed() {
          return localStorage.getItem('admin_sidebar_collapsed') === '1';
        }

        function apply() {
          const collapsed = isCollapsed();
          if (window.innerWidth <= 800) {
            sidebar.classList.toggle('open', collapsed);
            sidebar.classList.remove('collapsed');
          } else {
            sidebar.classList.toggle('collapsed', collapsed);
            sidebar.classList.remove('open');
          }
        }

        apply();
        toggle.addEventListener('click', function () {
          const current = isCollapsed();
          localStorage.setItem('admin_sidebar_collapsed', current ? '0' : '1');
          apply();
        });
        window.addEventListener('resize', apply);
      })();
      
      function displayProduct(p) {
        // Update product details
        const titleElements = document.querySelectorAll('#productName');
        titleElements.forEach(el => el.textContent = p.name);
        
        document.getElementById('productPrice').textContent = formatPrice(p.price);
        document.getElementById('productStock').textContent = p.stock;

        // Tạo description từ specs
        var desc = 'Điện thoại ' + p.name;
        if (p.brand) desc += ' thương hiệu ' + p.brand;
        if (p.screenSize) desc += ', màn hình ' + p.screenSize;
        if (p.ram && p.storage) desc += ', ' + p.ram + ' / ' + p.storage;
        if (p.chipset) desc += ', chip ' + p.chipset;
        desc += '. Sản phẩm chính hãng, bảo hành toàn quốc.';

        document.getElementById('productDescription').textContent = desc;

        // Update category
        if (p.category) {
          document.getElementById('productCategory').textContent = p.category.name;
        }

        // Get all images
        const imgs = p.imageUrls && p.imageUrls.length ? p.imageUrls : (p.imageUrl ? [p.imageUrl] : []);

        // Update main image
        const mainImg = document.getElementById('productMainImage');
        if (imgs.length > 0) {
          const url = typeof imgs[0] === 'string' ? imgs[0] : imgs[0].url;
          mainImg.src = url.startsWith('/') ? ctx + url : url;
          mainImg.alt = p.name;
        }

        // Update thumbnails
        const thumbsContainer = document.getElementById('product-imgs');
        thumbsContainer.innerHTML = '';

        if (imgs.length > 0) {
          imgs.forEach((u, index) => {
            const url = typeof u === 'string' ? u : u.url;
            const thumbDiv = document.createElement('div');
            thumbDiv.className = 'product-preview';
            const thumbImg = document.createElement('img');
            thumbImg.src = url.startsWith('/') ? ctx + url : url;
            thumbImg.alt = p.name;
            thumbImg.style.cursor = 'pointer';
            thumbImg.dataset.index = index;
            thumbDiv.appendChild(thumbImg);
            thumbsContainer.appendChild(thumbDiv);
          });
        }

        // Display specs in the specs section
        displaySpecs(p);

        // Add thumbnail click handling
        const thumbnails = document.querySelectorAll('#product-imgs img');
        thumbnails.forEach(thumb => {
          thumb.addEventListener('click', function() {
            const url = this.src;
            document.getElementById('productMainImage').src = url;
            
            // Remove active class from all thumbnails
            thumbnails.forEach(t => t.classList.remove('active'));
            
            // Add active class to clicked thumbnail
            this.classList.add('active');
          });
        });
        
        // Activate the first thumbnail
        if (thumbnails.length > 0) {
          thumbnails[0].classList.add('active');
        }


      }

      function displaySpecs(p) {
        const specsContainer = document.getElementById('specsContent');
        specsContainer.innerHTML = '';
        
        // Create specs items
        const specs = [
          { name: 'Thương hiệu', value: p.brand },
          { name: 'Kích thước màn hình', value: p.screenSize },
          { name: 'Công nghệ màn hình', value: p.displayTech },
          { name: 'Độ phân giải', value: p.resolution },
          { name: 'Tính năng màn hình', value: p.displayFeatures },
          { name: 'Camera sau', value: p.rearCamera },
          { name: 'Camera trước', value: p.frontCamera },
          { name: 'Chipset', value: p.chipset },
          { name: 'CPU', value: p.cpuSpecs },
          { name: 'RAM', value: p.ram },
          { name: 'Bộ nhớ trong', value: p.storage },
          { name: 'Pin', value: p.battery },
          { name: 'Loại SIM', value: p.simType },
          { name: 'Hệ điều hành', value: p.os },
          { name: 'Hỗ trợ NFC', value: p.nfcSupport },
        ];

        // Display specs as grid
        specs.forEach(spec => {
          if (spec.value) {
            const specItem = document.createElement('div');
            specItem.className = 'spec-item';
            
            const specName = document.createElement('span');
            specName.className = 'spec-name';
            specName.textContent = spec.name;
            
            const specValue = document.createElement('span');
            specValue.className = 'spec-value';
            specValue.textContent = spec.value;
            
            specItem.appendChild(specName);
            specItem.appendChild(specValue);
            specsContainer.appendChild(specItem);
          }
        });
      }

      function formatPrice(price) {
        if (!price) return '0 ₫';
        return price.toLocaleString('vi-VN') + ' ₫';
      }

      async function addToCart(productId, quantity) {
        // Check if user is logged in
        if (!isUserLoggedIn) {
          alert('Vui lòng đăng nhập để thêm vào giỏ hàng');
          window.location.href = ctx + '/login';
          return;
        }

        try {
          const response = await fetch(ctx + '/api/cart/add', {
            method: 'POST',
            headers: {
              'Content-Type': 'application/json'
            },
            credentials: 'include',
            body: JSON.stringify({ productId: productId, quantity: quantity })
          });

          if (response.ok) {
            alert('Đã thêm vào giỏ hàng!');
            // Update cart count in header
            if (typeof updateGlobalCartCount === 'function') {
              updateGlobalCartCount();
            }
          } else if (response.status === 401 || response.status === 403) {
            alert('Vui lòng đăng nhập để thêm vào giỏ hàng');
            window.location.href = ctx + '/login';
          } else {
            alert('Có lỗi xảy ra. Vui lòng thử lại.');
          }
        } catch (error) {
          console.error('Error adding to cart:', error);
          alert('Có lỗi xảy ra. Vui lòng thử lại.');
        }
      }

      async function addToWishlist(productId) {
        try {
          var btn = document.getElementById('addToWishlistBtn');
          var icon = btn.querySelector('i');
          var isInWishlist = icon.classList.contains('fa-heart');

          var url = isInWishlist
            ? ctx + '/api/favorite/remove/' + productId
            : ctx + '/api/favorite/add';
          var method = isInWishlist ? 'DELETE' : 'POST';
          var body = isInWishlist ? null : JSON.stringify({ productId: productId });

          const response = await fetch(url, {
            method: method,
            headers: {
              'Content-Type': 'application/json'
            },
            credentials: 'include',
            body: body
          });

          if (response.ok) {
            if (isInWishlist) {
              // Remove from wishlist
              alert('Đã xóa khỏi danh sách yêu thích!');
              icon.classList.remove('fa-heart');
              icon.classList.add('fa-heart-o');
              btn.style.color = '';
            } else {
              // Add to wishlist
              alert('Đã thêm vào danh sách yêu thích!');
              icon.classList.remove('fa-heart-o');
              icon.classList.add('fa-heart');
              btn.style.color = '#d70018';
            }
            // Update wishlist count in header
            if (typeof updateGlobalWishlistCount === 'function') {
              updateGlobalWishlistCount();
            }
          } else if (response.status === 401 || response.status === 403) {
            alert('Vui lòng đăng nhập để thao tác với danh sách yêu thích');
            window.location.href = ctx + '/login';
          } else {
            alert('Có lỗi xảy ra. Vui lòng thử lại.');
          }
        } catch (error) {
          console.error('Error toggling wishlist:', error);
          alert('Có lỗi xảy ra. Vui lòng thử lại.');
        }
      }

      function checkWishlistStatus(productId) {
        // Check if this product is in wishlist
        fetch(ctx + '/api/favorite', {
          credentials: 'include'
        })
          .then(res => res.ok ? res.json() : [])
          .then(favorites => {
            const isInWishlist = favorites.some(fav => fav.productId == productId);
            if (isInWishlist) {
              var btn = document.getElementById('addToWishlistBtn');
              if (btn) {
                var icon = btn.querySelector('i');
                icon.classList.remove('fa-heart-o');
                icon.classList.add('fa-heart');
                btn.style.color = '#d70018';
              }
            }
          })
          .catch(err => console.error('Error checking wishlist status:', err));
      }

      async function loadRelatedProducts(categoryId) {
        if (!categoryId) {
          console.log('No categoryId provided for related products');
          return;
        }

        try {
          console.log('Loading related products for category:', categoryId);
          const response = await fetch(ctx + '/api/products?categoryId=' + categoryId + '&limit=4');

          if (!response.ok) {
            console.error('Failed to fetch related products:', response.status, response.statusText);
            return;
          }

          const products = await response.json();
          console.log('Related products loaded:', products);

          const container = document.getElementById('relatedProducts');

          if (!products || products.length === 0) {
            console.log('No related products found');
            container.innerHTML = '<div class="col-md-12"><p class="text-center">Không có sản phẩm liên quan</p></div>';
            return;
          }

          container.innerHTML = '';
          products.slice(0, 4).forEach(product => {
            const categoryName = product.category ? product.category.name : 'Chưa phân loại';
            const imgSrc = product.imageUrl ? ctx + product.imageUrl : ctx + '/images/no-image.png';
            const discountLabel = product.discount ? '<div class="product-label"><span class="sale">-' + product.discount + '%</span></div>' : '';

            const productHtml = '<div class="col-md-3 col-xs-6">' +
              '<div class="product">' +
                '<div class="product-img">' +
                  '<img src="' + imgSrc + '" alt="' + product.name + '">' +
                  discountLabel +
                '</div>' +
                '<div class="product-body">' +
                  '<p class="product-category">' + categoryName + '</p>' +
                  '<h3 class="product-name"><a href="' + ctx + '/product/' + product.id + '">' + product.name + '</a></h3>' +
                  '<h4 class="product-price">' + formatPrice(product.price) + '</h4>' +
                  '<div class="product-rating">' +
                    '<i class="fa fa-star"></i>' +
                    '<i class="fa fa-star"></i>' +
                    '<i class="fa fa-star"></i>' +
                    '<i class="fa fa-star"></i>' +
                    '<i class="fa fa-star-o"></i>' +
                  '</div>' +
                  '<div class="product-btns">' +
                    '<button class="add-to-wishlist" data-product-id="' + product.id + '" onclick="toggleRelatedWishlist(' + product.id + ', this)"><i class="fa fa-heart-o"></i><span class="tooltipp">Yêu thích</span></button>' +
                    '<button class="quick-view" onclick="window.location.href=\'' + ctx + '/product/' + product.id + '\'"><i class="fa fa-eye"></i><span class="tooltipp">Xem chi tiết</span></button>' +
                  '</div>' +
                '</div>' +
                '<div class="add-to-cart">' +
                  '<button class="add-to-cart-btn" onclick="addToCart(' + product.id + ', 1)"><i class="fa fa-shopping-cart"></i> Thêm vào giỏ</button>' +
                '</div>' +
              '</div>' +
            '</div>';

            container.innerHTML += productHtml;
          });

          // Load wishlist status for related products only if user is logged in
          if (isUserLoggedIn) {
            loadRelatedWishlistStatus();
          }
        } catch (error) {
          console.error('Error loading related products:', error);
        }
      }

      // Toggle wishlist for related products
      async function toggleRelatedWishlist(productId, button) {
        // Check if user is logged in
        if (!isUserLoggedIn) {
          alert('Vui lòng đăng nhập để thao tác với danh sách yêu thích');
          window.location.href = ctx + '/login';
          return;
        }

        try {
          var icon = button.querySelector('i');
          var isInWishlist = icon.classList.contains('fa-heart');

          var url = isInWishlist
            ? ctx + '/api/favorite/remove/' + productId
            : ctx + '/api/favorite/add';
          var method = isInWishlist ? 'DELETE' : 'POST';
          var body = isInWishlist ? null : JSON.stringify({ productId: productId });

          const response = await fetch(url, {
            method: method,
            headers: {
              'Content-Type': 'application/json'
            },
            credentials: 'include',
            body: body
          });

          if (response.ok) {
            if (isInWishlist) {
              // Remove from wishlist
              icon.classList.remove('fa-heart');
              icon.classList.add('fa-heart-o');
              button.style.color = '';
              alert('Đã xóa khỏi danh sách yêu thích!');
            } else {
              // Add to wishlist
              icon.classList.remove('fa-heart-o');
              icon.classList.add('fa-heart');
              button.style.color = '#d70018';
              alert('Đã thêm vào danh sách yêu thích!');
            }
            // Update wishlist count in header
            if (typeof updateGlobalWishlistCount === 'function') {
              updateGlobalWishlistCount();
            }
          } else if (response.status === 401 || response.status === 403) {
            alert('Vui lòng đăng nhập để thao tác với danh sách yêu thích');
            window.location.href = ctx + '/login';
          } else {
            alert('Có lỗi xảy ra. Vui lòng thử lại.');
          }
        } catch (error) {
          console.error('Error toggling wishlist:', error);
          alert('Có lỗi xảy ra. Vui lòng thử lại.');
        }
      }

      // Load wishlist status for related products
      function loadRelatedWishlistStatus() {
        fetch(ctx + '/api/favorite', {
          credentials: 'include'
        })
          .then(res => res.ok ? res.json() : [])
          .then(favorites => {
            favorites.forEach(favorite => {
              var buttons = document.querySelectorAll('.add-to-wishlist[data-product-id="' + favorite.productId + '"]');
              buttons.forEach(button => {
                var icon = button.querySelector('i');
                if (icon) {
                  icon.classList.remove('fa-heart-o');
                  icon.classList.add('fa-heart');
                  button.style.color = '#d70018';
                }
              });
            });
          })
          .catch(err => console.error('Error loading wishlist status:', err));
      }
    </script>
  </body>
</html>

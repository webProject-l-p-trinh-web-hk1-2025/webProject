<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="org.springframework.security.core.context.SecurityContextHolder" %>
<%@ page import="org.springframework.security.core.Authentication" %>
<%@ page import="org.springframework.security.authentication.AnonymousAuthenticationToken" %>
<%
    Authentication auth = SecurityContextHolder.getContext().getAuthentication();
    boolean isAuthenticated = auth != null && auth.isAuthenticated() && !(auth instanceof AnonymousAuthenticationToken);
    request.setAttribute("isUserAuthenticated", isAuthenticated);
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Chi tiết sản phẩm - <c:out value="${product.name}" default="Sản phẩm"/></title>
</head>
<body>
<!-- BREADCRUMB -->
<div id="breadcrumb" class="section">
  <div class="container">
    <div class="row">
      <div class="col-md-12">
        <ul class="breadcrumb-tree">
          <li><a href="${pageContext.request.contextPath}/">Trang chủ</a></li>
          <li><a href="${pageContext.request.contextPath}/shop">Sản phẩm</a></li>
          <li class="active" id="breadcrumbName">Chi tiết sản phẩm</li>
        </ul>
      </div>
    </div>
  </div>
</div>
<!-- /BREADCRUMB -->

<!-- SECTION -->
<div class="section">
  <div class="container">
    <div class="row">
      <!-- Product main img -->
      <div class="col-md-5 col-md-push-2">
        <div id="product-main-img">
          <!-- Main images will be inserted here -->
        </div>
      </div>
      <!-- /Product main img -->

      <!-- Product thumb imgs -->
      <div class="col-md-2 col-md-pull-5">
        <div id="product-imgs">
          <!-- Thumbnails will be inserted here -->
        </div>
      </div>
      <!-- /Product thumb imgs -->

      <!-- Product details -->
      <div class="col-md-5">
        <div class="product-details">
          <h2 class="product-name" id="productName">Loading...</h2>
          <div>
            <div class="product-rating" id="productRating">
              <i class="fa fa-star"></i>
              <i class="fa fa-star"></i>
              <i class="fa fa-star"></i>
              <i class="fa fa-star"></i>
              <i class="fa fa-star-o"></i>
            </div>
            <a class="review-link" href="#tab3">10 Review(s) | Add your review</a>
          </div>
          <div>
            <h3 class="product-price" id="productPrice">$0.00</h3>
            <span class="product-available" id="productStock">In Stock</span>
          </div>
          <p id="productDescription">Loading product description...</p>

          <div class="add-to-cart">
            <div class="qty-label">
              Qty
              <div class="input-number">
                <input type="number" id="quantity" value="1" min="1">
                <span class="qty-up">+</span>
                <span class="qty-down">-</span>
              </div>
            </div>
            <button class="add-to-cart-btn" id="addToCartBtn"><i class="fa fa-shopping-cart"></i> add to cart</button>
          </div>

          <ul class="product-btns">
            <li><a href="#" id="addToWishlistBtn"><i class="fa fa-heart-o"></i> add to wishlist</a></li>
            <li><a href="#"><i class="fa fa-exchange"></i> add to compare</a></li>
          </ul>

          <ul class="product-links">
            <li>Category:</li>
            <li><a href="#" id="productCategory">Category</a></li>
          </ul>

          <ul class="product-links">
            <li>Share:</li>
            <li><a href="#"><i class="fa fa-facebook"></i></a></li>
            <li><a href="#"><i class="fa fa-twitter"></i></a></li>
            <li><a href="#"><i class="fa fa-google-plus"></i></a></li>
            <li><a href="#"><i class="fa fa-envelope"></i></a></li>
          </ul>
        </div>
      </div>
      <!-- /Product details -->

      <!-- Product tab -->
      <div class="col-md-12">
        <div id="product-tab">
          <!-- product tab nav -->
          <ul class="tab-nav">
            <li class="active"><a data-toggle="tab" href="#tab1">Mô tả</a></li>
            <li><a data-toggle="tab" href="#tab2">Thông số kỹ thuật</a></li>
            <li><a data-toggle="tab" href="#tab3">Đánh giá (0)</a></li>
          </ul>
          <!-- /product tab nav -->

          <!-- product tab content -->
          <div class="tab-content">
            <!-- tab1 -->
            <div id="tab1" class="tab-pane fade in active">
              <div class="row">
                <div class="col-md-12">
                  <p id="tabDescription">Đang tải thông tin sản phẩm...</p>
                </div>
              </div>
            </div>
            <!-- /tab1 -->

            <!-- tab2 -->
            <div id="tab2" class="tab-pane fade in">
              <div class="row">
                <div class="col-md-12">
                  <div id="specsContent">
                    <p>Đang tải thông số kỹ thuật...</p>
                  </div>
                </div>
              </div>
            </div>
            <!-- /tab2 -->

            <!-- tab3 -->
            <div id="tab3" class="tab-pane fade in">
              <div class="row">
                <!-- Rating -->
                <div class="col-md-3">
                  <div id="rating">
                    <div class="rating-avg">
                      <span>4.5</span>
                      <div class="rating-stars">
                        <i class="fa fa-star"></i>
                        <i class="fa fa-star"></i>
                        <i class="fa fa-star"></i>
                        <i class="fa fa-star"></i>
                        <i class="fa fa-star-o"></i>
                      </div>
                    </div>
                    <ul class="rating">
                      <li>
                        <div class="rating-stars">
                          <i class="fa fa-star"></i>
                          <i class="fa fa-star"></i>
                          <i class="fa fa-star"></i>
                          <i class="fa fa-star"></i>
                          <i class="fa fa-star"></i>
                        </div>
                        <div class="rating-progress">
                          <div style="width: 80%;"></div>
                        </div>
                        <span class="sum">3</span>
                      </li>
                      <li>
                        <div class="rating-stars">
                          <i class="fa fa-star"></i>
                          <i class="fa fa-star"></i>
                          <i class="fa fa-star"></i>
                          <i class="fa fa-star"></i>
                          <i class="fa fa-star-o"></i>
                        </div>
                        <div class="rating-progress">
                          <div style="width: 60%;"></div>
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
                      <input class="input" type="text" placeholder="Tên của bạn">
                      <input class="input" type="email" placeholder="Email">
                      <textarea class="input" placeholder="Đánh giá của bạn"></textarea>
                      <div class="input-rating">
                        <span>Xếp hạng: </span>
                        <div class="stars">
                          <input id="star5" name="rating" value="5" type="radio"><label for="star5"></label>
                          <input id="star4" name="rating" value="4" type="radio"><label for="star4"></label>
                          <input id="star3" name="rating" value="3" type="radio"><label for="star3"></label>
                          <input id="star2" name="rating" value="2" type="radio"><label for="star2"></label>
                          <input id="star1" name="rating" value="1" type="radio"><label for="star1"></label>
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

<!-- Section -->
<div class="section">
  <div class="container">
    <div class="row">
      <div class="col-md-12">
        <div class="section-title text-center">
          <h3 class="title">Sản phẩm liên quan</h3>
        </div>
      </div>
      <div id="relatedProducts" class="row">
        <!-- Related products will be inserted here -->
      </div>
    </div>
  </div>
</div>
<!-- /Section -->

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

function displayProduct(p) {
  // Update breadcrumb
  document.getElementById('breadcrumbName').textContent = p.name;
  
  // Update product details
  document.getElementById('productName').textContent = p.name;
  document.getElementById('productPrice').textContent = formatPrice(p.price);
  document.getElementById('productStock').textContent = p.stock > 0 ? 'Còn hàng' : 'Hết hàng';
  
  // Tạo description từ specs
  var desc = 'Điện thoại ' + p.name;
  if (p.brand) desc += ' thương hiệu ' + p.brand;
  if (p.screenSize) desc += ', màn hình ' + p.screenSize;
  if (p.ram && p.storage) desc += ', ' + p.ram + ' / ' + p.storage;
  if (p.chipset) desc += ', chip ' + p.chipset;
  desc += '. Sản phẩm chính hãng, bảo hành toàn quốc.';
  
  document.getElementById('productDescription').textContent = desc;
  document.getElementById('tabDescription').textContent = desc;
  
  // Update category
  if (p.category) {
    document.getElementById('productCategory').textContent = p.category.name;
  }
  
  // Get all images
  const imgs = p.imageUrls && p.imageUrls.length ? p.imageUrls : (p.imageUrl ? [p.imageUrl] : []);
  
  // Update main images slider
  const mainImgContainer = document.getElementById('product-main-img');
  mainImgContainer.innerHTML = '';
  
  if (imgs.length > 0) {
    imgs.forEach((u) => {
      const url = typeof u === 'string' ? u : u.url;
      const mainDiv = document.createElement('div');
      mainDiv.className = 'product-preview';
      const mainImg = document.createElement('img');
      mainImg.src = url.startsWith('/') ? ctx + url : url;
      mainImg.alt = p.name;
      mainDiv.appendChild(mainImg);
      mainImgContainer.appendChild(mainDiv);
    });
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
  
  // Update specs in tab2
  displaySpecs(p);
  
  // Initialize slick carousel for product images
  setTimeout(() => {
    if (typeof $.fn.slick !== 'undefined') {
      // Destroy existing slick instances if any
      if ($('#product-main-img').hasClass('slick-initialized')) {
        $('#product-main-img').slick('unslick');
      }
      if ($('#product-imgs').hasClass('slick-initialized')) {
        $('#product-imgs').slick('unslick');
      }
      
      $('#product-main-img').slick({
        infinite: true,
        speed: 300,
        slidesToShow: 1,
        arrows: false,
        fade: true,
        asNavFor: '#product-imgs'
      });
      
      $('#product-imgs').slick({
        slidesToShow: 3,
        slidesToScroll: 1,
        arrows: true,
        vertical: true,
        verticalSwiping: true,
        focusOnSelect: true,
        asNavFor: '#product-main-img',
        responsive: [{
          breakpoint: 991,
          settings: {
            vertical: false,
            slidesToShow: 4
          }
        }]
      });
    }
  }, 100);
  
  // Setup add to cart button
  document.getElementById('addToCartBtn').addEventListener('click', () => {
    const quantity = parseInt(document.getElementById('quantity').value) || 1;
    addToCart(p.id, quantity);
  });
  
  // Setup add to wishlist button
  document.getElementById('addToWishlistBtn').addEventListener('click', (e) => {
    e.preventDefault();
    addToWishlist(p.id);
  });
  
  // Setup quantity controls
  document.querySelector('.qty-up').addEventListener('click', () => {
    const input = document.getElementById('quantity');
    input.value = parseInt(input.value) + 1;
  });
  
  document.querySelector('.qty-down').addEventListener('click', () => {
    const input = document.getElementById('quantity');
    if (parseInt(input.value) > 1) {
      input.value = parseInt(input.value) - 1;
    }
  });
}

function displaySpecs(p) {
  const specsContainer = document.getElementById('specsContent');
  const specs = [];
  
  // Collect all specs
  if (p.brand) specs.push({ key: 'Thương hiệu', value: p.brand });
  if (p.screenSize) specs.push({ key: 'Kích thước màn hình', value: p.screenSize });
  if (p.displayTech) specs.push({ key: 'Công nghệ màn hình', value: p.displayTech });
  if (p.resolution) specs.push({ key: 'Độ phân giải', value: p.resolution });
  if (p.displayFeatures) specs.push({ key: 'Tính năng màn hình', value: p.displayFeatures });
  if (p.rearCamera) specs.push({ key: 'Camera sau', value: p.rearCamera });
  if (p.frontCamera) specs.push({ key: 'Camera trước', value: p.frontCamera });
  if (p.chipset) specs.push({ key: 'Chipset', value: p.chipset });
  if (p.cpuSpecs) specs.push({ key: 'CPU', value: p.cpuSpecs });
  if (p.ram) specs.push({ key: 'RAM', value: p.ram });
  if (p.storage) specs.push({ key: 'Bộ nhớ trong', value: p.storage });
  if (p.battery) specs.push({ key: 'Pin', value: p.battery });
  if (p.simType) specs.push({ key: 'Loại SIM', value: p.simType });
  if (p.os) specs.push({ key: 'Hệ điều hành', value: p.os });
  if (p.nfcSupport) specs.push({ key: 'Hỗ trợ NFC', value: p.nfcSupport });
  
  // Add custom specs
  if (p.specs && Array.isArray(p.specs)) {
    p.specs.forEach(s => {
      if (s && s.key) specs.push({ key: s.key, value: s.value });
    });
  }
  
  if (specs.length > 0) {
    let html = '<table class="table table-striped">';
    specs.forEach(spec => {
      html += '<tr>';
      html += '<td style="width: 40%; font-weight: 500;">' + spec.key + '</td>';
      html += '<td>' + (spec.value || '') + '</td>';
      html += '</tr>';
    });
    html += '</table>';
    specsContainer.innerHTML = html;
  } else {
    specsContainer.innerHTML = '<p>Chưa có thông số kỹ thuật.</p>';
  }
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
    
    console.log('Response status:', response.status);
    
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

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!-- FOOTER -->
<footer id="footer">
    <!-- top footer -->
    <div class="section">
        <div class="container">
            <div class="row">
                <div class="col-md-3 col-xs-6">
                    <div class="footer">
                        <h3 class="footer-title">Về chúng tôi</h3>
                        <p>Cửa hàng điện thoại uy tín, chuyên cung cấp các sản phẩm điện thoại chính hãng với giá cả cạnh tranh nhất thị trường.</p>
                        <ul class="footer-links">
                            <li><a href="#"><i class="fa fa-map-marker"></i>268 Lý Thường Kiệt, Quận 10, TP.HCM</a></li>
                            <li><a href="#"><i class="fa fa-phone"></i>+84 123-456-789</a></li>
                            <li><a href="#"><i class="fa fa-envelope-o"></i>contact@phonestore.vn</a></li>
                        </ul>
                    </div>
                </div>

                <div class="col-md-3 col-xs-6">
                    <div class="footer">
                        <h3 class="footer-title">Danh mục</h3>
                        <ul class="footer-links">
                            <li><a href="${pageContext.request.contextPath}/">Trang chủ</a></li>
                            <li><a href="${pageContext.request.contextPath}/products">Sản phẩm</a></li>
                            <li><a href="${pageContext.request.contextPath}/deals">Khuyến mãi</a></li>
                            <li><a href="${pageContext.request.contextPath}/about">Giới thiệu</a></li>
                            <li><a href="${pageContext.request.contextPath}/contact">Liên hệ</a></li>
                        </ul>
                    </div>
                </div>

                <div class="clearfix visible-xs"></div>

                <div class="col-md-3 col-xs-6">
                    <div class="footer">
                        <h3 class="footer-title">Hỗ trợ khách hàng</h3>
                        <ul class="footer-links">
                            <li><a href="${pageContext.request.contextPath}/faq">Câu hỏi thường gặp</a></li>
                            <li><a href="${pageContext.request.contextPath}/warranty">Chính sách bảo hành</a></li>
                            <li><a href="${pageContext.request.contextPath}/return">Đổi trả hàng</a></li>
                            <li><a href="${pageContext.request.contextPath}/payment">Hướng dẫn thanh toán</a></li>
                            <li><a href="${pageContext.request.contextPath}/shipping">Vận chuyển</a></li>
                        </ul>
                    </div>
                </div>

                <div class="col-md-3 col-xs-6">
                    <div class="footer">
                        <h3 class="footer-title">Tài khoản</h3>
                        <ul class="footer-links">
                            <li><a href="${pageContext.request.contextPath}/profile">Thông tin tài khoản</a></li>
                            <li><a href="${pageContext.request.contextPath}/cart">Giỏ hàng</a></li>
                            <li><a href="${pageContext.request.contextPath}/wishlist">Yêu thích</a></li>
                            <li><a href="${pageContext.request.contextPath}/orders">Đơn hàng của tôi</a></li>
                            <li><a href="${pageContext.request.contextPath}/help">Trợ giúp</a></li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- /top footer -->

    <!-- bottom footer -->
    <div id="bottom-footer" class="section">
        <div class="container">
            <div class="row">
                <div class="col-md-12 text-center">
                    <ul class="footer-payments">
                        <li><a href="#"><i class="fa fa-cc-visa"></i></a></li>
                        <li><a href="#"><i class="fa fa-credit-card"></i></a></li>
                        <li><a href="#"><i class="fa fa-cc-paypal"></i></a></li>
                        <li><a href="#"><i class="fa fa-cc-mastercard"></i></a></li>
                    </ul>
                    <span class="copyright">
                        Copyright &copy;<script>document.write(new Date().getFullYear());</script> 
                        PhoneStore - Dự án Web bán điện thoại
                    </span>
                </div>
            </div>
        </div>
    </div>
    <!-- /bottom footer -->
</footer>
<!-- /FOOTER -->

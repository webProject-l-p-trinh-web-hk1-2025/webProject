<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<title>Kết quả thanh toán</title>

<script>
    const urlParams = new URLSearchParams(window.location.search);
    
    // Bảng mã lỗi vnp_ResponseCode
    const responseCodeMessages = {
        "00": "Giao dịch thành công",
        "07": "Trừ tiền thành công. Giao dịch bị nghi ngờ (liên quan tới lừa đảo, giao dịch bất thường)",
        "09": "Giao dịch không thành công do: Thẻ/Tài khoản của khách hàng chưa đăng ký dịch vụ InternetBanking tại ngân hàng",
        "10": "Giao dịch không thành công do: Khách hàng xác thực thông tin thẻ/tài khoản không đúng quá 3 lần",
        "11": "Giao dịch không thành công do: Đã hết hạn chờ thanh toán. Xin quý khách vui lòng thực hiện lại giao dịch",
        "12": "Giao dịch không thành công do: Thẻ/Tài khoản của khách hàng bị khóa",
        "13": "Giao dịch không thành công do Quý khách nhập sai mật khẩu xác thực giao dịch (OTP). Xin quý khách vui lòng thực hiện lại giao dịch",
        "24": "Giao dịch không thành công do: Khách hàng hủy giao dịch",
        "51": "Giao dịch không thành công do: Tài khoản của quý khách không đủ số dư để thực hiện giao dịch",
        "65": "Giao dịch không thành công do: Tài khoản của Quý khách đã vượt quá hạn mức giao dịch trong ngày",
        "75": "Ngân hàng thanh toán đang bảo trì",
        "79": "Giao dịch không thành công do: KH nhập sai mật khẩu thanh toán quá số lần quy định. Xin quý khách vui lòng thực hiện lại giao dịch",
        "99": "Các lỗi khác (lỗi còn lại, không có trong danh sách mã lỗi đã liệt kê)"
    };
    
    // Bảng mã lỗi vnp_TransactionStatus
    const transactionStatusMessages = {
        "00": "Giao dịch thanh toán thành công",
        "01": "Giao dịch chưa hoàn tất",
        "02": "Giao dịch bị lỗi",
        "04": "Giao dịch đảo (Khách hàng đã bị trừ tiền tại Ngân hàng nhưng GD chưa thành công ở VNPAY)",
        "05": "VNPAY đang xử lý giao dịch này (GD hoàn tiền)",
        "06": "VNPAY đã gửi yêu cầu hoàn tiền sang Ngân hàng (GD hoàn tiền)",
        "07": "Giao dịch bị nghi ngờ gian lận",
        "09": "GD Hoàn trả bị từ chối"
    };
    
    const responseCode = urlParams.get('vnp_ResponseCode');
    const transactionStatus = urlParams.get('vnp_TransactionStatus');
    
    if (responseCode) {
        console.log("\n Mã phản hồi (vnp_ResponseCode): " + responseCode);
        console.log(" Chi tiết: " + (responseCodeMessages[responseCode] || "Mã lỗi không xác định"));
    }
    
    if (transactionStatus) {
        console.log("\n Trạng thái giao dịch (vnp_TransactionStatus): " + transactionStatus);
        console.log(" Chi tiết: " + (transactionStatusMessages[transactionStatus] || "Trạng thái không xác định"));
    }
    
</script>

<style>
    .payment-result-page {
        min-height: 80vh;
        display: flex;
        justify-content: center;
        align-items: center;
        padding: 40px 20px;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    }

    .result-container {
        background-color: #fff;
        padding: 60px 50px;
        border-radius: 20px;
        box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
        max-width: 500px;
        width: 100%;
        text-align: center;
        animation: slideUp 0.6s ease-out;
    }

    .success-icon {
        width: 100px;
        height: 100px;
        margin: 0 auto 30px;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        animation: scaleIn 0.5s ease-out 0.2s both;
    }

    .success-icon svg {
        width: 60px;
        height: 60px;
        stroke: white;
        stroke-width: 3;
        stroke-linecap: round;
        stroke-linejoin: round;
        fill: none;
        animation: checkmark 0.8s ease-out 0.4s both;
    }

    .error-icon {
        width: 100px;
        height: 100px;
        margin: 0 auto 30px;
        background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        animation: scaleIn 0.5s ease-out 0.2s both;
    }

    .error-icon svg {
        width: 60px;
        height: 60px;
        stroke: white;
        stroke-width: 3;
        stroke-linecap: round;
        stroke-linejoin: round;
        fill: none;
    }

    .result-container h2 {
        color: #2d3748;
        margin-bottom: 15px;
        font-size: 32px;
        font-weight: 700;
        animation: fadeIn 0.6s ease-out 0.3s both;
    }

    .success-message {
        color: #48bb78;
        font-size: 20px;
        margin-bottom: 30px;
        font-weight: 500;
        animation: fadeIn 0.6s ease-out 0.4s both;
    }

    .error-message {
        color: #f56565;
        font-size: 20px;
        margin-bottom: 20px;
        font-weight: 500;
        animation: fadeIn 0.6s ease-out 0.4s both;
    }

    .description {
        color: #718096;
        font-size: 16px;
        line-height: 1.6;
        margin-bottom: 40px;
        animation: fadeIn 0.6s ease-out 0.5s both;
    }

    .button-group {
        display: flex;
        gap: 15px;
        justify-content: center;
        animation: fadeIn 0.6s ease-out 0.6s both;
    }

    a.button {
        display: inline-block;
        padding: 14px 32px;
        color: white;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        border-radius: 50px;
        text-decoration: none;
        font-weight: 600;
        font-size: 16px;
        transition: all 0.3s ease;
        box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
    }

    a.button:hover {
        transform: translateY(-2px);
        box-shadow: 0 6px 20px rgba(102, 126, 234, 0.6);
    }

    a.button.secondary {
        background: linear-gradient(135deg, #a8edea 0%, #fed6e3 100%);
        color: #2d3748;
        box-shadow: 0 4px 15px rgba(168, 237, 234, 0.4);
    }

    a.button.secondary:hover {
        box-shadow: 0 6px 20px rgba(168, 237, 234, 0.6);
    }

    @keyframes slideUp {
        from {
            opacity: 0;
            transform: translateY(30px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }

    @keyframes fadeIn {
        from {
            opacity: 0;
        }
        to {
            opacity: 1;
        }
    }

    @keyframes scaleIn {
        from {
            transform: scale(0);
        }
        to {
            transform: scale(1);
        }
    }

    @keyframes checkmark {
        from {
            stroke-dasharray: 100;
            stroke-dashoffset: 100;
        }
        to {
            stroke-dasharray: 100;
            stroke-dashoffset: 0;
        }
    }
</style>

<div class="payment-result-page">
    <div class="result-container">
        <c:choose>
            <c:when test="${success}">
                <div class="success-icon">
                    <svg viewBox="0 0 52 52">
                        <path d="M14 27l9 9 19-19"/>
                    </svg>
                </div>
                <h2>Thanh toán thành công!</h2>
                <p class="success-message">Đơn hàng của bạn đã được xác nhận</p>
                <p class="description">
                    Cảm ơn bạn đã mua sắm tại cửa hàng chúng tôi. 
                    Đơn hàng của bạn đang được xử lý và sẽ sớm được giao đến bạn.
                </p>
            </c:when>
            <c:otherwise>
                <div class="error-icon">
                    <svg viewBox="0 0 52 52">
                        <line x1="16" y1="16" x2="36" y2="36"/>
                        <line x1="36" y1="16" x2="16" y2="36"/>
                    </svg>
                </div>
                <h2>Thanh toán thất bại!</h2>
                <p class="error-message">Đã có lỗi xảy ra trong quá trình thanh toán</p>
                <p class="description">
                    ${not empty message ? message : 'Vui lòng thử lại hoặc liên hệ với chúng tôi để được hỗ trợ.'}
                </p>
            </c:otherwise>
        </c:choose>

        <div class="button-group">
            <a href="${pageContext.request.contextPath}/" class="button">Trang chủ</a>
            <a href="${pageContext.request.contextPath}/order" class="button secondary">Đơn hàng của tôi</a>
        </div>
    </div>
</div>
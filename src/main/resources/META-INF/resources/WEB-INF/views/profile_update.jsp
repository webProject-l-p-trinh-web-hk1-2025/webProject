<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Cập nhật thông tin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; }
        .container { margin-top: 24px; max-width: 920px; }
        .avatar-box{ width:160px; height:160px; border-radius:8px; overflow:hidden; background:#fff; display:inline-block }
        .avatar-box img{ width:100%; height:100%; object-fit:cover }
        .card-profile{ padding:18px; border-radius:8px; box-shadow:0 6px 18px rgba(0,0,0,0.04); background:#fff }
    </style>
</head>
<body>
<div class="container">
    <div class="card-profile">
        <h3 class="text-danger mb-3">Cập nhật thông tin</h3>

        <c:if test="${not empty success}">
            <div class="alert alert-success">${success}</div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-danger">${error}</div>
        </c:if>

    <form method="post" action="${pageContext.request.contextPath}/profile-update" enctype="multipart/form-data">
            <div class="row g-4">
                <div class="col-md-8">
                    <div class="mb-3">
                        <label class="form-label">Họ và tên</label>
                        <input type="text" name="fullname" value="${user.fullname}" class="form-control" />
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Email</label>
                        <input type="email" name="email" value="${user.email}" class="form-control" />
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Số điện thoại</label>
                        <input type="text" name="phone" value="${user.phone}" class="form-control" />
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Địa chỉ</label>
                        <input type="text" name="address" value="${user.address}" class="form-control" />
                    </div>
                </div>
                <div class="col-md-4 text-center">
                    <div class="mb-3">
                        <label class="form-label d-block">Ảnh đại diện</label>
                        <div class="avatar-box mb-2" id="avatarPreview">
                            <c:choose>
                                <c:when test="${not empty user.avatarUrl}">
                                    <img src="${pageContext.request.contextPath}${user.avatarUrl}" alt="avatar" />
                                </c:when>
                                <c:otherwise>
                                    <img src="/image/default-avatar.png" alt="avatar" />
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div>
                            <input class="form-control form-control-sm" type="file" name="avt" id="avt" accept="image/*" onchange="previewAvatar(this)" />
                        </div>
                        <small class="text-muted">JPG/PNG, tối đa 2MB</small>
                    </div>
                </div>
            </div>

            <div class="mt-3 d-flex gap-2">
                <button class="btn btn-danger">Lưu thay đổi</button>
                <a href="${pageContext.request.contextPath}/profile" class="btn btn-outline-secondary">Hủy</a>
            </div>
        </form>
    </div>
</div>

<script>
    function previewAvatar(input){
        if(!input.files || !input.files[0]) return;
        const reader = new FileReader();
        reader.onload = function(e){
            // update local preview box
            const preview = document.getElementById('avatarPreview');
            if(preview) preview.innerHTML = '<img src="'+e.target.result+'" alt="avatar" />';

            // if the profile header avatar exists on the page, update it as well
            try{
                const headerImg = document.querySelector('.profile-avatar img');
                if(headerImg) headerImg.src = e.target.result;
            }catch(err){ /* ignore if not present */ }
        };
        reader.readAsDataURL(input.files[0]);
    }
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
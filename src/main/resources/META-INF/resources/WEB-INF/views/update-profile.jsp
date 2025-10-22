<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<!doctype html>
<html>
<head>
    <meta charset="utf-8" />
    <title>Cập nhật thông tin cá nhân</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/update-profile.css" />
    <style>
        /* small inline fallback for pages that don't load static files */
        .up-grid{ gap:18px; }
    </style>
</head>
<body class="update-profile-page">
    <div class="up-card">
        <h2 class="up-title">Cập nhật thông tin cá nhân</h2>

        <c:if test="${not empty success}">
            <div class="flash success">${success}</div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="flash error">${error}</div>
        </c:if>

        <div class="up-grid">
            <div>
                <form class="up-form" action="${pageContext.request.contextPath}/update-profile" method="post" enctype="multipart/form-data">
                    <div class="form-row">
                        <label for="fullname">Họ và tên</label>
                        <input type="text" id="fullname" name="fullname" value="${fn:escapeXml(user.fullname)}" required />
                    </div>

                    <div class="form-row">
                        <label for="email">Email</label>
                        <input type="email" id="email" name="email" value="${fn:escapeXml(user.email)}" required />
                    </div>

                    <div class="form-row">
                        <label for="address">Địa chỉ</label>
                        <input type="text" id="address" name="address" value="${fn:escapeXml(user.address)}" />
                    </div>

                    <div class="form-actions">
                        <button class="btn btn-primary" type="submit">Cập nhật</button>
                        <a class="btn btn-ghost" href="${pageContext.request.contextPath}/profile">Hủy</a>
                    </div>
                </form>
            </div>

            <div class="up-side">
                <div class="avatar-wrap" id="avatarPreview">
                    <c:choose>
                        <c:when test="${not empty user.avatarUrl}">
                            <img src="${pageContext.request.contextPath}${user.avatarUrl}" alt="Avatar" />
                        </c:when>
                        <c:otherwise>
                            <img src="${pageContext.request.contextPath}/static/image/default-avatar.png" alt="Avatar" />
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="file-input">
                    <label class="note" for="avt">Chọn ảnh đại diện</label>
                    <form:form />
                    <input type="file" id="avt" name="avt" accept="image/*" onchange="previewAvatar(this)" />
                </div>
                <div style="margin-top:12px;" class="note">Kích thước tối đa 2MB. Định dạng: jpg, png.</div>
            </div>
        </div>
    </div>

    <script>
        function previewAvatar(input){
            if(!input.files || !input.files[0]) return;
            const reader = new FileReader();
            reader.onload = function(e){
                const wrap = document.getElementById('avatarPreview');
                wrap.innerHTML = '<img src="'+e.target.result+'" alt="Avatar" />';
            };
            reader.readAsDataURL(input.files[0]);
        }
    </script>
</body>
</html>
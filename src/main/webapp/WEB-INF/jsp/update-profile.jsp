<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <%@ page contentType="text/html;charset=UTF-8" %>
        <html>

        <head>
            <title>Cập nhật thông tin cá nhân</title>
        </head>

        <body>
            <h2>Cập nhật thông tin cá nhân</h2>

            <c:if test="${not empty success}">
                <p style="color:green">${success}</p>
            </c:if>
            <c:if test="${not empty error}">
                <p style="color:red">${error}</p>
            </c:if>

            <form action="${pageContext.request.contextPath}/update-profile" method="post"
                enctype="multipart/form-data">

                <div>
                    <label for="fullname">Họ và tên:</label>
                    <input type="text" id="fullname" name="fullname" value="${user.fullname}" required />
                </div>

                <div>
                    <label for="email">Email:</label>
                    <input type="email" id="email" name="email" value="${user.email}" required />
                </div>

                <div>
                    <label for="address">Địa chỉ:</label>
                    <input type="text" id="address" name="address" value="${user.address}" required />
                </div>

                <div>
                    <label for="avt">Ảnh đại diện:</label>
                    <input type="file" id="avt" name="avt" accept="image/*" />
                    <c:if test="${not empty user.avatarUrl}">
                        <br />
                        <img src="${user.avatarUrl}" alt="Avatar" width="120" height="120" />
                    </c:if>
                </div>

                <div>
                    <button type="submit">Cập nhật</button>
                </div>
            </form>

        </body>

        </html>
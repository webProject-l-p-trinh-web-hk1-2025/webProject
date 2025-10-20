<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <html>

        <head>
            <title>Danh sách Document</title>
            <style>
                table {
                    border-collapse: collapse;
                    width: 100%;
                }

                th,
                td {
                    border: 1px solid #ccc;
                    padding: 8px;
                    vertical-align: top;
                }

                th {
                    background-color: #f2f2f2;
                }

                .img-gallery {
                    display: flex;
                    flex-wrap: wrap;
                    gap: 5px;
                }

                .img-gallery img {
                    width: 80px;
                    height: 80px;
                    object-fit: cover;
                    border-radius: 4px;
                }

                .btn {
                    padding: 4px 8px;
                    text-decoration: none;
                    border-radius: 4px;
                    border: 1px solid #333;
                    cursor: pointer;
                }

                .btn-view {
                    background-color: #4CAF50;
                    color: white;
                }
            </style>
        </head>

        <body>
            <h2>Danh sách Document</h2>

            <c:if test="${not empty success}">
                <p style="color:green">${success}</p>
            </c:if>
            <c:if test="${not empty error}">
                <p style="color:red">${error}</p>
            </c:if>

            <table>
                <tr>
                    <th>ID</th>
                    <th>Title</th>
                    <th>Description</th>
                    <th>Product ID</th>
                    <th>Images</th>
                    <th>Hành động</th>
                </tr>
                <c:forEach var="doc" items="${documents}">
                    <tr>
                        <td>${doc.id}</td>
                        <td>${doc.title}</td>
                        <td>
                            <div style="max-height:150px; overflow:auto;">
                                <c:out value="${doc.description}" escapeXml="false" />
                            </div>
                        </td>
                        <td>${doc.productId}</td>
                        <td>
                            <div class="img-gallery">
                                <c:forEach var="img" items="${doc.images}">
                                    <img src="${pageContext.request.contextPath}${img.imageUrl}" alt="Image" />
                                </c:forEach>
                            </div>
                        </td>
                        <td>
                            <a href="${pageContext.request.contextPath}/admin/document/${doc.id}"
                                class="btn btn-view">Xem chi tiết</a>
                        </td>
                    </tr>
                </c:forEach>
            </table>

        </body>

        </html>
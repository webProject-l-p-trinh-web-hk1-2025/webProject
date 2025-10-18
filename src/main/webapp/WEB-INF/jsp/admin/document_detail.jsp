<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <html>

        <head>
            <title>Chi tiết Document</title>
            <style>
                .document-detail {
                    max-width: 800px;
                    margin: 20px auto;
                    padding: 15px;
                    border: 1px solid #ccc;
                    border-radius: 6px;
                    background-color: #f9f9f9;
                }

                h2 {
                    margin-bottom: 10px;
                }

                .field {
                    margin-bottom: 10px;
                }

                .field label {
                    font-weight: bold;
                }

                .images {
                    display: flex;
                    flex-wrap: wrap;
                    gap: 10px;
                    margin-top: 10px;
                }

                .images img {
                    width: 120px;
                    height: 120px;
                    object-fit: cover;
                    border-radius: 4px;
                }

                .btn-back {
                    display: inline-block;
                    padding: 5px 10px;
                    margin-top: 15px;
                    background-color: #ccc;
                    color: #000;
                    text-decoration: none;
                    border-radius: 4px;
                }

                .btn-back:hover {
                    background-color: #bbb;
                }
            </style>
        </head>

        <body>

            <div class="document-detail">
                <h2>${document.title}</h2>

                <div class="field">
                    <label>Product ID: </label>
                    <span>${document.productId}</span>
                </div>

                <div class="field">
                    <label>Description:</label>
                    <div>
                        <c:out value="${document.description}" escapeXml="false" />
                    </div>
                </div>

                <div class="field">
                    <label>Images:</label>
                    <div class="images">
                        <c:forEach var="img" items="${document.images}">
                            <img src="${pageContext.request.contextPath}${img.imageUrl}" alt="Document Image" />
                        </c:forEach>
                    </div>
                </div>

                <a href="${pageContext.request.contextPath}/admin/documents" class="btn-back">Quay lại danh sách</a>
            </div>

        </body>

        </html>
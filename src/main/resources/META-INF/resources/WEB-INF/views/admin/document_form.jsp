<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <html>

        <head>
            <title>${document != null ? "Chỉnh sửa Document" : "Tạo Document mới"}</title>
            <style>
                body {
                    font-family: Arial, sans-serif;
                }

                .form-group {
                    margin-bottom: 15px;
                }

                label {
                    display: block;
                    font-weight: bold;
                    margin-bottom: 5px;
                }

                input[type="text"],
                select {
                    width: 100%;
                    padding: 8px;
                    box-sizing: border-box;
                }

                #editor {
                    border: 1px solid #ccc;
                    min-height: 300px;
                    padding: 10px;
                }

                .editor-toolbar button {
                    margin-right: 5px;
                    margin-bottom: 5px;
                    padding: 5px 8px;
                }

                /* -- CSS MỚI -- */
                .editor-toolbar label {
                    display: inline-block;
                    font-weight: normal;
                    margin: 0 5px 0 10px;
                    vertical-align: middle;
                }

                .editor-toolbar input[type="color"] {
                    width: 40px;
                    height: 28px;
                    padding: 2px;
                    vertical-align: middle;
                    border: 1px solid #ccc;
                    border-radius: 4px;
                    margin-bottom: 5px;
                }

                /* -- HẾT CSS MỚI -- */

                .btn {
                    padding: 6px 12px;
                    border: none;
                    border-radius: 4px;
                    cursor: pointer;
                }

                .btn-save {
                    background-color: #4CAF50;
                    color: white;
                }

                .btn-cancel {
                    background-color: #f44336;
                    color: white;
                    text-decoration: none;
                }

                .img-preview img {
                    max-width: 150px;
                    max-height: 150px;
                    margin: 5px;
                    border-radius: 4px;
                    object-fit: cover;
                }
            </style>
        </head>

        <body>

            <h2>${document != null ? "Chỉnh sửa Document" : "Tạo Document mới"}</h2>

            <%-- (Các thông báo error/success giữ nguyên) --%>
                <c:if test="${not empty error}">
                    <p style="color:red">${error}</p>
                </c:if>
                <c:if test="${not empty success}">
                    <p style="color:green">${success}</p>
                </c:if>

                <%-- (Form action logic giữ nguyên) --%>
                    <c:choose>
                        <c:when test="${document != null && document.id != null}">
                            <c:set var="formAction"
                                value="${pageContext.request.contextPath}/admin/document/update/${document.id}" />
                        </c:when>
                        <c:otherwise>
                            <c:set var="formAction" value="${pageContext.request.contextPath}/admin/document/create" />
                        </c:otherwise>
                    </c:choose>

                    <form action="${formAction}" method="post" enctype="multipart/form-data" onsubmit="syncEditor()">

                        <%-- (Các trường title và productId giữ nguyên) --%>
                            <div class="form-group">
                                <label>Title:</label>
                                <input type="text" name="title" value="${document != null ? document.title : ''}"
                                    required />
                            </div>
                            <div class="form-group">
                                <label>Product ID:</label>
                                <input type="text" name="productId"
                                    value="${document != null ? document.productId : ''}" required />
                            </div>

                            <div class="form-group editor-toolbar">
                                <button type="button" onclick="formatDoc('formatBlock', 'p')">P</button>
                                <button type="button" onclick="formatDoc('formatBlock', 'h1')">H1</button>
                                <button type="button" onclick="formatDoc('formatBlock', 'h2')">H2</button>
                                <button type="button" onclick="formatDoc('formatBlock', 'h3')">H3</button>
                                <button type="button" onclick="formatDoc('insertUnorderedList')">UL</button>
                                <button type="button" onclick="formatDoc('insertOrderedList')">OL</button>
                                <button type="button" onclick="insertLink()">Link</button>
                                <button type="button" onclick="triggerImageUpload()">Image</button>

                                <button type="button" onclick="insertTable()">Table</button>

                                <label for="editorColorPicker">Color:</label>
                                <input type="color" id="editorColorPicker" onchange="formatDoc('foreColor', this.value)"
                                    title="Text Color">
                            </div>

                            <div id="editor" contenteditable="true">
                                <c:if test="${document != null}">
                                    <c:out value="${document.description}" escapeXml="false" />
                                </c:if>
                            </div>

                            <%-- (Input ẩn và phần upload ảnh gallery giữ nguyên) --%>
                                <input type="file" id="editorImageInput" accept="image/*" style="display: none;"
                                    onchange="uploadImage(this)">
                                <div class="form-group">
                                    <label>Upload Images (Gallery):</label>
                                    <input type="file" name="images" multiple accept="image/*" />
                                    <c:if test="${document != null && not empty document.images}">
                                        <div class="img-preview">
                                            <c:forEach var="img" items="${document.images}">
                                                <img src="${pageContext.request.contextPath}${img.imageUrl}"
                                                    alt="Image" />
                                            </c:forEach>
                                        </div>
                                    </c:if>
                                </div>

                                <input type="hidden" name="description" id="description">

                                <div class="form-group">
                                    <button type="submit" class="btn btn-save">${document != null ? 'Cập nhật' :
                                        'Tạo'}</button>
                                    <a href="${pageContext.request.contextPath}/admin/document/list"
                                        class="btn btn-cancel">Hủy</a>
                                </div>
                    </form>

                    <script>
                        // Hàm chung để thực thi lệnh định dạng
                        function formatDoc(command, value = null) {
                            document.execCommand(command, false, value);
                            document.getElementById('editor').focus();
                        }

                        // Hàm chèn link (giữ nguyên)
                        function insertLink() {
                            const url = prompt("Nhập URL:");
                            if (url) {
                                document.execCommand('createLink', false, url);
                                document.getElementById('editor').focus();
                            }
                        }

                        // --- HÀM MỚI ĐỂ TẠO BẢNG ---
                        function insertTable() {
                            const rows = prompt("Nhập số hàng (rows):", "3");
                            const cols = prompt("Nhập số cột (columns):", "3");

                            // Xác thực đầu vào
                            const numRows = parseInt(rows);
                            const numCols = parseInt(cols);

                            if (isNaN(numRows) || isNaN(numCols) || numRows <= 0 || numCols <= 0) {
                                alert("Số hàng và cột không hợp lệ.");
                                return;
                            }

                            // Xây dựng chuỗi HTML cho bảng
                            // Thêm style cơ bản để nhìn thấy đường viền
                            let tableHtml = '<table border="1" style="border-collapse: collapse; width: 100%;">';
                            tableHtml += '<tbody>';

                            for (let i = 0; i < numRows; i++) {
                                tableHtml += '<tr>';
                                for (let j = 0; j < numCols; j++) {
                                    // Thêm &nbsp; để ô không bị xẹp và có thể click vào
                                    tableHtml += '<td>&nbsp;</td>';
                                }
                                tableHtml += '</tr>';
                            }

                            tableHtml += '</tbody></table>';

                            // Chèn HTML vào editor
                            document.execCommand('insertHTML', false, tableHtml);
                            document.getElementById('editor').focus();
                        }

                        // --- (Các hàm upload ảnh giữ nguyên) ---
                        function triggerImageUpload() {
                            document.getElementById('editorImageInput').click();
                        }

                        function uploadImage(input) {
                            if (input.files && input.files[0]) {
                                const file = input.files[0];
                                const formData = new FormData();
                                formData.append('image', file);

                                const uploadUrl = "${pageContext.request.contextPath}/admin/document/upload-image";

                                fetch(uploadUrl, {
                                    method: 'POST',
                                    body: formData
                                })
                                    .then(response => {
                                        if (!response.ok) {
                                            throw new Error('Network response was not ok');
                                        }
                                        return response.json();
                                    })
                                    .then(data => {
                                        if (data && data.imageUrl) {
                                            const imageUrl = "${pageContext.request.contextPath}" + data.imageUrl;
                                            document.execCommand('insertImage', false, imageUrl);
                                            document.getElementById('editor').focus();
                                        } else {
                                            throw new Error('Invalid JSON response from server');
                                        }
                                    })
                                    .catch(error => {
                                        console.error('Error uploading image:', error);
                                        alert('Lỗi: Không thể tải ảnh lên.');
                                    });
                                input.value = null;
                            }
                        }

                        // --- (Hàm đồng bộ và khởi tạo giữ nguyên) ---
                        function syncEditor() {
                            document.getElementById('description').value = document.getElementById('editor').innerHTML;
                        }

                        const editor = document.getElementById('editor');
                        if (editor.innerHTML.trim() === '') {
                            editor.innerHTML = '<p>&nbsp;</p>';
                        }
                    </script>

        </body>

        </html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>

<head>
    <title>${document != null ? "Chỉnh sửa tài liệu" : "Tạo tài liệu mới"}</title>
    <meta name="viewport" content="width=device-width,initial-scale=1" />
    <link rel="stylesheet" href="<c:url value='/css/admin-dashboard.css'/>" />
    <link rel="stylesheet" href="<c:url value='/css/documents_admin.css'/>" />
    <link rel="stylesheet" href="<c:url value='/css/document_form.css'/>" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" />
    
    <style>
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

                /* Resizable wrapper for images and tables */
                .img-wrapper,
                .table-wrapper {
                    display: block;
                    position: relative;
                    max-width: 100%;
                    margin: 5px auto;
                }

                .img-wrapper img,
                .table-wrapper table {
                    display: block;
                    width: 100%;
                    max-width: 100%;
                }
                
                /* Support for text-align from justifyCenter/justifyLeft/justifyRight */
                #editor [style*="text-align: center"] .img-wrapper,
                #editor [style*="text-align: center"] .table-wrapper {
                    margin-left: auto;
                    margin-right: auto;
                }
                
                #editor [style*="text-align: left"] .img-wrapper,
                #editor [style*="text-align: left"] .table-wrapper {
                    margin-left: 0;
                    margin-right: auto;
                }
                
                #editor [style*="text-align: right"] .img-wrapper,
                #editor [style*="text-align: right"] .table-wrapper {
                    margin-left: auto;
                    margin-right: 0;
                }

                .img-wrapper:hover,
                .table-wrapper:hover,
                .img-wrapper.resizing,
                .table-wrapper.resizing {
                    outline: 2px dashed #1976d2;
                }

                .resize-handle {
                    position: absolute;
                    bottom: 0;
                    right: 0;
                    width: 16px;
                    height: 16px;
                    background: #1976d2;
                    border: 2px solid white;
                    border-radius: 50%;
                    cursor: nwse-resize;
                    opacity: 0;
                    transition: opacity 0.2s;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    color: white;
                    font-size: 10px;
                }

                .img-wrapper:hover .resize-handle,
                .table-wrapper:hover .resize-handle,
                .img-wrapper.resizing .resize-handle,
                .table-wrapper.resizing .resize-handle {
                    opacity: 1;
                }
    </style>
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
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/products"><i class="fas fa-box"></i><span class="nav-text">Products</span></a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/categories"><i class="fas fa-tag"></i><span class="nav-text">Categories</span></a>
                    </li>
                    <li class="active">
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
                    <h2>${document != null ? "Chỉnh sửa tài liệu" : "Tạo tài liệu mới"}</h2>
                    <a href="${pageContext.request.contextPath}/admin/document" class="btn btn-outline">
                        <i class="fas fa-arrow-left"></i> Quay lại danh sách
                    </a>
                </div>

                <c:if test="${not empty error}">
                    <div class="alert alert-danger">
                        ${error}
                    </div>
                </c:if>
                <c:if test="${not empty success}">
                    <div class="alert alert-success">
                        ${success}
                    </div>
                </c:if>

                <%-- Form action logic --%>
                <c:choose>
                    <c:when test="${document != null && document.id != null}">
                        <c:set var="formAction" value="${pageContext.request.contextPath}/admin/document/update/${document.id}" />
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
                                <label>Product:</label>
                                <select name="productId" required style="width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 4px;">
                                    <option value="">-- Chọn sản phẩm --</option>
                                    <c:forEach items="${products}" var="product">
                                        <option value="${product.id}" 
                                            ${document != null && document.productId == product.id ? 'selected' : ''}>
                                            ${product.name} (ID: ${product.id})
                                        </option>
                                    </c:forEach>
                                </select>
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
                                
                                <span style="margin: 0 5px;">|</span>
                                
                                <button type="button" onclick="alignContent('left')" title="Căn trái">⬅</button>
                                <button type="button" onclick="alignContent('center')" title="Căn giữa">↔</button>
                                <button type="button" onclick="alignContent('right')" title="Căn phải">➡</button>
                                <button type="button" onclick="formatDoc('justifyFull')" title="Căn đều">⬌</button>

                                <label for="editorColorPicker">Color:</label>
                                <input type="color" id="editorColorPicker" onchange="formatDoc('foreColor', this.value)"
                                    title="Text Color">
                            </div>

                            <div id="editor" contenteditable="true">
                                <c:if test="${document != null}">
                                    <c:out value="${document.description}" escapeXml="false" />
                                </c:if>
                            </div>

                            <input type="file" id="editorImageInput" accept="image/*" style="display: none;"
                                onchange="uploadImage(this)">

                            <input type="hidden" name="description" id="description">

                                <div class="form-group">
                                    <button type="submit" class="btn btn-save">${document != null ? 'Cập nhật' :
                                        'Tạo'}</button>
                                    <a href="${pageContext.request.contextPath}/admin/document"
                                        class="btn btn-cancel">Hủy</a>
                                </div>
                    </form>

                    <script>
                        // Hàm chung để thực thi lệnh định dạng
                        function formatDoc(command, value = null) {
                            document.execCommand(command, false, value);
                            document.getElementById('editor').focus();
                        }

                        // Hàm căn lề cho cả text, ảnh và bảng
                        function alignContent(align) {
                            const selection = window.getSelection();
                            
                            // Check if we're inside an img-wrapper or table-wrapper
                            if (selection.rangeCount > 0) {
                                let node = selection.getRangeAt(0).commonAncestorContainer;
                                if (node.nodeType === 3) node = node.parentElement;
                                
                                // Find wrapper
                                let wrapper = null;
                                let current = node;
                                while (current && current !== editor) {
                                    if (current.classList && 
                                        (current.classList.contains('img-wrapper') || 
                                         current.classList.contains('table-wrapper'))) {
                                        wrapper = current;
                                        break;
                                    }
                                    current = current.parentElement;
                                }
                                
                                if (wrapper) {
                                    // Apply margin alignment to wrapper
                                    if (align === 'center') {
                                        wrapper.style.marginLeft = 'auto';
                                        wrapper.style.marginRight = 'auto';
                                        wrapper.style.display = 'block';
                                    } else if (align === 'left') {
                                        wrapper.style.marginLeft = '0';
                                        wrapper.style.marginRight = 'auto';
                                        wrapper.style.display = 'block';
                                    } else if (align === 'right') {
                                        wrapper.style.marginLeft = 'auto';
                                        wrapper.style.marginRight = '0';
                                        wrapper.style.display = 'block';
                                    }
                                } else {
                                    // Apply text alignment for regular text
                                    if (align === 'left') {
                                        formatDoc('justifyLeft');
                                    } else if (align === 'center') {
                                        formatDoc('justifyCenter');
                                    } else if (align === 'right') {
                                        formatDoc('justifyRight');
                                    }
                                }
                            }
                            
                            editor.focus();
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
                            
                            // Make the new table resizable
                            setTimeout(() => {
                                const tables = editor.querySelectorAll('table:not(.resizable)');
                                if (tables.length > 0) {
                                    makeResizable(tables[tables.length - 1]);
                                }
                            }, 100);
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

                        // --- DRAG TO RESIZE IMAGES & TABLES ---
                        let isResizing = false;
                        let currentWrapper = null;
                        let startX = 0;
                        let startWidth = 0;

                        // Wrap element with resizable container
                        function makeResizable(element) {
                            // Check if already wrapped
                            if (element.parentElement && 
                                (element.parentElement.classList.contains('img-wrapper') || 
                                 element.parentElement.classList.contains('table-wrapper'))) {
                                return;
                            }
                            
                            // Create wrapper
                            const wrapper = document.createElement('div');
                            wrapper.className = element.tagName === 'IMG' ? 'img-wrapper' : 'table-wrapper';
                            
                            // Set initial width from element if it has inline style
                            if (element.style.width) {
                                wrapper.style.width = element.style.width;
                                element.style.width = '100%';
                            }
                            
                            // Wrap the element
                            element.parentNode.insertBefore(wrapper, element);
                            wrapper.appendChild(element);
                            
                            // Create resize handle
                            const handle = document.createElement('div');
                            handle.className = 'resize-handle';
                            handle.innerHTML = '⇲';
                            wrapper.appendChild(handle);
                            
                            // Handle mouse down on resize handle
                            handle.addEventListener('mousedown', function(e) {
                                e.preventDefault();
                                e.stopPropagation();
                                startResize(wrapper, e);
                            });
                        }

                        function startResize(wrapper, e) {
                            isResizing = true;
                            currentWrapper = wrapper;
                            startX = e.clientX;
                            startWidth = wrapper.offsetWidth;
                            
                            wrapper.classList.add('resizing');
                            document.body.style.cursor = 'nwse-resize';
                            
                            document.addEventListener('mousemove', doResize);
                            document.addEventListener('mouseup', stopResize);
                        }

                        function doResize(e) {
                            if (!isResizing || !currentWrapper) return;
                            
                            const deltaX = e.clientX - startX;
                            let newWidth = startWidth + deltaX;
                            
                            // Min 50px, max 100% of editor width
                            const minWidth = 50;
                            const maxWidth = editor.offsetWidth - 20;
                            newWidth = Math.max(minWidth, Math.min(newWidth, maxWidth));
                            
                            currentWrapper.style.width = newWidth + 'px';
                        }

                        function stopResize() {
                            if (isResizing) {
                                isResizing = false;
                                if (currentWrapper) {
                                    currentWrapper.classList.remove('resizing');
                                }
                                document.body.style.cursor = '';
                                currentWrapper = null;
                                
                                document.removeEventListener('mousemove', doResize);
                                document.removeEventListener('mouseup', stopResize);
                            }
                        }

                        // Make existing images and tables resizable on load
                        setTimeout(() => {
                            // Wrap images that aren't already wrapped
                            editor.querySelectorAll('img').forEach(img => {
                                if (!img.parentElement.classList.contains('img-wrapper')) {
                                    makeResizable(img);
                                }
                            });
                            
                            // Wrap tables that aren't already wrapped
                            editor.querySelectorAll('table').forEach(table => {
                                if (!table.parentElement.classList.contains('table-wrapper')) {
                                    makeResizable(table);
                                }
                            });
                        }, 300);

                        // Make newly inserted images resizable
                        const originalExecCommand = document.execCommand;
                        document.execCommand = function(command, showUI, value) {
                            const result = originalExecCommand.call(this, command, showUI, value);
                            
                            if (command === 'insertImage') {
                                setTimeout(() => {
                                    editor.querySelectorAll('img').forEach(img => {
                                        if (!img.parentElement.classList.contains('img-wrapper')) {
                                            makeResizable(img);
                                        }
                                    });
                                }, 100);
                            }
                            
                            return result;
                        };

                        // Delete with keyboard
                        document.addEventListener('keydown', function(e) {
                            if (e.key === 'Delete' || e.key === 'Backspace') {
                                const selection = window.getSelection();
                                if (selection && selection.rangeCount > 0) {
                                    const range = selection.getRangeAt(0);
                                    let node = range.commonAncestorContainer;
                                    
                                    // Find wrapper if we're inside one
                                    while (node && node !== editor) {
                                        if (node.classList && 
                                            (node.classList.contains('img-wrapper') || 
                                             node.classList.contains('table-wrapper'))) {
                                            if (confirm('Xóa ' + (node.classList.contains('img-wrapper') ? 'ảnh' : 'bảng') + ' này?')) {
                                                node.remove();
                                            }
                                            e.preventDefault();
                                            return;
                                        }
                                        node = node.parentNode;
                                    }
                                }
                            }
                        });
                    </script>

                    <script>
                        // Sidebar toggle
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
                    </script>

        </body>

        </html>
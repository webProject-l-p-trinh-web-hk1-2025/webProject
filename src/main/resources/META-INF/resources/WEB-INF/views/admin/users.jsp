<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <html>

        <head>
            <title>Danh sách Users (Admin)</title>
            <style>
                table {
                    border-collapse: collapse;
                    width: 100%;
                }

                th,
                td {
                    border: 1px solid #ccc;
                    padding: 8px;
                    text-align: left;
                }

                th {
                    background-color: #f2f2f2;
                }

                .btn {
                    padding: 4px 8px;
                    text-decoration: none;
                    border: 1px solid #333;
                    border-radius: 4px;
                }

                .btn-edit {
                    background-color: #4CAF50;
                    color: white;
                    padding: 4px 8px;
                    text-decoration: none;
                    border: 1px solid #333;
                    border-radius: 4px;
                    transition: background-color 0.3s, transform 0.2s;
                    cursor: pointer;
                }

                .btn-edit:hover {
                    background-color: #45a049;
                    transform: scale(1.05);
                }

                .btn-delete {
                    background-color: #f44336;
                    color: white;
                }

                .filter-input {
                    width: 120px;
                    margin-right: 5px;
                }

                .edit-form-row {
                    background: #f9f9f9;
                }

                .edit-form-row input,
                .edit-form-row select {
                    margin-right: 5px;
                    padding: 2px 4px;
                }
            </style>
        </head>

        <body>
            <h2>Danh sách Users (Admin)</h2>

            <button type="button" class="btn btn-edit"
                onclick="document.getElementById('createFormDiv').style.display='block';">
                Tạo user mới
            </button>
            <br /><br />

            <!-- Form tạo user ẩn -->
            <div id="createFormDiv"
                style="display:none; background:#eef; padding:10px; border:1px solid #ccc; margin-bottom:10px;">

                <c:if test="${not empty error}">
                    <p style="color:red">${error}</p>
                </c:if>

                <c:if test="${not empty success}">
                    <p style="color:green">${success}</p>
                </c:if>

                <form action="${pageContext.request.contextPath}/admin/createUser" method="post">
                    Phone: <input type="text" name="phone" required />
                    Full Name: <input type="text" name="fullname" required />
                    Email: <input type="email" name="email" required />
                    Address: <input type="text" name="address" />
                    Role:
                    <select name="role" required>
                        <option value="ADMIN">ADMIN</option>
                        <option value="USER">USER</option>
                        <option value="SELLER">SELLER</option>
                        <option value="GUEST">GUEST</option>
                        <option value="SHIPPER">SHIPPER</option>
                    </select>
                    Active:
                    <select name="active" required>
                        <option value="true">Đang hoạt động</option>
                        <option value="false">Ngưng hoạt động</option>
                    </select>
                    <button type="submit" class="btn btn-save">Tạo</button>
                    <button type="button" class="btn btn-cancel"
                        onclick="document.getElementById('createFormDiv').style.display='none'">Hủy</button>
                </form>
            </div>

            <!-- Bộ lọc client-side -->
            <label>Phone:</label><input type="text" id="filterPhone" class="filter-input" onkeyup="filterTable()">
            <label>Full Name:</label><input type="text" id="filterFullname" class="filter-input"
                onkeyup="filterTable()">
            <label>Email:</label><input type="text" id="filterEmail" class="filter-input" onkeyup="filterTable()">
            <label>Role:</label>
            <select id="filterRole" onchange="filterTable()">
                <option value="">--All--</option>
                <option value="ADMIN">ADMIN</option>
                <option value="USER">USER</option>
                <option value="SELLER">SELLER</option>
                <option value="GUEST">GUEST</option>
                <option value="SHIPPER">SHIPPER</option>
            </select>
            <label>Active:</label>
            <select id="filterActive" onchange="filterTable()">
                <option value="">--All--</option>
                <option value="true">Đang hoạt động</option>
                <option value="false">Ngưng hoạt động</option>
            </select>

            <br /><br />

            <table id="usersTable">
                <tr>
                    <th>ID</th>
                    <th>Phone</th>
                    <th>Full Name</th>
                    <th>Email</th>
                    <th>Address</th>
                    <th>Role</th>
                    <th>Active</th>
                    <th>Avatar</th>
                    <th>Hành động</th>
                </tr>
                <c:forEach var="user" items="${users}">
                    <tr>
                        <td>${user.id}</td>
                        <td>${user.phone}</td>
                        <td>${user.fullname}</td>
                        <td>${user.email}</td>
                        <td>${user.address}</td>
                        <td>${user.role}</td>
                        <td>${user.active}</td>
                        <td>
                            <c:if test="${not empty user.avatarUrl}">
                                <img src="${pageContext.request.contextPath}${user.avatarUrl}" width="50" height="50" />
                            </c:if>
                        </td>
                        <td>
                            <button type="button" onclick="showEditForm('${user.id}')" class="btn btn-edit">Sửa</button>
                            <form action="${pageContext.request.contextPath}/admin/deleteUser/${user.id}" method="post"
                                style="display:inline;" onsubmit="return confirm('Bạn có chắc muốn xóa user này?');">
                                <button type="submit" class="btn btn-delete">Xóa</button>
                            </form>
                        </td>
                    </tr>

                    <!-- Form ẩn sửa user -->
                    <tr id="editFormRow-${user.id}" class="edit-form-row" style="display:none;">
                        <td colspan="9">
                            <form action="${pageContext.request.contextPath}/admin/updateUser/${user.id}" method="post">
                                Full Name: <input type="text" name="fullname" value="${user.fullname}" required />
                                Email: <input type="email" name="email" value="${user.email}" required />
                                Address: <input type="text" name="address" value="${user.address}" />
                                Role:
                                <select name="role" required>
                                    <option value="ADMIN" ${user.role=='ADMIN' ? 'selected' : '' }>ADMIN</option>
                                    <option value="USER" ${user.role=='USER' ? 'selected' : '' }>USER</option>
                                    <option value="SELLER" ${user.role=='SELLER' ? 'selected' : '' }>SELLER</option>
                                    <option value="GUEST" ${user.role=='GUEST' ? 'selected' : '' }>GUEST</option>
                                    <option value="SHIPPER" ${user.role=='SHIPPER' ? 'selected' : '' }>SHIPPER</option>
                                </select>
                                Active:
                                <select name="active" required>
                                    <option value="true" ${user.active ? 'selected' : '' }>Đang hoạt động</option>
                                    <option value="false" ${!user.active ? 'selected' : '' }>Ngưng hoạt động</option>
                                </select>
                                <button type="submit" class="btn btn-save">Lưu</button>
                                <button type="button" onclick="hideEditForm('${user.id}')"
                                    class="btn btn-cancel">Hủy</button>
                            </form>
                        </td>
                    </tr>

                </c:forEach>
            </table>

            <script>
                function filterTable() {
                    let phone = document.getElementById('filterPhone').value.toLowerCase();
                    let fullname = document.getElementById('filterFullname').value.toLowerCase();
                    let email = document.getElementById('filterEmail').value.toLowerCase();
                    let role = document.getElementById('filterRole').value;
                    let active = document.getElementById('filterActive').value;

                    let table = document.getElementById('usersTable');
                    let tr = table.getElementsByTagName('tr');

                    for (let i = 1; i < tr.length; i++) { // bỏ header
                        // Skip edit form rows
                        if (tr[i].classList.contains('edit-form-row')) continue;

                        let tdPhone = tr[i].getElementsByTagName('td')[1].textContent.toLowerCase();
                        let tdFullname = tr[i].getElementsByTagName('td')[2].textContent.toLowerCase();
                        let tdEmail = tr[i].getElementsByTagName('td')[3].textContent.toLowerCase();
                        let tdRole = tr[i].getElementsByTagName('td')[5].textContent;
                        let tdActive = tr[i].getElementsByTagName('td')[6].textContent.toLowerCase() === 'true' ? 'true' : 'false';

                        let show = true;
                        if (phone && !tdPhone.includes(phone)) show = false;
                        if (fullname && !tdFullname.includes(fullname)) show = false;
                        if (email && !tdEmail.includes(email)) show = false;
                        if (role && tdRole !== role) show = false;
                        if (active && tdActive !== active) show = false;

                        tr[i].style.display = show ? '' : 'none';

                        // hide corresponding edit form if row is hidden
                        let editRow = document.getElementById('editFormRow-' + tr[i].getElementsByTagName('td')[0].textContent);
                        if (editRow) editRow.style.display = 'none';
                    }
                }

                function showEditForm(userId) {
                    document.getElementById('editFormRow-' + userId).style.display = '';
                }

                function hideEditForm(userId) {
                    document.getElementById('editFormRow-' + userId).style.display = 'none';
                }
            </script>

        </body>

        </html>
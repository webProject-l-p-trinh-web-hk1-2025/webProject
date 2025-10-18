<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Order Test Page</title>
    <meta charset="UTF-8">
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 1200px;
            margin: 20px auto;
            padding: 20px;
        }
        .section {
            border: 1px solid #ccc;
            padding: 15px;
            margin: 15px 0;
            border-radius: 5px;
        }
        button {
            background-color: #4CAF50;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            margin: 5px;
        }
        button:hover {
            background-color: #45a049;
        }
        .delete-btn {
            background-color: #f44336;
        }
        .delete-btn:hover {
            background-color: #da190b;
        }
        input {
            padding: 8px;
            margin: 5px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        #result {
            margin-top: 20px;
            padding: 15px;
            background-color: #f9f9f9;
            border-radius: 5px;
            white-space: pre-wrap;
            word-wrap: break-word;
        }
    </style>
</head>
<body>
    <h1>Order Module Test Page</h1>

    <div class="section">
        <h2>1. Tạo đơn hàng mới</h2>
        <div>
            Product ID: <input type="number" id="createProductId" placeholder="Product ID" value="1" />
            Số lượng: <input type="number" id="createQuantity" placeholder="Quantity" value="1" />
            Giá: <input type="number" id="createPrice" placeholder="Price" value="1000000" />
            <button onclick="createOrder()">Create Order</button>
        </div>
    </div>

    <div class="section">
        <h2>2. Xem đơn hàng theo ID</h2>
        <input type="number" id="orderIdInput" placeholder="Order ID" />
        <button onclick="getOrderById()">Get Order</button>
    </div>

    <div class="section">
        <h2>3. Xem tất cả đơn hàng</h2>
        <button onclick="getAllOrders()">Get All Orders</button>
    </div>

    <div class="section">
        <h2>4. Hủy đơn hàng</h2>
        <input type="number" id="cancelOrderIdInput" placeholder="Order ID" />
        <button onclick="cancelOrder()" class="delete-btn">Cancel Order</button>
    </div>

    <div id="result">
        <strong>Kết quả sẽ hiển thị ở đây...</strong>
    </div>

    <script>
        var API_BASE = '/api/orders';

        function showResult(data) {
            var resultDiv = document.getElementById('result');
            resultDiv.innerHTML = '<strong>Response:</strong>\n' + JSON.stringify(data, null, 2);
        }

        function showError(error) {
            var resultDiv = document.getElementById('result');
            resultDiv.innerHTML = '<strong style="color: red;">Error:</strong>\n' + error;
        }

        function createOrder() {
            var productId = document.getElementById('createProductId').value;
            var quantity = document.getElementById('createQuantity').value;
            var price = document.getElementById('createPrice').value;

            if (!productId || !quantity || !price) {
                alert('Vui lòng nhập đầy đủ thông tin!');
                return;
            }

            fetch(API_BASE + '/create', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                credentials: 'include',
                body: JSON.stringify({
                    productId: parseInt(productId),
                    quantity: parseInt(quantity),
                    price: parseFloat(price)
                })
            })
            .then(function(response) {
                if (response.status === 401 || response.status === 403) {
                    throw new Error('VUI LÒNG ĐĂNG NHẬP TRƯỚC!');
                }
                if (!response.ok) {
                    throw new Error('HTTP error! status: ' + response.status);
                }
                return response.json();
            })
            .then(function(data) {
                showResult(data);
            })
            .catch(function(error) {
                showError(error.message);
            });
        }

        function getOrderById() {
            var orderId = document.getElementById('orderIdInput').value;
            if (!orderId) {
                alert('Vui lòng nhập Order ID!');
                return;
            }

            fetch(API_BASE + '/' + orderId, {
                method: 'GET',
                credentials: 'include'
            })
            .then(function(response) {
                if (response.status === 401 || response.status === 403) {
                    throw new Error('VUI LÒNG ĐĂNG NHẬP TRƯỚC!');
                }
                if (!response.ok) {
                    throw new Error('HTTP error! status: ' + response.status);
                }
                return response.json();
            })
            .then(function(data) {
                showResult(data);
            })
            .catch(function(error) {
                showError(error.message);
            });
        }

        function getAllOrders() {
            fetch(API_BASE, {
                method: 'GET',
                credentials: 'include'
            })
            .then(function(response) {
                if (response.status === 401 || response.status === 403) {
                    throw new Error('VUI LÒNG ĐĂNG NHẬP TRƯỚC!');
                }
                if (!response.ok) {
                    throw new Error('HTTP error! status: ' + response.status);
                }
                return response.json();
            })
            .then(function(data) {
                showResult(data);
            })
            .catch(function(error) {
                showError(error.message);
            });
        }

        function cancelOrder() {
            var orderId = document.getElementById('cancelOrderIdInput').value;
            if (!orderId) {
                alert('Vui lòng nhập Order ID để hủy!');
                return;
            }

            if (!confirm('Bạn có chắc muốn hủy đơn hàng #' + orderId + '?')) {
                return;
            }

            fetch(API_BASE + '/' + orderId + '/cancel', {
                method: 'PUT',
                credentials: 'include'
            })
            .then(function(response) {
                if (response.status === 401 || response.status === 403) {
                    throw new Error('VUI LÒNG ĐĂNG NHẬP TRƯỚC!');
                }
                if (!response.ok) {
                    throw new Error('HTTP error! status: ' + response.status);
                }
                return response.json();
            })
            .then(function(data) {
                showResult(data);
            })
            .catch(function(error) {
                showError(error.message);
            });
        }
    </script>
</body>
</html>

<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Test Cart API</title>
    <style>
        body { font-family: Arial; padding: 20px; background: #f5f5f5; }
        .container { max-width: 800px; margin: 0 auto; background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        h1 { color: #333; text-align: center; }
        h2 { color: #555; border-bottom: 2px solid #4CAF50; padding-bottom: 10px; margin-top: 30px; }
        .section { margin: 20px 0; padding: 15px; background: #f9f9f9; border-radius: 5px; }
        input { padding: 10px; margin: 5px; width: 120px; border: 1px solid #ddd; border-radius: 4px; }
        button { padding: 10px 20px; margin: 5px; background: #4CAF50; color: white; border: none; cursor: pointer; border-radius: 4px; font-size: 14px; }
        button:hover { background: #45a049; }
        .delete { background: #f44336; }
        .delete:hover { background: #da190b; }
        pre { background: #f5f5f5; padding: 15px; border-radius: 5px; overflow-x: auto; margin-top: 15px; border-left: 4px solid #4CAF50; }
        .error { border-left-color: #f44336; background: #ffebee; }
    </style>
</head>
<body>
    <div class="container">
        <h1>🛒 Test Cart Module</h1>
        
        <div class="section">
            <h2>1. Xem giỏ hàng</h2>
            <button onclick="getCart()">📋 Lấy giỏ hàng</button>
        </div>

        <div class="section">
            <h2>2. Thêm sản phẩm vào giỏ</h2>
            <div>
                Product ID: <input type="number" id="productId" value="1">
                Số lượng: <input type="number" id="quantity" value="2">
                <button onclick="addItem()">➕ Thêm vào giỏ</button>
            </div>
        </div>

        <div class="section">
            <h2>3. Xóa sản phẩm khỏi giỏ</h2>
            <div>
                Product ID: <input type="number" id="removeProductId" value="1">
                <button class="delete" onclick="removeItem()">🗑️ Xóa sản phẩm</button>
            </div>
        </div>

        <div class="section">
            <h2>4. Xóa toàn bộ giỏ hàng</h2>
            <button class="delete" onclick="clearCart()">🧹 Xóa hết</button>
        </div>

        <div class="section">
            <h2>5. Đặt hàng</h2>
            <button onclick="goToOrder()" style="background: #FF9800;">📦 Đặt hàng ngay</button>
        </div>

        <pre id="result"></pre>
    </div>

    <script>
        function showResult(data, isError) {
            var resultDiv = document.getElementById('result');
            resultDiv.className = isError ? 'error' : '';
            resultDiv.textContent = JSON.stringify(data, null, 2);
        }

        function getCart() {
            fetch('/api/cart')
                .then(function(response) { return response.json(); })
                .then(function(data) { showResult(data, false); })
                .catch(function(error) { showResult({error: error.message}, true); });
        }

        function addItem() {
            var productId = document.getElementById('productId').value;
            var quantity = document.getElementById('quantity').value;
            
            fetch('/api/cart/add', {
                method: 'POST',
                headers: {'Content-Type': 'application/json'},
                body: JSON.stringify({
                    productId: parseInt(productId), 
                    quantity: parseInt(quantity)
                })
            })
            .then(function(response) { return response.json(); })
            .then(function(data) { showResult(data, false); })
            .catch(function(error) { showResult({error: error.message}, true); });
        }

        function removeItem() {
            var productId = document.getElementById('removeProductId').value;
            
            fetch('/api/cart/remove/' + productId, {
                method: 'DELETE'
            })
            .then(function(response) { return response.json(); })
            .then(function(data) { showResult(data, false); })
            .catch(function(error) { showResult({error: error.message}, true); });
        }

        function clearCart() {
            if (!confirm('Bạn có chắc muốn xóa toàn bộ giỏ hàng?')) return;
            
            fetch('/api/cart/clear', {
                method: 'DELETE'
            })
            .then(function(response) { return response.json(); })
            .then(function(data) { showResult(data, false); })
            .catch(function(error) { showResult({error: error.message}, true); });
        }

        function goToOrder() {
            window.location.href = '/order';
        }
    </script>
</body>
</html>

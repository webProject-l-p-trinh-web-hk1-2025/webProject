<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
  <%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Products Test</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
</head>
<body class="bg-light">
<div class="container py-4">
  <h3>Product List (Test)</h3>

  <table class="table table-striped align-middle">
    <thead>
      <tr>
        <th>ID</th>
        <th>Name</th>
        <th>Brand</th>
        <th>Price</th>
        <th>Stock</th>
        <th class="text-end" style="width:140px">Xem</th>
      </tr>
    </thead>
    <tbody id="tbody"></tbody>
  </table>

  <div id="empty" class="text-muted"></div>
</div>

<script>
const ctx = "<%=request.getContextPath()%>";
const api = ctx + "/api/products";

async function loadAll(){
  const res = await fetch(api);
  const data = await res.json();
  render(data);
}

function render(list){
  const tbody = document.getElementById("tbody");
  const empty = document.getElementById("empty");
  tbody.innerHTML = "";
  if (!list || list.length === 0){
    empty.textContent = "No products.";
    return;
  }
  empty.textContent = "";
  list.forEach(p=>{
    const tr = document.createElement("tr");
    tr.innerHTML =
      "<td>" + (p.id ?? "") + "</td>" +
      "<td>" + (p.name ?? "") + "</td>" +
      "<td>" + (p.brand ?? "") + "</td>" +
      "<td>" + (p.price ?? "") + "</td>" +
      "<td>" + (p.stock ?? 0) + "</td>" +
      "<td class='text-end'>" +
        "<a class='btn btn-sm btn-outline-secondary' " +
        "href='"+ctx+"/product_detail?id="+p.id+"'>View</a>" +
      "</td>";
    tbody.appendChild(tr);
  });
}

loadAll();
</script>
</body>
</html>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
  String ctx = request.getContextPath();
  String id  = request.getParameter("id");
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Product Detail</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
</head>
<body class="bg-light">
<div class="container py-4" style="max-width:820px;">
  <div class="d-flex justify-content-between align-items-center mb-3">
    <h3 class="m-0">Product Detail</h3>

    <!-- Nút Back: ưu tiên quay lại trang trước; nếu vào trực tiếp thì về /product_list -->
    <button class="btn btn-secondary" type="button" onclick="goBack()">Back</button>
  </div>

  <div class="card">
    <div class="card-body">
      <dl class="row">
        <dt class="col-sm-3">ID</dt>          <dd class="col-sm-9" id="p_id"></dd>
        <dt class="col-sm-3">Name</dt>        <dd class="col-sm-9" id="p_name"></dd>
        <dt class="col-sm-3">Brand</dt>       <dd class="col-sm-9" id="p_brand"></dd>
        <dt class="col-sm-3">Price</dt>       <dd class="col-sm-9" id="p_price"></dd>
        <dt class="col-sm-3">Stock</dt>       <dd class="col-sm-9" id="p_stock"></dd>
        <dt class="col-sm-3">Created</dt>     <dd class="col-sm-9" id="p_created"></dd>
        <dt class="col-sm-3">Description</dt> <dd class="col-sm-9" id="p_desc"></dd>
      </dl>

      <div id="err" class="text-danger small"></div>
    </div>
  </div>
</div>

<script>
const ctx = "<%=ctx%>";
const api = ctx + "/api/products";
const id  = "<%= id==null ? "" : id %>";

// Back thông minh
function goBack(){
  if (document.referrer && document.referrer.startsWith(location.origin)) {
    history.back();
  } else {
    window.location = ctx + "/product_list";
  }
}

(async ()=>{
  if (!id){ return showErr("Missing id"); }
  try {
    const res = await fetch(api + "/" + id, { headers: { "Accept": "application/json" }});
    if (!res.ok){ return showErr("Not found ("+res.status+")"); }
    const p = await res.json();

    set("p_id", p.id);
    set("p_name", p.name || "");
    set("p_brand", p.brand || "");
    set("p_price", fmt(p.price));
    set("p_stock", p.stock ?? 0);
    set("p_created", p.createdAt ? new Date(p.createdAt).toLocaleString() : "");
    set("p_desc", p.description || "");
  } catch(e){
    console.error(e);
    showErr("Error loading detail");
  }
})();

function set(i,v){ document.getElementById(i).textContent = v ?? ""; }
function fmt(x){ if (x==null) return ""; const n=Number(x); return isNaN(n)?x:n.toLocaleString(); }
function showErr(msg){ document.getElementById("err").textContent = msg; }
</script>
</body>
</html>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Documents (Test)</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
</head>
<body class="bg-light">
<div class="container py-4">
  <h3>Documents (Test)</h3>

  <div class="d-flex mb-3">
    <input id="q" class="form-control me-2" placeholder="Search title..." style="max-width:280px">
    <button class="btn btn-outline-secondary" onclick="doSearch()">Search</button>
  </div>

  <table class="table table-striped align-middle">
    <thead>
      <tr>
        <th style="width:90px">ID</th>
        <th>Title</th>
        <th style="width:220px">Updated</th>
        <th style="width:130px" class="text-end">Actions</th>
      </tr>
    </thead>
    <tbody id="tbody"></tbody>
  </table>
  <div id="empty" class="text-muted"></div>
</div>

<script>
const ctx = "<%=request.getContextPath()%>";
const api = ctx + "/api/documents";

async function loadAll(){
  try{
    const res = await fetch(api, { headers: { "Accept":"application/json" }});
    if(!res.ok){ console.error("HTTP",res.status,await res.text()); return; }
    const data = await res.json();
    render(data);
  }catch(e){ console.error(e); }
}
async function doSearch(){
  const k = document.getElementById("q").value.trim();
  const url = k ? (api + "?q=" + encodeURIComponent(k)) : api;
  const res = await fetch(url, { headers: { "Accept":"application/json" }});
  const data = await res.json();
  render(data);
}
function render(list){
  const tb = document.getElementById("tbody");
  const empty = document.getElementById("empty");
  tb.innerHTML = "";
  if(!list || list.length===0){ empty.textContent="No documents."; return; }
  empty.textContent = "";
  list.forEach(d=>{
    const tr = document.createElement("tr");
    tr.innerHTML =
      "<td>"+(d.documentId ?? "")+"</td>"+
      "<td>"+escapeHtml(d.title ?? "")+"</td>"+
      "<td>"+fmtDate(d.updatedAt)+"</td>"+
      "<td class='text-end'>" +
        "<a class='btn btn-sm btn-outline-secondary' href='"+ctx+"/document_detail?id="+d.documentId+"'>View</a>" +
      "</td>";
    tb.appendChild(tr);
  });
}
function fmtDate(s){ if(!s) return ""; try { return new Date(s).toLocaleString(); } catch(e){return s;} }
function escapeHtml(x){ return (x||"").replace(/[&<>"']/g,m=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[m])); }

loadAll();
</script>
</body>
</html>

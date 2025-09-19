<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
  String ctx = request.getContextPath();
  String id  = request.getParameter("id");
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Document Detail</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
</head>
<body class="bg-light">
<div class="container py-4" style="max-width:900px;">
  <div class="d-flex justify-content-between align-items-center mb-3">
    <h3 class="m-0">Document Detail</h3>
    <a class="btn btn-secondary" href="<%=ctx%>/document_list">Back</a>
  </div>

  <div class="card"><div class="card-body">
    <h4 id="title"></h4>
    <div class="text-muted mb-2">
      <span id="created"></span> • <span id="updated"></span>
    </div>
    <hr/>
    <div id="content" style="white-space:pre-wrap;"></div>
  </div></div>
</div>

<script>
const ctx = "<%=ctx%>";
const api = ctx + "/api/documents";
const id  = "<%= id==null ? "" : id %>";

(async ()=>{
  if(!id){ alert("Missing id"); return; }
  const res = await fetch(api + "/" + id, { headers: { "Accept":"application/json" }});
  if(!res.ok){ alert("Not found"); return; }
  const d = await res.json();
  setText("title", d.title);
  setText("created", "Created: " + fmtDate(d.createdAt));
  setText("updated", "Updated: " + fmtDate(d.updatedAt));
  setHtml("content", escapeHtml(d.content||""));
})();

function setText(i,v){ document.getElementById(i).textContent = v || ""; }
function setHtml(i,v){ document.getElementById(i).innerHTML = v || ""; }
function fmtDate(s){ if(!s) return ""; try { return new Date(s).toLocaleString(); } catch(e){return s;} }
function escapeHtml(x){ return (x||"").replace(/[&<>"']/g,m=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[m])); }
</script>
</body>
</html>

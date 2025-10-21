<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ taglib
prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
  <head>
    <title>Trang quản trị</title>
    <meta name="viewport" content="width=device-width,initial-scale=1" />
    <link rel="stylesheet" href="<c:url value='/css/admin-dashboard.css'/>" />
  </head>
  <body>
    <div class="page-header">
      <div>
        <h1>Trang quản trị</h1>
        <div class="lead">Chọn chức năng quản lý hoặc xem nhanh số liệu.</div>
      </div>
      <div style="display: flex; gap: 8px; align-items: center">
        <a class="btn" href="${pageContext.request.contextPath}/admin/users"
          >Users</a
        >
        <a class="btn" href="${pageContext.request.contextPath}/admin/products"
          >Products</a
        >
        <a
          class="btn secondary"
          href="${pageContext.request.contextPath}/admin/chat"
          >Chat</a
        >
      </div>
    </div>

    <div class="top-grid">
      <div class="card small">
        <div class="card-title">Quản lý Users</div>
        <div class="card-sub">
          Danh sách, tạo, sửa, xóa tài khoản người dùng.
        </div>
        <a class="btn" href="${pageContext.request.contextPath}/admin/users"
          >Mở Users</a
        >
      </div>

      <div class="card small">
        <div class="card-title">Quản lý Documents</div>
        <div class="card-sub">Quản lý document/guides, upload ảnh.</div>
        <a
          class="btn"
          href="${pageContext.request.contextPath}/admin/document/list"
          >Mở Documents</a
        >
      </div>

      <div class="card small">
        <div class="card-title">Quản lý Products</div>
        <div class="card-sub">Danh sách sản phẩm, thêm mới, sửa, xóa.</div>
        <div style="display: flex; gap: 8px">
          <a
            class="btn"
            href="${pageContext.request.contextPath}/admin/products"
            >Mở Products</a
          >
          <a
            class="btn secondary"
            href="${pageContext.request.contextPath}/admin/products/new"
            >Thêm mới</a
          >
        </div>
      </div>

      <div class="card small">
        <div class="card-title">Hỗ trợ & khác</div>
        <div class="card-sub">Chat nội bộ và thông tin hệ thống.</div>
        <a class="btn" href="${pageContext.request.contextPath}/admin/chat"
          >Mở Chat</a
        >
      </div>
    </div>

    <div class="section">
      <div class="charts-row">
        <div class="chart-box card">
          <div class="card-title">Thống kê</div>
          <div class="card-sub">Số lượng chính của hệ thống</div>
          <div
            style="
              display: flex;
              gap: 12px;
              align-items: center;
              margin-top: 8px;
            "
          >
            <div style="width: 320px"><canvas id="overviewDonut"></canvas></div>
            <div style="flex: 1"><canvas id="overviewBar"></canvas></div>
          </div>
        </div>

        <div class="chart-box card">
          <div class="card-title">Orders over time</div>
          <div class="controls" style="margin: 8px 0">
            <label>Period:</label>
            <select id="periodSelect">
              <option value="week" selected>Last 7 days</option>
              <option value="month">By month</option>
            </select>
            <button id="reloadBtn" class="btn">Reload</button>
            <button id="exportCsvBtn" class="btn secondary">Export CSV</button>
            <div style="margin-left: auto">
              Total: <strong id="ordersTotal">0</strong>
            </div>
          </div>
          <div style="background: transparent; padding-top: 6px">
            <canvas id="ordersChart" height="120"></canvas>
          </div>
        </div>
      </div>
    </div>

    <div class="section two-col">
      <div class="card revenue">
        <div class="card-title">Revenue</div>
        <div class="controls" style="margin: 8px 0">
          <select id="revPeriodSelect">
            <option value="week" selected>Last 7 days</option>
            <option value="month">By month</option>
          </select>
          <button id="reloadRevBtn" class="btn">Reload</button>
          <button id="exportRevCsvBtn" class="btn secondary">Export CSV</button>
          <div style="margin-left: auto">
            Total Revenue: <strong id="revTotal">0</strong>
          </div>
        </div>
        <canvas id="revenueChart" height="140"></canvas>
      </div>

      <div class="card top-products">
        <div class="card-title">Top Products</div>
        <div class="controls" style="margin: 8px 0">
          <label>Top</label>
          <select id="topLimitSelect">
            <option value="5">5</option>
            <option value="10" selected>10</option>
            <option value="20">20</option>
          </select>
          <button id="reloadTopBtn" class="btn">Reload</button>
          <button id="exportTopCsvBtn" class="btn secondary">Export CSV</button>
        </div>
        <canvas id="topProductsChart" height="220"></canvas>
      </div>
    </div>

    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script>
      async function fetchOverview() {
        const resp = await fetch(
          `${location.protocol}//${
            location.host
          }${"${pageContext.request.contextPath}"}'/admin/api/stats/overview`.replace(
            "'${pageContext.request.contextPath}'",
            ""
          )
        );
        if (!resp.ok) throw new Error("Failed to load stats");
        return resp.json();
      }

      // Safe fetch that works with contextPath
      async function fetchOverviewSafe() {
        const base = "${pageContext.request.contextPath}";
        const resp = await fetch(base + "/admin/api/stats/overview");
        if (!resp.ok) throw new Error("Failed to load stats");
        return resp.json();
      }

      function renderCharts(data) {
        const donutCtx = document
          .getElementById("overviewDonut")
          .getContext("2d");
        new Chart(donutCtx, {
          type: "doughnut",
          data: {
            labels: ["Users", "Products", "Orders"],
            datasets: [
              {
                data: [data.users, data.products, data.orders],
                backgroundColor: ["#1976d2", "#43a047", "#e53935"],
              },
            ],
          },
          options: {
            plugins: { legend: { position: "bottom" } },
          },
        });

        const barCtx = document.getElementById("overviewBar").getContext("2d");
        new Chart(barCtx, {
          type: "bar",
          data: {
            labels: ["Users", "Products", "Orders"],
            datasets: [
              {
                label: "Counts",
                data: [data.users, data.products, data.orders],
                backgroundColor: ["#1976d2", "#43a047", "#e53935"],
              },
            ],
          },
          options: { scales: { y: { beginAtZero: true } } },
        });
      }

      (async function () {
        try {
          const data = await fetchOverviewSafe();
          renderCharts(data);
          // load orders chart default
          await loadOrdersChart("week");
        } catch (e) {
          console.error(e);
        }
      })();

      async function fetchOrders(period) {
        const base = "${pageContext.request.contextPath}";
        const resp = await fetch(
          base + "/admin/api/stats/orders?period=" + period
        );
        if (!resp.ok) throw new Error("Failed to load orders stats");
        return resp.json();
      }

      let ordersChart = null;
      async function loadOrdersChart(period) {
        try {
          const data = await fetchOrders(period);
          const labels = Object.keys(data);
          const values = Object.values(data);
          const ctx = document.getElementById("ordersChart").getContext("2d");
          if (ordersChart) ordersChart.destroy();
          ordersChart = new Chart(ctx, {
            type: "line",
            data: {
              labels: labels,
              datasets: [
                {
                  label: "Orders",
                  data: values,
                  fill: true,
                  backgroundColor: "rgba(25,118,210,0.08)",
                  borderColor: "#1976d2",
                },
              ],
            },
            options: { scales: { y: { beginAtZero: true } } },
          });
          // update total
          const total = values.reduce((acc, v) => acc + Number(v), 0);
          document.getElementById("ordersTotal").innerText = total;
        } catch (e) {
          console.error(e);
        }
      }

      document
        .getElementById("reloadBtn")
        .addEventListener("click", function () {
          const p = document.getElementById("periodSelect").value;
          loadOrdersChart(p);
        });

      document
        .getElementById("exportCsvBtn")
        .addEventListener("click", function () {
          const p = document.getElementById("periodSelect").value;
          fetchOrders(p)
            .then((data) => {
              const labels = Object.keys(data);
              const values = Object.values(data);
              let csv = "label,count\n";
              for (let i = 0; i < labels.length; i++)
                csv += `${labels[i]},${values[i]}\n`;
              const blob = new Blob([csv], { type: "text/csv;charset=utf-8;" });
              const url = URL.createObjectURL(blob);
              const a = document.createElement("a");
              a.href = url;
              a.download = `orders_${p}.csv`;
              document.body.appendChild(a);
              a.click();
              a.remove();
              URL.revokeObjectURL(url);
            })
            .catch((e) => console.error(e));
        });

      // Revenue
      async function fetchRevenue(period) {
        const base = "${pageContext.request.contextPath}";
        const resp = await fetch(
          base + "/admin/api/stats/revenue?period=" + period
        );
        if (!resp.ok) throw new Error("Failed to load revenue stats");
        return resp.json();
      }

      let revenueChart = null;
      async function loadRevenueChart(period) {
        try {
          const data = await fetchRevenue(period);
          const labels = Object.keys(data);
          const values = Object.values(data).map((v) => Number(v));
          const ctx = document.getElementById("revenueChart").getContext("2d");
          if (revenueChart) revenueChart.destroy();
          revenueChart = new Chart(ctx, {
            type: "line",
            data: {
              labels,
              datasets: [
                {
                  label: "Revenue",
                  data: values,
                  borderColor: "#43a047",
                  backgroundColor: "rgba(67,160,71,0.08)",
                  fill: true,
                },
              ],
            },
            options: { scales: { y: { beginAtZero: true } } },
          });
          const total = values.reduce((a, b) => a + b, 0);
          document.getElementById("revTotal").innerText = total.toFixed(2);
        } catch (e) {
          console.error(e);
        }
      }

      document
        .getElementById("reloadRevBtn")
        .addEventListener("click", function () {
          const p = document.getElementById("revPeriodSelect").value;
          loadRevenueChart(p);
        });

      document
        .getElementById("exportRevCsvBtn")
        .addEventListener("click", function () {
          const p = document.getElementById("revPeriodSelect").value;
          fetchRevenue(p)
            .then((data) => {
              const labels = Object.keys(data);
              const values = Object.values(data);
              let csv = "label,revenue\n";
              for (let i = 0; i < labels.length; i++)
                csv += `${labels[i]},${values[i]}\n`;
              const blob = new Blob([csv], { type: "text/csv;charset=utf-8;" });
              const url = URL.createObjectURL(blob);
              const a = document.createElement("a");
              a.href = url;
              a.download = `revenue_${p}.csv`;
              document.body.appendChild(a);
              a.click();
              a.remove();
              URL.revokeObjectURL(url);
            })
            .catch((e) => console.error(e));
        });

      // Top products
      async function fetchTopProducts(limit) {
        const base = "${pageContext.request.contextPath}";
        const resp = await fetch(
          base + "/admin/api/stats/top-products?limit=" + limit
        );
        if (!resp.ok) throw new Error("Failed to load top products");
        return resp.json();
      }

      let topChart = null;
      async function loadTopProducts(limit) {
        try {
          const data = await fetchTopProducts(limit);
          const labels = data.map((d) => d.name);
          const values = data.map((d) => d.sold);
          const ctx = document
            .getElementById("topProductsChart")
            .getContext("2d");
          if (topChart) topChart.destroy();
          topChart = new Chart(ctx, {
            type: "bar",
            data: {
              labels,
              datasets: [
                {
                  label: "Units sold",
                  data: values,
                  backgroundColor: "#ffb300",
                },
              ],
            },
            options: { indexAxis: "y", scales: { x: { beginAtZero: true } } },
          });
        } catch (e) {
          console.error(e);
        }
      }

      document
        .getElementById("reloadTopBtn")
        .addEventListener("click", function () {
          const lim = document.getElementById("topLimitSelect").value;
          loadTopProducts(lim);
        });

      document
        .getElementById("exportTopCsvBtn")
        .addEventListener("click", function () {
          const lim = document.getElementById("topLimitSelect").value;
          fetchTopProducts(lim)
            .then((data) => {
              let csv = "productId,name,sold,revenue\n";
              for (const r of data)
                csv += `${r.productId},"${r.name}",${r.sold},${r.revenue}\n`;
              const blob = new Blob([csv], { type: "text/csv;charset=utf-8;" });
              const url = URL.createObjectURL(blob);
              const a = document.createElement("a");
              a.href = url;
              a.download = `top_products_${lim}.csv`;
              document.body.appendChild(a);
              a.click();
              a.remove();
              URL.revokeObjectURL(url);
            })
            .catch((e) => console.error(e));
        });

      // initial loads for new charts
      (async function () {
        loadRevenueChart("week");
        loadTopProducts(document.getElementById("topLimitSelect").value);
      })();
    </script>
  </body>
</html>

<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ taglib
prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
  <head>
    <title>Trang quản trị</title>
    <meta name="viewport" content="width=device-width,initial-scale=1" />
    <link rel="stylesheet" href="<c:url value='/css/admin-dashboard.css'/>" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" />
  </head>
  <body>
    <div class="top-grid">
      <div class="card small">
        <div class="stat-widget-two card-body">
          <div class="stat-content">
            <div>
              <div class="stat-text">Total Users</div>
              <div class="stat-digit" id="total-users">Loading...</div>
            </div>
            <div style="text-align:right; color:var(--muted); font-size:12px;">Total</div>
          </div>
          <div class="progress"><span class="progress-bar progress-bar-success" style="width:100%"></span></div>
        </div>
      </div>

      <div class="card small">
        <div class="stat-widget-two card-body">
          <div class="stat-content">
            <div>
              <div class="stat-text">Total Products</div>
              <div class="stat-digit" id="total-products">Loading...</div>
            </div>
            <div style="text-align:right; color:var(--muted); font-size:12px;">Total</div>
          </div>
          <div class="progress"><span class="progress-bar progress-bar-primary" style="width:100%"></span></div>
        </div>
      </div>

      <div class="card small">
        <div class="stat-widget-two card-body">
          <div class="stat-content">
            <div>
              <div class="stat-text">Total Revenue</div>
              <div class="stat-digit" id="total-revenue">Loading...</div>
            </div>
            <div style="text-align:right; color:var(--muted); font-size:12px;">All time</div>
          </div>
          <div class="progress"><span class="progress-bar progress-bar-warning" style="width:100%"></span></div>
        </div>
      </div>

      <div class="card small">
        <div class="stat-widget-two card-body">
          <div class="stat-content">
            <div>
              <div class="stat-text">Orders</div>
              <div class="stat-digit" id="total-orders">Loading...</div>
            </div>
            <div style="text-align:right; color:var(--muted); font-size:12px;">Total</div>
          </div>
          <div class="progress"><span class="progress-bar progress-bar-danger" style="width:100%"></span></div>
        </div>
      </div>
    </div>

    <!-- app layout with collapsible sidebar -->
    <div class="app-layout">
  <!-- Metismenu-style sidebar -->
  <div class="quixnav sidebar" id="sidebar">
        <div class="quixnav-scroll">
          <button id="navToggle" class="nav-toggle-btn" title="Toggle sidebar">☰</button>
          <ul class="metismenu" id="menu">
            <li class="active">
              <a href="${pageContext.request.contextPath}/admin/dashboard"><i class="icon icon-home"></i><span class="nav-text">Dashboard</span></a>
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
            <li>
              <a href="${pageContext.request.contextPath}/admin/document"><i class="fas fa-file-alt"></i><span class="nav-text">Documents</span></a>
            </li>
            <li>
              <a href="${pageContext.request.contextPath}/admin/chat"><i class="fas fa-comments"></i><span class="nav-text">Chat</span></a>
            </li>
          </ul>
        </div>
      </div>

      <div class="main-content">

    <div class="section">
      <div class="charts-row">
        <div class="chart-box card">
          <div class="card-title">Thống kê</div>
          <div class="card-sub">Số lượng chính của hệ thống</div>
          <div class="controls" style="margin: 8px 0; display: flex; flex-wrap: wrap; gap: 16px;">
            <div>
              <label>Top Products</label>
              <select id="topLimitSelect">
                <option value="5">5</option>
                <option value="10" selected>10</option>
                <option value="20">20</option>
              </select>
              <button id="reloadTopBtn" class="btn">Reload</button>
            </div>
            <div style="margin-left: auto;">
              <label>User Stats</label>
              <select id="userTimePeriodSelect">
                <option value="week" selected>By Week</option>
                <option value="month">By Month</option>
              </select>
              <button id="reloadUsersBtn" class="btn">Reload</button>
            </div>
          </div>
          <div style="display: flex; gap: 20px; margin-top: 8px;">
            <div style="width: 280px; height: 280px;">
              <canvas id="topProductsChart"></canvas>
            </div>
            <div style="flex: 1; height: 280px;">
              <canvas id="usersByTimeChart"></canvas>
            </div>
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

    <div class="section">
      <div class="card revenue">
        <div class="card-title">Revenue</div>
        <div class="controls" style="margin: 8px 0">
          <select id="revPeriodSelect">
            <option value="week" selected>Last 7 days</option>
            <option value="month">By month</option>
          </select>
          <button id="reloadRevBtn" class="btn">Reload</button>
          <div style="margin-left: auto">
            Total Revenue: <strong id="revTotal">0</strong>
          </div>
        </div>
        <canvas id="revenueChart" height="140"></canvas>
      </div>
    </div>

    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script>
      // compute theme colors once (read from CSS variables)
      const __cs_theme = getComputedStyle(document.documentElement);
      const THEME = {
        primary: (__cs_theme.getPropertyValue("--primary") || "#1976d2").trim(),
        accent: (__cs_theme.getPropertyValue("--accent") || "#43a047").trim(),
        danger: (__cs_theme.getPropertyValue("--danger") || "#e53935").trim(),
        warning: (__cs_theme.getPropertyValue("--warning") || "#ffb300").trim(),
      };

      const hexToRgba = (hex, alpha) => {
        if (!hex) return null;
        let h = hex.replace("#", "").trim();
        if (h.length === 3)
          h = h
            .split("")
            .map((c) => c + c)
            .join("");
        const r = parseInt(h.slice(0, 2), 16);
        const g = parseInt(h.slice(2, 4), 16);
        const b = parseInt(h.slice(4, 6), 16);
        return `rgba(${r},${g},${b},${alpha})`;
      };

      // Safe fetch functions that work with contextPath

      // Function to load overview stats
      async function loadOverviewStats() {
        try {
          const base = "${pageContext.request.contextPath}";
          const resp = await fetch(base + "/admin/api/stats/overview");
          if (!resp.ok) throw new Error("Failed to load overview stats");
          const data = await resp.json();
          
          // Update the stat cards with actual data
          document.getElementById("total-users").textContent = data.users.toLocaleString();
          document.getElementById("total-products").textContent = data.products.toLocaleString();
          document.getElementById("total-revenue").textContent = "$" + parseFloat(data.totalRevenue).toLocaleString(undefined, {minimumFractionDigits: 2, maximumFractionDigits: 2});
          document.getElementById("total-orders").textContent = data.orders.toLocaleString();
          
        } catch (e) {
          console.error("Error loading overview stats:", e);
          // Set error message if data couldn't be loaded
          document.getElementById("total-users").textContent = "Error";
          document.getElementById("total-products").textContent = "Error";
          document.getElementById("total-revenue").textContent = "Error";
          document.getElementById("total-orders").textContent = "Error";
        }
      }

      // Initialize charts and stats
      (async function () {
        try {
          // load overview stats
          await loadOverviewStats();
          
          // load orders chart default
          await loadOrdersChart("week");
          // load revenue chart default - using same period as orders
          await loadRevenueChart("week");
          // load top products
          await loadTopProducts(document.getElementById("topLimitSelect").value);
          // load users by time chart
          await loadUsersByTimeChart('week');
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
                  backgroundColor:
                    hexToRgba(THEME.primary, 0.08) || "rgba(25,118,210,0.08)",
                  borderColor: THEME.primary || "#1976d2",
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

      // Export CSV functionality removed

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

      // Export CSV functionality removed

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
          
          // Generate an array of colors for the pie slices
          const generateColors = (count) => {
            const baseColors = [
              '#4285F4', '#EA4335', '#FBBC05', '#34A853', // Google colors
              '#3b82f6', '#ec4899', '#8b5cf6', '#10b981', '#f97316', // Additional vibrant colors
              '#6366f1', '#14b8a6', '#ef4444', '#f59e0b', '#84cc16' // More colors if needed
            ];
            
            // If we need more colors than our base list, we'll create variations
            if (count <= baseColors.length) {
              return baseColors.slice(0, count);
            } else {
              const result = [...baseColors];
              for (let i = baseColors.length; i < count; i++) {
                // Generate some variations of the base colors
                const baseIndex = i % baseColors.length;
                const opacity = 0.6 + (i / count * 0.4); // Vary opacity between 0.6-1.0
                result.push(hexToRgba(baseColors[baseIndex], opacity) || baseColors[baseIndex]);
              }
              return result;
            }
          };
          
          if (topChart) topChart.destroy();
          topChart = new Chart(ctx, {
            type: "pie", // Changed from "bar" to "pie"
            data: {
              labels,
              datasets: [
                {
                  label: "Units sold",
                  data: values,
                  backgroundColor: generateColors(values.length),
                  borderWidth: 1,
                  borderColor: '#ffffff'
                },
              ],
            },
            options: {
              responsive: true,
              plugins: {
                legend: {
                  position: 'right',
                  labels: {
                    // This more specific font property overrides the global property
                    font: {
                      size: 12
                    }
                  }
                },
                tooltip: {
                  callbacks: {
                    label: function(context) {
                      const label = context.label || '';
                      const value = context.raw || 0;
                      const total = context.dataset.data.reduce((acc, val) => acc + val, 0);
                      const percentage = ((value / total) * 100).toFixed(1);
                      return `${label}: ${value} units (${percentage}%)`;
                    }
                  }
                }
              }
            }
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

      // Export CSV functionality removed
        
      // Users by time chart functions
      async function fetchUsersByTime(period) {
        const base = "${pageContext.request.contextPath}";
        const resp = await fetch(
          base + "/admin/api/stats/users-by-time?period=" + period
        );
        if (!resp.ok) throw new Error("Failed to load user stats");
        return resp.json();
      }
      
      // Add event listener for user period selector
      document
        .getElementById("userTimePeriodSelect")
        .addEventListener("change", function() {
          const period = this.value;
          loadUsersByTimeChart(period);
        });
        
      document
        .getElementById("reloadUsersBtn")
        .addEventListener("click", function() {
          const period = document.getElementById("userTimePeriodSelect").value;
          loadUsersByTimeChart(period);
        });
      
      let usersByTimeChart = null;
      async function loadUsersByTimeChart(period = 'week') {
        try {
          // Use the real API endpoint to get user data
          const data = await fetchUsersByTime(period);
          
          const labels = Object.keys(data);
          const values = Object.values(data);
          
          const ctx = document.getElementById("usersByTimeChart").getContext("2d");
          if (usersByTimeChart) usersByTimeChart.destroy();
          
          usersByTimeChart = new Chart(ctx, {
            type: "line",
            data: {
              labels,
              datasets: [
                {
                  label: "User Registrations",
                  data: values,
                  fill: true,
                  borderColor: "#1976d2",
                  backgroundColor: hexToRgba(THEME.primary, 0.08) || "rgba(25,118,210,0.08)",
                  tension: 0.1,
                  pointRadius: 3,
                  pointHoverRadius: 5,
                }
              ]
            },
            options: {
              responsive: true,
              maintainAspectRatio: false,
              scales: {
                y: { 
                  beginAtZero: true,
                  title: {
                    display: true,
                    text: 'Number of Registrations'
                  }
                },
                x: {
                  title: {
                    display: true,
                    text: period === 'week' ? 'Date' : 'Month'
                  }
                }
              },
              plugins: {
                title: {
                  display: true,
                  text: 'User Registrations',
                  font: {
                    size: 16,
                  }
                },
                tooltip: {
                  callbacks: {
                    label: function(context) {
                      return `Registered users: ${context.raw}`;
                    }
                  }
                }
              }
            }
          });
        } catch (e) {
          console.error('Error loading users chart:', e);
        }
      }
      
      // No sample charts needed anymore

      // ensure main-content closes if layout inserted
      (function ensureLayoutClose(){
        const main = document.querySelector('.main-content');
        if (!main) return; // nothing to do
      })();

      // metismenu-like submenu toggles
      (function () {
        const menu = document.getElementById('menu');
        if (!menu) return;
        menu.querySelectorAll('.has-arrow').forEach((btn) => {
          btn.addEventListener('click', function (e) {
            e.preventDefault();
            const li = btn.parentElement;
            const sub = li.querySelector('ul');
            const expanded = btn.getAttribute('aria-expanded') === 'true';
            // close other open siblings
            li.parentElement.querySelectorAll(':scope > li').forEach((sibling) => {
              if (sibling !== li) {
                const a = sibling.querySelector('.has-arrow');
                if (a) {
                  a.setAttribute('aria-expanded', 'false');
                  const u = sibling.querySelector('ul');
                  if (u) u.style.display = 'none';
                }
              }
            });
            // toggle this one
            if (sub) {
              btn.setAttribute('aria-expanded', expanded ? 'false' : 'true');
              sub.style.display = expanded ? 'none' : 'block';
            }
          });
          // initially hide nested uls
          const sib = btn.parentElement.querySelector('ul');
          if (sib) sib.style.display = 'none';
        });
      })();

      // sidebar toggle: wire toggle button, live toggle and persist state
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

        // initial apply
        apply();

        // toggle on click
        toggle.addEventListener('click', function () {
          const current = isCollapsed();
          localStorage.setItem('admin_sidebar_collapsed', current ? '0' : '1');
          apply();
        });

        // update on resize
        window.addEventListener('resize', apply);
      })();
    </script>
  </body>
</html>

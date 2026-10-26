<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.Map,com.internlink.model.Admin" %>
<%!
    private String escapeHtml(String value) {
        if (value == null) return "";
        return value.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")
                .replace("\"", "&quot;").replace("'", "&#39;");
    }
%>
<%
    if (!(session.getAttribute("admin") instanceof Admin)) {
        response.sendRedirect(request.getContextPath() + "/admin/login.jsp");
        return;
    }
    if (!Boolean.TRUE.equals(request.getAttribute("reportsReady"))
            && request.getAttribute("reportsError") == null) {
        response.sendRedirect(request.getContextPath() + "/ReportsServlet");
        return;
    }
    Map<String, Integer> statusCounts = (Map<String, Integer>) request.getAttribute("statusCounts");
    int maxCount = 0;
    if (statusCounts != null) {
        for (Integer count : statusCounts.values()) {
            if (count != null && count > maxCount) maxCount = count;
        }
    }
    String reportsError = (String) request.getAttribute("reportsError");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Placement Reports | InternLink</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css?v=20261019">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
    <style>
        .report-panel { padding: 22px; border-radius: 12px; }
        .report-chart { display: grid; gap: 18px; }
        .chart-row { display: grid; grid-template-columns: minmax(100px, 160px) minmax(100px, 1fr) 48px; align-items: center; gap: 14px; }
        .chart-label, .chart-value { font-size: 12px; }
        .chart-value { color: var(--muted); text-align: right; }
        .chart-track { height: 12px; overflow: hidden; border-radius: 999px; background: var(--panel-soft); }
        .chart-bar { height: 100%; min-width: 2px; border-radius: inherit; background: linear-gradient(90deg, var(--green), var(--green-soft)); }
        .empty-state { padding: 24px 10px; color: var(--muted); text-align: center; }
        @media (max-width: 600px) { .chart-row { grid-template-columns: 95px minmax(50px, 1fr) 36px; gap: 8px; } }
    </style>
</head>
<body class="app-shell">
<div class="dashboard-layout">
    <aside class="sidebar">
        <a class="brand" href="<%= request.getContextPath() %>/index.jsp"><span class="brand-mark material-symbols-outlined">trending_up</span><span>InternLink</span></a>
        <nav class="side-nav" aria-label="Admin navigation">
            <a href="<%= request.getContextPath() %>/AdminDashboardServlet"><span class="material-symbols-outlined">space_dashboard</span>Overview</a>
            <a href="<%= request.getContextPath() %>/ManageStudentsServlet"><span class="material-symbols-outlined">school</span>Manage students</a>
            <a href="<%= request.getContextPath() %>/ManageCompaniesServlet"><span class="material-symbols-outlined">business</span>Manage companies</a>
            <a href="<%= request.getContextPath() %>/ManageInternshipsServlet"><span class="material-symbols-outlined">work</span>Manage internships</a>
            <a href="<%= request.getContextPath() %>/ViewApplicationsServlet"><span class="material-symbols-outlined">assignment</span>View applications</a>
            <a class="active" href="<%= request.getContextPath() %>/ReportsServlet"><span class="material-symbols-outlined">bar_chart</span>Reports</a>
        </nav>
        <div class="side-separator"></div>
        <nav class="side-nav" aria-label="Account navigation">
            <a href="<%= request.getContextPath() %>/LogoutServlet"><span class="material-symbols-outlined">logout</span>Logout</a>
        </nav>
    </aside>
    <main class="dashboard-main">
        <header class="dashboard-top">
            <div><span class="eyebrow">Administration</span><h1>Placement reports.</h1><p>Application outcomes and placement statistics from current platform data.</p></div>
        </header>
        <% if (reportsError != null) { %>
            <div class="status-box error" role="alert"><%= escapeHtml(reportsError) %></div>
        <% } else { %>
            <section class="metrics" aria-label="Placement statistics">
                <article class="metric-card glass">
                    <span class="material-symbols-outlined">assignment</span>
                    <p class="metric-label">Total applications</p>
                    <p class="metric-value"><%= request.getAttribute("totalApplications") %></p>
                </article>
                <article class="metric-card glass">
                    <span class="material-symbols-outlined">verified</span>
                    <p class="metric-label">Selected applications</p>
                    <p class="metric-value"><%= request.getAttribute("selectedApplications") %></p>
                </article>
                <article class="metric-card glass">
                    <span class="material-symbols-outlined">percent</span>
                    <p class="metric-label">Selection rate</p>
                    <p class="metric-value"><%= request.getAttribute("selectionRate") %>%</p>
                </article>
                <article class="metric-card glass">
                    <span class="material-symbols-outlined">work</span>
                    <p class="metric-label">Internship postings</p>
                    <p class="metric-value"><%= request.getAttribute("internshipCount") %></p>
                </article>
            </section>
            <section class="report-panel glass" aria-labelledby="status-chart-title">
                <div class="panel-head"><h2 id="status-chart-title">Applications by status</h2><span>Current totals</span></div>
                <% if (statusCounts == null || statusCounts.isEmpty()) { %>
                    <div class="empty-state">There are no applications to report yet.</div>
                <% } else { %>
                    <div class="report-chart" role="img" aria-label="Bar chart of application counts by status">
                        <% for (Map.Entry<String, Integer> entry : statusCounts.entrySet()) {
                            int count = entry.getValue() == null ? 0 : entry.getValue();
                            int width = maxCount == 0 ? 0 : (int) Math.round(count * 100.0 / maxCount);
                        %>
                            <div class="chart-row">
                                <span class="chart-label"><%= escapeHtml(entry.getKey()) %></span>
                                <div class="chart-track"><div class="chart-bar" style="width:<%= width %>%"></div></div>
                                <span class="chart-value"><%= count %></span>
                            </div>
                        <% } %>
                    </div>
                <% } %>
            </section>
        <% } %>
    </main>
</div>
</body>
</html>

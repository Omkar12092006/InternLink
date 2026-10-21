<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.internlink.model.Admin" %>
<%
    if (!(session.getAttribute("admin") instanceof Admin)) {
        response.sendRedirect(request.getContextPath() + "/admin/login.jsp");
        return;
    }
    if (!Boolean.TRUE.equals(request.getAttribute("dashboardReady"))) {
        response.sendRedirect(request.getContextPath() + "/AdminDashboardServlet");
        return;
    }
    String dashboardError = (String) request.getAttribute("dashboardError");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard | InternLink</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css?v=20261019">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
</head>
<body class="app-shell">
    <div class="dashboard-layout">
        <aside class="sidebar">
            <a class="brand" href="<%= request.getContextPath() %>/index.jsp">
                <span class="brand-mark material-symbols-outlined">trending_up</span><span>InternLink</span>
            </a>
            <nav class="side-nav" aria-label="Admin navigation">
                <a class="active" href="<%= request.getContextPath() %>/AdminDashboardServlet">
                    <span class="material-symbols-outlined">space_dashboard</span>Overview
                </a>
                <a href="<%= request.getContextPath() %>/browseInternships.jsp">
                    <span class="material-symbols-outlined">work</span>Browse internships
                </a>
            </nav>
            <div class="side-separator"></div>
            <nav class="side-nav" aria-label="Account navigation">
                <a href="<%= request.getContextPath() %>/LogoutServlet">
                    <span class="material-symbols-outlined">logout</span>Logout
                </a>
            </nav>
        </aside>

        <main class="dashboard-main">
            <header class="dashboard-top">
                <div>
                    <span class="eyebrow">Administration</span>
                    <h1>System overview.</h1>
                    <p>Platform activity at a glance.</p>
                </div>
                <div class="dashboard-tools">
                    <span class="status-box success">
                        <span class="material-symbols-outlined">admin_panel_settings</span>
                        Administrator
                    </span>
                </div>
            </header>

            <% if (dashboardError != null) { %>
                <div class="status-box error" role="alert"><%= dashboardError %></div>
            <% } else { %>
                <section class="metrics" aria-label="System overview metrics">
                    <article class="metric-card glass">
                        <span class="material-symbols-outlined">school</span>
                        <p class="metric-label">Total students</p>
                        <p class="metric-value"><%= request.getAttribute("studentCount") %></p>
                    </article>
                    <article class="metric-card glass">
                        <span class="material-symbols-outlined">business</span>
                        <p class="metric-label">Total companies</p>
                        <p class="metric-value"><%= request.getAttribute("companyCount") %></p>
                    </article>
                    <article class="metric-card glass">
                        <span class="material-symbols-outlined">work</span>
                        <p class="metric-label">Total internships</p>
                        <p class="metric-value"><%= request.getAttribute("internshipCount") %></p>
                    </article>
                    <article class="metric-card glass">
                        <span class="material-symbols-outlined">assignment</span>
                        <p class="metric-label">Total applications</p>
                        <p class="metric-value"><%= request.getAttribute("applicationCount") %></p>
                    </article>
                </section>
            <% } %>
        </main>
    </div>
</body>
</html>

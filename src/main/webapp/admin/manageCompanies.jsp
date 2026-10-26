<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List,com.internlink.model.Admin,com.internlink.model.Company" %>
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
    if (!Boolean.TRUE.equals(request.getAttribute("managementReady"))) {
        response.sendRedirect(request.getContextPath() + "/ManageCompaniesServlet");
        return;
    }
    List<Company> companies = (List<Company>) request.getAttribute("companies");
    String managementMessage = (String) request.getAttribute("managementMessage");
    String managementError = (String) request.getAttribute("managementError");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Companies | InternLink</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css?v=20261019">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
    <style>
        .management-panel { overflow-x: auto; padding: 22px; border-radius: 12px; }
        .management-table { width: 100%; border-collapse: collapse; text-align: left; }
        .management-table th, .management-table td { padding: 12px 10px; border-bottom: 1px solid var(--line); vertical-align: middle; }
        .management-table th { color: var(--muted); font-size: 11px; text-transform: uppercase; }
        .management-table td { font-size: 12px; }
        .row-actions { display: flex; flex-wrap: wrap; gap: 8px; }
        .row-actions form { display: inline; }
        .management-button { padding: 8px 10px; border: 1px solid var(--line); border-radius: 7px; color: var(--text); background: var(--panel-soft); cursor: pointer; font: inherit; font-size: 11px; }
        .management-button.primary { color: var(--ink); border-color: var(--green); background: var(--green); font-weight: 700; }
        .management-button.danger { color: #ffd4db; }
        .empty-state { padding: 24px 10px; color: var(--muted); text-align: center; }
    </style>
</head>
<body class="app-shell">
<div class="dashboard-layout">
    <aside class="sidebar">
        <a class="brand" href="<%= request.getContextPath() %>/index.jsp">
            <span class="brand-mark material-symbols-outlined">trending_up</span><span>InternLink</span>
        </a>
        <nav class="side-nav" aria-label="Admin navigation">
            <a href="<%= request.getContextPath() %>/AdminDashboardServlet"><span class="material-symbols-outlined">space_dashboard</span>Overview</a>
            <a href="<%= request.getContextPath() %>/ManageStudentsServlet"><span class="material-symbols-outlined">school</span>Manage students</a>
            <a class="active" href="<%= request.getContextPath() %>/ManageCompaniesServlet"><span class="material-symbols-outlined">business</span>Manage companies</a>
            <a href="<%= request.getContextPath() %>/ManageInternshipsServlet"><span class="material-symbols-outlined">work</span>Manage internships</a>
            <a href="<%= request.getContextPath() %>/ViewApplicationsServlet"><span class="material-symbols-outlined">assignment</span>View applications</a>
            <a href="<%= request.getContextPath() %>/ReportsServlet"><span class="material-symbols-outlined">bar_chart</span>Reports</a>
        </nav>
        <div class="side-separator"></div>
        <nav class="side-nav" aria-label="Account navigation">
            <a href="<%= request.getContextPath() %>/LogoutServlet"><span class="material-symbols-outlined">logout</span>Logout</a>
        </nav>
    </aside>
    <main class="dashboard-main">
        <header class="dashboard-top">
            <div>
                <span class="eyebrow">Administration</span>
                <h1>Manage companies.</h1>
                <p>Review company accounts and their verification status.</p>
            </div>
        </header>
        <% if (managementMessage != null) { %>
            <div class="status-box success" role="status"><%= escapeHtml(managementMessage) %></div>
        <% } %>
        <% if (managementError != null) { %>
            <div class="status-box error" role="alert"><%= escapeHtml(managementError) %></div>
        <% } %>
        <section class="management-panel glass">
            <div class="panel-head"><h2>Company accounts</h2><span><%= companies == null ? 0 : companies.size() %> accounts</span></div>
            <% if (companies == null) { %>
                <div class="empty-state">Company accounts could not be loaded.</div>
            <% } else if (companies.isEmpty()) { %>
                <div class="empty-state">There are no company accounts yet.</div>
            <% } else { %>
                <table class="management-table">
                    <thead><tr><th>Company</th><th>Contact</th><th>Email</th><th>Industry</th><th>Location</th><th>Status</th><th>Actions</th></tr></thead>
                    <tbody>
                    <% for (Company company : companies) { %>
                        <tr>
                            <td><%= escapeHtml(company.getCompanyName()) %></td>
                            <td><%= escapeHtml(company.getHrName()) %></td>
                            <td><%= escapeHtml(company.getEmail()) %></td>
                            <td><%= escapeHtml(company.getIndustry()) %></td>
                            <td><%= escapeHtml(company.getLocation()) %></td>
                            <td><span class="badge <%= company.isVerified() ? "badge-green" : "badge-amber" %>"><%= company.isVerified() ? "Verified" : "Pending" %></span></td>
                            <td>
                                <div class="row-actions">
                                    <% if (company.isVerified()) { %>
                                        <form action="<%= request.getContextPath() %>/ManageCompaniesServlet" method="post">
                                            <input type="hidden" name="action" value="reject">
                                            <input type="hidden" name="companyId" value="<%= company.getId() %>">
                                            <button class="management-button" type="submit">Reject</button>
                                        </form>
                                    <% } else { %>
                                        <form action="<%= request.getContextPath() %>/ManageCompaniesServlet" method="post">
                                            <input type="hidden" name="action" value="verify">
                                            <input type="hidden" name="companyId" value="<%= company.getId() %>">
                                            <button class="management-button primary" type="submit">Verify</button>
                                        </form>
                                    <% } %>
                                    <form action="<%= request.getContextPath() %>/ManageCompaniesServlet" method="post" onsubmit="return confirm('Delete this company account?');">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="companyId" value="<%= company.getId() %>">
                                        <button class="management-button danger" type="submit">Delete</button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                    <% } %>
                    </tbody>
                </table>
            <% } %>
        </section>
    </main>
</div>
</body>
</html>

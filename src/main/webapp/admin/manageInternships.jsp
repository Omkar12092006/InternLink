<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List,com.internlink.model.Admin,com.internlink.model.Internship" %>
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
    if (!Boolean.TRUE.equals(request.getAttribute("moderationReady"))) {
        response.sendRedirect(request.getContextPath() + "/ManageInternshipsServlet");
        return;
    }
    List<Internship> internships = (List<Internship>) request.getAttribute("internships");
    String message = (String) request.getAttribute("moderationMessage");
    String error = (String) request.getAttribute("moderationError");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Internships | InternLink</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css?v=20261019">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
    <style>
        .management-panel { overflow-x: auto; padding: 22px; border-radius: 12px; }
        .management-table { width: 100%; border-collapse: collapse; text-align: left; }
        .management-table th, .management-table td { padding: 12px 10px; border-bottom: 1px solid var(--line); vertical-align: top; }
        .management-table th { color: var(--muted); font-size: 11px; text-transform: uppercase; }
        .management-table td { font-size: 12px; }
        .row-actions, .row-actions form { display: flex; flex-wrap: wrap; gap: 8px; }
        .management-button { padding: 8px 10px; border: 1px solid var(--line); border-radius: 7px; color: var(--text); background: var(--panel-soft); cursor: pointer; font: inherit; font-size: 11px; }
        .management-button.primary { color: var(--ink); border-color: var(--green); background: var(--green); font-weight: 700; }
        .management-button.danger { color: #ffd4db; }
        .empty-state { padding: 24px 10px; color: var(--muted); text-align: center; }
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
            <a class="active" href="<%= request.getContextPath() %>/ManageInternshipsServlet"><span class="material-symbols-outlined">work</span>Manage internships</a>
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
            <div><span class="eyebrow">Administration</span><h1>Manage internships.</h1><p>Review new listings before publishing and remove unsuitable postings.</p></div>
        </header>
        <% if (message != null) { %><div class="status-box success" role="status"><%= escapeHtml(message) %></div><% } %>
        <% if (error != null) { %><div class="status-box error" role="alert"><%= escapeHtml(error) %></div><% } %>
        <section class="management-panel glass">
            <div class="panel-head"><h2>Internship postings</h2><span><%= internships == null ? 0 : internships.size() %> postings</span></div>
            <% if (internships == null) { %>
                <div class="empty-state">Internship postings could not be loaded.</div>
            <% } else if (internships.isEmpty()) { %>
                <div class="empty-state">There are no internship postings yet.</div>
            <% } else { %>
                <table class="management-table">
                    <thead><tr><th>Role</th><th>Company</th><th>Location</th><th>Posted</th><th>Status</th><th>Actions</th></tr></thead>
                    <tbody>
                    <% for (Internship internship : internships) { %>
                        <tr>
                            <td><strong><%= escapeHtml(internship.getTitle()) %></strong><br><%= escapeHtml(internship.getCategory()) %></td>
                            <td><%= escapeHtml(internship.getCompany()) %></td>
                            <td><%= escapeHtml(internship.getLocation()) %></td>
                            <td><%= internship.getPostedDate() == null ? "—" : internship.getPostedDate() %></td>
                            <td><span class="badge <%= internship.isApproved() ? "badge-green" : "badge-amber" %>"><%= internship.isApproved() ? "Approved" : "Pending review" %></span></td>
                            <td><div class="row-actions">
                                <% if (!internship.isApproved()) { %>
                                    <form action="<%= request.getContextPath() %>/ManageInternshipsServlet" method="post">
                                        <input type="hidden" name="action" value="approve">
                                        <input type="hidden" name="internshipId" value="<%= internship.getId() %>">
                                        <button class="management-button primary" type="submit">Approve</button>
                                    </form>
                                <% } %>
                                <form action="<%= request.getContextPath() %>/ManageInternshipsServlet" method="post" onsubmit="return confirm('Remove this posting? Its applications will also be deleted.');">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="internshipId" value="<%= internship.getId() %>">
                                    <button class="management-button danger" type="submit">Remove</button>
                                </form>
                            </div></td>
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

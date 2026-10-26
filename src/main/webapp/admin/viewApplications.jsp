<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List,com.internlink.model.Admin,com.internlink.model.Application" %>
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
    if (!Boolean.TRUE.equals(request.getAttribute("applicationsReady"))) {
        response.sendRedirect(request.getContextPath() + "/ViewApplicationsServlet");
        return;
    }
    List<Application> applications = (List<Application>) request.getAttribute("applications");
    String error = (String) request.getAttribute("applicationsError");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>All Applications | InternLink</title>
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
        .management-table td { min-width: 100px; font-size: 12px; }
        .cover-letter { min-width: 200px !important; max-width: 360px; white-space: pre-wrap; overflow-wrap: anywhere; }
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
            <a href="<%= request.getContextPath() %>/ManageInternshipsServlet"><span class="material-symbols-outlined">work</span>Manage internships</a>
            <a class="active" href="<%= request.getContextPath() %>/ViewApplicationsServlet"><span class="material-symbols-outlined">assignment</span>View applications</a>
            <a href="<%= request.getContextPath() %>/ReportsServlet"><span class="material-symbols-outlined">bar_chart</span>Reports</a>
        </nav>
        <div class="side-separator"></div>
        <nav class="side-nav" aria-label="Account navigation">
            <a href="<%= request.getContextPath() %>/LogoutServlet"><span class="material-symbols-outlined">logout</span>Logout</a>
        </nav>
    </aside>
    <main class="dashboard-main">
        <header class="dashboard-top">
            <div><span class="eyebrow">Administration</span><h1>All applications.</h1><p>Review application activity across every internship.</p></div>
        </header>
        <% if (error != null) { %><div class="status-box error" role="alert"><%= escapeHtml(error) %></div><% } %>
        <section class="management-panel glass">
            <div class="panel-head"><h2>Applications</h2><span><%= applications == null ? 0 : applications.size() %> applications</span></div>
            <% if (applications == null) { %>
                <div class="empty-state">Applications could not be loaded.</div>
            <% } else if (applications.isEmpty()) { %>
                <div class="empty-state">There are no applications yet.</div>
            <% } else { %>
                <table class="management-table">
                    <thead><tr><th>Applicant</th><th>Email</th><th>University</th><th>Internship</th><th>Company</th><th>Status</th><th>Applied</th><th>Resume link</th><th>Cover letter</th></tr></thead>
                    <tbody>
                    <% for (Application applicationRecord : applications) { %>
                        <tr>
                            <td><%= escapeHtml(applicationRecord.getApplicantName()) %></td>
                            <td><%= escapeHtml(applicationRecord.getApplicantEmail()) %></td>
                            <td><%= escapeHtml(applicationRecord.getUniversity()) %></td>
                            <td><%= escapeHtml(applicationRecord.getInternshipTitle()) %><br><%= escapeHtml(applicationRecord.getInternshipLocation()) %></td>
                            <td><%= escapeHtml(applicationRecord.getInternshipCompany()) %></td>
                            <td><span class="badge badge-blue"><%= escapeHtml(applicationRecord.getStatus()) %></span></td>
                            <td><%= applicationRecord.getAppliedDate() == null ? "—" : applicationRecord.getAppliedDate().toString().replace('T', ' ') %></td>
                            <td><%= escapeHtml(applicationRecord.getResumeLink()) %></td>
                            <td class="cover-letter"><%= escapeHtml(applicationRecord.getCoverLetter()) %></td>
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

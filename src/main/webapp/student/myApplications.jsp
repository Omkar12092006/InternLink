<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.time.format.DateTimeFormatter,java.util.List,com.internlink.model.Application,com.internlink.model.Student" %>
<%!
    private String escapeHtml(String value) {
        if (value == null) return "";
        return value.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")
                .replace("\"", "&quot;").replace("'", "&#39;");
    }
%>
<%
    Student student = (Student) request.getAttribute("student");
    if (student == null) {
        response.sendRedirect(request.getContextPath() + "/MyApplicationsServlet");
        return;
    }
    List<Application> applications = (List<Application>) request.getAttribute("applications");
    String error = (String) request.getAttribute("applicationsError");
    DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("MMM d, yyyy");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Applications | InternLink</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css?v=20261019">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
</head>
<body class="app-shell">
<div class="dashboard-layout">
    <aside class="sidebar">
        <a class="brand" href="<%= request.getContextPath() %>/index.jsp"><span class="brand-mark material-symbols-outlined">trending_up</span><span>InternLink</span></a>
        <nav class="side-nav" aria-label="Student navigation">
            <a href="<%= request.getContextPath() %>/StudentDashboardServlet"><span class="material-symbols-outlined">space_dashboard</span>Dashboard</a>
            <a href="<%= request.getContextPath() %>/StudentProfileServlet"><span class="material-symbols-outlined">person</span>My Profile</a>
            <a class="active" href="<%= request.getContextPath() %>/MyApplicationsServlet"><span class="material-symbols-outlined">work_history</span>Applications</a>
            <a href="<%= request.getContextPath() %>/StudentInterviewsServlet"><span class="material-symbols-outlined">calendar_month</span>Interviews</a>
            <a href="<%= request.getContextPath() %>/browseInternships.jsp"><span class="material-symbols-outlined">search</span>Find Internships</a>
        </nav>
        <div class="side-separator"></div>
        <nav class="side-nav"><a href="<%= request.getContextPath() %>/LogoutServlet"><span class="material-symbols-outlined">logout</span>Logout</a></nav>
    </aside>
    <main class="dashboard-main">
        <header class="dashboard-top">
            <div><span class="eyebrow">Student workspace</span><h1>My applications.</h1><p>Track the status of your internship applications.</p></div>
            <a class="button button-primary" href="<%= request.getContextPath() %>/browseInternships.jsp">Find internships</a>
        </header>
        <% if (error != null) { %>
            <div class="status-box error" role="alert"><%= escapeHtml(error) %></div>
        <% } else if (Boolean.TRUE.equals(request.getAttribute("applicationsReady"))) { %>
            <section class="panel glass" style="padding:2rem;">
                <div class="panel-head"><h2>Application history</h2><span><%= applications.size() %> applications</span></div>
                <% if (applications.isEmpty()) { %>
                    <div class="empty-state"><p>You have not applied to any internships yet.</p></div>
                <% } else { %>
                    <div class="form-stack">
                        <% for (Application applicationRecord : applications) { %>
                            <article class="application">
                                <span class="company-logo"><%= applicationRecord.getInternshipCompany() == null || applicationRecord.getInternshipCompany().isBlank() ? "IL" : escapeHtml(applicationRecord.getInternshipCompany().substring(0, 1).toUpperCase()) %></span>
                                <div class="application-copy">
                                    <strong><a href="<%= request.getContextPath() %>/applyInternship.jsp?id=<%= applicationRecord.getInternshipId() %>"><%= escapeHtml(applicationRecord.getInternshipTitle()) %></a></strong>
                                    <span><%= escapeHtml(applicationRecord.getInternshipCompany()) %> · <%= escapeHtml(applicationRecord.getInternshipLocation()) %>
                                        <% if (applicationRecord.getAppliedDate() != null) { %> · Applied <%= applicationRecord.getAppliedDate().format(dateFormatter) %><% } %>
                                    </span>
                                </div>
                                <span class="badge badge-blue"><%= escapeHtml(applicationRecord.getStatus()) %></span>
                            </article>
                        <% } %>
                    </div>
                <% } %>
            </section>
        <% } %>
    </main>
</div>
</body>
</html>

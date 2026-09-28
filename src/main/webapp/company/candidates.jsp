<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.internlink.model.Application" %>
<%@ page import="com.internlink.model.Company" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.util.Collections" %>
<%@ page import="java.util.List" %>
<%
    if (request.getAttribute("applications") == null || request.getAttribute("company") == null) {
        response.sendRedirect(request.getContextPath() + "/CompanyCandidatesServlet");
        return;
    }
    Company company = (Company) request.getAttribute("company");
    List<Application> applications = (List<Application>) request.getAttribute("applications");
    if (applications == null) applications = Collections.emptyList();
    DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("MMM d, yyyy");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Candidates | InternLink</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css?v=20260928">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
</head>
<body class="app-shell">
    <div class="dashboard-layout">
        <aside class="sidebar">
            <a class="brand" href="<%= request.getContextPath() %>/index.jsp"><span class="brand-mark material-symbols-outlined">trending_up</span><span>InternLink</span></a>
            <nav class="side-nav" aria-label="Company candidates navigation">
                <a href="<%= request.getContextPath() %>/company/dashboard.jsp"><span class="material-symbols-outlined">space_dashboard</span>Dashboard</a>
                <a href="<%= request.getContextPath() %>/CompanyProfileServlet"><span class="material-symbols-outlined">person</span>Company Profile</a>
                <a href="<%= request.getContextPath() %>/company/postings.jsp"><span class="material-symbols-outlined">work</span>Postings</a>
                <a class="active" href="<%= request.getContextPath() %>/CompanyCandidatesServlet"><span class="material-symbols-outlined">group</span>Candidates</a>
                <a href="<%= request.getContextPath() %>/ReviewApplicationsServlet"><span class="material-symbols-outlined">fact_check</span>Review Applications</a>
            </nav>
            <div class="side-separator"></div>
            <nav class="side-nav">
                <a href="<%= request.getContextPath() %>/LogoutServlet"><span class="material-symbols-outlined">logout</span>Logout</a>
            </nav>
        </aside>

        <main class="dashboard-main">
            <header class="dashboard-top">
                <div>
                    <span class="eyebrow">Candidates</span>
                    <h1>Applicant pipeline</h1>
                    <p>Applicants for <%= company.getCompanyName() %> internships.</p>
                </div>
                <div class="dashboard-tools">
                    <a href="<%= request.getContextPath() %>/ReviewApplicationsServlet" class="button button-primary">Review applications</a>
                    <a href="<%= request.getContextPath() %>/company/dashboard.jsp" class="button button-ghost">Back to dashboard</a>
                </div>
            </header>

            <section class="panel glass" style="padding:2rem;">
                <div class="panel-head">
                    <h2>Applicants</h2>
                    <span class="badge badge-blue"><%= applications.size() %> applications</span>
                </div>
                <% if (applications.isEmpty()) { %>
                    <div class="empty-state">
                        <p>No students have applied to your internships yet.</p>
                        <a class="button button-primary" href="<%= request.getContextPath() %>/company/postings.jsp">Manage internship postings</a>
                    </div>
                <% } else { %>
                    <div class="form-stack">
                        <% for (Application applicationRecord : applications) { %>
                            <article class="application">
                                <span class="company-logo"><%= applicationRecord.getApplicantName() == null || applicationRecord.getApplicantName().isBlank() ? "?" : applicationRecord.getApplicantName().substring(0, 1).toUpperCase() %></span>
                                <div class="application-copy">
                                    <strong><%= applicationRecord.getApplicantName() %></strong>
                                    <span><%= applicationRecord.getUniversity() == null || applicationRecord.getUniversity().isBlank() ? "University not provided" : applicationRecord.getUniversity() %> · <%= applicationRecord.getApplicantEmail() %></span>
                                    <span><%= applicationRecord.getInternshipTitle() %> · <%= applicationRecord.getInternshipLocation() %>
                                        <% if (applicationRecord.getAppliedDate() != null) { %> · Applied <%= applicationRecord.getAppliedDate().format(dateFormatter) %><% } %>
                                    </span>
                                </div>
                                <span class="badge badge-blue"><%= applicationRecord.getStatus() %></span>
                            </article>
                        <% } %>
                    </div>
                <% } %>
            </section>
        </main>
    </div>
</body>
</html>

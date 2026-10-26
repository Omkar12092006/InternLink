<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.time.format.DateTimeFormatter,java.util.Collections,java.util.List,com.internlink.model.Interview,com.internlink.model.Student" %>
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
        response.sendRedirect(request.getContextPath() + "/StudentInterviewsServlet");
        return;
    }
    List<Interview> interviews = (List<Interview>) request.getAttribute("interviews");
    if (interviews == null) interviews = Collections.emptyList();
    String error = (String) request.getAttribute("interviewsError");
    DateTimeFormatter displayDate = DateTimeFormatter.ofPattern("EEEE, MMM d, yyyy 'at' h:mm a");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Interviews | InternLink</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css?v=20261019">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
    <style>
        .interview-card { padding: 22px; margin-bottom: 14px; border-radius: 12px; }
        .interview-card h2 { margin: 0 0 8px; font-size: 17px; }
        .interview-detail { display: flex; align-items: center; gap: 9px; margin-top: 10px; color: var(--muted); font-size: 13px; }
        .interview-notes { margin-top: 14px; padding: 12px; border-radius: 8px; background: var(--panel-soft); white-space: pre-wrap; overflow-wrap: anywhere; font-size: 13px; }
        .interview-card a { color: var(--green-soft); overflow-wrap: anywhere; }
        .empty-state { padding: 24px 10px; color: var(--muted); text-align: center; }
    </style>
</head>
<body class="app-shell">
<div class="dashboard-layout">
    <aside class="sidebar">
        <a class="brand" href="<%= request.getContextPath() %>/index.jsp"><span class="brand-mark material-symbols-outlined">trending_up</span><span>InternLink</span></a>
        <nav class="side-nav" aria-label="Student navigation">
            <a href="<%= request.getContextPath() %>/StudentDashboardServlet"><span class="material-symbols-outlined">space_dashboard</span>Dashboard</a>
            <a href="<%= request.getContextPath() %>/StudentProfileServlet"><span class="material-symbols-outlined">person</span>My Profile</a>
            <a href="<%= request.getContextPath() %>/MyApplicationsServlet"><span class="material-symbols-outlined">work_history</span>Applications</a>
            <a class="active" href="<%= request.getContextPath() %>/StudentInterviewsServlet"><span class="material-symbols-outlined">calendar_month</span>Interviews</a>
            <a href="<%= request.getContextPath() %>/browseInternships.jsp"><span class="material-symbols-outlined">search</span>Find Internships</a>
        </nav>
        <div class="side-separator"></div>
        <nav class="side-nav"><a href="<%= request.getContextPath() %>/LogoutServlet"><span class="material-symbols-outlined">logout</span>Logout</a></nav>
    </aside>
    <main class="dashboard-main">
        <header class="dashboard-top">
            <div><span class="eyebrow">Student workspace</span><h1>My interviews.</h1><p>View interview schedules and updates from employers.</p></div>
        </header>
        <% if (error != null) { %>
            <div class="status-box error" role="alert"><%= escapeHtml(error) %></div>
        <% } else if (Boolean.TRUE.equals(request.getAttribute("interviewsReady"))) { %>
            <% if (interviews.isEmpty()) { %>
                <section class="panel glass empty-state"><p>No interviews have been scheduled for you yet.</p></section>
            <% } else { %>
                <% for (Interview interviewRecord : interviews) { %>
                    <article class="interview-card glass">
                        <div class="panel-head">
                            <div><span class="eyebrow">Interview</span><h2><%= escapeHtml(interviewRecord.getInternshipTitle()) %></h2></div>
                            <span class="badge <%= "Cancelled".equals(interviewRecord.getStatus()) ? "badge-amber" : "badge-green" %>"><%= escapeHtml(interviewRecord.getStatus()) %></span>
                        </div>
                        <div class="interview-detail"><span class="material-symbols-outlined">business</span><%= escapeHtml(interviewRecord.getInternshipCompany()) %></div>
                        <% if (interviewRecord.getScheduledAt() != null) { %>
                            <div class="interview-detail"><span class="material-symbols-outlined">schedule</span><%= interviewRecord.getScheduledAt().format(displayDate) %></div>
                        <% } %>
                        <div class="interview-detail"><span class="material-symbols-outlined">meeting_room</span><%= escapeHtml(interviewRecord.getMode()) %></div>
                        <% if (interviewRecord.getMeetingLink() != null && !interviewRecord.getMeetingLink().isBlank()) { %>
                            <div class="interview-detail"><span class="material-symbols-outlined">link</span><a href="<%= escapeHtml(interviewRecord.getMeetingLink()) %>" target="_blank" rel="noopener noreferrer">Join interview</a></div>
                        <% } %>
                        <% if (interviewRecord.getNotes() != null && !interviewRecord.getNotes().isBlank()) { %>
                            <div class="interview-notes"><strong>Notes from the employer</strong><br><%= escapeHtml(interviewRecord.getNotes()) %></div>
                        <% } %>
                    </article>
                <% } %>
            <% } %>
        <% } %>
    </main>
</div>
</body>
</html>

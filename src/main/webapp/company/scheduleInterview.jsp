<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.time.format.DateTimeFormatter,java.util.Collections,java.util.List,java.util.Map,com.internlink.model.Application,com.internlink.model.Company,com.internlink.model.Interview" %>
<%!
    private String escapeHtml(String value) {
        if (value == null) return "";
        return value.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")
                .replace("\"", "&quot;").replace("'", "&#39;");
    }
%>
<%
    Company company = (Company) session.getAttribute("company");
    if (company == null) {
        response.sendRedirect(com.internlink.util.RedirectUtil.companyLoginUrl(
                request.getContextPath(), "ScheduleInterviewServlet"));
        return;
    }
    List<Application> applications = (List<Application>) request.getAttribute("applications");
    List<Interview> interviews = (List<Interview>) request.getAttribute("interviews");
    Map<Integer, Interview> interviewsByApplication =
            (Map<Integer, Interview>) request.getAttribute("interviewsByApplication");
    if (applications == null) applications = Collections.emptyList();
    if (interviews == null) interviews = Collections.emptyList();
    if (interviewsByApplication == null) interviewsByApplication = Collections.emptyMap();
    String message = (String) request.getAttribute("scheduleMessage");
    String error = (String) request.getAttribute("scheduleError");
    DateTimeFormatter dateTimeInput = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
    DateTimeFormatter displayDate = DateTimeFormatter.ofPattern("MMM d, yyyy 'at' h:mm a");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Schedule Interviews | InternLink</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css?v=20261019">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
    <style>
        .interview-list { display: grid; gap: 16px; }
        .interview-card { padding: 20px; border: 1px solid var(--line); border-radius: 10px; background: var(--panel-soft); }
        .interview-card h3 { margin: 0 0 4px; font-size: 15px; }
        .interview-meta { margin-bottom: 16px; color: var(--muted); font-size: 12px; }
        .interview-form { display: grid; gap: 14px; }
        .interview-form .field textarea { min-height: 85px; resize: vertical; }
        .interview-status { color: var(--green-soft); font-size: 12px; font-weight: 700; }
        .section-title { margin: 28px 0 14px; font-size: 17px; }
        .meeting-link { overflow-wrap: anywhere; }
    </style>
</head>
<body class="app-shell">
<div class="dashboard-layout">
    <aside class="sidebar">
        <a class="brand" href="<%= request.getContextPath() %>/index.jsp"><span class="brand-mark material-symbols-outlined">trending_up</span><span>InternLink</span></a>
        <nav class="side-nav" aria-label="Company navigation">
            <a href="<%= request.getContextPath() %>/company/dashboard.jsp"><span class="material-symbols-outlined">space_dashboard</span>Dashboard</a>
            <a href="<%= request.getContextPath() %>/CompanyProfileServlet"><span class="material-symbols-outlined">person</span>Company Profile</a>
            <a href="<%= request.getContextPath() %>/company/postings.jsp"><span class="material-symbols-outlined">work</span>Postings</a>
            <a href="<%= request.getContextPath() %>/ReviewApplicationsServlet"><span class="material-symbols-outlined">fact_check</span>Review Applications</a>
            <a class="active" href="<%= request.getContextPath() %>/ScheduleInterviewServlet"><span class="material-symbols-outlined">calendar_month</span>Interviews</a>
            <a href="<%= request.getContextPath() %>/CompanyCandidatesServlet"><span class="material-symbols-outlined">group</span>Candidates</a>
        </nav>
        <div class="side-separator"></div>
        <nav class="side-nav"><a href="<%= request.getContextPath() %>/LogoutServlet"><span class="material-symbols-outlined">logout</span>Logout</a></nav>
    </aside>
    <main class="dashboard-main">
        <header class="dashboard-top">
            <div><span class="eyebrow">Company workspace</span><h1>Interview scheduling.</h1><p>Schedule interviews with applicants and manage interview status.</p></div>
        </header>
        <% if (message != null) { %><div class="status-box success" role="status"><%= escapeHtml(message) %></div><% } %>
        <% if (error != null) { %><div class="status-box error" role="alert"><%= escapeHtml(error) %></div><% } %>
        <% if (!Boolean.TRUE.equals(request.getAttribute("scheduleReady"))) { %>
            <section class="panel glass" style="padding:2rem;"><div class="empty-state">Interview scheduling data could not be loaded. Refresh to try again.</div></section>
        <% } else { %>
            <h2 class="section-title">Applicants</h2>
            <section class="interview-list" aria-label="Applications and interview schedules">
                <% if (applications.isEmpty()) { %>
                    <article class="panel glass empty-state">There are no applications to schedule yet.</article>
                <% } else { %>
                    <% for (Application applicationRecord : applications) {
                        Interview interviewRecord = interviewsByApplication.get(applicationRecord.getId());
                        String applicationStatus = applicationRecord.getStatus() == null ? "Pending" : applicationRecord.getStatus();
                        boolean eligible = !"Rejected".equalsIgnoreCase(applicationStatus)
                                && !"Selected".equalsIgnoreCase(applicationStatus)
                                && !"Interview Completed".equalsIgnoreCase(applicationStatus);
                    %>
                        <article class="interview-card">
                            <h3><%= escapeHtml(applicationRecord.getApplicantName()) %> — <%= escapeHtml(applicationRecord.getInternshipTitle()) %></h3>
                            <div class="interview-meta"><%= escapeHtml(applicationRecord.getApplicantEmail()) %>
                                <% if (applicationRecord.getUniversity() != null && !applicationRecord.getUniversity().isBlank()) { %>
                                    · <%= escapeHtml(applicationRecord.getUniversity()) %>
                                <% } %>
                                · Application status: <strong><%= escapeHtml(applicationStatus) %></strong>
                            </div>
                            <% if (interviewRecord == null && eligible) { %>
                                <form class="interview-form" action="<%= request.getContextPath() %>/ScheduleInterviewServlet" method="post">
                                    <input type="hidden" name="action" value="schedule">
                                    <input type="hidden" name="applicationId" value="<%= applicationRecord.getId() %>">
                                    <div class="form-row">
                                        <div class="field"><label for="when-<%= applicationRecord.getId() %>">Date and time</label>
                                            <input class="input" type="datetime-local" id="when-<%= applicationRecord.getId() %>" name="scheduledAt" min="<%= java.time.LocalDateTime.now().plusMinutes(1).format(dateTimeInput) %>" required>
                                        </div>
                                        <div class="field"><label for="mode-<%= applicationRecord.getId() %>">Interview mode</label>
                                            <select class="input" id="mode-<%= applicationRecord.getId() %>" name="mode" required>
                                                <option value="Online">Online</option><option value="In person">In person</option><option value="Phone">Phone</option>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="field"><label for="link-<%= applicationRecord.getId() %>">Meeting link (optional; HTTP/HTTPS)</label>
                                        <input class="input" type="url" id="link-<%= applicationRecord.getId() %>" name="meetingLink" maxlength="500" placeholder="https://">
                                    </div>
                                    <div class="field"><label for="notes-<%= applicationRecord.getId() %>">Notes for the applicant (optional)</label>
                                        <textarea class="input" id="notes-<%= applicationRecord.getId() %>" name="notes" maxlength="5000"></textarea>
                                    </div>
                                    <button class="button button-primary" type="submit">Schedule interview</button>
                                </form>
                            <% } else if (interviewRecord != null) { %>
                                <div class="interview-meta">
                                    <span class="interview-status"><%= escapeHtml(interviewRecord.getStatus()) %></span>
                                    · <%= interviewRecord.getScheduledAt() == null ? "" : interviewRecord.getScheduledAt().format(displayDate) %>
                                    · <%= escapeHtml(interviewRecord.getMode()) %>
                                    <% if (interviewRecord.getMeetingLink() != null) { %>
                                        · <a class="meeting-link" href="<%= escapeHtml(interviewRecord.getMeetingLink()) %>" target="_blank" rel="noopener noreferrer">Meeting link</a>
                                    <% } %>
                                </div>
                                <form class="interview-form" action="<%= request.getContextPath() %>/ScheduleInterviewServlet" method="post">
                                    <input type="hidden" name="action" value="update">
                                    <input type="hidden" name="interviewId" value="<%= interviewRecord.getId() %>">
                                    <input type="hidden" name="applicationId" value="<%= applicationRecord.getId() %>">
                                    <div class="form-row">
                                        <div class="field"><label for="update-when-<%= interviewRecord.getId() %>">Date and time</label>
                                            <input class="input" type="datetime-local" id="update-when-<%= interviewRecord.getId() %>" name="scheduledAt" value="<%= interviewRecord.getScheduledAt().format(dateTimeInput) %>" required>
                                        </div>
                                        <div class="field"><label for="update-mode-<%= interviewRecord.getId() %>">Interview mode</label>
                                            <select class="input" id="update-mode-<%= interviewRecord.getId() %>" name="mode" required>
                                                <option value="Online" <%= "Online".equals(interviewRecord.getMode()) ? "selected" : "" %>>Online</option>
                                                <option value="In person" <%= "In person".equals(interviewRecord.getMode()) ? "selected" : "" %>>In person</option>
                                                <option value="Phone" <%= "Phone".equals(interviewRecord.getMode()) ? "selected" : "" %>>Phone</option>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="form-row">
                                        <div class="field"><label for="update-link-<%= interviewRecord.getId() %>">Meeting link (optional)</label>
                                            <input class="input" type="url" id="update-link-<%= interviewRecord.getId() %>" name="meetingLink" maxlength="500" value="<%= escapeHtml(interviewRecord.getMeetingLink()) %>">
                                        </div>
                                        <div class="field"><label for="status-<%= interviewRecord.getId() %>">Interview status</label>
                                            <select class="input" id="status-<%= interviewRecord.getId() %>" name="status" required>
                                                <option value="Scheduled" <%= "Scheduled".equals(interviewRecord.getStatus()) ? "selected" : "" %>>Scheduled</option>
                                                <option value="Completed" <%= "Completed".equals(interviewRecord.getStatus()) ? "selected" : "" %>>Completed</option>
                                                <option value="Cancelled" <%= "Cancelled".equals(interviewRecord.getStatus()) ? "selected" : "" %>>Cancelled</option>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="field"><label for="update-notes-<%= interviewRecord.getId() %>">Notes for the applicant</label>
                                        <textarea class="input" id="update-notes-<%= interviewRecord.getId() %>" name="notes" maxlength="5000"><%= escapeHtml(interviewRecord.getNotes()) %></textarea>
                                    </div>
                                    <button class="button button-ghost" type="submit">Update interview</button>
                                </form>
                            <% } else { %>
                                <span class="interview-status">Interview scheduling is unavailable for this application.</span>
                            <% } %>
                        </article>
                    <% } %>
                <% } %>
            </section>
        <% } %>
    </main>
</div>
</body>
</html>

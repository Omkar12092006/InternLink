<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.internlink.model.Application" %>
<%@ page import="com.internlink.model.Company" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Collections" %>
<%
    Company company = (Company) session.getAttribute("company");
    if (company == null) {
        response.sendRedirect(com.internlink.util.RedirectUtil.companyLoginUrl(
                request.getContextPath(), "ReviewApplicationsServlet"));
        return;
    }

    List<Application> applications = (List<Application>) request.getAttribute("applications");
    if (applications == null) {
        applications = Collections.emptyList();
    }

    String successMessage = request.getParameter("success");
    String errorMessage = request.getParameter("error");
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MMM dd, yyyy");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Review Applications | InternLink</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css?v=20260922">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
    <style>
        .status-badge {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 6px 10px;
            border-radius: 999px;
            font-size: 11px;
            font-weight: 700;
            letter-spacing: 0.02em;
            white-space: nowrap;
        }
        .badge-pending { background: rgba(96, 165, 250, 0.12); color: #bfdbfe; }
        .badge-shortlisted { background: rgba(34, 197, 94, 0.12); color: #bbf7d0; }
        .badge-rejected { background: rgba(239, 68, 68, 0.12); color: #fecaca; }
        .badge-selected { background: rgba(168, 85, 247, 0.12); color: #e9d5ff; }
        .badge-interview { background: rgba(14, 165, 233, 0.12); color: #bae6fd; }
        .button-small { padding: 8px 10px; font-size: 11px; }
        .table-wrap { overflow-x: auto; }
        .application-table { width: 100%; border-collapse: collapse; min-width: 900px; }
        .application-table th, .application-table td { padding: 1rem; border-bottom: 1px solid var(--line); vertical-align: top; text-align: left; }
        .application-table th { color: var(--muted); font-size: 11px; letter-spacing: 0.08em; text-transform: uppercase; }
        .applicant-meta { display: grid; gap: 4px; }
        .applicant-meta strong { font-size: 15px; }
        .applicant-meta span { color: var(--muted); font-size: 12px; }
        .cover-letter { max-width: 300px; color: var(--muted); font-size: 12px; line-height: 1.6; }
        .action-stack { display: flex; gap: 8px; flex-wrap: wrap; }
        .button-muted { border-color: rgba(148, 163, 184, 0.3); background: rgba(148, 163, 184, 0.08); color: #e2e8f0; }
        .button-muted:hover { border-color: rgba(148, 163, 184, 0.5); background: rgba(148, 163, 184, 0.12); }
    </style>
</head>
<body class="app-shell">
    <div class="dashboard-layout">
        <aside class="sidebar">
            <a class="brand" href="<%= request.getContextPath() %>/index.jsp"><span class="brand-mark material-symbols-outlined">trending_up</span><span>InternLink</span></a>
            <nav class="side-nav" aria-label="Company review navigation">
                <a href="<%= request.getContextPath() %>/company/dashboard.jsp"><span class="material-symbols-outlined">space_dashboard</span>Dashboard</a>
                <a href="<%= request.getContextPath() %>/CompanyProfileServlet"><span class="material-symbols-outlined">person</span>Company Profile</a>
                <a href="<%= request.getContextPath() %>/company/postings.jsp"><span class="material-symbols-outlined">work</span>Postings</a>
                <a class="active" href="<%= request.getContextPath() %>/ReviewApplicationsServlet"><span class="material-symbols-outlined">fact_check</span>Review Applications</a>
                <a href="<%= request.getContextPath() %>/ScheduleInterviewServlet"><span class="material-symbols-outlined">calendar_month</span>Interviews</a>
                <a href="<%= request.getContextPath() %>/CompanyCandidatesServlet"><span class="material-symbols-outlined">group</span>Candidates</a>
            </nav>
            <div class="side-separator"></div>
            <nav class="side-nav">
                <a href="<%= request.getContextPath() %>/LogoutServlet"><span class="material-symbols-outlined">logout</span>Logout</a>
            </nav>
        </aside>

        <main class="dashboard-main">
            <header class="dashboard-top">
                <div>
                    <span class="eyebrow">Applications</span>
                    <h1>Review applicants</h1>
                    <p>Track incoming applications and decide who to shortlist or move forward.</p>
                </div>
                <div class="dashboard-tools">
                    <a href="<%= request.getContextPath() %>/ScheduleInterviewServlet" class="button button-primary">Schedule interviews</a>
                    <a href="<%= request.getContextPath() %>/company/dashboard.jsp" class="button button-ghost">Back to dashboard</a>
                </div>
            </header>

            <section class="panel glass" style="padding: 2rem;">
                <% if ("updated".equals(successMessage)) { %>
                    <div class="status-box success"><span class="material-symbols-outlined">check_circle</span>Application status updated successfully.</div>
                <% } else if ("missing_application".equals(errorMessage) || "invalid_application".equals(errorMessage)) { %>
                    <div class="status-box error"><span class="material-symbols-outlined">error</span>Invalid application selected.</div>
                <% } else if ("invalid_status".equals(errorMessage) || "not_updated".equals(errorMessage)) { %>
                    <div class="status-box error"><span class="material-symbols-outlined">error</span>Unable to update the application status.</div>
                <% } %>

                <div style="display:flex; justify-content:space-between; align-items:center; gap:1rem; margin-bottom:1.5rem;">
                    <h2 style="margin:0;">Applicants for your internships</h2>
                    <span class="badge badge-blue"><%= applications.size() %> submissions</span>
                </div>

                <% if (applications == null || applications.isEmpty()) { %>
                    <div class="empty-state">
                        <p>No applications have been submitted to your internships yet.</p>
                    </div>
                <% } else { %>
                    <div class="table-wrap">
                        <table class="application-table">
                            <thead>
                                <tr>
                                    <th>Applicant</th>
                                    <th>Internship</th>
                                    <th>University</th>
                                    <th>Applied</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Application app : applications) { %>
                                    <% String status = app.getStatus() == null ? "Pending" : app.getStatus(); %>
                                    <% String badgeClass = "badge-pending"; %>
                                    <% if ("Shortlisted".equals(status)) { badgeClass = "badge-shortlisted"; } else if ("Rejected".equals(status)) { badgeClass = "badge-rejected"; } else if ("Selected".equals(status)) { badgeClass = "badge-selected"; } else if (status.startsWith("Interview ")) { badgeClass = "badge-interview"; } %>
                                    <tr>
                                        <td>
                                            <div class="applicant-meta">
                                                <strong><%= app.getApplicantName() %></strong>
                                                <span><%= app.getApplicantEmail() %></span>
                                            </div>
                                        </td>
                                        <td>
                                            <div class="applicant-meta">
                                                <strong><%= app.getInternshipTitle() != null ? app.getInternshipTitle() : "Internship" %></strong>
                                                <span><%= app.getInternshipLocation() != null ? app.getInternshipLocation() : "Location unavailable" %></span>
                                            </div>
                                        </td>
                                        <td>
                                            <div class="applicant-meta">
                                                <strong><%= app.getUniversity() != null && !app.getUniversity().isBlank() ? app.getUniversity() : "Not provided" %></strong>
                                                <span>Cover letter: <%= app.getCoverLetter() != null && !app.getCoverLetter().isBlank() ? "Included" : "Not provided" %></span>
                                            </div>
                                        </td>
                                        <td>
                                            <div class="applicant-meta">
                                                <strong><%= app.getAppliedDate() != null ? formatter.format(app.getAppliedDate()) : "Recently" %></strong>
                                                <span><%= app.getCoverLetter() != null && !app.getCoverLetter().isBlank() ? app.getCoverLetter().replaceAll("\\r?\\n", " ") : "" %></span>
                                            </div>
                                        </td>
                                        <td>
                                            <span class="status-badge <%= badgeClass %>"><%= status %></span>
                                        </td>
                                        <td>
                                            <div class="action-stack">
                                                <form action="<%= request.getContextPath() %>/UpdateApplicationStatusServlet" method="post" style="margin:0;">
                                                    <input type="hidden" name="applicationId" value="<%= app.getId() %>">
                                                    <input type="hidden" name="status" value="Shortlisted">
                                                    <button type="submit" class="button button-ghost button-small">Shortlist</button>
                                                </form>
                                                <form action="<%= request.getContextPath() %>/UpdateApplicationStatusServlet" method="post" style="margin:0;">
                                                    <input type="hidden" name="applicationId" value="<%= app.getId() %>">
                                                    <input type="hidden" name="status" value="Rejected">
                                                    <button type="submit" class="button button-danger button-small">Reject</button>
                                                </form>
                                                <form action="<%= request.getContextPath() %>/UpdateApplicationStatusServlet" method="post" style="margin:0;">
                                                    <input type="hidden" name="applicationId" value="<%= app.getId() %>">
                                                    <input type="hidden" name="status" value="Selected">
                                                    <button type="submit" class="button button-primary button-small">Select</button>
                                                </form>
                                            </div>
                                        </td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                <% } %>
            </section>
        </main>
    </div>
</body>
</html>

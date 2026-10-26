<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.internlink.dao.InternshipDAO" %>
<%@ page import="com.internlink.model.Company" %>
<%@ page import="com.internlink.model.Internship" %>
<%@ page import="java.util.List" %>
<%
    Company company = (Company) session.getAttribute("company");
    if (company == null) {
        response.sendRedirect(com.internlink.util.RedirectUtil.companyLoginUrl(
                request.getContextPath(), "company/postings.jsp"));
        return;
    }
    List<Internship> postings = new InternshipDAO().getByCompanyId(company.getId());
    String successMessage = request.getParameter("success");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Company Postings | InternLink</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css?v=20260922">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
    <style>
        .button-danger {
            border-color: rgba(239, 68, 68, 0.38);
            background: rgba(239, 68, 68, 0.18);
            color: #ffe4e6;
            box-shadow: 0 10px 24px rgba(239, 68, 68, 0.12);
        }
        .button-danger:hover {
            border-color: rgba(239, 68, 68, 0.58);
            background: rgba(239, 68, 68, 0.26);
            color: #fff1f2;
        }
    </style>
</head>
<body class="app-shell">
    <div class="dashboard-layout">
        <aside class="sidebar">
            <a class="brand" href="<%= request.getContextPath() %>/index.jsp"><span class="brand-mark material-symbols-outlined">trending_up</span><span>InternLink</span></a>
            <nav class="side-nav" aria-label="Company postings navigation">
                <a href="<%= request.getContextPath() %>/company/dashboard.jsp"><span class="material-symbols-outlined">space_dashboard</span>Dashboard</a>
                <a href="<%= request.getContextPath() %>/CompanyProfileServlet"><span class="material-symbols-outlined">person</span>Company Profile</a>
                <a class="active" href="postings.jsp"><span class="material-symbols-outlined">work</span>Postings</a>
                <a href="<%= request.getContextPath() %>/ReviewApplicationsServlet"><span class="material-symbols-outlined">fact_check</span>Review Applications</a>
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
                    <span class="eyebrow">Postings</span>
                    <h1>Internship listings</h1>
                    <p>Review and manage the roles your company is hiring for.</p>
                </div>
                <div class="dashboard-tools">
                    <a href="postInternship.jsp" class="button button-primary">Post internship</a>
                    <a href="<%= request.getContextPath() %>/company/dashboard.jsp" class="button button-ghost">Back to dashboard</a>
                </div>
            </header>

            <section class="panel glass" style="padding: 2rem;">
                <% if ("created".equals(successMessage)) { %>
                    <div class="status-box success"><span class="material-symbols-outlined">check_circle</span>Listing submitted and awaiting admin approval.</div>
                <% } else if ("updated".equals(successMessage)) { %>
                    <div class="status-box success"><span class="material-symbols-outlined">check_circle</span>Listing updated and submitted for admin approval.</div>
                <% } else if ("deleted".equals(successMessage)) { %>
                    <div class="status-box success"><span class="material-symbols-outlined">check_circle</span>Internship listing deleted successfully.</div>
                <% } %>
                <% if ("error".equals(successMessage)) { %>
                    <div class="status-box error"><span class="material-symbols-outlined">error</span>Unable to complete the internship listing change.</div>
                <% } %>

                <h2>Current opportunities</h2>
                <div class="form-stack" style="margin-top: 1.5rem;">
                    <% if (postings == null || postings.isEmpty()) { %>
                        <div class="empty-state">
                            <p>You have not posted any internships yet.</p>
                            <a href="postInternship.jsp" class="button button-primary">Create your first listing</a>
                        </div>
                    <% } else { %>
                        <% for (Internship internship : postings) { %>
                            <div class="panel" style="padding: 1.25rem; border: 1px solid var(--line); border-radius: 12px; background: rgba(255,255,255,0.02);">
                                <div style="display:flex; justify-content:space-between; align-items:flex-start; gap:1rem; flex-wrap:wrap;">
                                    <div>
                                        <strong><%= internship.getTitle() %></strong>
                                        <p style="color: var(--muted); margin: 0.45rem 0 0;"> <%= internship.getLocation() %> • <%= internship.getDuration() %> • <%= internship.isPaid() ? "Paid" : "Unpaid" %> </p>
                                        <p style="margin: 0.5rem 0 0;"><span class="badge <%= internship.isApproved() ? "badge-green" : "badge-amber" %>"><%= internship.isApproved() ? "Approved" : "Pending admin approval" %></span></p>
                                        <p style="color: var(--muted); margin: 0.5rem 0 0;"><%= internship.getDescription() == null ? "" : internship.getDescription().substring(0, Math.min(140, internship.getDescription().length())) %></p>
                                    </div>
                                    <div style="display:flex; gap:0.75rem; align-items:center;">
                                        <a href="postInternship.jsp?id=<%= internship.getId() %>" class="button button-ghost">Edit</a>
                                        <form action="<%= request.getContextPath() %>/DeleteInternshipServlet" method="post" onsubmit="return confirm('Delete this internship listing?');" style="margin:0;">
                                            <input type="hidden" name="id" value="<%= internship.getId() %>">
                                            <button type="submit" class="button button-danger">Delete</button>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        <% } %>
                    <% } %>
                </div>
            </section>
        </main>
    </div>
</body>
</html>

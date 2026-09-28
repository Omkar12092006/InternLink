<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.internlink.dao.InternshipDAO" %>
<%@ page import="com.internlink.model.Company" %>
<%@ page import="com.internlink.model.Internship" %>
<%@ page import="java.util.List" %>
<%
    Company company = (Company) session.getAttribute("company");
    if (company == null) {
        response.sendRedirect(request.getContextPath() + "/company/login.jsp");
        return;
    }
    List<Internship> myPostings = new InternshipDAO().getByCompanyId(company.getId());
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Company Dashboard | InternLink</title>
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
            <nav class="side-nav" aria-label="Company navigation">
                <a class="active" href="dashboard.jsp"><span class="material-symbols-outlined">space_dashboard</span>Dashboard</a>
                <a href="profile.jsp"><span class="material-symbols-outlined">person</span>Company Profile</a>
                <a href="postings.jsp"><span class="material-symbols-outlined">work</span>Postings</a>
                <a href="<%= request.getContextPath() %>/ReviewApplicationsServlet"><span class="material-symbols-outlined">fact_check</span>Review Applications</a>
                <a href="candidates.jsp"><span class="material-symbols-outlined">group</span>Candidates</a>
            </nav>
            <div class="side-separator"></div>
            <nav class="side-nav">
                <a href="<%= request.getContextPath() %>/index.jsp"><span class="material-symbols-outlined">logout</span>Logout</a>
            </nav>
        </aside>

        <main class="dashboard-main">
            <header class="dashboard-top">
                <div>
                    <span class="eyebrow">Company workspace</span>
                    <h1>Welcome, <%= company.getCompanyName() %>.</h1>
                    <p>Your dashboard for managing internship opportunities and candidate outreach.</p>
                </div>
                <div class="dashboard-tools">
                    <a href="postInternship.jsp" class="button button-primary">Post a new internship</a>
                </div>
            </header>

            <section class="panel glass profile-panel" style="padding: 2rem;">
                <div class="status-box info">
                    <span class="material-symbols-outlined">verified</span>
                    Account status: <%= company.isVerified() ? "Verified" : "Pending verification" %>
                </div>
            </section>

            <section class="panel glass" style="padding: 2rem; margin-top: 2rem;">
                <div style="display:flex; justify-content:space-between; align-items:center; gap:1rem; margin-bottom:1.5rem;">
                    <h2 style="margin:0;">My Postings</h2>
                    <a href="postInternship.jsp" class="button button-ghost">Create listing</a>
                </div>

                <% if (myPostings == null || myPostings.isEmpty()) { %>
                    <div class="empty-state">
                        <p>No internship listings published yet.</p>
                        <a href="postInternship.jsp" class="button button-primary">Post your first internship</a>
                    </div>
                <% } else { %>
                    <div class="form-stack">
                        <% for (Internship internship : myPostings) { %>
                            <div class="panel" style="padding: 1.25rem; border: 1px solid var(--line); border-radius: 12px; background: rgba(255,255,255,0.02);">
                                <div style="display:flex; justify-content:space-between; gap:1rem; align-items:flex-start; flex-wrap:wrap;">
                                    <div>
                                        <strong><%= internship.getTitle() %></strong>
                                        <p style="color: var(--muted); margin: 0.35rem 0 0;">
                                            <%= internship.getLocation() %> • <%= internship.getDuration() %> • <%= internship.isPaid() ? "Paid" : "Unpaid" %>
                                        </p>
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
                    </div>
                <% } %>
            </section>
        </main>
    </div>
</body>
</html>

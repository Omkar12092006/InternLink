<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.internlink.model.Company" %>
<%
    Company company = (Company) session.getAttribute("company");
    if (company == null) {
        response.sendRedirect(request.getContextPath() + "/company/login.jsp");
        return;
    }
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
</head>
<body class="app-shell">
    <div class="dashboard-layout">
        <aside class="sidebar">
            <a class="brand" href="<%= request.getContextPath() %>/index.jsp"><span class="brand-mark material-symbols-outlined">trending_up</span><span>InternLink</span></a>
            <nav class="side-nav" aria-label="Company dashboard navigation">
                <a class="active" href="dashboard.jsp"><span class="material-symbols-outlined">space_dashboard</span>Dashboard</a>
                <a href="profile.jsp"><span class="material-symbols-outlined">person</span>Company Profile</a>
                <a href="postings.jsp"><span class="material-symbols-outlined">work</span>Postings</a>
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
                    <h1>Welcome back, <%= company.getCompanyName() %></h1>
                    <p>Manage your company profile and overview from this dashboard.</p>
                </div>
            </header>

            <section class="metrics" aria-label="Company metrics">
                <article class="panel glass metric-card">
                    <span class="material-symbols-outlined">work</span>
                    <div class="metric-label">Open postings</div>
                    <div class="metric-value">08</div>
                    <div class="metric-delta">Active listings</div>
                </article>
                <article class="panel glass metric-card">
                    <span class="material-symbols-outlined">person_search</span>
                    <div class="metric-label">Applicants</div>
                    <div class="metric-value">132</div>
                    <div class="metric-delta">+18% this month</div>
                </article>
                <article class="panel glass metric-card">
                    <span class="material-symbols-outlined">group</span>
                    <div class="metric-label">Shortlisted</div>
                    <div class="metric-value">24</div>
                    <div class="metric-delta">Interview stage</div>
                </article>
                <article class="panel glass metric-card">
                    <span class="material-symbols-outlined">bar_chart</span>
                    <div class="metric-label">Response rate</div>
                    <div class="metric-value">76%</div>
                    <div class="metric-delta">Candidate engagement</div>
                </article>
            </section>

            <section class="panel glass" style="padding: 2rem; max-width: 720px; margin-bottom: 2rem;">
                <h2>Company overview</h2>
                <p>Your employer account is active and ready. Use the profile section to update company details.</p>
            </section>

            <section id="postings" class="panel glass" style="padding: 2rem; margin-bottom: 2rem;">
                <h2>Postings</h2>
                <div class="form-stack" style="margin-top: 1rem;">
                    <div class="panel" style="padding: 1rem 1.25rem; border: 1px solid var(--line); border-radius: 10px; background: rgba(255,255,255,0.02);">
                        <strong>Software Engineering Intern</strong>
                        <p style="color: var(--muted); margin-top: 0.35rem;">Remote • Full-time • 3 openings</p>
                    </div>
                    <div class="panel" style="padding: 1rem 1.25rem; border: 1px solid var(--line); border-radius: 10px; background: rgba(255,255,255,0.02);">
                        <strong>Product Design Intern</strong>
                        <p style="color: var(--muted); margin-top: 0.35rem;">Hybrid • 2 openings</p>
                    </div>
                    <div class="panel" style="padding: 1rem 1.25rem; border: 1px solid var(--line); border-radius: 10px; background: rgba(255,255,255,0.02);">
                        <strong>Marketing Intern</strong>
                        <p style="color: var(--muted); margin-top: 0.35rem;">On-site • 1 opening</p>
                    </div>
                </div>
            </section>

            <section id="candidates" class="panel glass" style="padding: 2rem;">
                <h2>Candidates</h2>
                <div class="form-stack" style="margin-top: 1rem;">
                    <div class="panel" style="padding: 1rem 1.25rem; border: 1px solid var(--line); border-radius: 10px; background: rgba(255,255,255,0.02);">
                        <strong>Priya Nair</strong>
                        <p style="color: var(--muted); margin-top: 0.35rem;">Computer Science • Resume matched • 92%</p>
                    </div>
                    <div class="panel" style="padding: 1rem 1.25rem; border: 1px solid var(--line); border-radius: 10px; background: rgba(255,255,255,0.02);">
                        <strong>Daniel Kim</strong>
                        <p style="color: var(--muted); margin-top: 0.35rem;">UX Design • Portfolio reviewed • Interview scheduled</p>
                    </div>
                    <div class="panel" style="padding: 1rem 1.25rem; border: 1px solid var(--line); border-radius: 10px; background: rgba(255,255,255,0.02);">
                        <strong>Amrit Singh</strong>
                        <p style="color: var(--muted); margin-top: 0.35rem;">Business Analytics • Application in review</p>
                    </div>
                </div>
            </section>
        </main>
    </div>
</body>
</html>

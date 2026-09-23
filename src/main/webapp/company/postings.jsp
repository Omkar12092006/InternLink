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
    <title>Company Postings | InternLink</title>
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
            <nav class="side-nav" aria-label="Company postings navigation">
                <a href="dashboard.jsp"><span class="material-symbols-outlined">space_dashboard</span>Dashboard</a>
                <a href="profile.jsp"><span class="material-symbols-outlined">person</span>Company Profile</a>
                <a class="active" href="postings.jsp"><span class="material-symbols-outlined">work</span>Postings</a>
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
                    <span class="eyebrow">Postings</span>
                    <h1>Internship listings</h1>
                    <p>Review and manage the roles your company is hiring for.</p>
                </div>
                <div class="dashboard-tools">
                    <a href="dashboard.jsp" class="button button-ghost">Back to dashboard</a>
                </div>
            </header>

            <section class="panel glass" style="padding: 2rem;">
                <h2>Current opportunities</h2>
                <div class="form-stack" style="margin-top: 1.5rem;">
                    <div class="panel" style="padding: 1.25rem; border: 1px solid var(--line); border-radius: 10px; background: rgba(255,255,255,0.02);">
                        <strong>Software Engineering Intern</strong>
                        <p style="color: var(--muted); margin-top: 0.45rem;">Remote • Full-time • 3 openings</p>
                    </div>
                    <div class="panel" style="padding: 1.25rem; border: 1px solid var(--line); border-radius: 10px; background: rgba(255,255,255,0.02);">
                        <strong>Product Design Intern</strong>
                        <p style="color: var(--muted); margin-top: 0.45rem;">Hybrid • 2 openings</p>
                    </div>
                    <div class="panel" style="padding: 1.25rem; border: 1px solid var(--line); border-radius: 10px; background: rgba(255,255,255,0.02);">
                        <strong>Marketing Intern</strong>
                        <p style="color: var(--muted); margin-top: 0.45rem;">On-site • 1 opening</p>
                    </div>
                </div>
            </section>
        </main>
    </div>
</body>
</html>

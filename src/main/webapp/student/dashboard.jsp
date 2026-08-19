<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Dashboard | InternLink</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css?v=20260819">
    <link rel="preconnect" href="https://fonts.googleapis.com"><link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
</head>
<body class="app-shell">
    <div class="dashboard-layout">
        <aside class="sidebar">
            <a class="brand" href="../index.jsp"><span class="brand-mark material-symbols-outlined">trending_up</span><span>InternLink</span></a>
            <nav class="side-nav" aria-label="Student dashboard navigation">
                <a class="active" href="dashboard.jsp"><span class="material-symbols-outlined">space_dashboard</span>Dashboard</a>
                <a href="#profile"><span class="material-symbols-outlined">person</span>My Profile</a>
                <a href="#applications"><span class="material-symbols-outlined">work_history</span>Applications</a>
                <a href="#saved"><span class="material-symbols-outlined">bookmark</span>Saved Jobs</a>
                <a href="#interviews"><span class="material-symbols-outlined">event</span>Interviews</a>
            </nav>
            <div class="side-separator"></div>
            <nav class="side-nav"><a href="#settings"><span class="material-symbols-outlined">settings</span>Settings</a><a href="../index.jsp"><span class="material-symbols-outlined">logout</span>Logout</a></nav>
        </aside>

        <main class="dashboard-main">
            <header class="dashboard-top"><div><span class="eyebrow">Student workspace</span><h1>Welcome Back, Alex</h1><p>Here is your internship application status at a glance.</p></div><div class="dashboard-tools"><label class="search"><span class="material-symbols-outlined">search</span><input type="search" placeholder="Search roles"></label><button class="button button-ghost" aria-label="Notifications"><span class="material-symbols-outlined">notifications</span></button><span class="avatar">A</span></div></header>

            <section class="metrics" aria-label="Application metrics">
                <article class="metric-card glass fade-up"><span class="material-symbols-outlined">send</span><p class="metric-label">Applications</p><p class="metric-value">12</p><p class="metric-delta">+2 this week</p></article>
                <article class="metric-card glass fade-up delay-1"><span class="material-symbols-outlined">pending_actions</span><p class="metric-label">Under Review</p><p class="metric-value">04</p><p class="metric-delta">Awaiting response</p></article>
                <article class="metric-card glass fade-up delay-2"><span class="material-symbols-outlined">calendar_month</span><p class="metric-label">Interviews</p><p class="metric-value">02</p><p class="metric-delta">Next: tomorrow</p></article>
                <article class="metric-card glass fade-up delay-3"><span class="material-symbols-outlined">verified</span><p class="metric-label">Offers</p><p class="metric-value">01</p><p class="metric-delta">Waiting for decision</p></article>
            </section>

            <div class="dashboard-grid">
                <section class="panel glass" id="applications"><div class="panel-head"><h2>Recent Applications</h2><a href="#applications">View all</a></div>
                    <div class="application"><span class="company-logo">TCS</span><div class="application-copy"><strong>Java Developer Intern</strong><span>TCS · Applied 2 days ago</span></div><span class="badge badge-blue">Under Review</span></div>
                    <div class="application"><span class="company-logo">IF</span><div class="application-copy"><strong>Frontend Developer Intern</strong><span>Infosys · Applied 5 days ago</span></div><span class="badge badge-amber">Interview Scheduled</span></div>
                    <div class="application"><span class="company-logo">MS</span><div class="application-copy"><strong>Data Science Intern</strong><span>Microsoft · Applied 1 week ago</span></div><span class="badge badge-green">Offer Received</span></div>
                    <div class="application"><span class="company-logo">AD</span><div class="application-copy"><strong>Product Design Intern</strong><span>Adobe · Applied 2 weeks ago</span></div><span class="badge badge-blue">Under Review</span></div>
                </section>
                <aside class="panel glass" id="saved"><div class="panel-head"><h2>Recommended for You</h2><a href="../browseInternships.jsp">Explore</a></div>
                    <div class="job"><strong>Product Engineering Intern</strong><span>Atlassian · Remote</span><div class="job-foot"><span>94% match</span><span>View role</span></div></div>
                    <div class="job"><strong>UX Research Intern</strong><span>Adobe · Bengaluru</span><div class="job-foot"><span>89% match</span><span>View role</span></div></div>
                    <div class="job"><strong>Cloud Platform Intern</strong><span>Microsoft · Hyderabad</span><div class="job-foot"><span>86% match</span><span>View role</span></div></div>
                </aside>
            </div>
        </main>
    </div>
</body>
</html>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>InternLink | Internship Placement Ecosystem</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css?v=20260819">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
</head>
<body class="app-shell">
    <header class="topbar">
        <div class="container topbar-inner">
            <a class="brand" href="index.jsp"><span class="brand-mark material-symbols-outlined">trending_up</span><span>InternLink</span></a>
            <nav class="nav-links" aria-label="Main navigation"><a href="#features">Features</a><a href="browseInternships.jsp">Internships</a><a href="#about">About</a></nav>
            <div class="nav-actions"><a class="button button-ghost" href="student/login.jsp">Student Login</a><a class="button button-primary" href="student/register.jsp">Get Started</a></div>
        </div>
    </header>

    <main>
        <section class="hero">
            <div class="container hero-grid">
                <div class="fade-up">
                    <span class="eyebrow">The smarter placement network</span>
                    <h1>Build the career you want with <strong>InternLink.</strong></h1>
                    <p class="hero-copy">Connect ambitious students with the companies shaping tomorrow. Discover better opportunities, move through applications with clarity, and start your next chapter.</p>
                    <div class="hero-actions"><a class="button button-primary" href="browseInternships.jsp">Browse internships <span class="material-symbols-outlined">arrow_forward</span></a><a class="button button-ghost" href="student/register.jsp">Create an account</a></div>
                    <div class="hero-note"><span class="pulse"></span><span>Trusted by students and recruiters across the ecosystem</span></div>
                </div>
                <div class="mockup glass fade-up delay-2" aria-label="InternLink dashboard preview">
                    <div class="mockup-window"><div class="mockup-bar"><i></i><i></i><i></i></div><div class="mockup-content">
                        <aside class="mockup-side"><b>InternLink</b><span>Overview</span><span>Applications</span><span>Saved roles</span><span>Profile</span></aside>
                        <div class="mockup-main"><span class="eyebrow">Student workspace</span><h3>Welcome back, Alex</h3><div class="mockup-stats"><div class="mini-stat"><small>Applications</small><strong>12</strong></div><div class="mini-stat"><small>Interviews</small><strong>04</strong></div><div class="mini-stat"><small>Profile views</small><strong>28</strong></div></div><div class="chart"></div></div>
                    </div></div>
                </div>
            </div>
        </section>

        <section class="feature-section" id="features"><div class="container"><div class="section-heading"><div><span class="eyebrow">Everything in one place</span><h2>Designed for forward motion.</h2></div><p>Every detail is built to make the path from discovery to placement feel simpler.</p></div>
            <div class="feature-grid"><article class="feature-card glass fade-up"><span class="feature-icon material-symbols-outlined">auto_awesome</span><h3>AI-Powered Matching</h3><p>Surface roles that fit your strengths, goals, and working style.</p></article><article class="feature-card glass fade-up delay-1"><span class="feature-icon material-symbols-outlined">badge</span><h3>Dynamic Profiles</h3><p>Showcase the work, skills, and experience that make you stand out.</p></article><article class="feature-card glass fade-up delay-2"><span class="feature-icon material-symbols-outlined">timeline</span><h3>Application Clarity</h3><p>Track every application, conversation, interview, and offer in one view.</p></article><article class="feature-card glass fade-up delay-3"><span class="feature-icon material-symbols-outlined">hub</span><h3>Real Connections</h3><p>Build direct relationships with teams looking for emerging talent.</p></article></div>
        </div></section>

        <section class="stats-section" id="about"><div class="container stats-grid"><div class="stat"><strong>500+</strong><span>Active internships</span></div><div class="stat"><strong>50K+</strong><span>Students registered</span></div><div class="stat"><strong>1,000+</strong><span>Partner companies</span></div><div class="stat"><strong>98%</strong><span>Placement success rate</span></div></div></section>
        <section class="feature-section"><div class="container section-heading"><div><span class="eyebrow">Ready when you are</span><h2>Your next opportunity starts here.</h2></div><div class="hero-actions"><a class="button button-primary" href="student/register.jsp">Join as a student</a><a class="button button-ghost" href="company/register.jsp">Join as a company</a></div></div></section>
    </main>

    <footer class="footer"><div class="container footer-inner"><span>© 2026 InternLink. Building careers, one connection at a time.</span><span>For students · For companies · Privacy</span></div></footer>
</body>
</html>

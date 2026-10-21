<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html class="scroll-smooth dark" lang="en">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>InternLink - Online Internship & Placement Portal</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/dark-theme.css">
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet"/>
    <style>
        body { background-color: #0B0F0E; color: #F3F4F6; font-family: 'Inter', sans-serif; }
        .btn-primary { 
            @apply bg-green-600 text-white px-6 py-3 rounded-lg font-semibold 
            hover:bg-green-700 transition-all duration-200 hover:shadow-lg hover:shadow-green-500/50;
        }
        .btn-secondary {
            @apply border-2 border-green-600 text-green-400 px-6 py-3 rounded-lg font-semibold 
            hover:bg-green-600/10 transition-all duration-200;
        }
        .card-feature {
            @apply bg-gradient-to-br from-gray-900 to-black border border-gray-800 rounded-2xl p-8
            hover:border-green-600/50 transition-all duration-300 hover:shadow-lg hover:shadow-green-500/20;
        }
        .hero-section {
            position: relative;
            isolation: isolate;
            overflow: hidden;
            padding: clamp(64px, 8vw, 104px) 24px;
            background:
                radial-gradient(ellipse at 78% 45%, rgba(34, 197, 94, .13), transparent 39%),
                radial-gradient(ellipse at 10% 0%, rgba(134, 239, 172, .06), transparent 34%),
                #0B1210 !important;
        }
        .hero-section::before,
        .hero-section::after {
            position: absolute;
            z-index: -1;
            content: "";
            pointer-events: none;
        }
        .hero-section::before {
            top: 12%;
            right: 5%;
            width: 360px;
            height: 360px;
            border: 1px solid rgba(134, 239, 172, .07);
            border-radius: 50%;
        }
        .hero-section::after {
            top: 20%;
            right: 11%;
            width: 240px;
            height: 240px;
            border: 1px solid rgba(134, 239, 172, .05);
            border-radius: 50%;
        }
        .hero-inner {
            display: grid;
            grid-template-columns: minmax(0, .92fr) minmax(0, 1.08fr);
            align-items: center;
            gap: clamp(42px, 7vw, 92px);
            width: min(1180px, 100%);
            margin: 0 auto;
        }
        .hero-copy-block { min-width: 0; }
        .hero-badge {
            display: inline-flex;
            align-items: center;
            gap: 9px;
            padding: 8px 13px;
            border: 1px solid rgba(134, 239, 172, .2);
            border-radius: 999px;
            background: rgba(18, 29, 24, .82);
            color: #C7F9D5 !important;
            font-size: 12px;
            font-weight: 600;
            letter-spacing: .01em;
        }
        .hero-badge .material-symbols-outlined {
            color: #86EFAC !important;
            font-size: 17px;
        }
        .hero-title {
            max-width: 620px;
            margin: 25px 0 20px;
            color: #F4F8F5 !important;
            font-size: clamp(42px, 5.2vw, 68px);
            font-weight: 750;
            line-height: 1.06;
            letter-spacing: -.055em;
        }
        .hero-title span {
            color: #86EFAC !important;
            background: linear-gradient(100deg, #86EFAC 10%, #22C55E 90%);
            background-clip: text;
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }
        .hero-description {
            max-width: 520px;
            color: #AABAB1 !important;
            font-size: clamp(15px, 1.5vw, 17px);
            line-height: 1.75;
        }
        .hero-actions {
            display: flex;
            flex-wrap: wrap;
            align-items: center;
            gap: 12px;
            margin-top: 30px;
        }
        .hero-button {
            display: inline-flex;
            min-height: 48px;
            align-items: center;
            justify-content: center;
            gap: 9px;
            padding: 0 20px;
            border: 1px solid transparent;
            border-radius: 9px;
            font-size: 14px;
            font-weight: 700;
            text-decoration: none;
            transition: background-color .18s ease, border-color .18s ease, transform .18s ease;
        }
        .hero-button:hover { transform: translateY(-1px); }
        .hero-button-primary {
            background: #22C55E !important;
            color: #07110B !important;
            box-shadow: 0 8px 24px rgba(34, 197, 94, .16);
        }
        .hero-button-primary:hover { background: #4ADE80 !important; }
        .hero-button-secondary {
            border-color: rgba(196, 215, 203, .2);
            background: rgba(18, 29, 24, .72);
            color: #E4EEE7 !important;
        }
        .hero-button-secondary:hover {
            border-color: rgba(134, 239, 172, .45);
            background: #121D18;
        }
        .hero-button:focus-visible {
            outline: 3px solid rgba(134, 239, 172, .72);
            outline-offset: 3px;
        }
        .hero-trust {
            display: flex;
            align-items: center;
            gap: 9px;
            margin-top: 25px;
            color: #91A69A !important;
            font-size: 12px;
        }
        .hero-trust .material-symbols-outlined {
            color: #86EFAC !important;
            font-size: 17px;
        }
        .hero-preview-wrap { position: relative; min-width: 0; }
        .hero-preview-glow {
            position: absolute;
            inset: 12% 4%;
            z-index: -1;
            border-radius: 40%;
            background: rgba(34, 197, 94, .12);
            filter: blur(55px);
        }
        .hero-preview {
            overflow: hidden;
            border: 1px solid rgba(155, 190, 168, .2);
            border-radius: 16px;
            background: #121D18 !important;
            box-shadow: 0 28px 90px rgba(0, 0, 0, .38), 0 0 55px rgba(34, 197, 94, .07);
        }
        .preview-topbar {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
            padding: 17px 20px;
            border-bottom: 1px solid rgba(155, 190, 168, .12);
            background: rgba(255, 255, 255, .015);
        }
        .preview-brand {
            display: flex;
            align-items: center;
            gap: 10px;
            color: #EDF7F0 !important;
            font-size: 13px;
            font-weight: 700;
        }
        .preview-brand-mark {
            display: grid;
            width: 30px;
            height: 30px;
            place-items: center;
            border: 1px solid rgba(134, 239, 172, .18);
            border-radius: 9px;
            background: rgba(34, 197, 94, .11);
            color: #86EFAC !important;
        }
        .preview-demo-tag {
            padding: 6px 9px;
            border: 1px solid rgba(134, 239, 172, .16);
            border-radius: 999px;
            background: rgba(34, 197, 94, .08);
            color: #A7F3BD !important;
            font-size: 10px;
            font-weight: 700;
            letter-spacing: .07em;
            text-transform: uppercase;
        }
        .preview-body { padding: clamp(18px, 3vw, 28px); }
        .preview-eyebrow {
            color: #91A69A !important;
            font-size: 11px;
            font-weight: 600;
            letter-spacing: .08em;
            text-transform: uppercase;
        }
        .preview-heading {
            margin-top: 6px;
            color: #F0F7F2 !important;
            font-size: 20px;
            font-weight: 700;
            letter-spacing: -.025em;
        }
        .preview-listing {
            margin-top: 19px;
            padding: 19px;
            border: 1px solid rgba(155, 190, 168, .15);
            border-radius: 12px;
            background: linear-gradient(145deg, rgba(24, 39, 31, .96), rgba(15, 25, 20, .98)) !important;
        }
        .preview-listing-top {
            display: flex;
            align-items: flex-start;
            gap: 13px;
        }
        .preview-company-logo {
            display: grid;
            flex: 0 0 44px;
            width: 44px;
            height: 44px;
            place-items: center;
            border: 1px solid rgba(134, 239, 172, .15);
            border-radius: 11px;
            background: #1C3025;
            color: #A7F3BD !important;
            font-size: 13px;
            font-weight: 800;
        }
        .preview-role { min-width: 0; flex: 1; }
        .preview-role h3 {
            color: #F0F7F2 !important;
            font-size: 15px;
            font-weight: 700;
            line-height: 1.4;
        }
        .preview-company {
            margin-top: 3px;
            color: #AABAB1 !important;
            font-size: 12px;
        }
        .preview-status {
            flex: 0 0 auto;
            padding: 5px 8px;
            border-radius: 999px;
            background: rgba(134, 239, 172, .1);
            color: #A7F3BD !important;
            font-size: 10px;
            font-weight: 700;
        }
        .preview-details {
            display: flex;
            flex-wrap: wrap;
            gap: 10px 18px;
            margin-top: 18px;
            padding-bottom: 17px;
            border-bottom: 1px solid rgba(155, 190, 168, .12);
        }
        .preview-detail {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            color: #B4C2B9 !important;
            font-size: 11px;
        }
        .preview-detail .material-symbols-outlined {
            color: #86EFAC !important;
            font-size: 16px;
        }
        .preview-progress-head {
            display: flex;
            justify-content: space-between;
            gap: 12px;
            margin-top: 16px;
            color: #DDE8E0 !important;
            font-size: 11px;
            font-weight: 600;
        }
        .preview-progress-head span:last-child {
            color: #AABAB1 !important;
            font-weight: 500;
        }
        .preview-progress-track {
            overflow: hidden;
            height: 6px;
            margin-top: 10px;
            border-radius: 999px;
            background: #26362D;
        }
        .preview-progress-value {
            width: 50%;
            height: 100%;
            border-radius: inherit;
            background: linear-gradient(90deg, #22C55E, #86EFAC);
        }
        .preview-stages {
            display: flex;
            justify-content: space-between;
            gap: 8px;
            margin-top: 10px;
            color: #91A69A !important;
            font-size: 10px;
        }
        .preview-disclaimer {
            margin-top: 13px;
            color: #81948A !important;
            font-size: 10px;
            line-height: 1.5;
        }
        @media (max-width: 900px) {
            .hero-inner { grid-template-columns: minmax(0, 1fr) minmax(0, 1fr); gap: 32px; }
            .hero-title { font-size: clamp(40px, 6vw, 58px); }
            .preview-listing { padding: 16px; }
            .preview-status { display: none; }
        }
        @media (max-width: 680px) {
            .hero-section { padding: 56px 20px 64px; }
            .hero-inner { grid-template-columns: 1fr; gap: 38px; }
            .hero-title { max-width: 540px; margin-top: 20px; font-size: clamp(40px, 11vw, 56px); }
            .hero-description { font-size: 15px; }
            .hero-actions { align-items: stretch; }
            .hero-button { flex: 1 1 190px; }
            .hero-trust { align-items: flex-start; line-height: 1.5; }
            .hero-preview { border-radius: 13px; }
            .hero-section::before { top: 49%; right: -140px; }
            .hero-section::after { top: 53%; right: -85px; }
        }
        @media (prefers-reduced-motion: reduce) {
            .hero-button { transition: none; }
            .hero-button:hover { transform: none; }
        }
    </style>
</head>
<body class="min-h-screen flex flex-col">
    <!-- Navigation Bar -->
    <nav class="sticky top-0 z-50 bg-gray-950 border-b border-gray-800">
        <div class="max-w-7xl mx-auto px-4 md:px-8 py-4 flex flex-wrap justify-center md:justify-between items-center gap-x-6 gap-y-3">
            <!-- Logo -->
            <div class="flex items-center gap-3">
                <span class="material-symbols-outlined text-2xl text-green-500">trending_up</span>
                <a href="<%= request.getContextPath() %>/index.jsp" class="text-2xl font-bold text-white">InternLink</a>
            </div>

            <!-- Nav Links -->
            <div class="flex flex-wrap justify-center items-center gap-x-4 gap-y-2 md:gap-8">
                <a href="#about" class="text-gray-300 hover:text-green-400 transition">About</a>
                <a href="#features" class="text-gray-300 hover:text-green-400 transition">Features</a>
                <a href="<%= request.getContextPath() %>/browseInternships.jsp" class="text-gray-300 hover:text-green-400 transition">Internships</a>
                <a href="<%= request.getContextPath() %>/company/login.jsp" class="text-gray-300 hover:text-green-400 transition">Company</a>
            </div>

            <!-- CTA Buttons -->
            <div class="flex flex-wrap justify-center items-center gap-2">
                <a href="<%= request.getContextPath() %>/admin/login.jsp" class="border border-green-500 text-green-400 hover:bg-green-600 hover:text-white px-4 py-2 rounded-lg transition font-semibold">
                    Admin Login
                </a>
                <a href="<%= request.getContextPath() %>/student/login.jsp" class="text-gray-300 hover:text-green-400 px-4 py-2 rounded transition">
                    Student Login
                </a>
                <a href="<%= request.getContextPath() %>/student/register.jsp" class="btn-primary text-sm">
                    Get Started
                </a>
            </div>
        </div>
    </nav>

    <!-- Hero Section -->
    <section id="home" class="hero-section">
        <div class="hero-inner">
            <div class="hero-copy-block">
                <span class="hero-badge">
                    <span class="material-symbols-outlined" aria-hidden="true">auto_awesome</span>
                    Your Career Journey Starts Here
                </span>
                <h1 class="hero-title">Launch Your Career with <span>InternLink</span></h1>
                <p class="hero-description">
                    Discover internships, connect with leading companies, and take the next step toward your dream career.
                </p>
                <div class="hero-actions">
                    <a href="<%= request.getContextPath() %>/browseInternships.jsp" class="hero-button hero-button-primary">
                        Explore Internships <span aria-hidden="true">→</span>
                    </a>
                    <a href="<%= request.getContextPath() %>/student/register.jsp" class="hero-button hero-button-secondary">
                        Create Free Account
                    </a>
                </div>
                <p class="hero-trust">
                    <span class="material-symbols-outlined" aria-hidden="true">verified_user</span>
                    Built to connect students with opportunities
                </p>
            </div>

            <div class="hero-preview-wrap">
                <div class="hero-preview-glow" aria-hidden="true"></div>
                <section class="hero-preview" aria-label="Demonstration internship dashboard preview">
                    <header class="preview-topbar">
                        <div class="preview-brand">
                            <span class="preview-brand-mark material-symbols-outlined" aria-hidden="true">space_dashboard</span>
                            <span>InternLink workspace</span>
                        </div>
                        <span class="preview-demo-tag">Demo preview</span>
                    </header>
                    <div class="preview-body">
                        <p class="preview-eyebrow">Application tracker</p>
                        <h2 class="preview-heading">Your internship journey</h2>

                        <article class="preview-listing">
                            <div class="preview-listing-top">
                                <div class="preview-company-logo" aria-label="Sample company placeholder">SC</div>
                                <div class="preview-role">
                                    <h3>Product Design Intern</h3>
                                    <p class="preview-company">Sample Company · Demonstration listing</p>
                                </div>
                                <span class="preview-status">In progress</span>
                            </div>
                            <div class="preview-details" aria-label="Demonstration listing details">
                                <span class="preview-detail"><span class="material-symbols-outlined" aria-hidden="true">location_on</span>Austin, TX</span>
                                <span class="preview-detail"><span class="material-symbols-outlined" aria-hidden="true">calendar_month</span>12 weeks</span>
                                <span class="preview-detail"><span class="material-symbols-outlined" aria-hidden="true">payments</span>Paid</span>
                            </div>
                            <div class="preview-progress-head">
                                <span>Application progress</span>
                                <span>2 of 4 steps</span>
                            </div>
                            <div class="preview-progress-track" role="img" aria-label="Demonstration application progress: 2 of 4 steps">
                                <div class="preview-progress-value"></div>
                            </div>
                            <div class="preview-stages" aria-hidden="true">
                                <span>Applied</span><span>Review</span><span>Interview</span><span>Decision</span>
                            </div>
                        </article>
                        <p class="preview-disclaimer">Illustrative sample content only — this preview is not connected to live listings or application records.</p>
                    </div>
                </section>
            </div>
        </div>
    </section>

    <!-- Features Section -->
    <section id="features" class="py-20 md:py-32 px-4 max-w-7xl mx-auto">
        <div class="text-center mb-16">
            <h2 class="text-4xl font-bold text-white mb-4">Why Choose InternLink?</h2>
            <p class="text-gray-400 text-lg">Everything you need for your internship journey</p>
        </div>

        <div class="grid md:grid-cols-3 gap-8">
            <!-- Feature 1 -->
            <div class="card-feature">
                <span class="material-symbols-outlined text-5xl text-green-500 mb-4">search</span>
                <h3 class="text-2xl font-bold text-white mb-3">Easy Search</h3>
                <p class="text-gray-400">Find internships by company, location, role, and more with advanced filtering.</p>
            </div>

            <!-- Feature 2 -->
            <div class="card-feature">
                <span class="material-symbols-outlined text-5xl text-green-500 mb-4">check_circle</span>
                <h3 class="text-2xl font-bold text-white mb-3">One-Click Apply</h3>
                <p class="text-gray-400">Apply to multiple positions instantly with your pre-filled profile.</p>
            </div>

            <!-- Feature 3 -->
            <div class="card-feature">
                <span class="material-symbols-outlined text-5xl text-green-500 mb-4">bar_chart</span>
                <h3 class="text-2xl font-bold text-white mb-3">Track Progress</h3>
                <p class="text-gray-400">Monitor your applications, interviews, and offers in real-time.</p>
            </div>

            <!-- Feature 4 -->
            <div class="card-feature">
                <span class="material-symbols-outlined text-5xl text-green-500 mb-4">school</span>
                <h3 class="text-2xl font-bold text-white mb-3">Campus Connect</h3>
                <p class="text-gray-400">Access university-verified resources and placement statistics.</p>
            </div>

            <!-- Feature 5 -->
            <div class="card-feature">
                <span class="material-symbols-outlined text-5xl text-green-500 mb-4">business</span>
                <h3 class="text-2xl font-bold text-white mb-3">Top Companies</h3>
                <p class="text-gray-400">Network with leading tech and Fortune 500 companies.</p>
            </div>

            <!-- Feature 6 -->
            <div class="card-feature">
                <span class="material-symbols-outlined text-5xl text-green-500 mb-4">security</span>
                <h3 class="text-2xl font-bold text-white mb-3">Secure Profile</h3>
                <p class="text-gray-400">Your data is encrypted and protected with industry standards.</p>
            </div>
        </div>
    </section>

    <!-- Quick Stats -->
    <section class="bg-gradient-to-r from-green-900/20 to-emerald-900/20 py-16 px-4">
        <div class="max-w-7xl mx-auto grid md:grid-cols-4 gap-8 text-center">
            <div> 
                <div class="text-4xl font-bold text-green-400">500+</div>
                <p class="text-gray-400 mt-2">Active Internships</p>
            </div>
            <div>
                <div class="text-4xl font-bold text-green-400">50K+</div>
                <p class="text-gray-400 mt-2">Students Registered</p>
            </div>
            <div>
                <div class="text-4xl font-bold text-green-400">1000+</div>
                <p class="text-gray-400 mt-2">Companies Partnered</p>
            </div>
            <div>
                <div class="text-4xl font-bold text-green-400">95%</div>
                <p class="text-gray-400 mt-2">Placement Rate</p>
            </div>
        </div>
    </section>

    <!-- About Section -->
    <section id="about" class="py-20 md:py-28 px-4">
        <div class="max-w-4xl mx-auto text-center">
            <span class="text-green-400 font-semibold uppercase tracking-wider">About InternLink</span>
            <h2 class="text-4xl font-bold text-white mt-3 mb-6">A clearer path from learning to your first opportunity</h2>
            <p class="text-gray-300 text-lg leading-relaxed">
                InternLink brings students and employers together in one place. Students can discover internships,
                apply for opportunities, and follow their application progress, while companies can share openings
                and connect with emerging talent.
            </p>
        </div>
    </section>

    <!-- CTA Section -->
    <section class="py-20 px-4 text-center bg-gray-950">
        <h2 class="text-4xl font-bold text-white mb-4">Ready to Get Started?</h2>
        <p class="text-gray-400 text-lg mb-8">Join thousands of students finding their perfect internship</p>
        <div class="flex flex-col md:flex-row gap-4 justify-center">
            <a href="student/register.jsp" class="btn-primary">Register as Student</a>
            <a href="company/register.jsp" class="btn-secondary">Register as Company</a>
        </div>
    </section>

    <!-- Footer -->
    <footer class="bg-gray-950 border-t border-gray-800 text-gray-400 py-12 px-4">
        <div class="max-w-7xl mx-auto grid md:grid-cols-4 gap-8 mb-8">
            <div>
                <h4 class="text-white font-bold mb-4">InternLink</h4>
                <p class="text-sm">Your gateway to career success</p>
            </div>
            <div>
                <h4 class="text-white font-bold mb-4">For Students</h4>
                <ul class="space-y-2 text-sm"><li><a href="#" class="hover:text-green-400">Browse Jobs</a></li><li><a href="#" class="hover:text-green-400">My Profile</a></li></ul>
            </div>
            <div>
                <h4 class="text-white font-bold mb-4">For Companies</h4>
                <ul class="space-y-2 text-sm"><li><a href="#" class="hover:text-green-400">Post Job</a></li><li><a href="#" class="hover:text-green-400">Hiring</a></li></ul>
            </div>
            <div>
                <h4 class="text-white font-bold mb-4">Legal</h4>
                <ul class="space-y-2 text-sm"><li><a href="#" class="hover:text-green-400">Privacy</a></li><li><a href="#" class="hover:text-green-400">Terms</a></li></ul>
            </div>
        </div>
        <div class="border-t border-gray-800 pt-8 text-center text-sm">
            <p>&copy; 2026 InternLink. All rights reserved.</p>
        </div>
    </footer>

    <script>
        // Smooth scroll for anchor links
        document.querySelectorAll('a[href^="#"]').forEach(link => {
            link.addEventListener('click', (e) => {
                e.preventDefault();
                const target = document.querySelector(link.getAttribute('href'));
                if (target) target.scrollIntoView({ behavior: 'smooth' });
            });
        });
    </script>
</body>
</html>
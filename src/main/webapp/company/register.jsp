<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Company Registration | InternLink</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css?v=20260819">
    <link rel="preconnect" href="https://fonts.googleapis.com"><link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet"><link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
</head>
<body class="app-shell">
    <main class="auth-page"><div class="split-auth fade-up">
        <section class="value-panel glass"><div><a class="brand" href="../index.jsp"><span class="brand-mark material-symbols-outlined">trending_up</span><span>InternLink</span></a><span class="eyebrow">Recruit better, faster</span><h1>Meet the talent behind what is next.</h1><p>Turn your internship pipeline into a competitive advantage with a smarter way to discover and engage emerging talent.</p></div><div class="value-list"><div><span class="material-symbols-outlined">public</span><span><strong>Global Talent Pool</strong><br>Reach ambitious students from universities everywhere.</span></div><div><span class="material-symbols-outlined">auto_awesome</span><span><strong>AI-Powered Shortlisting</strong><br>Spend less time sorting and more time meeting great candidates.</span></div><div><span class="material-symbols-outlined">campaign</span><span>Build a visible employer brand with meaningful opportunities.</span></div></div></section>
        <section class="register-form glass"><span class="eyebrow">Company registration</span><h2>Join the recruiter network</h2><p>Create your company workspace and start building your next intern cohort.</p>
            <% if (request.getAttribute("errorMessage") != null) { %><p class="error-text"><%= request.getAttribute("errorMessage") %></p><% } %>
            <form class="form-stack" action="<%= request.getContextPath() %>/CompanyRegisterServlet" method="post">
                <div class="field"><label for="company_name">Company Name</label><input class="input" id="company_name" name="company_name" placeholder="Acme Corporation" type="text" required></div>
                <div class="form-row"><div class="field"><label for="hr_name">HR Contact Name</label><input class="input" id="hr_name" name="hr_name" placeholder="Full name" type="text" required></div><div class="field"><label for="industry">Industry</label><select class="input" id="industry" name="industry" required><option value="">Select industry</option><option>Technology</option><option>Finance</option><option>Healthcare</option><option>Education</option><option>Manufacturing</option></select></div></div>
                <div class="form-row"><div class="field"><label for="email">Company Email</label><input class="input" id="email" name="email" placeholder="talent@company.com" type="email" required></div><div class="field"><label for="phone">Phone Number</label><input class="input" id="phone" name="phone" placeholder="+1 (555) 000-0000" type="tel" required></div></div>
                <div class="form-row"><div class="field"><label for="website">Company Website</label><input class="input" id="website" name="website" placeholder="https://company.com" type="url"></div><div class="field"><label for="location">Company Location</label><input class="input" id="location" name="location" placeholder="City, Country" type="text"></div></div>
                <div class="field"><label for="description">Company Description</label><textarea class="input" id="description" name="description" placeholder="Tell candidates about your mission and intern culture" rows="3"></textarea></div>
                <div class="form-row"><div class="field"><label for="password">Password</label><input class="input" id="password" name="password" placeholder="Create a password" type="password" required></div><div class="field"><label for="confirm_password">Confirm Password</label><input class="input" id="confirm_password" name="confirm_password" placeholder="Repeat password" type="password" required></div></div>
                <label class="form-foot"><span><input class="check" type="checkbox" required> I agree to the Terms and Privacy Policy</span></label>
                <button class="button button-primary" type="submit">Create company account <span class="material-symbols-outlined">arrow_forward</span></button>
            </form>
            <div class="auth-divider">ALREADY A PARTNER?</div><p class="auth-switch"><a href="login.jsp">Sign in to the recruiter portal</a></p>
        </section>
    </div></main>
</body>
</html>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Login | InternLink</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css?v=20260819">
    <link rel="preconnect" href="https://fonts.googleapis.com"><link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet"><link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
</head>
<body class="app-shell">
    <main class="auth-page"><div class="auth-wrap fade-up">
        <a class="back-link" href="../index.jsp"><span class="material-symbols-outlined">arrow_back</span>Back to home</a>
        <section class="auth-card glass">
            <div class="auth-head"><span class="eyebrow">Student workspace</span><h1>Welcome back.</h1><p>Sign in to continue your internship journey.</p></div>
            <form class="form-stack" action="<%= request.getContextPath() %>/StudentLoginServlet" method="post">
                <div class="field"><label for="email">Email or Student ID</label><div class="input-icon"><span class="material-symbols-outlined">alternate_email</span><input class="input" type="email" name="email" id="email" placeholder="student@university.edu" required></div></div>
                <div class="field"><div class="form-foot"><label for="password">Password</label><a class="muted-link" href="#forgot">Forgot password?</a></div><div class="input-icon"><span class="material-symbols-outlined">lock</span><input class="input" type="password" name="password" id="password" placeholder="Enter your password" required><button type="button" class="password-toggle" onclick="togglePassword()" aria-label="Show password"><span class="material-symbols-outlined" id="toggleIcon">visibility</span></button></div></div>
                <label class="form-foot"><span><input class="check" type="checkbox" name="remember"> Remember me</span></label>
                <button class="button button-primary" type="submit">Sign in <span class="material-symbols-outlined">arrow_forward</span></button>
            </form>
            <div class="auth-divider">OR</div><p class="auth-switch">New to InternLink? <a href="register.jsp">Create a student account</a></p>
        </section>
        <div class="security-note"><span class="material-symbols-outlined">verified_user</span><span>Your account information is encrypted and securely protected.</span></div>
    </div></main>
    <script>function togglePassword(){const input=document.getElementById('password');const icon=document.getElementById('toggleIcon');const visible=input.type==='password';input.type=visible?'text':'password';icon.textContent=visible?'visibility_off':'visibility';}</script>
</body>
</html>

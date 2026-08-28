<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Student Account | InternLink</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css?v=20260819">
    <link rel="preconnect" href="https://fonts.googleapis.com"><link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet"><link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
</head>
<body class="app-shell">
    <main class="auth-page"><div class="split-auth fade-up">
        <section class="value-panel glass"><div>        <a class="brand" href="<%= request.getContextPath() %>/index.jsp"><span class="brand-mark material-symbols-outlined">trending_up</span><span>InternLink</span></a><span class="eyebrow">Start with your edge</span><h1>Your next opportunity is closer than you think.</h1><p>Build a profile that tells your story, then let the right teams find you.</p></div><div class="value-list"><div><span class="material-symbols-outlined">auto_awesome</span><span>Personalized internship matches based on your goals.</span></div><div><span class="material-symbols-outlined">insights</span><span>A clear workspace for applications and interviews.</span></div><div><span class="material-symbols-outlined">verified</span><span>University-ready profile and secure account data.</span></div></div></section>
        <section class="register-form glass"><span class="eyebrow">Student registration</span><h2>Create your account</h2><p>Take the first step toward a better internship search.</p>
            <% if (request.getAttribute("errorMessage") != null) { %>
                <div style="background:rgba(239,68,68,0.1);border:1px solid rgba(239,68,68,0.3);border-radius:8px;padding:12px 16px;margin-bottom:16px;display:flex;align-items:center;gap:8px;">
                    <span class="material-symbols-outlined" style="color:#EF4444;font-size:20px;">error</span>
                    <span style="color:#FCA5A5;font-size:14px;"><%= request.getAttribute("errorMessage") %></span>
                </div>
            <% } %>
            <form id="registerForm" class="form-stack" method="POST" action="<%= request.getContextPath() %>/StudentRegisterServlet" onsubmit="handleSubmit(event)">
                <div class="form-row"><div class="field"><label for="fullName">Full Name</label><input class="input" type="text" id="fullName" name="fullName" placeholder="Alex Morgan" required><span class="error-text hidden" id="fullNameError"></span></div><div class="field"><label for="universityId">University ID</label><input class="input" type="text" id="universityId" name="universityId" placeholder="21BIT001" required><span class="error-text hidden" id="universityIdError"></span></div></div>
                <div class="form-row"><div class="field"><label for="email">Edu Email</label><input class="input" type="email" id="email" name="email" placeholder="alex@university.edu" required><span class="error-text hidden" id="emailError"></span></div><div class="field"><label for="phone">Phone Number</label><input class="input" type="tel" id="phone" name="phone" placeholder="9876543210" required><span class="error-text hidden" id="phoneError"></span></div></div>
                <div class="form-row"><div class="field"><label for="password">Password</label><div class="input-icon"><input class="input" type="password" id="password" name="password" placeholder="Create a password" oninput="updatePasswordStrength()" required><button type="button" class="password-toggle" onclick="togglePasswordVisibility('password','passwordToggle')" aria-label="Show password"><span class="material-symbols-outlined" id="passwordToggle">visibility</span></button></div><div class="password-meter"><span id="strengthBar"></span></div><span class="error-text hidden" id="passwordError"></span></div><div class="field"><label for="confirmPassword">Confirm Password</label><div class="input-icon"><input class="input" type="password" id="confirmPassword" name="confirmPassword" placeholder="Repeat password" required><button type="button" class="password-toggle" onclick="togglePasswordVisibility('confirmPassword','confirmPasswordToggle')" aria-label="Show password"><span class="material-symbols-outlined" id="confirmPasswordToggle">visibility</span></button></div><span class="error-text hidden" id="confirmPasswordError"></span></div></div>
                <label class="form-foot"><span><input class="check" type="checkbox" name="terms" required> I agree to the Terms and Privacy Policy</span></label>
                <button class="button button-primary" type="submit">Create student account <span class="material-symbols-outlined">arrow_forward</span></button>
            </form>
            <% if (request.getAttribute("errorMessage") != null) { %>
                <div style="background:rgba(239,68,68,0.1);border:1px solid rgba(239,68,68,0.3);border-radius:8px;padding:12px 16px;margin-bottom:16px;display:flex;align-items:center;gap:8px;">
                    <span class="material-symbols-outlined" style="color:#EF4444;font-size:20px;">error</span>
                    <span style="color:#FCA5A5;font-size:14px;"><%= request.getAttribute("errorMessage") %></span>
                </div>
            <% } %>
            <div class="auth-divider">ALREADY REGISTERED?</div><p class="auth-switch"><a href="login.jsp">Sign in to your account</a></p>
        </section>
    </div></main>
    <script>
        function setError(id, message) { const element = document.getElementById(id); element.textContent = message; element.classList.toggle('hidden', !message); }
        function validateForm() { const name = fullName.value.trim(), university = universityId.value.trim(), mail = email.value.trim(), number = phone.value.replace(/[^\d]/g, ''), pass = password.value, confirm = confirmPassword.value; let valid = true; setError('fullNameError', name.length < 3 ? 'Use at least 3 characters' : ''); setError('universityIdError', /^[A-Z0-9]{4,}$/i.test(university) ? '' : 'Enter a valid university ID'); setError('emailError', /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(mail) ? '' : 'Enter a valid edu email'); setError('phoneError', /^[0-9]{10}$/.test(number) ? '' : 'Enter a valid 10-digit number'); setError('passwordError', pass.length < 8 || !/[A-Z]/.test(pass) || !/[0-9]/.test(pass) ? 'Use 8+ characters, uppercase, and a number' : ''); setError('confirmPasswordError', pass === confirm ? '' : 'Passwords do not match'); document.querySelectorAll('.error-text').forEach(item => { if (!item.classList.contains('hidden')) valid = false; }); return valid; }
        function updatePasswordStrength() { const value = password.value; let score = 0; if (value.length >= 8) score += 25; if (/[A-Z]/.test(value)) score += 25; if (/[0-9]/.test(value)) score += 25; if (/[!@#$%^&*]/.test(value)) score += 25; strengthBar.style.width = score + '%'; }
        function togglePasswordVisibility(inputId, iconId) { const input = document.getElementById(inputId), icon = document.getElementById(iconId), visible = input.type === 'password'; input.type = visible ? 'text' : 'password'; icon.textContent = visible ? 'visibility_off' : 'visibility'; }
        function handleSubmit(event) { event.preventDefault(); if (validateForm()) document.getElementById('registerForm').submit(); }
    </script>
</body>
</html>

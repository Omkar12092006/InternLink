<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.internlink.model.Admin" %>
<%
    if (session.getAttribute("admin") instanceof Admin) {
        response.sendRedirect(request.getContextPath() + "/AdminDashboardServlet");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Admin Login | InternLink</title>
        <link rel="icon" type="image/png" href="<%= request.getContextPath() %>/images/favicon.png">
        <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css?v=20261019">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
    </head>
    <body class="app-shell">
        <main class="auth-page">
            <div class="auth-wrap fade-up">
                <a class="back-link" href="<%= request.getContextPath() %>/index.jsp">
                    <span class="material-symbols-outlined">arrow_back</span>Back to home
                </a>
                <section class="auth-card glass">
                    <div class="auth-head">
                        <span class="eyebrow">Administration</span>
                        <h1>Admin sign in.</h1>
                        <p>Sign in to review system activity and platform metrics.</p>
                    </div>
                    <% if (request.getAttribute("errorMessage") != null) { %>
                        <div role="alert" style="background:rgba(239,68,68,0.1);border:1px solid rgba(239,68,68,0.3);border-radius:8px;padding:12px 16px;margin-bottom:16px;color:#FCA5A5;font-size:14px;">
                            <%= request.getAttribute("errorMessage") %>
                        </div>
                    <% } %>
                    <form class="form-stack" action="<%= request.getContextPath() %>/AdminLoginServlet" method="post">
                        <div class="field">
                            <label for="email">Email</label>
                            <div class="input-icon">
                                <span class="material-symbols-outlined">alternate_email</span>
                                <input class="input" type="email" name="email" id="email" autocomplete="username"
                                       placeholder="admin@internlink.com" required>
                            </div>
                        </div>
                        <div class="field">
                            <label for="password">Password</label>
                            <div class="input-icon">
                                <span class="material-symbols-outlined">lock</span>
                                <input class="input" type="password" name="password" id="password"
                                       autocomplete="current-password" placeholder="Enter your password" required>
                            </div>
                        </div>
                        <button class="button button-primary" type="submit">
                            Sign in <span class="material-symbols-outlined">arrow_forward</span>
                        </button>
                    </form>
                </section>
                <div class="security-note">
                    <span class="material-symbols-outlined">verified_user</span>
                    <span>Authorized administrators only.</span>
                </div>
            </div>
        </main>
    </body>
</html>

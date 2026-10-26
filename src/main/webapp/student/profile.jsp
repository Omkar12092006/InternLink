<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.internlink.model.Student" %>
<%!
    private String escapeHtml(String value) {
        if (value == null) return "";
        return value.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")
                .replace("\"", "&quot;").replace("'", "&#39;");
    }
%>
<%
    Student student = (Student) request.getAttribute("student");
    if (student == null) {
        response.sendRedirect(request.getContextPath() + "/StudentProfileServlet");
        return;
    }
    String message = (String) request.getAttribute("profileMessage");
    String error = (String) request.getAttribute("profileError");
    String resumeResult = request.getParameter("resume");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile | InternLink</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css?v=20261019">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
</head>
<body class="app-shell">
<div class="dashboard-layout">
    <aside class="sidebar">
        <a class="brand" href="<%= request.getContextPath() %>/index.jsp"><span class="brand-mark material-symbols-outlined">trending_up</span><span>InternLink</span></a>
        <nav class="side-nav" aria-label="Student navigation">
            <a href="<%= request.getContextPath() %>/StudentDashboardServlet"><span class="material-symbols-outlined">space_dashboard</span>Dashboard</a>
            <a class="active" href="<%= request.getContextPath() %>/StudentProfileServlet"><span class="material-symbols-outlined">person</span>My Profile</a>
            <a href="<%= request.getContextPath() %>/MyApplicationsServlet"><span class="material-symbols-outlined">work_history</span>Applications</a>
            <a href="<%= request.getContextPath() %>/StudentInterviewsServlet"><span class="material-symbols-outlined">calendar_month</span>Interviews</a>
            <a href="<%= request.getContextPath() %>/browseInternships.jsp"><span class="material-symbols-outlined">search</span>Find Internships</a>
        </nav>
        <div class="side-separator"></div>
        <nav class="side-nav"><a href="<%= request.getContextPath() %>/LogoutServlet"><span class="material-symbols-outlined">logout</span>Logout</a></nav>
    </aside>
    <main class="dashboard-main">
        <header class="dashboard-top">
            <div><span class="eyebrow">Student workspace</span><h1>My profile.</h1><p>Keep your contact details and resume up to date.</p></div>
        </header>
        <% if (message != null) { %><div class="status-box success" role="status"><%= escapeHtml(message) %></div><% } %>
        <% if (error != null) { %><div class="status-box error" role="alert"><%= escapeHtml(error) %></div><% } %>
        <% if ("uploaded".equals(resumeResult)) { %>
            <div class="status-box success" role="status">Resume uploaded successfully.</div>
        <% } else if ("invalid".equals(resumeResult)) { %>
            <div class="status-box error" role="alert">Choose a valid PDF, DOC, or DOCX resume.</div>
        <% } else if ("too-large".equals(resumeResult)) { %>
            <div class="status-box error" role="alert">Resume files must be 5 MB or smaller.</div>
        <% } else if ("empty".equals(resumeResult)) { %>
            <div class="status-box error" role="alert">Choose a resume file to upload.</div>
        <% } else if ("failed".equals(resumeResult)) { %>
            <div class="status-box error" role="alert">The resume could not be saved. Please try again.</div>
        <% } %>

        <section class="panel glass" style="padding:2rem;">
            <div class="panel-head"><h2>Personal information</h2></div>
            <form class="form-stack" action="<%= request.getContextPath() %>/StudentProfileServlet" method="post">
                <div class="field">
                    <label for="fullName">Full name</label>
                    <input class="input" type="text" id="fullName" name="fullName" maxlength="100" required value="<%= escapeHtml(student.getFullName()) %>">
                </div>
                <div class="field">
                    <label for="email">Email</label>
                    <input class="input" type="email" id="email" name="email" maxlength="100" required value="<%= escapeHtml(student.getEmail()) %>">
                </div>
                <div class="form-row">
                    <div class="field">
                        <label for="phone">Phone</label>
                        <input class="input" type="tel" id="phone" name="phone" maxlength="30" value="<%= escapeHtml(student.getPhone()) %>">
                    </div>
                    <div class="field">
                        <label for="course">Course</label>
                        <input class="input" type="text" id="course" name="course" maxlength="100" value="<%= escapeHtml(student.getCourse()) %>">
                    </div>
                </div>
                <button class="button button-primary" type="submit">Save profile</button>
            </form>
        </section>

        <section class="panel glass" id="resume" style="padding:2rem;margin-top:2rem;">
            <div class="panel-head"><h2>Resume</h2>
                <% if (student.getResumeFile() != null) { %>
                    <a href="<%= request.getContextPath() %>/DownloadResumeServlet">Download current resume</a>
                <% } %>
            </div>
            <p style="color:var(--muted);font-size:13px;margin-bottom:18px;">PDF, DOC, or DOCX; maximum file size 5 MB.</p>
            <form class="form-stack" action="<%= request.getContextPath() %>/UploadResumeServlet" method="post" enctype="multipart/form-data">
                <div class="field">
                    <label for="resume">Choose resume</label>
                    <input class="input" type="file" id="resume" name="resume" accept=".pdf,.doc,.docx,application/pdf,application/msword,application/vnd.openxmlformats-officedocument.wordprocessingml.document" required>
                </div>
                <button class="button button-primary" type="submit">Upload resume</button>
            </form>
        </section>
    </main>
</div>
</body>
</html>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List,com.internlink.model.Admin,com.internlink.model.Student" %>
<%!
    private String escapeHtml(String value) {
        if (value == null) return "";
        return value.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")
                .replace("\"", "&quot;").replace("'", "&#39;");
    }
%>
<%
    if (!(session.getAttribute("admin") instanceof Admin)) {
        response.sendRedirect(request.getContextPath() + "/admin/login.jsp");
        return;
    }
    if (!Boolean.TRUE.equals(request.getAttribute("managementReady"))) {
        response.sendRedirect(request.getContextPath() + "/ManageStudentsServlet");
        return;
    }
    List<Student> students = (List<Student>) request.getAttribute("students");
    Student editingStudent = (Student) request.getAttribute("editingStudent");
    String managementMessage = (String) request.getAttribute("managementMessage");
    String managementError = (String) request.getAttribute("managementError");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Students | InternLink</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css?v=20261019">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
    <style>
        .management-panel { overflow-x: auto; padding: 22px; border-radius: 12px; }
        .management-table { width: 100%; border-collapse: collapse; text-align: left; }
        .management-table th, .management-table td { padding: 12px 10px; border-bottom: 1px solid var(--line); vertical-align: middle; }
        .management-table th { color: var(--muted); font-size: 11px; text-transform: uppercase; }
        .management-table td { font-size: 12px; }
        .management-table input { min-width: 115px; max-width: 190px; }
        .row-actions { display: flex; flex-wrap: wrap; gap: 8px; }
        .row-actions form { display: inline; }
        .management-button { padding: 8px 10px; border: 1px solid var(--line); border-radius: 7px; color: var(--text); background: var(--panel-soft); cursor: pointer; font: inherit; font-size: 11px; }
        .management-button.primary { color: var(--ink); border-color: var(--green); background: var(--green); font-weight: 700; }
        .management-button.danger { color: #ffd4db; }
        .empty-state { padding: 24px 10px; color: var(--muted); text-align: center; }
    </style>
</head>
<body class="app-shell">
<div class="dashboard-layout">
    <aside class="sidebar">
        <a class="brand" href="<%= request.getContextPath() %>/index.jsp">
            <span class="brand-mark material-symbols-outlined">trending_up</span><span>InternLink</span>
        </a>
        <nav class="side-nav" aria-label="Admin navigation">
            <a href="<%= request.getContextPath() %>/AdminDashboardServlet"><span class="material-symbols-outlined">space_dashboard</span>Overview</a>
            <a class="active" href="<%= request.getContextPath() %>/ManageStudentsServlet"><span class="material-symbols-outlined">school</span>Manage students</a>
            <a href="<%= request.getContextPath() %>/ManageCompaniesServlet"><span class="material-symbols-outlined">business</span>Manage companies</a>
        </nav>
        <div class="side-separator"></div>
        <nav class="side-nav" aria-label="Account navigation">
            <a href="<%= request.getContextPath() %>/LogoutServlet"><span class="material-symbols-outlined">logout</span>Logout</a>
        </nav>
    </aside>
    <main class="dashboard-main">
        <header class="dashboard-top">
            <div>
                <span class="eyebrow">Administration</span>
                <h1>Admin: Manage Students &amp; Companies</h1>
                <p>Review and update student accounts.</p>
            </div>
        </header>
        <% if (managementMessage != null) { %>
            <div class="status-box success" role="status"><%= escapeHtml(managementMessage) %></div>
        <% } %>
        <% if (managementError != null) { %>
            <div class="status-box error" role="alert"><%= escapeHtml(managementError) %></div>
        <% } %>
        <% if (editingStudent != null) { %>
            <section class="management-panel glass" style="margin-bottom:18px;">
                <div class="panel-head"><h2>Edit student account</h2></div>
                <form class="row-actions" action="<%= request.getContextPath() %>/ManageStudentsServlet" method="post">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="studentId" value="<%= editingStudent.getId() %>">
                    <label>Full name <input class="input" name="fullName" maxlength="100" required value="<%= escapeHtml(editingStudent.getFullName()) %>"></label>
                    <label>Email <input class="input" type="email" name="email" maxlength="100" required value="<%= escapeHtml(editingStudent.getEmail()) %>"></label>
                    <label>Phone <input class="input" name="phone" maxlength="30" value="<%= escapeHtml(editingStudent.getPhone()) %>"></label>
                    <label>Course <input class="input" name="course" maxlength="100" value="<%= escapeHtml(editingStudent.getCourse()) %>"></label>
                    <button class="management-button primary" type="submit">Save changes</button>
                    <a class="management-button" href="<%= request.getContextPath() %>/ManageStudentsServlet">Cancel</a>
                </form>
            </section>
        <% } %>
        <section class="management-panel glass">
            <div class="panel-head"><h2>Student accounts</h2><span><%= students == null ? 0 : students.size() %> accounts</span></div>
            <% if (students == null) { %>
                <div class="empty-state">Student accounts could not be loaded.</div>
            <% } else if (students.isEmpty()) { %>
                <div class="empty-state">There are no student accounts yet.</div>
            <% } else { %>
                <table class="management-table">
                    <thead><tr><th>Name</th><th>Email</th><th>Phone</th><th>Course</th><th>Actions</th></tr></thead>
                    <tbody>
                    <% for (Student student : students) { %>
                        <tr>
                            <td><%= escapeHtml(student.getFullName()) %></td>
                            <td><%= escapeHtml(student.getEmail()) %></td>
                            <td><%= escapeHtml(student.getPhone()) %></td>
                            <td><%= escapeHtml(student.getCourse()) %></td>
                            <td>
                                <div class="row-actions">
                                    <a class="management-button" href="<%= request.getContextPath() %>/ManageStudentsServlet?edit=<%= student.getId() %>">Edit</a>
                                    <form action="<%= request.getContextPath() %>/ManageStudentsServlet" method="post" onsubmit="return confirm('Delete this student account?');">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="studentId" value="<%= student.getId() %>">
                                        <button class="management-button danger" type="submit">Delete</button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                    <% } %>
                    </tbody>
                </table>
            <% } %>
        </section>
    </main>
</div>
</body>
</html>

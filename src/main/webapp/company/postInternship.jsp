<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.internlink.dao.InternshipDAO" %>
<%@ page import="com.internlink.model.Company" %>
<%@ page import="com.internlink.model.Internship" %>
<%
    Company company = (Company) session.getAttribute("company");
    if (company == null) {
        response.sendRedirect(request.getContextPath() + "/company/login.jsp");
        return;
    }

    String errorMessage = (String) request.getAttribute("errorMessage");
    String idParam = request.getParameter("id");
    Internship internship = null;
    boolean editing = idParam != null && !idParam.trim().isEmpty();
    if (editing) {
        try {
            internship = new InternshipDAO().getInternshipById(Integer.parseInt(idParam));
        } catch (NumberFormatException ignored) {
            response.sendRedirect(request.getContextPath() + "/company/postings.jsp");
            return;
        }
        if (internship == null || internship.getCompanyId() != company.getId()) {
            response.sendRedirect(request.getContextPath() + "/company/postings.jsp");
            return;
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= editing ? "Edit Internship" : "Post Internship" %> | InternLink</title>
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
            <nav class="side-nav" aria-label="Company navigation">
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
                    <span class="eyebrow"><%= editing ? "Edit listing" : "New listing" %></span>
                    <h1><%= editing ? "Update internship" : "Create internship listing" %></h1>
                    <p>Share your opportunity with student candidates.</p>
                </div>
                <div class="dashboard-tools">
                    <a href="postings.jsp" class="button button-ghost">View all postings</a>
                </div>
            </header>

            <section class="panel glass profile-panel">
                <% if (errorMessage != null) { %>
                    <div class="status-box error"><span class="material-symbols-outlined">error</span><%= errorMessage %></div>
                <% } %>

                <form class="form-stack" action="<%= request.getContextPath() %><%= editing ? "/EditInternshipServlet" : "/PostInternshipServlet" %>" method="post">
                    <% if (editing && internship != null) { %>
                        <input type="hidden" name="id" value="<%= internship.getId() %>">
                    <% } %>

                    <div class="form-row">
                        <div class="field">
                            <label for="title">Internship title</label>
                            <input class="input" id="title" name="title" type="text" value="<%= internship != null && internship.getTitle() != null ? internship.getTitle() : "" %>" required>
                        </div>
                        <div class="field">
                            <label for="category">Category</label>
                            <select class="input" id="category" name="category" required>
                                <option value="">Select category</option>
                                <option value="Software Engineering" <%= internship != null && "Software Engineering".equals(internship.getCategory()) ? "selected" : "" %>>Software Engineering</option>
                                <option value="Data Science" <%= internship != null && "Data Science".equals(internship.getCategory()) ? "selected" : "" %>>Data Science</option>
                                <option value="UX/UI Design" <%= internship != null && "UX/UI Design".equals(internship.getCategory()) ? "selected" : "" %>>UX/UI Design</option>
                                <option value="Product Management" <%= internship != null && "Product Management".equals(internship.getCategory()) ? "selected" : "" %>>Product Management</option>
                                <option value="Marketing" <%= internship != null && "Marketing".equals(internship.getCategory()) ? "selected" : "" %>>Marketing</option>
                            </select>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="field">
                            <label for="location">Location</label>
                            <input class="input" id="location" name="location" type="text" value="<%= internship != null && internship.getLocation() != null ? internship.getLocation() : "" %>" required>
                        </div>
                        <div class="field">
                            <label for="duration">Duration</label>
                            <input class="input" id="duration" name="duration" type="text" value="<%= internship != null && internship.getDuration() != null ? internship.getDuration() : "" %>" placeholder="Summer (3 months)" required>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="field">
                            <label for="payType">Compensation</label>
                            <select class="input" id="payType" name="payType" required>
                                <option value="paid" <%= internship != null && internship.isPaid() ? "selected" : "" %>>Paid</option>
                                <option value="unpaid" <%= internship != null && !internship.isPaid() ? "selected" : "" %>>Unpaid</option>
                            </select>
                        </div>
                        <div class="field">
                            <label for="stipend">Stipend</label>
                            <input class="input" id="stipend" name="stipend" type="text" value="<%= internship != null && internship.getStipend() != null ? internship.getStipend() : "$0" %>" placeholder="$6,000/month">
                        </div>
                    </div>

                    <div class="field">
                        <label for="skills">Required skills</label>
                        <textarea class="input" id="skills" name="skills" rows="3" required><%= internship != null && internship.getSkills() != null ? internship.getSkills() : "" %></textarea>
                    </div>

                    <div class="field">
                        <label for="description">Role description</label>
                        <textarea class="input" id="description" name="description" rows="6" required><%= internship != null && internship.getDescription() != null ? internship.getDescription() : "" %></textarea>
                    </div>

                    <div class="field" hidden>
                        <label for="emoji">Emoji</label>
                        <input class="input" id="emoji" name="emoji" type="text" value="<%= internship != null && internship.getEmoji() != null ? internship.getEmoji() : "work" %>">
                    </div>

                    <div class="field" hidden>
                        <label for="color">Color</label>
                        <input class="input" id="color" name="color" type="text" value="<%= internship != null && internship.getColor() != null ? internship.getColor() : "#22C55E" %>">
                    </div>

                    <button class="button button-primary" type="submit"><%= editing ? "Update listing" : "Publish internship" %></button>
                </form>
            </section>
        </main>
    </div>
</body>
</html>

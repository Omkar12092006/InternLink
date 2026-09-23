<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.internlink.model.Company" %>
<%
    Company company = (Company) session.getAttribute("company");
    if (company == null) {
        response.sendRedirect(request.getContextPath() + "/company/login.jsp");
        return;
    }
    String successMessage = (String) request.getAttribute("successMessage");
    String errorMessage = (String) request.getAttribute("errorMessage");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Company Profile | InternLink</title>
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
            <nav class="side-nav" aria-label="Company profile navigation">
                <a href="dashboard.jsp"><span class="material-symbols-outlined">space_dashboard</span>Dashboard</a>
                <a class="active" href="profile.jsp"><span class="material-symbols-outlined">person</span>Company Profile</a>
                <a href="postings.jsp"><span class="material-symbols-outlined">work</span>Postings</a>
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
                    <span class="eyebrow">Profile manager</span>
                    <h1>Company profile</h1>
                    <p>Review and update your company information for candidate outreach.</p>
                </div>
                <div class="dashboard-tools">
                    <a href="dashboard.jsp" class="button button-ghost">Back to dashboard</a>
                </div>
            </header>

            <section class="panel glass profile-panel">
                <% if (successMessage != null) { %>
                    <div class="status-box success"><span class="material-symbols-outlined">check_circle</span><%= successMessage %></div>
                <% } %>
                <% if (errorMessage != null) { %>
                    <div class="status-box error"><span class="material-symbols-outlined">error</span><%= errorMessage %></div>
                <% } %>

                <form class="form-stack" action="<%= request.getContextPath() %>/CompanyProfileServlet" method="post">
                    <div class="form-row">
                        <div class="field">
                            <label for="companyName">Company name</label>
                            <input class="input" id="companyName" name="companyName" type="text" value="<%= company.getCompanyName() == null ? "" : company.getCompanyName() %>" required>
                        </div>
                        <div class="field">
                            <label for="hrName">HR contact</label>
                            <input class="input" id="hrName" name="hrName" type="text" value="<%= company.getHrName() == null ? "" : company.getHrName() %>" required>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="field">
                            <label for="industry">Industry</label>
                            <select class="input" id="industry" name="industry" required>
                                <option value="">Select industry</option>
                                <option value="Technology" <%= "Technology".equals(company.getIndustry()) ? "selected" : "" %>>Technology</option>
                                <option value="Finance" <%= "Finance".equals(company.getIndustry()) ? "selected" : "" %>>Finance</option>
                                <option value="Healthcare" <%= "Healthcare".equals(company.getIndustry()) ? "selected" : "" %>>Healthcare</option>
                                <option value="Education" <%= "Education".equals(company.getIndustry()) ? "selected" : "" %>>Education</option>
                                <option value="Manufacturing" <%= "Manufacturing".equals(company.getIndustry()) ? "selected" : "" %>>Manufacturing</option>
                            </select>
                        </div>
                        <div class="field">
                            <label for="location">Location</label>
                            <input class="input" id="location" name="location" type="text" value="<%= company.getLocation() == null ? "" : company.getLocation() %>">
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="field">
                            <label for="email">Email</label>
                            <input class="input" id="email" name="email" type="email" value="<%= company.getEmail() == null ? "" : company.getEmail() %>" required>
                        </div>
                        <div class="field">
                            <label for="phone">Phone</label>
                            <input class="input" id="phone" name="phone" type="tel" value="<%= company.getPhone() == null ? "" : company.getPhone() %>">
                        </div>
                    </div>

                    <div class="field">
                        <label for="website">Website</label>
                        <input class="input" id="website" name="website" type="url" value="<%= company.getWebsite() == null ? "" : company.getWebsite() %>">
                    </div>

                    <div class="field">
                        <label for="description">Company description</label>
                        <textarea class="input" id="description" name="description" rows="5"><%= company.getDescription() == null ? "" : company.getDescription() %></textarea>
                    </div>

                    <button class="button button-primary" type="submit">Save profile</button>
                </form>
            </section>
        </main>
    </div>
</body>
</html>

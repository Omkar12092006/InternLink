<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.internlink.model.Application" %>
<%@ page import="com.internlink.model.Internship" %>
<%@ page import="com.internlink.model.Student" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.util.Collections" %>
<%@ page import="java.util.List" %>
<%
    if (!Boolean.TRUE.equals(request.getAttribute("dashboardReady"))) {
        response.sendRedirect(request.getContextPath() + "/StudentDashboardServlet");
        return;
    }
    Student student = (Student) request.getAttribute("student");
    List<Application> applications = (List<Application>) request.getAttribute("applications");
    List<Internship> savedInternships = (List<Internship>) request.getAttribute("savedInternships");
    if (applications == null) applications = Collections.emptyList();
    if (savedInternships == null) savedInternships = Collections.emptyList();
    long pendingApplications = (Long) request.getAttribute("pendingApplications");
    long offers = (Long) request.getAttribute("offers");
    DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("MMM d, yyyy");
    String savedMessage = request.getParameter("saved");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Dashboard | InternLink</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css?v=20260928">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
</head>
<body class="app-shell">
    <div class="dashboard-layout">
        <aside class="sidebar">
            <a class="brand" href="<%= request.getContextPath() %>/index.jsp"><span class="brand-mark material-symbols-outlined">trending_up</span><span>InternLink</span></a>
            <nav class="side-nav" aria-label="Student dashboard navigation">
                <a class="active" href="#top"><span class="material-symbols-outlined">space_dashboard</span>Dashboard</a>
                <a href="#profile"><span class="material-symbols-outlined">person</span>My Profile</a>
                <a href="#applications"><span class="material-symbols-outlined">work_history</span>Applications</a>
                <a href="#saved"><span class="material-symbols-outlined">bookmark</span>Saved Jobs</a>
                <a href="<%= request.getContextPath() %>/browseInternships.jsp"><span class="material-symbols-outlined">search</span>Find Internships</a>
            </nav>
            <div class="side-separator"></div>
            <nav class="side-nav">
                <a href="<%= request.getContextPath() %>/LogoutServlet"><span class="material-symbols-outlined">logout</span>Logout</a>
            </nav>
        </aside>

        <main class="dashboard-main" id="top">
            <header class="dashboard-top">
                <div>
                    <span class="eyebrow">Student workspace</span>
                    <h1>Welcome, <%= student.getFullName() %>.</h1>
                    <p>Track your real applications and saved internship opportunities.</p>
                </div>
                <form class="dashboard-tools" action="<%= request.getContextPath() %>/browseInternships.jsp" method="get">
                    <label class="search">
                        <span class="material-symbols-outlined">search</span>
                        <input type="search" name="keyword" placeholder="Search internships" aria-label="Search internships">
                    </label>
                    <button class="button button-primary" type="submit">Search</button>
                </form>
            </header>

            <section class="metrics" aria-label="Your application metrics">
                <article class="metric-card glass">
                    <span class="material-symbols-outlined">send</span>
                    <p class="metric-label">Applications</p>
                    <p class="metric-value"><%= applications.size() %></p>
                    <p class="metric-delta">Submitted applications</p>
                </article>
                <article class="metric-card glass">
                    <span class="material-symbols-outlined">pending_actions</span>
                    <p class="metric-label">In progress</p>
                    <p class="metric-value"><%= pendingApplications %></p>
                    <p class="metric-delta">Pending or shortlisted</p>
                </article>
                <article class="metric-card glass">
                    <span class="material-symbols-outlined">verified</span>
                    <p class="metric-label">Selected</p>
                    <p class="metric-value"><%= offers %></p>
                    <p class="metric-delta">Offers from employers</p>
                </article>
                <article class="metric-card glass">
                    <span class="material-symbols-outlined">bookmark</span>
                    <p class="metric-label">Saved jobs</p>
                    <p class="metric-value"><%= savedInternships.size() %></p>
                    <p class="metric-delta">Your bookmarked roles</p>
                </article>
            </section>

            <section class="panel glass" id="profile" style="padding:2rem;margin-top:2rem;">
                <div class="panel-head">
                    <h2>My profile</h2>
                    <span class="eyebrow">Student account</span>
                </div>
                <div class="form-row">
                    <div><strong>Name</strong><p><%= student.getFullName() %></p></div>
                    <div><strong>Email</strong><p><%= student.getEmail() %></p></div>
                    <div><strong>Phone</strong><p><%= student.getPhone() == null || student.getPhone().isBlank() ? "Not provided" : student.getPhone() %></p></div>
                    <div><strong>Course</strong><p><%= student.getCourse() == null || student.getCourse().isBlank() ? "Not provided" : student.getCourse() %></p></div>
                </div>
            </section>

            <section class="panel glass" id="applications" style="padding:2rem;margin-top:2rem;">
                <div class="panel-head">
                    <h2>My applications</h2>
                    <a href="<%= request.getContextPath() %>/browseInternships.jsp">Find more internships</a>
                </div>
                <% if (applications.isEmpty()) { %>
                    <div class="empty-state">
                        <p>You have not applied to any internships yet.</p>
                        <a class="button button-primary" href="<%= request.getContextPath() %>/browseInternships.jsp">Browse internships</a>
                    </div>
                <% } else { %>
                    <div class="form-stack">
                        <% for (Application applicationRecord : applications) { %>
                            <article class="application">
                                <span class="company-logo"><%= applicationRecord.getInternshipCompany() == null || applicationRecord.getInternshipCompany().isBlank() ? "IL" : applicationRecord.getInternshipCompany().substring(0, 1).toUpperCase() %></span>
                                <div class="application-copy">
                                    <strong><a href="<%= request.getContextPath() %>/applyInternship.jsp?id=<%= applicationRecord.getInternshipId() %>"><%= applicationRecord.getInternshipTitle() %></a></strong>
                                    <span><%= applicationRecord.getInternshipCompany() %> · <%= applicationRecord.getInternshipLocation() %>
                                        <% if (applicationRecord.getAppliedDate() != null) { %> · Applied <%= applicationRecord.getAppliedDate().format(dateFormatter) %><% } %>
                                    </span>
                                </div>
                                <span class="badge badge-blue"><%= applicationRecord.getStatus() %></span>
                            </article>
                        <% } %>
                    </div>
                <% } %>
            </section>

            <section class="panel glass" id="saved" style="padding:2rem;margin-top:2rem;">
                <div class="panel-head">
                    <h2>Saved internships</h2>
                    <a href="<%= request.getContextPath() %>/browseInternships.jsp">Browse internships</a>
                </div>
                <% if ("removed".equals(savedMessage)) { %>
                    <div class="status-box success">Saved internship removed.</div>
                <% } else if ("error".equals(savedMessage)) { %>
                    <div class="status-box error">Could not remove that saved internship. Please try again.</div>
                <% } %>
                <% if (savedInternships.isEmpty()) { %>
                    <div class="empty-state">
                        <p>You have not saved any internships yet.</p>
                        <a class="button button-primary" href="<%= request.getContextPath() %>/browseInternships.jsp">Explore internships</a>
                    </div>
                <% } else { %>
                    <div class="form-stack">
                        <% for (Internship internship : savedInternships) { %>
                            <article class="application">
                                <span class="company-logo"><%= internship.getCompany() == null || internship.getCompany().isBlank() ? "IL" : internship.getCompany().substring(0, 1).toUpperCase() %></span>
                                <div class="application-copy">
                                    <strong><a href="<%= request.getContextPath() %>/applyInternship.jsp?id=<%= internship.getId() %>"><%= internship.getTitle() %></a></strong>
                                    <span><%= internship.getCompany() %> · <%= internship.getLocation() %> · <%= internship.isPaid() ? internship.getStipend() : "Unpaid" %></span>
                                </div>
                                <div class="dashboard-tools">
                                    <a class="button button-ghost" href="<%= request.getContextPath() %>/applyInternship.jsp?id=<%= internship.getId() %>">View details</a>
                                    <form action="<%= request.getContextPath() %>/StudentDashboardServlet#saved" method="post">
                                        <input type="hidden" name="internshipId" value="<%= internship.getId() %>">
                                        <button class="button button-ghost" type="submit">Remove saved</button>
                                    </form>
                                </div>
                            </article>
                        <% } %>
                    </div>
                <% } %>
            </section>
        </main>
    </div>
</body>
</html>

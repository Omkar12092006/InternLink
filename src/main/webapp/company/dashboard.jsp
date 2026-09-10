<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.internlink.model.Company" %>
<%
    Company company = (Company) session.getAttribute("company");
    if (company == null) {
        response.sendRedirect(request.getContextPath() + "/company/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Company Dashboard | InternLink</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body class="app-shell">
    <main class="auth-page">
        <section class="auth-card glass">
            <span class="eyebrow">Company workspace</span>
            <h1>Welcome, <%= company.getCompanyName() %>.</h1>
            <p>Your company account is ready. An administrator will review verification before publishing opportunities.</p>
            <p class="muted-link">Account status: <%= company.isVerified() ? "Verified" : "Pending verification" %></p>
        </section>
    </main>
</body>
</html>

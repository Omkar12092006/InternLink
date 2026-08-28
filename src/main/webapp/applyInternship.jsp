<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.internlink.model.Student" %>
<%@ page import="com.internlink.model.Internship" %>
<%@ page import="com.internlink.dao.InternshipDAO" %>
<%@ page import="com.internlink.dao.ApplicationDAO" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%
    Student sessionStudent = (Student) session.getAttribute("student");
    boolean isLoggedIn = (sessionStudent != null);
    String contextPath = request.getContextPath();

    String idParam = request.getParameter("id");
    Internship internship = null;
    String errorMessage = null;
    boolean alreadyApplied = false;

    if (idParam == null || idParam.trim().isEmpty()) {
        errorMessage = "No internship ID provided.";
    } else {
        try {
            int internshipId = Integer.parseInt(idParam);
            InternshipDAO internshipDAO = new InternshipDAO();
            internship = internshipDAO.getInternshipById(internshipId);
            if (internship == null) {
                errorMessage = "Internship not found.";
            } else if (isLoggedIn) {
                ApplicationDAO appDAO = new ApplicationDAO();
                alreadyApplied = appDAO.hasApplied(internshipId, sessionStudent.getEmail());
            }
        } catch (NumberFormatException e) {
            errorMessage = "Invalid internship ID.";
        } catch (Exception e) {
            errorMessage = "An error occurred while loading the internship details.";
        }
    }

    DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("MMM dd, yyyy");
%>
<!DOCTYPE html>
<html class="dark" lang="en">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title><%= internship != null ? internship.getTitle() : "Internship Details" %> | InternLink</title>
    <link rel="stylesheet" href="<%= contextPath %>/css/dark-theme.css">
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet"/>
    <style>
        body { background-color: #0B0F0E; color: #F3F4F6; font-family: 'Inter', sans-serif; }
        .detail-card { background: linear-gradient(135deg, #111816 0%, #0a0f0d 100%); border: 1px solid #26332D; border-radius: 12px; padding: 32px; }
        .badge-paid { padding: 4px 12px; background: rgba(34, 197, 94, 0.15); color: #86EFAC; border-radius: 6px; font-size: 13px; font-weight: 700; }
        .badge-unpaid { padding: 4px 12px; background: rgba(239, 68, 68, 0.15); color: #FCA5A5; border-radius: 6px; font-size: 13px; font-weight: 700; }
        .info-tag { padding: 6px 14px; background: #1a221e; color: #A7B0AB; border-radius: 20px; font-size: 13px; font-weight: 500; }
        .skill-tag { font-size: 12px; background: #1a221e; color: #A7B0AB; padding: 5px 12px; border-radius: 6px; }
        .company-icon { width: 72px; height: 72px; border-radius: 14px; display: flex; align-items: center; justify-content: center; font-size: 32px; flex-shrink: 0; }
        .success-overlay { background: rgba(11, 15, 14, 0.95); position: fixed; inset: 0; z-index: 50; display: flex; align-items: center; justify-content: center; }
        .spinner { display: inline-block; width: 20px; height: 20px; border: 3px solid rgba(34, 197, 94, 0.2); border-top: 3px solid #22C55E; border-radius: 50%; animation: spin 0.8s linear infinite; }
        @keyframes spin { to { transform: rotate(360deg); } }
    </style>
</head>
<body class="min-h-screen flex flex-col">
    <!-- Navigation -->
    <nav class="bg-gray-950 border-b border-gray-800 sticky top-0 z-40">
        <div class="max-w-7xl mx-auto px-6 py-4 flex justify-between items-center">
            <div class="flex items-center gap-3">
                <span class="material-symbols-outlined text-2xl text-green-500">trending_up</span>
                <a href="<%= contextPath %>/index.jsp" class="text-xl font-bold text-white">InternLink</a>
            </div>
            <div class="flex items-center gap-4">
                <a href="<%= contextPath %>/index.jsp" class="text-gray-300 hover:text-green-400 transition">Home</a>
                <a href="<%= contextPath %>/browseInternships.jsp" class="text-gray-300 hover:text-green-400 transition">Browse Internships</a>
                <% if (isLoggedIn) { %>
                    <a href="<%= contextPath %>/student/dashboard.jsp" class="text-gray-300 hover:text-green-400 transition">Dashboard</a>
                    <span class="text-green-400 text-sm font-medium">Hi, <%= sessionStudent.getFullName().split(" ")[0] %></span>
                <% } else { %>
                    <a href="<%= contextPath %>/student/login.jsp" class="text-gray-300 hover:text-green-400 transition">Login</a>
                    <a href="<%= contextPath %>/student/register.jsp" class="bg-green-600 text-white px-4 py-2 rounded-lg hover:bg-green-700 transition">Sign Up</a>
                <% } %>
            </div>
        </div>
    </nav>

    <!-- Main Content -->
    <div class="flex-1 max-w-5xl mx-auto w-full px-6 py-8">
        <% if (errorMessage != null) { %>
            <div class="text-center py-20">
                <span class="material-symbols-outlined text-6xl text-red-500">error_outline</span>
                <h2 class="text-2xl font-bold text-white mt-4 mb-2"><%= errorMessage %></h2>
                <p class="text-gray-400 mb-6">The internship you are looking for does not exist or has been removed.</p>
                <a href="<%= contextPath %>/browseInternships.jsp" class="bg-green-600 text-white px-6 py-3 rounded-lg font-semibold hover:bg-green-700 transition">
                    Browse All Internships
                </a>
            </div>
        <% } else if (internship != null) { %>
            <div class="flex items-center gap-2 text-sm text-gray-400 mb-6">
                <a href="<%= contextPath %>/browseInternships.jsp" class="hover:text-green-400 transition">Internships</a>
                <span class="material-symbols-outlined text-sm">chevron_right</span>
                <span class="text-gray-300"><%= internship.getTitle() %></span>
            </div>

            <div class="detail-card mb-6">
                <div class="flex gap-5 mb-6">
                    <div class="company-icon" style="background:<%= getCompanyColor(internship.getCompany()) %>20; color:<%= getCompanyColor(internship.getCompany()) %>;">
                        <span class="material-symbols-outlined"><%= getCompanyIcon(internship.getCategory()) %></span>
                    </div>
                    <div class="flex-1">
                        <h1 class="text-2xl font-bold text-white mb-1"><%= internship.getTitle() %></h1>
                        <p class="text-gray-400 text-lg"><%= internship.getCompany() %></p>
                        <div class="flex flex-wrap gap-2 mt-3">
                            <% if (internship.isPaid()) { %>
                                <span class="badge-paid">Paid<%= internship.getStipend() != null ? " &middot; " + internship.getStipend() : "" %></span>
                            <% } else { %>
                                <span class="badge-unpaid">Unpaid</span>
                            <% } %>
                            <span class="info-tag"><span class="material-symbols-outlined text-sm align-middle mr-1">location_on</span><%= internship.getLocation() %></span>
                            <span class="info-tag"><span class="material-symbols-outlined text-sm align-middle mr-1">schedule</span><%= internship.getDuration() %></span>
                            <span class="info-tag"><span class="material-symbols-outlined text-sm align-middle mr-1">category</span><%= internship.getCategory() %></span>
                        </div>
                    </div>
                </div>

                <div class="border-t border-gray-800 pt-5 flex justify-between items-center">
                    <div class="text-sm text-gray-400">
                        <span class="ml-4"><%= internship.getApplicants() %> applicants</span>
                    </div>
                    <div>
                        <% if (!isLoggedIn) { %>
                            <a href="<%= contextPath %>/student/login.jsp?redirect=applyInternship.jsp?id=<%= internship.getId() %>" class="bg-green-600 text-white px-6 py-2.5 rounded-lg font-semibold hover:bg-green-700 transition">
                                Login to Apply
                            </a>
                        <% } else if (alreadyApplied) { %>
                            <span class="bg-gray-700 text-gray-300 px-6 py-2.5 rounded-lg font-semibold inline-flex items-center gap-2">
                                <span class="material-symbols-outlined text-sm">check_circle</span>
                                Already Applied
                            </span>
                        <% } else { %>
                            <button id="applyBtn" onclick="submitApplication(<%= internship.getId() %>)" class="bg-green-600 text-white px-6 py-2.5 rounded-lg font-semibold hover:bg-green-700 transition inline-flex items-center gap-2">
                                <span id="applyBtnText">Submit Application</span>
                            </button>
                        <% } %>
                    </div>
                </div>
            </div>

            <div class="grid md:grid-cols-3 gap-6">
                <div class="md:col-span-2 space-y-6">
                    <div class="detail-card">
                        <h2 class="text-lg font-bold text-white mb-3 flex items-center gap-2">
                            <span class="material-symbols-outlined text-green-500">description</span>
                            About this Internship
                        </h2>
                        <p class="text-gray-300 leading-relaxed"><%= internship.getDescription() %></p>
                    </div>

                    <% if (internship.getSkills() != null && !internship.getSkills().isEmpty()) { %>
                    <div class="detail-card">
                        <h2 class="text-lg font-bold text-white mb-3 flex items-center gap-2">
                            <span class="material-symbols-outlined text-green-500">psychology</span>
                            Required Skills
                        </h2>
                        <div class="flex flex-wrap gap-2">
                            <% for (String skill : internship.getSkills().split("\\s*,\\s*")) { %>
                                <span class="skill-tag"><%= skill %></span>
                            <% } %>
                        </div>
                    </div>
                    <% } %>
                </div>

                <div class="space-y-6">
                    <div class="detail-card">
                        <h3 class="text-sm font-bold text-white mb-3 uppercase tracking-wider">Internship Details</h3>
                        <div class="space-y-3 text-sm">
                            <div class="flex justify-between">
                                <span class="text-gray-400">Category</span>
                                <span class="text-white font-medium"><%= internship.getCategory() %></span>
                            </div>
                            <div class="flex justify-between">
                                <span class="text-gray-400">Location</span>
                                <span class="text-white font-medium"><%= internship.getLocation() %></span>
                            </div>
                            <div class="flex justify-between">
                                <span class="text-gray-400">Duration</span>
                                <span class="text-white font-medium"><%= internship.getDuration() %></span>
                            </div>
                            <div class="flex justify-between">
                                <span class="text-gray-400">Stipend</span>
                                <span class="text-white font-medium"><%= internship.getStipendType() %><%= internship.getStipend() != null ? " (" + internship.getStipend() + ")" : "" %></span>
                            </div>
                            <% if (internship.getPostedDate() != null) { %>
                            <div class="flex justify-between">
                                <span class="text-gray-400">Posted</span>
                                <span class="text-white font-medium"><%= internship.getPostedDate().format(dateFormatter) %></span>
                            </div>
                            <% } %>
                        </div>
                    </div>
                </div>
            </div>
        <% } %>
    </div>

    <!-- Success Overlay -->
    <div id="successOverlay" class="success-overlay hidden">
        <div class="text-center">
            <span class="material-symbols-outlined text-6xl text-green-500">check_circle</span>
            <h2 class="text-2xl font-bold text-white mt-4 mb-2">Application Submitted!</h2>
            <p class="text-gray-400 mb-6">Your application has been sent to the employer. Good luck!</p>
            <div class="flex gap-4 justify-center">
                <a href="<%= contextPath %>/student/dashboard.jsp" class="bg-green-600 text-white px-6 py-3 rounded-lg font-semibold hover:bg-green-700 transition">
                    Go to Dashboard
                </a>
                <a href="<%= contextPath %>/browseInternships.jsp" class="border border-gray-600 text-gray-300 px-6 py-3 rounded-lg font-semibold hover:bg-gray-800 transition">
                    Browse More
                </a>
            </div>
        </div>
    </div>

    <!-- Toast Notification -->
    <div id="toast" class="fixed bottom-6 right-6 z-50 hidden">
        <div id="toastContent" class="bg-gray-800 border border-gray-700 rounded-lg px-5 py-3 shadow-xl flex items-center gap-3">
            <span id="toastIcon" class="material-symbols-outlined"></span>
            <span id="toastMessage" class="text-sm text-white"></span>
        </div>
    </div>

    <script>
        const contextPath = '<%= contextPath %>';
        const isLoggedIn = <%= isLoggedIn %>;

        function submitApplication(internshipId) {
            if (!isLoggedIn) {
                window.location.href = contextPath + '/student/login.jsp?redirect=applyInternship.jsp?id=' + internshipId;
                return;
            }

            const btn = document.getElementById('applyBtn');
            const btnText = document.getElementById('applyBtnText');
            btn.disabled = true;
            btnText.innerHTML = '<span class="spinner" style="width:14px;height:14px;border-width:2px;"></span> Submitting...';

            fetch(contextPath + '/ApplicationServlet', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'internshipId=' + internshipId
            })
            .then(response => response.json())
            .then(data => {
                if (data.redirect) {
                    window.location.href = data.redirect;
                    return;
                }
                if (data.success) {
                    document.getElementById('successOverlay').classList.remove('hidden');
                } else if (data.alreadyApplied) {
                    showToast('error', data.message);
                    btn.innerHTML = '<span class="material-symbols-outlined text-sm">check_circle</span> Already Applied';
                    btn.className = 'bg-gray-700 text-gray-300 px-6 py-2.5 rounded-lg font-semibold inline-flex items-center gap-2 cursor-default';
                } else {
                    showToast('error', data.message || 'Failed to submit application.');
                    btn.disabled = false;
                    btnText.textContent = 'Submit Application';
                }
            })
            .catch(error => {
                console.error('Application error:', error);
                showToast('error', 'An error occurred. Please try again.');
                btn.disabled = false;
                btnText.textContent = 'Submit Application';
            });
        }

        function showToast(type, message) {
            const toast = document.getElementById('toast');
            const icon = document.getElementById('toastIcon');
            const msg = document.getElementById('toastMessage');
            msg.textContent = message;
            if (type === 'success') {
                icon.textContent = 'check_circle';
                icon.className = 'material-symbols-outlined text-green-400';
            } else {
                icon.textContent = 'error';
                icon.className = 'material-symbols-outlined text-red-400';
            }
            toast.classList.remove('hidden');
            setTimeout(function() { toast.classList.add('hidden'); }, 3000);
        }
    </script>
</body>
</html>
<%!
    private String getCompanyColor(String company) {
        String[] colors = {"#22C55E", "#3B82F6", "#A855F7", "#F59E0B", "#EF4444", "#06B6D4", "#EC4899"};
        int hash = 0;
        for (int i = 0; i < company.length(); i++) {
            hash = company.charAt(i) + ((hash << 5) - hash);
        }
        return colors[Math.abs(hash) % colors.length];
    }

    private String getCompanyIcon(String category) {
        if (category == null) return "work";
        switch (category) {
            case "Software Engineering": return "code";
            case "Data Science": return "analytics";
            case "Product Management": return "dashboard";
            case "UX/UI Design": return "palette";
            default: return "work";
        }
    }
%>

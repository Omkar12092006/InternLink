<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.internlink.dao.InternshipDAO" %>
<%@ page import="com.internlink.model.Internship" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%
    InternshipDAO internshipDAO = new InternshipDAO();
    List<Internship> allInternships = internshipDAO.getAllInternships();

    String success = request.getParameter("success");
    String error = request.getParameter("error");

    StringBuilder jsonBuilder = new StringBuilder("[");
    for (int i = 0; i < allInternships.size(); i++) {
        Internship job = allInternships.get(i);
        if (i > 0) jsonBuilder.append(",");
        jsonBuilder.append("{");
        jsonBuilder.append("\"id\":").append(job.getId()).append(",");
        jsonBuilder.append("\"title\":\"").append(escapeJson(job.getTitle())).append("\",");
        jsonBuilder.append("\"company\":\"").append(escapeJson(job.getCompany())).append("\",");
        jsonBuilder.append("\"paid\":").append(job.isPaid()).append(",");
        jsonBuilder.append("\"location\":\"").append(escapeJson(job.getLocation())).append("\",");
        jsonBuilder.append("\"duration\":\"").append(escapeJson(job.getDuration())).append("\",");
        jsonBuilder.append("\"category\":\"").append(escapeJson(job.getCategory())).append("\",");
        jsonBuilder.append("\"description\":\"").append(escapeJson(job.getDescription())).append("\",");
        jsonBuilder.append("\"skills\":[");
        String[] skills = job.getSkillsArray();
        for (int j = 0; j < skills.length; j++) {
            if (j > 0) jsonBuilder.append(",");
            jsonBuilder.append("\"").append(escapeJson(skills[j].trim())).append("\"");
        }
        jsonBuilder.append("],");
        jsonBuilder.append("\"applicants\":").append(job.getApplicants()).append(",");
        jsonBuilder.append("\"posted\":\"").append(job.getPostedAgo()).append("\",");
        jsonBuilder.append("\"emoji\":\"").append(job.getEmoji() != null ? job.getEmoji() : "").append("\",");
        jsonBuilder.append("\"color\":\"").append(job.getColor() != null ? job.getColor() : "bg-gray-600").append("\",");
        jsonBuilder.append("\"stipend\":").append(job.getStipend() != null ? "\"" + escapeJson(job.getStipend()) + "\"" : "null");
        jsonBuilder.append("}");
    }
    jsonBuilder.append("]");
    String internshipsJson = jsonBuilder.toString();

    int paidCount = 0;
    int unpaidCount = 0;
    for (Internship job : allInternships) {
        if (job.isPaid()) paidCount++;
        else unpaidCount++;
    }

    String toastMessage = null;
    if ("true".equals(success)) {
        toastMessage = "Application submitted successfully!";
    } else if ("already_applied".equals(error)) {
        toastMessage = "You have already applied to this internship.";
    } else if ("failed".equals(error)) {
        toastMessage = "Application failed. Please try again.";
    } else if ("exception".equals(error)) {
        toastMessage = "An error occurred. Please try again later.";
    }

    String contextPath = request.getContextPath();
%>
<%!
    private String escapeJson(String str) {
        if (str == null) return "";
        return str.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "\\r").replace("\t", "\\t");
    }
%>
<!DOCTYPE html>
<html class="dark" lang="en">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>Browse Internships | InternLink</title>
    <link rel="stylesheet" href="<%= contextPath %>/css/dark-theme.css">
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet"/>
    <style>
        body { background-color: #0B0F0E; color: #F3F4F6; font-family: 'Inter', sans-serif; }
        .job-card { background: linear-gradient(135deg, #111827 0%, #000000 100%); border: 1px solid #1f2937; border-radius: 0.75rem; padding: 1.5rem; transition: all 0.3s ease; }
        .job-card:hover { border-color: rgba(22, 163, 74, 0.5); box-shadow: 0 10px 15px -3px rgba(22, 163, 74, 0.2); }
        .tag { padding: 0.25rem 0.75rem; background-color: #1f2937; color: #d1d5db; border-radius: 9999px; font-size: 0.75rem; font-weight: 600; }
        .badge-primary { padding: 0.25rem 0.5rem; background-color: rgba(22, 163, 74, 0.2); color: #4ade80; border-radius: 0.25rem; font-size: 0.75rem; font-weight: 600; }
        .badge-unpaid { padding: 0.25rem 0.5rem; background-color: rgba(239, 68, 68, 0.2); color: #f87171; border-radius: 0.25rem; font-size: 0.75rem; font-weight: 600; }
        .filter-section { background-color: #111827; border-radius: 0.5rem; padding: 1rem; border: 1px solid #1f2937; }
        .section-header { display: flex; align-items: center; gap: 0.75rem; margin-bottom: 1.5rem; padding-bottom: 1rem; border-bottom: 1px solid #1f2937; }
        .modal-overlay { display: none; position: fixed; inset: 0; background: rgba(0,0,0,0.7); z-index: 50; align-items: center; justify-content: center; }
        .modal-overlay.active { display: flex; }
        .toast { position: fixed; bottom: 2rem; right: 2rem; background: #1f2937; border: 1px solid #16a34a; color: white; padding: 1rem 1.5rem; border-radius: 0.5rem; z-index: 100; transform: translateY(100px); opacity: 0; transition: all 0.3s ease; }
        .toast.show { transform: translateY(0); opacity: 1; }
        .toast.error { border-color: #ef4444; }
        .bookmark-btn.saved .material-symbols-outlined { color: #16a34a; font-variation-settings: 'FILL' 1; }
        .hidden { display: none !important; }
    </style>
</head>
<body class="min-h-screen flex flex-col">
    <!-- Navigation -->
    <nav class="bg-gray-950 border-b border-gray-800 sticky top-0 z-40">
        <div class="max-w-7xl mx-auto px-6 py-4 flex justify-between items-center">
            <div class="flex items-center gap-3">
                <span class="material-symbols-outlined text-2xl text-green-500">trending_up</span>
                <h1 class="text-xl font-bold text-white">InternLink</h1>
            </div>
            <div class="flex items-center gap-4">
                <a href="<%= contextPath %>/index.jsp" class="text-gray-300 hover:text-green-400 transition">Home</a>
                <a href="<%= contextPath %>/student/login.jsp" class="text-gray-300 hover:text-green-400 transition">Login</a>
                <a href="<%= contextPath %>/student/register.jsp" class="bg-green-600 text-white px-4 py-2 rounded-lg hover:bg-green-700 transition">Sign Up</a>
            </div>
        </div>
    </nav>

    <!-- Main Content -->
    <div class="flex-1 flex">
        <!-- Sidebar Filters -->
        <div class="w-72 bg-gray-900 border-r border-gray-800 p-6 overflow-y-auto" style="max-height: calc(100vh - 73px);">
            <div class="mb-8">
                <h2 class="text-xl font-bold text-white mb-4 flex items-center gap-2">
                    <span class="material-symbols-outlined">filter_alt</span>
                    Filters
                </h2>
                <button onclick="clearAllFilters()" class="text-xs text-green-400 hover:text-green-300 transition flex items-center gap-1">
                    <span class="material-symbols-outlined text-xs">close</span>
                    Clear All
                </button>
            </div>

            <!-- Search -->
            <div class="mb-6">
                <input type="text" id="searchInput" placeholder="Search internships..." oninput="applyFilters()" class="w-full px-3 py-2 bg-gray-800 border border-gray-700 rounded-lg text-white placeholder-gray-500 focus:border-green-500 outline-none" />
            </div>

            <!-- Category Filter -->
            <div class="filter-section mb-6">
                <h3 class="font-semibold text-white mb-3">Category</h3>
                <div class="space-y-2">
                    <label class="flex items-center gap-2 text-gray-300 cursor-pointer hover:text-white">
                        <input type="checkbox" value="Software Engineering" class="category-filter w-4 h-4 accent-green-600" onchange="applyFilters()" />
                        <span>Software Engineering</span>
                    </label>
                    <label class="flex items-center gap-2 text-gray-300 cursor-pointer hover:text-white">
                        <input type="checkbox" value="Data Science" class="category-filter w-4 h-4 accent-green-600" onchange="applyFilters()" />
                        <span>Data Science</span>
                    </label>
                    <label class="flex items-center gap-2 text-gray-300 cursor-pointer hover:text-white">
                        <input type="checkbox" value="Product Management" class="category-filter w-4 h-4 accent-green-600" onchange="applyFilters()" />
                        <span>Product Management</span>
                    </label>
                    <label class="flex items-center gap-2 text-gray-300 cursor-pointer hover:text-white">
                        <input type="checkbox" value="UX/UI Design" class="category-filter w-4 h-4 accent-green-600" onchange="applyFilters()" />
                        <span>UX/UI Design</span>
                    </label>
                </div>
            </div>

            <!-- Location Filter -->
            <div class="filter-section mb-6">
                <h3 class="font-semibold text-white mb-3">Location</h3>
                <div class="space-y-2">
                    <label class="flex items-center gap-2 text-gray-300 cursor-pointer hover:text-white">
                        <input type="checkbox" value="Remote" class="location-filter w-4 h-4 accent-green-600" onchange="applyFilters()" />
                        <span>Remote</span>
                    </label>
                    <label class="flex items-center gap-2 text-gray-300 cursor-pointer hover:text-white">
                        <input type="checkbox" value="New York" class="location-filter w-4 h-4 accent-green-600" onchange="applyFilters()" />
                        <span>New York</span>
                    </label>
                    <label class="flex items-center gap-2 text-gray-300 cursor-pointer hover:text-white">
                        <input type="checkbox" value="San Francisco" class="location-filter w-4 h-4 accent-green-600" onchange="applyFilters()" />
                        <span>San Francisco</span>
                    </label>
                    <label class="flex items-center gap-2 text-gray-300 cursor-pointer hover:text-white">
                        <input type="checkbox" value="India" class="location-filter w-4 h-4 accent-green-600" onchange="applyFilters()" />
                        <span>India</span>
                    </label>
                </div>
            </div>

            <!-- Duration Filter -->
            <div class="filter-section mb-6">
                <h3 class="font-semibold text-white mb-3">Duration</h3>
                <div class="space-y-2">
                    <label class="flex items-center gap-2 text-gray-300 cursor-pointer hover:text-white">
                        <input type="radio" name="duration" value="Any" class="w-4 h-4 accent-green-600" checked onchange="applyFilters()" />
                        <span>Any</span>
                    </label>
                    <label class="flex items-center gap-2 text-gray-300 cursor-pointer hover:text-white">
                        <input type="radio" name="duration" value="3 months" class="w-4 h-4 accent-green-600" onchange="applyFilters()" />
                        <span>Summer (3 months)</span>
                    </label>
                    <label class="flex items-center gap-2 text-gray-300 cursor-pointer hover:text-white">
                        <input type="radio" name="duration" value="6 months" class="w-4 h-4 accent-green-600" onchange="applyFilters()" />
                        <span>Co-op (6 months)</span>
                    </label>
                </div>
            </div>

            <!-- Stipend Filter -->
            <div class="filter-section">
                <h3 class="font-semibold text-white mb-3">Stipend</h3>
                <div class="space-y-2">
                    <label class="flex items-center gap-2 text-gray-300 cursor-pointer hover:text-white">
                        <input type="radio" name="stipend" value="all" class="w-4 h-4 accent-green-600" checked onchange="applyFilters()" />
                        <span>All</span>
                    </label>
                    <label class="flex items-center gap-2 text-gray-300 cursor-pointer hover:text-white">
                        <input type="radio" name="stipend" value="Paid" class="w-4 h-4 accent-green-600" onchange="applyFilters()" />
                        <span>Paid Only</span>
                    </label>
                    <label class="flex items-center gap-2 text-gray-300 cursor-pointer hover:text-white">
                        <input type="radio" name="stipend" value="Unpaid" class="w-4 h-4 accent-green-600" onchange="applyFilters()" />
                        <span>Unpaid Only</span>
                    </label>
                </div>
            </div>
        </div>

        <!-- Job Listings -->
        <div class="flex-1 p-8 overflow-y-auto" style="max-height: calc(100vh - 73px);">
            <!-- Header -->
            <div class="mb-8">
                <div class="flex justify-between items-center mb-4">
                    <h1 class="text-4xl font-bold text-white">Open Internships</h1>
                    <div class="flex gap-3">
                        <select id="sortSelect" onchange="sortJobs()" class="bg-gray-800 border border-gray-700 rounded-lg px-4 py-2 text-white focus:border-green-500 outline-none">
                            <option value="recent">Most Recent</option>
                            <option value="relevant">Most Relevant</option>
                            <option value="stipend">Highest Stipend</option>
                            <option value="applicants">Most Applicants</option>
                        </select>
                    </div>
                </div>
                <p class="text-gray-400" id="resultCount">Showing <%= allInternships.size() %> internship<%= allInternships.size() != 1 ? "ies" : "y" %></p>
            </div>

            <!-- Paid Internships Section -->
            <div id="paidSection" class="mb-12">
                <div class="section-header">
                    <span class="material-symbols-outlined text-green-500">payments</span>
                    <h2 class="text-2xl font-bold text-white">Paid Internships</h2>
                    <span class="bg-green-600/20 text-green-400 text-xs font-semibold px-3 py-1 rounded-full" id="paidCount"><%= paidCount %></span>
                </div>
                <div id="paidJobs" class="grid grid-cols-1 gap-6"></div>
            </div>

            <!-- Unpaid Internships Section -->
            <div id="unpaidSection">
                <div class="section-header">
                    <span class="material-symbols-outlined text-red-400">money_off</span>
                    <h2 class="text-2xl font-bold text-white">Unpaid Internships</h2>
                    <span class="bg-red-600/20 text-red-400 text-xs font-semibold px-3 py-1 rounded-full" id="unpaidCount"><%= unpaidCount %></span>
                </div>
                <div id="unpaidJobs" class="grid grid-cols-1 gap-6"></div>
            </div>

            <!-- No Results -->
            <div id="noResults" class="hidden text-center py-16">
                <span class="material-symbols-outlined text-6xl text-gray-600 mb-4">search_off</span>
                <h3 class="text-xl font-semibold text-white mb-2">No internships found</h3>
                <p class="text-gray-400">Try adjusting your filters or search terms.</p>
                <button onclick="clearAllFilters()" class="mt-4 text-green-400 hover:text-green-300 underline">Clear all filters</button>
            </div>

            <!-- Load More -->
            <div class="mt-8 text-center" id="loadMoreContainer">
                <button onclick="loadMore()" id="loadMoreBtn" class="border-2 border-green-600 text-green-400 px-8 py-3 rounded-lg font-semibold hover:bg-green-600/10 transition">
                    Load More Internships
                </button>
            </div>
        </div>
    </div>

    <!-- Apply Modal -->
    <div id="applyModal" class="modal-overlay">
        <div class="bg-gray-900 border border-gray-700 rounded-xl p-8 max-w-lg w-full mx-4">
            <div class="flex justify-between items-center mb-6">
                <h3 class="text-2xl font-bold text-white">Apply for Internship</h3>
                <button onclick="closeModal()" class="text-gray-400 hover:text-white">
                    <span class="material-symbols-outlined">close</span>
                </button>
            </div>
            <div id="modalJobTitle" class="text-green-400 font-semibold mb-1"></div>
            <div id="modalJobCompany" class="text-gray-400 mb-6"></div>
            <form action="<%= contextPath %>/ApplyServlet" method="post">
                <input type="hidden" name="jobId" id="applyJobId" />
                <div class="mb-4">
                    <label class="block text-sm text-gray-300 mb-2">Full Name</label>
                    <input type="text" name="applicantName" required class="w-full px-3 py-2 bg-gray-800 border border-gray-700 rounded-lg text-white focus:border-green-500 outline-none" />
                </div>
                <div class="mb-4">
                    <label class="block text-sm text-gray-300 mb-2">Email</label>
                    <input type="email" name="applicantEmail" required class="w-full px-3 py-2 bg-gray-800 border border-gray-700 rounded-lg text-white focus:border-green-500 outline-none" />
                </div>
                <div class="mb-4">
                    <label class="block text-sm text-gray-300 mb-2">University</label>
                    <input type="text" name="university" required class="w-full px-3 py-2 bg-gray-800 border border-gray-700 rounded-lg text-white focus:border-green-500 outline-none" />
                </div>
                <div class="mb-4">
                    <label class="block text-sm text-gray-300 mb-2">Why are you interested? (Optional)</label>
                    <textarea name="coverLetter" rows="3" class="w-full px-3 py-2 bg-gray-800 border border-gray-700 rounded-lg text-white focus:border-green-500 outline-none"></textarea>
                </div>
                <div class="mb-6">
                    <label class="block text-sm text-gray-300 mb-2">Resume Link</label>
                    <input type="url" name="resumeLink" placeholder="https://drive.google.com/..." class="w-full px-3 py-2 bg-gray-800 border border-gray-700 rounded-lg text-white focus:border-green-500 outline-none" />
                </div>
                <div class="flex gap-3">
                    <button type="submit" class="flex-1 bg-green-600 text-white py-3 rounded-lg font-semibold hover:bg-green-700 transition">Submit Application</button>
                    <button type="button" onclick="closeModal()" class="px-6 py-3 border border-gray-700 text-gray-300 rounded-lg hover:bg-gray-800 transition">Cancel</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Toast Notification -->
    <div id="toast" class="toast<%= toastMessage != null && error != null ? " error" : "" %>">
        <span id="toastMessage"></span>
    </div>

    <script>
        const allJobs = <%= internshipsJson %>;

        let displayedCount = 8;
        let savedJobs = JSON.parse(localStorage.getItem('savedJobs') || '[]');

        function renderJobs(jobs, containerId) {
            const container = document.getElementById(containerId);
            container.innerHTML = jobs.map(job => `
                <div class="job-card" data-job-id="${job.id}">
                    <div class="flex gap-4 mb-4">
                        <div class="w-16 h-16 ${job.color} rounded-lg flex items-center justify-center text-2xl flex-shrink-0">${job.emoji}</div>
                        <div class="flex-1">
                            <div class="flex justify-between items-start mb-2">
                                <div class="flex-1 cursor-pointer" onclick="viewJobDetail(${job.id})">
                                    <h3 class="text-xl font-bold text-white hover:text-green-400 transition">${job.title}</h3>
                                    <p class="text-gray-400">${job.company}</p>
                                </div>
                                <button onclick="toggleBookmark(${job.id})" class="bookmark-btn ${savedJobs.includes(job.id) ? 'saved' : ''} text-gray-400 hover:text-green-400 transition" title="Save internship">
                                    <span class="material-symbols-outlined">${savedJobs.includes(job.id) ? 'bookmark' : 'bookmark_border'}</span>
                                </button>
                            </div>
                            <div class="flex flex-wrap gap-2 mb-3">
                                ${job.paid ? '<span class="badge-primary">Paid ' + (job.stipend ? '• ' + job.stipend : '') + '</span>' : '<span class="badge-unpaid">Unpaid</span>'}
                                <span class="tag">${job.location}</span>
                                <span class="tag">${job.duration}</span>
                                <span class="tag">${job.category}</span>
                            </div>
                            <p class="text-gray-300 mb-3">${job.description}</p>
                            <div class="flex flex-wrap gap-2 mb-4">
                                ${job.skills.map(s => '<span class="text-xs bg-gray-800 text-gray-300 px-2 py-1 rounded">' + s + '</span>').join('')}
                            </div>
                            <div class="flex justify-between items-center">
                                <span class="text-xs text-gray-500">Posted ${job.posted} • ${job.applicants} applicants</span>
                                <button onclick="openApplyModal(${job.id})" class="bg-green-600 text-white px-6 py-2 rounded-lg font-semibold hover:bg-green-700 transition">Apply Now</button>
                            </div>
                        </div>
                    </div>
                </div>
            `).join('');
        }

        function renderAll() {
            const paidJobs = allJobs.slice(0, displayedCount).filter(j => j.paid);
            const unpaidJobs = allJobs.slice(0, displayedCount).filter(j => !j.paid);
            renderJobs(paidJobs, 'paidJobs');
            renderJobs(unpaidJobs, 'unpaidJobs');
            document.getElementById('paidCount').textContent = paidJobs.length;
            document.getElementById('unpaidCount').textContent = unpaidJobs.length;
            const total = paidJobs.length + unpaidJobs.length;
            document.getElementById('resultCount').textContent = 'Showing ' + total + ' internship' + (total !== 1 ? 'ies' : 'y');
            document.getElementById('noResults').classList.toggle('hidden', total > 0);
            document.getElementById('loadMoreContainer').classList.toggle('hidden', displayedCount >= allJobs.length);
            document.getElementById('paidSection').classList.toggle('hidden', paidJobs.length === 0);
            document.getElementById('unpaidSection').classList.toggle('hidden', unpaidJobs.length === 0);
        }

        function applyFilters() {
            const search = document.getElementById('searchInput').value.toLowerCase();
            const categories = Array.from(document.querySelectorAll('.category-filter:checked')).map(c => c.value);
            const locations = Array.from(document.querySelectorAll('.location-filter:checked')).map(c => c.value);
            const duration = document.querySelector('input[name="duration"]:checked')?.value || 'Any';
            const stipend = document.querySelector('input[name="stipend"]:checked')?.value || 'all';

            let filtered = allJobs.filter(job => {
                if (search && !job.title.toLowerCase().includes(search) && !job.company.toLowerCase().includes(search) && !job.description.toLowerCase().includes(search) && !job.skills.some(s => s.toLowerCase().includes(search))) return false;
                if (categories.length && !categories.includes(job.category)) return false;
                if (locations.length && !locations.includes(job.location)) return false;
                if (duration !== 'Any') { if (duration === '3 months' && !job.duration.includes('3')) return false; if (duration === '6 months' && !job.duration.includes('6')) return false; }
                if (stipend === 'Paid' && !job.paid) return false;
                if (stipend === 'Unpaid' && job.paid) return false;
                return true;
            });

            const paidJobs = filtered.filter(j => j.paid);
            const unpaidJobs = filtered.filter(j => !j.paid);
            renderJobs(paidJobs, 'paidJobs');
            renderJobs(unpaidJobs, 'unpaidJobs');
            document.getElementById('paidCount').textContent = paidJobs.length;
            document.getElementById('unpaidCount').textContent = unpaidJobs.length;
            const total = paidJobs.length + unpaidJobs.length;
            document.getElementById('resultCount').textContent = total === 0 ? 'No internships found' : 'Showing ' + total + ' internship' + (total !== 1 ? 'ies' : 'y');
            document.getElementById('noResults').classList.toggle('hidden', total > 0);
            document.getElementById('loadMoreContainer').classList.add('hidden');
            document.getElementById('paidSection').classList.toggle('hidden', paidJobs.length === 0);
            document.getElementById('unpaidSection').classList.toggle('hidden', unpaidJobs.length === 0);
        }

        function clearAllFilters() {
            document.getElementById('searchInput').value = '';
            document.querySelectorAll('.category-filter, .location-filter').forEach(c => c.checked = false);
            document.querySelector('input[name="duration"][value="Any"]').checked = true;
            document.querySelector('input[name="stipend"][value="all"]').checked = true;
            displayedCount = 8;
            renderAll();
            showToast('Filters cleared');
        }

        function sortJobs() {
            const sortBy = document.getElementById('sortSelect').value;
            if (sortBy === 'recent') allJobs.sort((a, b) => a.id - b.id);
            else if (sortBy === 'stipend') allJobs.sort((a, b) => (b.applicants || 0) - (a.applicants || 0));
            else if (sortBy === 'applicants') allJobs.sort((a, b) => b.applicants - a.applicants);
            applyFilters();
        }

        function loadMore() {
            displayedCount = Math.min(displayedCount + 4, allJobs.length);
            renderAll();
            showToast('Loaded more internships');
        }

        function openApplyModal(jobId) {
            const job = allJobs.find(j => j.id === jobId);
            if (!job) return;
            document.getElementById('applyJobId').value = jobId;
            document.getElementById('modalJobTitle').textContent = job.title;
            document.getElementById('modalJobCompany').textContent = job.company;
            document.getElementById('applyModal').classList.add('active');
        }

        function closeModal() {
            document.getElementById('applyModal').classList.remove('active');
        }

        function toggleBookmark(jobId) {
            const idx = savedJobs.indexOf(jobId);
            if (idx > -1) { savedJobs.splice(idx, 1); showToast('Removed from saved'); }
            else { savedJobs.push(jobId); showToast('Saved to bookmarks'); }
            localStorage.setItem('savedJobs', JSON.stringify(savedJobs));
            applyFilters();
        }

        function viewJobDetail(jobId) {
            const job = allJobs.find(j => j.id === jobId);
            if (job) showToast('Viewing: ' + job.title + ' at ' + job.company);
        }

        function showToast(message) {
            const toast = document.getElementById('toast');
            document.getElementById('toastMessage').textContent = message;
            toast.classList.add('show');
            setTimeout(() => toast.classList.remove('show'), 3000);
        }

        document.getElementById('applyModal').addEventListener('click', function(e) { if (e.target === this) closeModal(); });

        <% if (toastMessage != null) { %>
        showToast('<%= escapeJson(toastMessage) %>');
        <% } %>

        renderAll();
    </script>
</body>
</html>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.internlink.model.Student" %>
<%
    Student sessionStudent = (Student) session.getAttribute("student");
    boolean isLoggedIn = (sessionStudent != null);
    String contextPath = request.getContextPath();
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
        .job-card { background: linear-gradient(135deg, #111816 0%, #0a0f0d 100%); border: 1px solid #26332D; border-radius: 12px; padding: 24px; transition: all 0.3s ease; }
        .job-card:hover { border-color: #22C55E; box-shadow: 0 8px 24px rgba(34, 197, 94, 0.15); }
        .tag { padding: 4px 12px; background: #1a221e; color: #A7B0AB; border-radius: 20px; font-size: 12px; font-weight: 600; }
        .badge-paid { padding: 4px 10px; background: rgba(34, 197, 94, 0.15); color: #86EFAC; border-radius: 6px; font-size: 12px; font-weight: 700; }
        .badge-unpaid { padding: 4px 10px; background: rgba(239, 68, 68, 0.15); color: #FCA5A5; border-radius: 6px; font-size: 12px; font-weight: 700; }
        .filter-section { background: #111816; border-radius: 8px; padding: 16px; border: 1px solid #26332D; }
        .filter-section label { transition: color 0.2s; }
        .filter-section label:hover { color: #fff; }
        .company-icon { width: 56px; height: 56px; border-radius: 10px; display: flex; align-items: center; justify-content: center; font-size: 24px; flex-shrink: 0; }
        .bookmark-btn { cursor: pointer; transition: all 0.2s; }
        .bookmark-btn:hover { transform: scale(1.2); }
        .bookmark-btn.active .material-symbols-outlined { color: #22C55E; font-variation-settings: 'FILL' 1; }
        .skill-tag { font-size: 11px; background: #1a221e; color: #A7B0AB; padding: 3px 8px; border-radius: 4px; }
        .active-filter { background: rgba(34, 197, 94, 0.1); border: 1px solid #22C55E; color: #86EFAC; padding: 2px 8px; border-radius: 20px; font-size: 11px; display: inline-flex; align-items: center; gap: 4px; margin: 2px; }
        .active-filter .remove-filter { cursor: pointer; font-size: 14px; line-height: 1; }
        .active-filter .remove-filter:hover { color: #EF4444; }
        .no-results { text-align: center; padding: 60px 20px; }
        .no-results .material-symbols-outlined { font-size: 64px; color: #26332D; margin-bottom: 16px; }
        .spinner { display: inline-block; width: 24px; height: 24px; border: 3px solid rgba(34, 197, 94, 0.2); border-top: 3px solid #22C55E; border-radius: 50%; animation: spin 0.8s linear infinite; }
        @keyframes spin { to { transform: rotate(360deg); } }
        input[type="checkbox"], input[type="radio"] { accent-color: #22C55E; }
        .filter-badge { background: #22C55E; color: #061009; font-size: 10px; font-weight: 700; padding: 1px 6px; border-radius: 10px; margin-left: 4px; }
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
                <% if (isLoggedIn) { %>
                    <a href="<%= contextPath %>/student/dashboard.jsp" class="text-gray-300 hover:text-green-400 transition">Dashboard</a>
                    <span class="text-green-400 text-sm font-medium">Hi, <%= sessionStudent.getFullName().split(" ")[0] %></span>
                    <a href="<%= contextPath %>/student/login.jsp" class="text-gray-300 hover:text-green-400 transition">Logout</a>
                <% } else { %>
                    <a href="<%= contextPath %>/student/login.jsp" class="text-gray-300 hover:text-green-400 transition">Login</a>
                    <a href="<%= contextPath %>/student/register.jsp" class="bg-green-600 text-white px-4 py-2 rounded-lg hover:bg-green-700 transition">Sign Up</a>
                <% } %>
            </div>
        </div>
    </nav>

    <!-- Main Content -->
    <div class="flex-1 flex">
        <!-- Sidebar Filters -->
        <div class="w-72 bg-gray-900 border-r border-gray-800 p-6 overflow-y-auto" style="max-height: calc(100vh - 73px);">
            <div class="mb-6 flex justify-between items-center">
                <h2 class="text-lg font-bold text-white flex items-center gap-2">
                    <span class="material-symbols-outlined">filter_alt</span>
                    Filters
                </h2>
                <button onclick="clearAllFilters()" class="text-xs text-green-400 hover:text-green-300 transition font-medium">Clear All</button>
            </div>

            <!-- Search -->
            <div class="mb-6">
                <div class="relative">
                    <span class="material-symbols-outlined absolute left-3 top-2.5 text-gray-500">search</span>
                    <input type="text" id="searchInput" placeholder="Search title, company, skill..." class="w-full pl-10 pr-3 py-2 bg-gray-800 border border-gray-700 rounded-lg text-white placeholder-gray-500 focus:border-green-500 outline-none text-sm" oninput="debounceSearch()"/>
                </div>
            </div>

            <!-- Category Filter -->
            <div class="filter-section mb-5">
                <h3 class="font-semibold text-white mb-3 text-sm">Category</h3>
                <div class="space-y-2">
                    <label class="flex items-center gap-2 text-gray-300 cursor-pointer text-sm">
                        <input type="checkbox" class="w-4 h-4" value="Software Engineering" onchange="applyFilters()"/>
                        <span>Software Engineering</span>
                    </label>
                    <label class="flex items-center gap-2 text-gray-300 cursor-pointer text-sm">
                        <input type="checkbox" class="w-4 h-4" value="Data Science" onchange="applyFilters()"/>
                        <span>Data Science</span>
                    </label>
                    <label class="flex items-center gap-2 text-gray-300 cursor-pointer text-sm">
                        <input type="checkbox" class="w-4 h-4" value="Product Management" onchange="applyFilters()"/>
                        <span>Product Management</span>
                    </label>
                    <label class="flex items-center gap-2 text-gray-300 cursor-pointer text-sm">
                        <input type="checkbox" class="w-4 h-4" value="UX/UI Design" onchange="applyFilters()"/>
                        <span>UX/UI Design</span>
                    </label>
                </div>
            </div>

            <!-- Location Filter -->
            <div class="filter-section mb-5">
                <h3 class="font-semibold text-white mb-3 text-sm">Location</h3>
                <div class="space-y-2">
                    <label class="flex items-center gap-2 text-gray-300 cursor-pointer text-sm">
                        <input type="checkbox" class="w-4 h-4" value="Remote" onchange="applyFilters()"/>
                        <span>Remote</span>
                    </label>
                    <label class="flex items-center gap-2 text-gray-300 cursor-pointer text-sm">
                        <input type="checkbox" class="w-4 h-4" value="New York" onchange="applyFilters()"/>
                        <span>New York</span>
                    </label>
                    <label class="flex items-center gap-2 text-gray-300 cursor-pointer text-sm">
                        <input type="checkbox" class="w-4 h-4" value="San Francisco" onchange="applyFilters()"/>
                        <span>San Francisco</span>
                    </label>
                    <label class="flex items-center gap-2 text-gray-300 cursor-pointer text-sm">
                        <input type="checkbox" class="w-4 h-4" value="India" onchange="applyFilters()"/>
                        <span>India</span>
                    </label>
                </div>
            </div>

            <!-- Duration Filter -->
            <div class="filter-section mb-5">
                <h3 class="font-semibold text-white mb-3 text-sm">Duration</h3>
                <div class="space-y-2">
                    <label class="flex items-center gap-2 text-gray-300 cursor-pointer text-sm">
                        <input type="radio" name="duration" value="Any" checked onchange="applyFilters()"/>
                        <span>Any</span>
                    </label>
                    <label class="flex items-center gap-2 text-gray-300 cursor-pointer text-sm">
                        <input type="radio" name="duration" value="Summer (3 months)" onchange="applyFilters()"/>
                        <span>Summer (3 months)</span>
                    </label>
                    <label class="flex items-center gap-2 text-gray-300 cursor-pointer text-sm">
                        <input type="radio" name="duration" value="Co-op (6 months)" onchange="applyFilters()"/>
                        <span>Co-op (6 months)</span>
                    </label>
                </div>
            </div>

            <!-- Stipend Filter -->
            <div class="filter-section">
                <h3 class="font-semibold text-white mb-3 text-sm">Stipend</h3>
                <div class="space-y-2">
                    <label class="flex items-center gap-2 text-gray-300 cursor-pointer text-sm">
                        <input type="checkbox" class="w-4 h-4" value="Paid" onchange="applyFilters()"/>
                        <span>Paid</span>
                    </label>
                    <label class="flex items-center gap-2 text-gray-300 cursor-pointer text-sm">
                        <input type="checkbox" class="w-4 h-4" value="Unpaid" onchange="applyFilters()"/>
                        <span>Unpaid</span>
                    </label>
                </div>
            </div>
        </div>

        <!-- Job Listings -->
        <div class="flex-1 p-8 overflow-y-auto" style="max-height: calc(100vh - 73px);">
            <!-- Header -->
            <div class="mb-6">
                <div class="flex justify-between items-center mb-3">
                    <h1 class="text-3xl font-bold text-white">Open Internships</h1>
                </div>
                <div class="flex justify-between items-center">
                    <p id="resultCount" class="text-gray-400">Loading internships...</p>
                </div>
                <!-- Active Filters Display -->
                <div id="activeFilters" class="mt-3 flex flex-wrap gap-1"></div>
            </div>

            <!-- Loading State -->
            <div id="loadingState" class="text-center py-12">
                <div class="spinner"></div>
                <p class="text-gray-500 mt-3">Loading internships...</p>
            </div>

            <!-- Error State -->
            <div id="errorState" class="hidden text-center py-12">
                <span class="material-symbols-outlined text-5xl text-red-500">error_outline</span>
                <p class="text-gray-400 mt-3" id="errorMessage">Unable to load internships.</p>
                <button onclick="loadInternships()" class="mt-4 text-green-400 hover:text-green-300 underline">Try Again</button>
            </div>

            <!-- Job Cards Container -->
            <div id="jobCardsContainer" class="grid grid-cols-1 gap-5"></div>

            <!-- No Results -->
            <div id="noResults" class="hidden no-results">
                <span class="material-symbols-outlined">search_off</span>
                <h3 class="text-xl font-bold text-white mb-2">No internships found</h3>
                <p class="text-gray-400 mb-4">Try adjusting your filters or search terms.</p>
                <button onclick="clearAllFilters()" class="text-green-400 hover:text-green-300 underline">Clear all filters</button>
            </div>

            <!-- Load More -->
            <div id="loadMoreContainer" class="mt-8 text-center hidden">
                <button id="loadMoreBtn" onclick="loadMore()" class="border-2 border-green-600 text-green-400 px-8 py-3 rounded-lg font-semibold hover:bg-green-600/10 transition">
                    Load More Internships
                </button>
                <p id="noMoreText" class="text-gray-500 hidden">No more internships available.</p>
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
        let currentPage = 1;
        let totalCount = 0;
        let hasMore = false;
        let isLoading = false;
        let searchTimeout = null;

        document.addEventListener('DOMContentLoaded', function() {
            loadInternships();
        });

        function debounceSearch() {
            clearTimeout(searchTimeout);
            searchTimeout = setTimeout(function() {
                applyFilters();
            }, 400);
        }

        function getFilterParams() {
            const keyword = document.getElementById('searchInput').value.trim();
            const categories = Array.from(document.querySelectorAll('.filter-section input[type="checkbox"][value="Software Engineering"], .filter-section input[type="checkbox"][value="Data Science"], .filter-section input[type="checkbox"][value="Product Management"], .filter-section input[type="checkbox"][value="UX/UI Design"]')).filter(cb => cb.checked).map(cb => cb.value);
            const locations = Array.from(document.querySelectorAll('.filter-section input[type="checkbox"][value="Remote"], .filter-section input[type="checkbox"][value="New York"], .filter-section input[type="checkbox"][value="San Francisco"], .filter-section input[type="checkbox"][value="India"]')).filter(cb => cb.checked).map(cb => cb.value);
            const durationEl = document.querySelector('input[name="duration"]:checked');
            const duration = durationEl ? durationEl.value : 'Any';
            const stipendChecked = Array.from(document.querySelectorAll('.filter-section input[type="checkbox"][value="Paid"], .filter-section input[type="checkbox"][value="Unpaid"]')).filter(cb => cb.checked).map(cb => cb.value);
            let stipend = null;
            if (stipendChecked.length === 1) {
                stipend = stipendChecked[0];
            }
            return { keyword, categories, locations, duration, stipend };
        }

        function applyFilters() {
            currentPage = 1;
            updateActiveFiltersDisplay();
            loadInternships();
        }

        function clearAllFilters() {
            document.getElementById('searchInput').value = '';
            document.querySelectorAll('.filter-section input[type="checkbox"]').forEach(cb => cb.checked = false);
            const anyDuration = document.querySelector('input[name="duration"][value="Any"]');
            if (anyDuration) anyDuration.checked = true;
            currentPage = 1;
            updateActiveFiltersDisplay();
            loadInternships();
        }

        function updateActiveFiltersDisplay() {
            const container = document.getElementById('activeFilters');
            container.innerHTML = '';
            const { keyword, categories, locations, duration, stipend } = getFilterParams();

            if (keyword) {
                container.innerHTML += '<span class="active-filter">Search: ' + escapeHtml(keyword) + '<span class="remove-filter" onclick="clearSearch()">&times;</span></span>';
            }
            categories.forEach(c => {
                container.innerHTML += '<span class="active-filter">' + escapeHtml(c) + '<span class="remove-filter" onclick="uncheckCategory(\'' + escapeHtml(c) + '\')">&times;</span></span>';
            });
            locations.forEach(l => {
                container.innerHTML += '<span class="active-filter">' + escapeHtml(l) + '<span class="remove-filter" onclick="uncheckLocation(\'' + escapeHtml(l) + '\')">&times;</span></span>';
            });
            if (duration && duration !== 'Any') {
                container.innerHTML += '<span class="active-filter">' + escapeHtml(duration) + '<span class="remove-filter" onclick="clearDuration()">&times;</span></span>';
            }
            if (stipend) {
                container.innerHTML += '<span class="active-filter">' + escapeHtml(stipend) + '<span class="remove-filter" onclick="uncheckStipend(\'' + escapeHtml(stipend) + '\')">&times;</span></span>';
            }
        }

        function clearSearch() {
            document.getElementById('searchInput').value = '';
            applyFilters();
        }

        function uncheckCategory(value) {
            document.querySelectorAll('.filter-section input[type="checkbox"]').forEach(cb => {
                if (cb.value === value) cb.checked = false;
            });
            applyFilters();
        }

        function uncheckLocation(value) {
            document.querySelectorAll('.filter-section input[type="checkbox"]').forEach(cb => {
                if (cb.value === value) cb.checked = false;
            });
            applyFilters();
        }

        function uncheckStipend(value) {
            document.querySelectorAll('.filter-section input[type="checkbox"]').forEach(cb => {
                if (cb.value === value) cb.checked = false;
            });
            applyFilters();
        }

        function clearDuration() {
            const anyDuration = document.querySelector('input[name="duration"][value="Any"]');
            if (anyDuration) anyDuration.checked = true;
            applyFilters();
        }

        function buildQueryString(page) {
            const { keyword, categories, locations, duration, stipend } = getFilterParams();
            const params = new URLSearchParams();
            params.set('page', page);
            if (keyword) params.set('keyword', keyword);
            categories.forEach(c => params.append('categories', c));
            locations.forEach(l => params.append('locations', l));
            if (duration && duration !== 'Any') params.set('duration', duration);
            if (stipend) params.set('stipend', stipend);
            return params.toString();
        }

        function loadInternships() {
            if (isLoading) return;
            isLoading = true;
            document.getElementById('loadingState').classList.remove('hidden');
            document.getElementById('errorState').classList.add('hidden');
            document.getElementById('jobCardsContainer').innerHTML = '';
            document.getElementById('noResults').classList.add('hidden');
            document.getElementById('loadMoreContainer').classList.add('hidden');
            document.getElementById('resultCount').textContent = 'Loading...';

            fetch(contextPath + '/InternshipServlet?' + buildQueryString(1), {
                method: 'GET',
                headers: { 'Accept': 'application/json' }
            })
            .then(response => {
                if (!response.ok) throw new Error('Server error');
                return response.json();
            })
            .then(data => {
                if (data.error) throw new Error(data.error);
                totalCount = data.totalCount;
                hasMore = data.hasMore;
                currentPage = 1;
                renderInternships(data.internships, false);
                updateResultCount();
                updateLoadMoreVisibility();
                document.getElementById('loadingState').classList.add('hidden');
                isLoading = false;
            })
            .catch(error => {
                console.error('Error loading internships:', error);
                document.getElementById('loadingState').classList.add('hidden');
                document.getElementById('errorState').classList.remove('hidden');
                document.getElementById('errorMessage').textContent = error.message || 'Unable to load internships. Please try again.';
                document.getElementById('resultCount').textContent = 'Error loading internships';
                isLoading = false;
            });
        }

        function loadMore() {
            if (isLoading || !hasMore) return;
            isLoading = true;
            const btn = document.getElementById('loadMoreBtn');
            btn.innerHTML = '<span class="spinner" style="width:16px;height:16px;border-width:2px;"></span> Loading...';
            btn.disabled = true;

            const nextPage = currentPage + 1;
            fetch(contextPath + '/InternshipServlet?' + buildQueryString(nextPage), {
                method: 'GET',
                headers: { 'Accept': 'application/json' }
            })
            .then(response => {
                if (!response.ok) throw new Error('Server error');
                return response.json();
            })
            .then(data => {
                if (data.error) throw new Error(data.error);
                totalCount = data.totalCount;
                hasMore = data.hasMore;
                currentPage = nextPage;
                renderInternships(data.internships, true);
                updateResultCount();
                updateLoadMoreVisibility();
                btn.innerHTML = 'Load More Internships';
                btn.disabled = false;
                isLoading = false;
            })
            .catch(error => {
                console.error('Error loading more:', error);
                btn.innerHTML = 'Load More Internships';
                btn.disabled = false;
                showToast('error', 'Failed to load more internships.');
                isLoading = false;
            });
        }

        function renderInternships(internships, append) {
            const container = document.getElementById('jobCardsContainer');
            if (!append) container.innerHTML = '';

            if (internships.length === 0 && !append) {
                document.getElementById('noResults').classList.remove('hidden');
                return;
            }

            internships.forEach(function(job) {
                const card = document.createElement('div');
                card.className = 'job-card';
                card.id = 'internship-card-' + job.id;

                const stipendBadge = job.stipendType === 'Paid'
                    ? '<span class="badge-paid">Paid' + (job.stipendAmount ? ' &middot; ' + escapeHtml(job.stipendAmount) : '') + '</span>'
                    : '<span class="badge-unpaid">Unpaid</span>';

                const skillsHtml = (job.skills || []).map(function(s) {
                    return '<span class="skill-tag">' + escapeHtml(s) + '</span>';
                }).join('');

                const bookmarkClass = job.isBookmarked ? 'active' : '';
                const bookmarkIcon = job.isBookmarked ? 'bookmark' : 'bookmark_border';

                card.innerHTML =
                    '<div class="flex gap-4">' +
                        '<div class="company-icon" style="background:' + getCompanyColor(job.company) + '20; color:' + getCompanyColor(job.company) + ';">' +
                            '<span class="material-symbols-outlined">' + getCompanyIcon(job.category) + '</span>' +
                        '</div>' +
                        '<div class="flex-1">' +
                            '<div class="flex justify-between items-start mb-2">' +
                                '<div>' +
                                    '<h3 class="text-lg font-bold text-white hover:text-green-400 cursor-pointer transition" onclick="viewInternship(' + job.id + ')">' + escapeHtml(job.title) + '</h3>' +
                                    '<p class="text-gray-400 text-sm">' + escapeHtml(job.company) + '</p>' +
                                '</div>' +
                                '<button class="bookmark-btn ' + bookmarkClass + '" id="bookmark-' + job.id + '" onclick="toggleBookmark(' + job.id + ')" title="Bookmark this internship">' +
                                    '<span class="material-symbols-outlined">' + bookmarkIcon + '</span>' +
                                '</button>' +
                            '</div>' +
                            '<div class="flex flex-wrap gap-2 mb-3">' +
                                stipendBadge +
                                '<span class="tag">' + escapeHtml(job.location) + '</span>' +
                                '<span class="tag">' + escapeHtml(job.duration) + '</span>' +
                                '<span class="tag">' + escapeHtml(job.category) + '</span>' +
                            '</div>' +
                            '<p class="text-gray-300 text-sm mb-3 line-clamp-2">' + escapeHtml(job.description) + '</p>' +
                            '<div class="flex flex-wrap gap-1 mb-4">' + skillsHtml + '</div>' +
                            '<div class="flex justify-between items-center">' +
                                '<span class="text-xs text-gray-500">' + (job.applicants || 0) + ' applicants</span>' +
                                '<button onclick="viewInternship(' + job.id + ')" class="bg-green-600 text-white px-5 py-2 rounded-lg font-semibold hover:bg-green-700 transition text-sm">' +
                                    'Apply Now' +
                                '</button>' +
                            '</div>' +
                        '</div>' +
                    '</div>';

                container.appendChild(card);
            });
        }

        function updateResultCount() {
            const el = document.getElementById('resultCount');
            if (totalCount === 0) {
                el.textContent = 'No internships found';
            } else {
                const { keyword, categories, locations, duration, stipend } = getFilterParams();
                const hasFilters = keyword || categories.length > 0 || locations.length > 0 || (duration && duration !== 'Any') || stipend;
                if (hasFilters) {
                    el.textContent = 'Showing ' + totalCount + ' internship' + (totalCount !== 1 ? 's' : '') + ' matching your filters';
                } else {
                    el.textContent = 'Showing ' + totalCount + ' internship opportunit' + (totalCount !== 1 ? 'ies' : 'y');
                }
            }
        }

        function updateLoadMoreVisibility() {
            const container = document.getElementById('loadMoreContainer');
            const btn = document.getElementById('loadMoreBtn');
            const noMore = document.getElementById('noMoreText');

            if (hasMore) {
                container.classList.remove('hidden');
                btn.classList.remove('hidden');
                noMore.classList.add('hidden');
            } else if (totalCount > 0) {
                container.classList.remove('hidden');
                btn.classList.add('hidden');
                noMore.classList.remove('hidden');
            } else {
                container.classList.add('hidden');
            }
        }

        function viewInternship(id) {
            window.location.href = contextPath + '/applyInternship.jsp?id=' + id;
        }

        function toggleBookmark(internshipId) {
            if (!isLoggedIn) {
                window.location.href = contextPath + '/student/login.jsp';
                return;
            }

            fetch(contextPath + '/BookmarkServlet', {
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
                    const btn = document.getElementById('bookmark-' + internshipId);
                    const icon = btn.querySelector('.material-symbols-outlined');
                    if (data.bookmarked) {
                        btn.classList.add('active');
                        icon.textContent = 'bookmark';
                    } else {
                        btn.classList.remove('active');
                        icon.textContent = 'bookmark_border';
                    }
                    showToast('success', data.message);
                } else {
                    showToast('error', data.message);
                }
            })
            .catch(error => {
                console.error('Bookmark error:', error);
                showToast('error', 'Failed to update bookmark.');
            });
        }

        function showToast(type, message) {
            const toast = document.getElementById('toast');
            const content = document.getElementById('toastContent');
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
            setTimeout(function() {
                toast.classList.add('hidden');
            }, 3000);
        }

        function escapeHtml(text) {
            if (!text) return '';
            const div = document.createElement('div');
            div.textContent = text;
            return div.innerHTML;
        }

        function getCompanyColor(company) {
            const colors = ['#22C55E', '#3B82F6', '#A855F7', '#F59E0B', '#EF4444', '#06B6D4', '#EC4899'];
            let hash = 0;
            for (let i = 0; i < company.length; i++) {
                hash = company.charCodeAt(i) + ((hash << 5) - hash);
            }
            return colors[Math.abs(hash) % colors.length];
        }

        function getCompanyIcon(category) {
            const icons = {
                'Software Engineering': 'code',
                'Data Science': 'analytics',
                'Product Management': 'dashboard',
                'UX/UI Design': 'palette'
            };
            return icons[category] || 'work';
        }
    </script>
</body>
</html>

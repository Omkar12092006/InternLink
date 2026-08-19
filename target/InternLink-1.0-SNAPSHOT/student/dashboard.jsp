<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html class="dark" lang="en">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>Dashboard | InternLink</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/dark-theme.css">
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet"/>
    <style>
        body { background-color: #0B0F0E; color: #F3F4F6; font-family: 'Inter', sans-serif; }
        .stat-card { @apply bg-gradient-to-br from-gray-900 to-black border border-gray-800 rounded-xl p-6 hover:border-green-600/50 transition-all; }
        .stat-value { @apply text-4xl font-bold text-green-400; }
        .stat-label { @apply text-gray-400 text-sm uppercase tracking-wide; }
        .sidebar-item { @apply px-6 py-3 hover:bg-gray-800 hover:border-l-4 hover:border-green-500 cursor-pointer transition-all; }
        .sidebar-item.active { @apply bg-green-600/10 border-l-4 border-green-500 text-green-400; }
    </style>
</head>
<body class="min-h-screen flex flex-col">
    <!-- Top Navigation -->
    <nav class="bg-gray-950 border-b border-gray-800 sticky top-0 z-40">
        <div class="max-w-7xl mx-auto px-6 py-4 flex justify-between items-center">
            <div class="flex items-center gap-3">
                <span class="material-symbols-outlined text-2xl text-green-500">trending_up</span>
                <h1 class="text-xl font-bold text-white">InternLink Dashboard</h1>
            </div>
            <div class="flex items-center gap-6">
                <div class="hidden md:flex bg-gray-800 rounded-lg px-3 py-2">
                    <span class="material-symbols-outlined text-gray-500">search</span>
                    <input type="text" placeholder="Search..." class="bg-transparent text-white ml-2 outline-none w-48" />
                </div>
                <div class="flex items-center gap-4">
                    <button class="relative">
                        <span class="material-symbols-outlined text-gray-400 hover:text-green-400 transition">notifications</span>
                        <span class="absolute top-0 right-0 w-2 h-2 bg-red-500 rounded-full"></span>
                    </button>
                    <div class="w-10 h-10 rounded-full bg-green-600 text-white flex items-center justify-center font-bold cursor-pointer hover:bg-green-700">
                        S
                    </div>
                </div>
            </div>
        </div>
    </nav>

    <!-- Main Content -->
    <div class="flex flex-1">
        <!-- Sidebar -->
        <div class="w-64 bg-gray-900 border-r border-gray-800 py-6">
            <ul class="space-y-1">
                <li class="sidebar-item active">
                    <div class="flex items-center gap-3">
                        <span class="material-symbols-outlined">dashboard</span>
                        <span>Dashboard</span>
                    </div>
                </li>
                <li class="sidebar-item">
                    <div class="flex items-center gap-3">
                        <span class="material-symbols-outlined">person</span>
                        <span>My Profile</span>
                    </div>
                </li>
                <li class="sidebar-item">
                    <div class="flex items-center gap-3">
                        <span class="material-symbols-outlined">work</span>
                        <span>Applications</span>
                    </div>
                </li>
                <li class="sidebar-item">
                    <div class="flex items-center gap-3">
                        <span class="material-symbols-outlined">bookmark</span>
                        <span>Saved Jobs</span>
                    </div>
                </li>
                <li class="sidebar-item">
                    <div class="flex items-center gap-3">
                        <span class="material-symbols-outlined">event</span>
                        <span>Interviews</span>
                    </div>
                </li>
                <div class="border-t border-gray-800 my-4"></div>
                <li class="sidebar-item">
                    <div class="flex items-center gap-3">
                        <span class="material-symbols-outlined">settings</span>
                        <span>Settings</span>
                    </div>
                </li>
                <li class="sidebar-item text-red-400 hover:!bg-red-600/10">
                    <div class="flex items-center gap-3">
                        <span class="material-symbols-outlined">logout</span>
                        <span>Logout</span>
                    </div>
                </li>
            </ul>
        </div>

        <!-- Content Area -->
        <div class="flex-1 p-8 overflow-auto">
            <!-- Welcome Section -->
            <div class="mb-8">
                <h2 class="text-4xl font-bold text-white mb-2">Welcome Back! 👋</h2>
                <p class="text-gray-400">Here's your internship application status at a glance</p>
            </div>

            <!-- Stats Grid -->
            <div class="grid md:grid-cols-4 gap-6 mb-8">
                <!-- Applied Card -->
                <div class="stat-card">
                    <div class="flex items-center justify-between mb-4">
                        <div>
                            <p class="stat-label">Applications</p>
                            <p class="stat-value">12</p>
                        </div>
                        <span class="material-symbols-outlined text-5xl text-green-600/30">send</span>
                    </div>
                    <p class="text-green-400 text-sm">+2 this week</p>
                </div>

                <!-- Under Review Card -->
                <div class="stat-card">
                    <div class="flex items-center justify-between mb-4">
                        <div>
                            <p class="stat-label">Under Review</p>
                            <p class="stat-value">4</p>
                        </div>
                        <span class="material-symbols-outlined text-5xl text-blue-600/30">pending_actions</span>
                    </div>
                    <p class="text-blue-400 text-sm">Awaiting response</p>
                </div>

                <!-- Interviews Card -->
                <div class="stat-card">
                    <div class="flex items-center justify-between mb-4">
                        <div>
                            <p class="stat-label">Interviews</p>
                            <p class="stat-value">2</p>
                        </div>
                        <span class="material-symbols-outlined text-5xl text-yellow-600/30">calendar_today</span>
                    </div>
                    <p class="text-yellow-400 text-sm">Scheduled</p>
                </div>

                <!-- Offers Card -->
                <div class="stat-card">
                    <div class="flex items-center justify-between mb-4">
                        <div>
                            <p class="stat-label">Offers</p>
                            <p class="stat-value">1</p>
                        </div>
                        <span class="material-symbols-outlined text-5xl text-purple-600/30">check_circle</span>
                    </div>
                    <p class="text-purple-400 text-sm">Waiting for decision</p>
                </div>
            </div>

            <!-- Recent Applications -->
            <div class="bg-gradient-to-br from-gray-900 to-black border border-gray-800 rounded-xl p-6">
                <h3 class="text-xl font-bold text-white mb-6 flex items-center gap-2">
                    <span class="material-symbols-outlined">history</span>
                    Recent Applications
                </h3>
                <div class="space-y-3">
                    <div class="flex items-center justify-between p-4 bg-gray-800/50 rounded-lg hover:bg-gray-800 transition">
                        <div>
                            <p class="font-semibold text-white">Java Developer Intern</p>
                            <p class="text-sm text-gray-400">TCS • Applied 2 days ago</p>
                        </div>
                        <span class="px-3 py-1 bg-blue-600/20 text-blue-400 rounded-full text-xs font-semibold">Under Review</span>
                    </div>
                    <div class="flex items-center justify-between p-4 bg-gray-800/50 rounded-lg hover:bg-gray-800 transition">
                        <div>
                            <p class="font-semibold text-white">Frontend Developer Intern</p>
                            <p class="text-sm text-gray-400">Infosys • Applied 5 days ago</p>
                        </div>
                        <span class="px-3 py-1 bg-yellow-600/20 text-yellow-400 rounded-full text-xs font-semibold">Interview Scheduled</span>
                    </div>
                    <div class="flex items-center justify-between p-4 bg-gray-800/50 rounded-lg hover:bg-gray-800 transition">
                        <div>
                            <p class="font-semibold text-white">Data Science Intern</p>
                            <p class="text-sm text-gray-400">Microsoft • Applied 1 week ago</p>
                        </div>
                        <span class="px-3 py-1 bg-green-600/20 text-green-400 rounded-full text-xs font-semibold">Offer Received</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
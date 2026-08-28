<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html class="dark" lang="en">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>Browse Internships | InternLink</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/dark-theme.css">
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet"/>
    <style>
        body { background-color: #0B0F0E; color: #F3F4F6; font-family: 'Inter', sans-serif; }
        .job-card { @apply bg-gradient-to-br from-gray-900 to-black border border-gray-800 rounded-xl p-6 hover:border-green-600/50 hover:shadow-lg hover:shadow-green-500/20 transition-all duration-300; }
        .tag { @apply px-3 py-1 bg-gray-800 text-gray-300 rounded-full text-xs font-semibold; }
        .badge-primary { @apply px-2 py-1 bg-green-600/20 text-green-400 rounded text-xs font-semibold; }
        .filter-section { @apply bg-gray-900 rounded-lg p-4 border border-gray-800; }
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
                <a href="index.jsp" class="text-gray-300 hover:text-green-400 transition">Home</a>
                <a href="student/login.jsp" class="text-gray-300 hover:text-green-400 transition">Login</a>
                <a href="student/register.jsp" class="bg-green-600 text-white px-4 py-2 rounded-lg hover:bg-green-700 transition">Sign Up</a>
            </div>
        </div>
    </nav>

    <!-- Main Content -->
    <div class="flex-1 flex">
        <!-- Sidebar Filters -->
        <div class="w-72 bg-gray-900 border-r border-gray-800 p-6 overflow-y-auto">
            <div class="mb-8">
                <h2 class="text-xl font-bold text-white mb-4 flex items-center gap-2">
                    <span class="material-symbols-outlined">filter_alt</span>
                    Filters
                </h2>
                <button class="text-xs text-green-400 hover:text-green-300 transition">Clear All</button>
            </div>

            <!-- Search -->
            <div class="mb-6">
                <input type="text" placeholder="Search internships..." class="w-full px-3 py-2 bg-gray-800 border border-gray-700 rounded-lg text-white placeholder-gray-500 focus:border-green-500 outline-none" />
            </div>

            <!-- Category Filter -->
            <div class="filter-section mb-6">
                <h3 class="font-semibold text-white mb-3">Category</h3>
                <div class="space-y-2">
                    <label class="flex items-center gap-2 text-gray-300 cursor-pointer hover:text-white">
                        <input type="checkbox" class="w-4 h-4 accent-green-600" />
                        <span>Software Engineering</span>
                    </label>
                    <label class="flex items-center gap-2 text-gray-300 cursor-pointer hover:text-white">
                        <input type="checkbox" class="w-4 h-4 accent-green-600" />
                        <span>Data Science</span>
                    </label>
                    <label class="flex items-center gap-2 text-gray-300 cursor-pointer hover:text-white">
                        <input type="checkbox" class="w-4 h-4 accent-green-600" />
                        <span>Product Management</span>
                    </label>
                    <label class="flex items-center gap-2 text-gray-300 cursor-pointer hover:text-white">
                        <input type="checkbox" class="w-4 h-4 accent-green-600" />
                        <span>UX/UI Design</span>
                    </label>
                </div>
            </div>

            <!-- Location Filter -->
            <div class="filter-section mb-6">
                <h3 class="font-semibold text-white mb-3">Location</h3>
                <div class="space-y-2">
                    <label class="flex items-center gap-2 text-gray-300 cursor-pointer hover:text-white">
                        <input type="checkbox" class="w-4 h-4 accent-green-600" />
                        <span>Remote</span>
                    </label>
                    <label class="flex items-center gap-2 text-gray-300 cursor-pointer hover:text-white">
                        <input type="checkbox" class="w-4 h-4 accent-green-600" />
                        <span>New York</span>
                    </label>
                    <label class="flex items-center gap-2 text-gray-300 cursor-pointer hover:text-white">
                        <input type="checkbox" class="w-4 h-4 accent-green-600" />
                        <span>San Francisco</span>
                    </label>
                    <label class="flex items-center gap-2 text-gray-300 cursor-pointer hover:text-white">
                        <input type="checkbox" class="w-4 h-4 accent-green-600" />
                        <span>India</span>
                    </label>
                </div>
            </div>

            <!-- Duration Filter -->
            <div class="filter-section mb-6">
                <h3 class="font-semibold text-white mb-3">Duration</h3>
                <div class="space-y-2">
                    <label class="flex items-center gap-2 text-gray-300 cursor-pointer hover:text-white">
                        <input type="radio" name="duration" class="w-4 h-4 accent-green-600" />
                        <span>Any</span>
                    </label>
                    <label class="flex items-center gap-2 text-gray-300 cursor-pointer hover:text-white">
                        <input type="radio" name="duration" class="w-4 h-4 accent-green-600" />
                        <span>Summer (3 months)</span>
                    </label>
                    <label class="flex items-center gap-2 text-gray-300 cursor-pointer hover:text-white">
                        <input type="radio" name="duration" class="w-4 h-4 accent-green-600" />
                        <span>Co-op (6 months)</span>
                    </label>
                </div>
            </div>

            <!-- Stipend Filter -->
            <div class="filter-section">
                <h3 class="font-semibold text-white mb-3">Stipend</h3>
                <div class="space-y-2">
                    <label class="flex items-center gap-2 text-gray-300 cursor-pointer hover:text-white">
                        <input type="checkbox" class="w-4 h-4 accent-green-600" />
                        <span>Paid</span>
                    </label>
                    <label class="flex items-center gap-2 text-gray-300 cursor-pointer hover:text-white">
                        <input type="checkbox" class="w-4 h-4 accent-green-600" />
                        <span>Unpaid</span>
                    </label>
                </div>
            </div>
        </div>

        <!-- Job Listings -->
        <div class="flex-1 p-8 overflow-y-auto">
            <!-- Header -->
            <div class="mb-8">
                <div class="flex justify-between items-center mb-4">
                    <h1 class="text-4xl font-bold text-white">Open Internships</h1>
                    <div class="flex gap-3">
                        <select class="bg-gray-800 border border-gray-700 rounded-lg px-4 py-2 text-white focus:border-green-500 outline-none">
                            <option>Most Recent</option>
                            <option>Most Relevant</option>
                            <option>Highest Stipend</option>
                        </select>
                    </div>
                </div>
                <p class="text-gray-400">Showing 124 internship opportunities</p>
            </div>

            <!-- Job Cards Grid -->
            <div class="grid grid-cols-1 gap-6">
                <!-- Job Card 1 -->
                <div class="job-card">
                    <div class="flex gap-4 mb-4">
                        <div class="w-16 h-16 bg-green-600 rounded-lg flex items-center justify-center text-2xl flex-shrink-0">
                            🚀
                        </div>
                        <div class="flex-1">
                            <div class="flex justify-between items-start mb-2">
                                <div>
                                    <h3 class="text-xl font-bold text-white hover:text-green-400 cursor-pointer transition">Frontend Developer Intern</h3>
                                    <p class="text-gray-400">TechNova Solutions</p>
                                </div>
                                <button class="text-gray-400 hover:text-green-400 transition">
                                    <span class="material-symbols-outlined">bookmark_border</span>
                                </button>
                            </div>
                            <div class="flex flex-wrap gap-2 mb-3">
                                <span class="badge-primary">💰 Paid</span>
                                <span class="tag">Remote</span>
                                <span class="tag">Summer 2024</span>
                            </div>
                            <p class="text-gray-300 mb-3">Join our core engineering team to build scalable frontend applications using React and TypeScript. You'll work closely with product managers and designers on cutting-edge web technologies.</p>
                            <div class="flex flex-wrap gap-2 mb-4">
                                <span class="text-xs bg-gray-800 text-gray-300 px-2 py-1 rounded">React</span>
                                <span class="text-xs bg-gray-800 text-gray-300 px-2 py-1 rounded">TypeScript</span>
                                <span class="text-xs bg-gray-800 text-gray-300 px-2 py-1 rounded">Tailwind CSS</span>
                            </div>
                            <div class="flex justify-between items-center">
                                <span class="text-xs text-gray-500">Posted 2 days ago • 45 applicants</span>
                                <button class="bg-green-600 text-white px-6 py-2 rounded-lg font-semibold hover:bg-green-700 transition">
                                    Apply Now
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Job Card 2 -->
                <div class="job-card">
                    <div class="flex gap-4 mb-4">
                        <div class="w-16 h-16 bg-blue-600 rounded-lg flex items-center justify-center text-2xl flex-shrink-0">
                            📊
                        </div>
                        <div class="flex-1">
                            <div class="flex justify-between items-start mb-2">
                                <div>
                                    <h3 class="text-xl font-bold text-white hover:text-green-400 cursor-pointer transition">Data Analyst Intern</h3>
                                    <p class="text-gray-400">Global Market Insights</p>
                                </div>
                                <button class="text-gray-400 hover:text-green-400 transition">
                                    <span class="material-symbols-outlined">bookmark_border</span>
                                </button>
                            </div>
                            <div class="flex flex-wrap gap-2 mb-3">
                                <span class="badge-primary">💰 Paid</span>
                                <span class="tag">New York, NY</span>
                                <span class="tag">6 Months</span>
                            </div>
                            <p class="text-gray-300 mb-3">Analyze financial market data and create insights using Python and SQL. Work with experienced analysts to understand market trends and build predictive models for investment decisions.</p>
                            <div class="flex flex-wrap gap-2 mb-4">
                                <span class="text-xs bg-gray-800 text-gray-300 px-2 py-1 rounded">Python</span>
                                <span class="text-xs bg-gray-800 text-gray-300 px-2 py-1 rounded">SQL</span>
                                <span class="text-xs bg-gray-800 text-gray-300 px-2 py-1 rounded">Tableau</span>
                            </div>
                            <div class="flex justify-between items-center">
                                <span class="text-xs text-gray-500">Posted 5 days ago • 128 applicants</span>
                                <button class="bg-green-600 text-white px-6 py-2 rounded-lg font-semibold hover:bg-green-700 transition">
                                    Apply Now
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Job Card 3 -->
                <div class="job-card">
                    <div class="flex gap-4 mb-4">
                        <div class="w-16 h-16 bg-purple-600 rounded-lg flex items-center justify-center text-2xl flex-shrink-0">
                            🎨
                        </div>
                        <div class="flex-1">
                            <div class="flex justify-between items-start mb-2">
                                <div>
                                    <h3 class="text-xl font-bold text-white hover:text-green-400 cursor-pointer transition">UX/UI Designer Intern</h3>
                                    <p class="text-gray-400">Creative Studio Inc</p>
                                </div>
                                <button class="text-gray-400 hover:text-green-400 transition">
                                    <span class="material-symbols-outlined">bookmark_border</span>
                                </button>
                            </div>
                            <div class="flex flex-wrap gap-2 mb-3">
                                <span class="badge-primary">💰 Paid</span>
                                <span class="tag">Remote</span>
                                <span class="tag">3-4 Months</span>
                            </div>
                            <p class="text-gray-300 mb-3">Design beautiful and intuitive user interfaces for our mobile and web applications. Collaborate with product teams and developers to bring your designs to life with modern design tools and frameworks.</p>
                            <div class="flex flex-wrap gap-2 mb-4">
                                <span class="text-xs bg-gray-800 text-gray-300 px-2 py-1 rounded">Figma</span>
                                <span class="text-xs bg-gray-800 text-gray-300 px-2 py-1 rounded">Adobe XD</span>
                                <span class="text-xs bg-gray-800 text-gray-300 px-2 py-1 rounded">Prototyping</span>
                            </div>
                            <div class="flex justify-between items-center">
                                <span class="text-xs text-gray-500">Posted 1 week ago • 67 applicants</span>
                                <button class="bg-green-600 text-white px-6 py-2 rounded-lg font-semibold hover:bg-green-700 transition">
                                    Apply Now
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Job Card 4 -->
                <div class="job-card">
                    <div class="flex gap-4 mb-4">
                        <div class="w-16 h-16 bg-yellow-600 rounded-lg flex items-center justify-center text-2xl flex-shrink-0">
                            ⚙️
                        </div>
                        <div class="flex-1">
                            <div class="flex justify-between items-start mb-2">
                                <div>
                                    <h3 class="text-xl font-bold text-white hover:text-green-400 cursor-pointer transition">Backend Developer Intern</h3>
                                    <p class="text-gray-400">CloudScale Technologies</p>
                                </div>
                                <button class="text-gray-400 hover:text-green-400 transition">
                                    <span class="material-symbols-outlined">bookmark_border</span>
                                </button>
                            </div>
                            <div class="flex flex-wrap gap-2 mb-3">
                                <span class="badge-primary">💰 Paid</span>
                                <span class="tag">India</span>
                                <span class="tag">Summer 2024</span>
                            </div>
                            <p class="text-gray-300 mb-3">Build robust backend systems and APIs using Java/Python. Work with microservices architecture and cloud platforms. Great opportunity to learn about scalable system design from experienced engineers.</p>
                            <div class="flex flex-wrap gap-2 mb-4">
                                <span class="text-xs bg-gray-800 text-gray-300 px-2 py-1 rounded">Java</span>
                                <span class="text-xs bg-gray-800 text-gray-300 px-2 py-1 rounded">Docker</span>
                                <span class="text-xs bg-gray-800 text-gray-300 px-2 py-1 rounded">AWS</span>
                            </div>
                            <div class="flex justify-between items-center">
                                <span class="text-xs text-gray-500">Posted 3 days ago • 89 applicants</span>
                                <button class="bg-green-600 text-white px-6 py-2 rounded-lg font-semibold hover:bg-green-700 transition">
                                    Apply Now
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Load More -->
            <div class="mt-8 text-center">
                <button class="border-2 border-green-600 text-green-400 px-8 py-3 rounded-lg font-semibold hover:bg-green-600/10 transition">
                    Load More Internships
                </button>
            </div>
        </div>
    </div>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html class="scroll-smooth dark" lang="en">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>InternLink - Online Internship & Placement Portal</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/dark-theme.css">
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet"/>
    <style>
        body { background-color: #0B0F0E; color: #F3F4F6; font-family: 'Inter', sans-serif; }
        .hero-gradient { background: linear-gradient(135deg, #22C55E 0%, #16A34A 100%); }
        .btn-primary { 
            @apply bg-green-600 text-white px-6 py-3 rounded-lg font-semibold 
            hover:bg-green-700 transition-all duration-200 hover:shadow-lg hover:shadow-green-500/50;
        }
        .btn-secondary {
            @apply border-2 border-green-600 text-green-400 px-6 py-3 rounded-lg font-semibold 
            hover:bg-green-600/10 transition-all duration-200;
        }
        .card-feature {
            @apply bg-gradient-to-br from-gray-900 to-black border border-gray-800 rounded-2xl p-8
            hover:border-green-600/50 transition-all duration-300 hover:shadow-lg hover:shadow-green-500/20;
        }
        .fade-in { animation: fadeIn 0.8s ease-in; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }
    </style>
</head>
<body class="min-h-screen flex flex-col">
    <!-- Navigation Bar -->
    <nav class="sticky top-0 z-50 bg-gray-950 border-b border-gray-800">
        <div class="max-w-7xl mx-auto px-4 md:px-8 py-4 flex justify-between items-center">
            <!-- Logo -->
            <div class="flex items-center gap-3">
                <span class="material-symbols-outlined text-2xl text-green-500">trending_up</span>
                <a href="<%= request.getContextPath() %>/index.jsp" class="text-2xl font-bold text-white">InternLink</a>
            </div>

            <!-- Nav Links -->
            <div class="hidden md:flex items-center gap-8">
                <a href="#features" class="text-gray-300 hover:text-green-400 transition">Features</a>
                <a href="browseInternships.jsp" class="text-gray-300 hover:text-green-400 transition">Internships</a>
                <a href="company/login.jsp" class="text-gray-300 hover:text-green-400 transition">Company</a>
            </div>

            <!-- CTA Buttons -->
            <div class="flex gap-3">
                <a href="student/login.jsp" class="text-gray-300 hover:text-green-400 px-4 py-2 rounded transition">
                    Student Login
                </a>
                <a href="student/register.jsp" class="btn-primary text-sm">
                    Get Started
                </a>
            </div>
        </div>
    </nav>

    <!-- Hero Section -->
    <section class="flex-grow hero-gradient flex items-center justify-center text-center py-20 md:py-32">
        <div class="max-w-4xl mx-auto px-4 fade-in">
            <h1 class="text-4xl md:text-6xl font-bold text-white mb-6">
                Launch Your Career with <span class="text-lime-300">InternLink</span>
            </h1>
            <p class="text-lg md:text-xl text-gray-100 mb-8 max-w-2xl mx-auto">
                Connect with top companies, explore internship opportunities, and land your dream position. All in one platform.
            </p>
            <div class="flex flex-col md:flex-row gap-4 justify-center">
                <a href="browseInternships.jsp" class="btn-primary">
                    Browse Internships
                </a>
                <a href="student/register.jsp" class="btn-secondary">
                    Create Account
                </a>
            </div>
        </div>
    </section>

    <!-- Features Section -->
    <section id="features" class="py-20 md:py-32 px-4 max-w-7xl mx-auto">
        <div class="text-center mb-16">
            <h2 class="text-4xl font-bold text-white mb-4">Why Choose InternLink?</h2>
            <p class="text-gray-400 text-lg">Everything you need for your internship journey</p>
        </div>

        <div class="grid md:grid-cols-3 gap-8">
            <!-- Feature 1 -->
            <div class="card-feature">
                <span class="material-symbols-outlined text-5xl text-green-500 mb-4">search</span>
                <h3 class="text-2xl font-bold text-white mb-3">Easy Search</h3>
                <p class="text-gray-400">Find internships by company, location, role, and more with advanced filtering.</p>
            </div>

            <!-- Feature 2 -->
            <div class="card-feature">
                <span class="material-symbols-outlined text-5xl text-green-500 mb-4">check_circle</span>
                <h3 class="text-2xl font-bold text-white mb-3">One-Click Apply</h3>
                <p class="text-gray-400">Apply to multiple positions instantly with your pre-filled profile.</p>
            </div>

            <!-- Feature 3 -->
            <div class="card-feature">
                <span class="material-symbols-outlined text-5xl text-green-500 mb-4">bar_chart</span>
                <h3 class="text-2xl font-bold text-white mb-3">Track Progress</h3>
                <p class="text-gray-400">Monitor your applications, interviews, and offers in real-time.</p>
            </div>

            <!-- Feature 4 -->
            <div class="card-feature">
                <span class="material-symbols-outlined text-5xl text-green-500 mb-4">school</span>
                <h3 class="text-2xl font-bold text-white mb-3">Campus Connect</h3>
                <p class="text-gray-400">Access university-verified resources and placement statistics.</p>
            </div>

            <!-- Feature 5 -->
            <div class="card-feature">
                <span class="material-symbols-outlined text-5xl text-green-500 mb-4">business</span>
                <h3 class="text-2xl font-bold text-white mb-3">Top Companies</h3>
                <p class="text-gray-400">Network with leading tech and Fortune 500 companies.</p>
            </div>

            <!-- Feature 6 -->
            <div class="card-feature">
                <span class="material-symbols-outlined text-5xl text-green-500 mb-4">security</span>
                <h3 class="text-2xl font-bold text-white mb-3">Secure Profile</h3>
                <p class="text-gray-400">Your data is encrypted and protected with industry standards.</p>
            </div>
        </div>
    </section>

    <!-- Quick Stats -->
    <section class="bg-gradient-to-r from-green-900/20 to-emerald-900/20 py-16 px-4">
        <div class="max-w-7xl mx-auto grid md:grid-cols-4 gap-8 text-center">
            <div>
                <div class="text-4xl font-bold text-green-400">500+</div>
                <p class="text-gray-400 mt-2">Active Internships</p>
            </div>
            <div>
                <div class="text-4xl font-bold text-green-400">50K+</div>
                <p class="text-gray-400 mt-2">Students Registered</p>
            </div>
            <div>
                <div class="text-4xl font-bold text-green-400">1000+</div>
                <p class="text-gray-400 mt-2">Companies Partnered</p>
            </div>
            <div>
                <div class="text-4xl font-bold text-green-400">95%</div>
                <p class="text-gray-400 mt-2">Placement Rate</p>
            </div>
        </div>
    </section>

    <!-- CTA Section -->
    <section class="py-20 px-4 text-center bg-gray-950">
        <h2 class="text-4xl font-bold text-white mb-4">Ready to Get Started?</h2>
        <p class="text-gray-400 text-lg mb-8">Join thousands of students finding their perfect internship</p>
        <div class="flex flex-col md:flex-row gap-4 justify-center">
            <a href="student/register.jsp" class="btn-primary">Register as Student</a>
            <a href="company/register.jsp" class="btn-secondary">Register as Company</a>
        </div>
    </section>

    <!-- Footer -->
    <footer class="bg-gray-950 border-t border-gray-800 text-gray-400 py-12 px-4">
        <div class="max-w-7xl mx-auto grid md:grid-cols-4 gap-8 mb-8">
            <div>
                <h4 class="text-white font-bold mb-4">InternLink</h4>
                <p class="text-sm">Your gateway to career success</p>
            </div>
            <div>
                <h4 class="text-white font-bold mb-4">For Students</h4>
                <ul class="space-y-2 text-sm"><li><a href="#" class="hover:text-green-400">Browse Jobs</a></li><li><a href="#" class="hover:text-green-400">My Profile</a></li></ul>
            </div>
            <div>
                <h4 class="text-white font-bold mb-4">For Companies</h4>
                <ul class="space-y-2 text-sm"><li><a href="#" class="hover:text-green-400">Post Job</a></li><li><a href="#" class="hover:text-green-400">Hiring</a></li></ul>
            </div>
            <div>
                <h4 class="text-white font-bold mb-4">Legal</h4>
                <ul class="space-y-2 text-sm"><li><a href="#" class="hover:text-green-400">Privacy</a></li><li><a href="#" class="hover:text-green-400">Terms</a></li></ul>
            </div>
        </div>
        <div class="border-t border-gray-800 pt-8 text-center text-sm">
            <p>&copy; 2026 InternLink. All rights reserved.</p>
        </div>
    </footer>

    <script>
        // Smooth scroll for anchor links
        document.querySelectorAll('a[href^="#"]').forEach(link => {
            link.addEventListener('click', (e) => {
                e.preventDefault();
                const target = document.querySelector(link.getAttribute('href'));
                if (target) target.scrollIntoView({ behavior: 'smooth' });
            });
        });
    </script>
</body>
</html>
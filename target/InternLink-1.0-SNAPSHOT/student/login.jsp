<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html class="dark" lang="en">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>Student Login | InternLink</title>
        <link rel="stylesheet" href="<%= request.getContextPath() %>/css/dark-theme.css">
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet"/>
    <style>
        body { background: linear-gradient(135deg, #0B0F0E 0%, #1a1a1a 100%); color: #F3F4F6; font-family: 'Inter', sans-serif; }
        .login-card { 
            @apply bg-gradient-to-br from-gray-900 to-black border border-gray-800 rounded-2xl;
        }
        .input-field {
            @apply w-full px-4 py-3 bg-gray-800 border border-gray-700 rounded-lg 
            text-white placeholder-gray-500 focus:outline-none focus:border-green-500 
            focus:ring-2 focus:ring-green-500/20 transition-all duration-200;
        }
        .btn-login {
            @apply w-full bg-green-600 text-white py-3 rounded-lg font-semibold 
            hover:bg-green-700 transition-all duration-200 hover:shadow-lg hover:shadow-green-500/50;
        }
        .divider { @apply flex items-center gap-4 my-6; }
        .divider::before, .divider::after { @apply flex-1 h-px bg-gray-700 content-['']; }
    </style>
</head>
<body class="min-h-screen flex flex-col">
    <!-- Header -->
    <header class="border-b border-gray-800 py-4 px-4">
        <div class="max-w-md mx-auto">
            <a href="../index.jsp" class="flex items-center gap-2 text-gray-300 hover:text-green-400 transition">
                <span class="material-symbols-outlined">arrow_back</span>
                Back to Home
            </a>
        </div>
    </header>

    <!-- Main Content -->
    <main class="flex-grow flex items-center justify-center px-4 py-12">
        <div class="w-full max-w-md">
            <!-- Card -->
            <div class="login-card p-8 md:p-10">
                <!-- Header -->
                <div class="text-center mb-8">
                    <div class="flex items-center justify-center gap-2 mb-4">
                        <span class="material-symbols-outlined text-3xl text-green-500">trending_up</span>
                        <h1 class="text-3xl font-bold text-white">InternLink</h1>
                    </div>
                    <h2 class="text-2xl font-bold text-white mb-2">Student Login</h2>
                    <p class="text-gray-400">Sign in to your account to access internship opportunities</p>
                </div>

                <!-- Form -->
                <form action="<%= request.getContextPath() %>/StudentLoginServlet" method="post" class="flex flex-col gap-4">
                    <!-- Email/ID Field -->
                    <div>
                        <label class="block text-sm font-semibold text-gray-300 mb-2">Email or Student ID</label>
                        <input 
                            type="email" 
                            name="email" 
                            id="email" 
                            placeholder="student@example.com"
                            class="input-field"
                            required
                        />
                    </div>

                    <!-- Password Field -->
                    <div>
                        <div class="flex justify-between items-center mb-2">
                            <label class="block text-sm font-semibold text-gray-300">Password</label>
                            <a href="#forgot" class="text-xs text-green-400 hover:text-green-300 transition">Forgot?</a>
                        </div>
                        <div class="relative">
                            <input 
                                type="password" 
                                name="password" 
                                id="password" 
                                placeholder="Enter your password"
                                class="input-field"
                                required
                            />
                            <button type="button" class="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 hover:text-gray-300 transition" onclick="togglePassword()">
                                <span class="material-symbols-outlined text-xl" id="toggleIcon">visibility</span>
                            </button>
                        </div>
                    </div>

                    <!-- Remember Me -->
                    <label class="flex items-center gap-2 cursor-pointer">
                        <input type="checkbox" name="remember" class="w-4 h-4 bg-gray-800 border border-gray-700 rounded cursor-pointer accent-green-600" />
                        <span class="text-sm text-gray-300">Remember me</span>
                    </label>

                    <!-- Submit Button -->
                    <button type="submit" class="btn-login mt-2">
                        Sign In
                    </button>
                </form>

                <!-- Divider -->
                <div class="divider"></div>

                <!-- Sign Up Link -->
                <p class="text-center text-gray-400">
                    Don't have an account? 
                    <a href="register.jsp" class="text-green-400 font-semibold hover:text-green-300 transition">
                        Create one
                    </a>
                </p>
            </div>

            <!-- Info Box -->
            <div class="mt-6 bg-gray-800/50 border border-gray-700 rounded-xl p-4">
                <p class="text-xs text-gray-400 text-center">
                    <span class="material-symbols-outlined text-sm align-middle">lock</span>
                    Your login information is encrypted and secure
                </p>
            </div>
        </div>
    </main>

    <script>
        function togglePassword() {
            const input = document.getElementById('password');
            const icon = document.getElementById('toggleIcon');
            if (input.type === 'password') {
                input.type = 'text';
                icon.textContent = 'visibility_off';
            } else {
                input.type = 'password';
                icon.textContent = 'visibility';
            }
        }
    </script>
</body>
</html>
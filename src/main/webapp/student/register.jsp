<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html class="dark" lang="en">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>Student Registration | InternLink</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/dark-theme.css">
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet"/>
    <style>
        body { background-color: #0B0F0E; color: #F3F4F6; font-family: 'Inter', sans-serif; }
        .register-card { @apply bg-gradient-to-br from-gray-900 to-black border border-gray-800 rounded-2xl p-8 w-full max-w-lg shadow-2xl; }
        .form-input { @apply w-full px-4 py-2.5 bg-gray-800 border border-gray-700 rounded-lg text-white placeholder-gray-500 focus:border-green-500 focus:ring-2 focus:ring-green-500/20 outline-none transition; }
        .form-label { @apply block text-sm font-semibold text-gray-300 mb-2; }
        .password-strength { @apply h-1 bg-gray-700 rounded-full overflow-hidden mt-2; }
        .password-strength-bar { @apply h-full transition-all duration-300; }
        .input-group { @apply relative; }
        .input-icon { @apply absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-500; }
        .error-text { @apply text-red-400 text-xs mt-1 hidden; }
        .btn-primary { @apply w-full bg-green-600 text-white font-semibold py-3 px-4 rounded-lg hover:bg-green-700 active:bg-green-800 transition-all disabled:opacity-50 disabled:cursor-not-allowed; }
        .divider { @apply flex items-center gap-4 my-6; }
        .divider::before, .divider::after { @apply content-[''] flex-1 border-t border-gray-700; }
    </style>
    <script>
        function validateForm() {
            const fullName = document.getElementById('fullName').value.trim();
            const universityId = document.getElementById('universityId').value.trim();
            const email = document.getElementById('email').value.trim();
            const phone = document.getElementById('phone').value.trim();
            const password = document.getElementById('password').value;
            const confirmPassword = document.getElementById('confirmPassword').value;

            let isValid = true;

            if (fullName.length < 3) {
                showError('fullNameError', 'Name must be at least 3 characters');
                isValid = false;
            } else {
                hideError('fullNameError');
            }

            const universityIdRegex = /^[A-Z0-9]{4,}$/i;
            if (!universityIdRegex.test(universityId)) {
                showError('universityIdError', 'Invalid University ID');
                isValid = false;
            } else {
                hideError('universityIdError');
            }

            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailRegex.test(email)) {
                showError('emailError', 'Please enter a valid email');
                isValid = false;
            } else {
                hideError('emailError');
            }

            const phoneRegex = /^[0-9]{10}$/;
            if (!phoneRegex.test(phone.replace(/[^\d]/g, ''))) {
                showError('phoneError', 'Please enter a valid 10-digit phone number');
                isValid = false;
            } else {
                hideError('phoneError');
            }

            if (password.length < 8) {
                showError('passwordError', 'Password must be at least 8 characters');
                isValid = false;
            } else if (!/[A-Z]/.test(password) || !/[0-9]/.test(password)) {
                showError('passwordError', 'Password must contain uppercase letter and number');
                isValid = false;
            } else {
                hideError('passwordError');
            }

            if (password !== confirmPassword) {
                showError('confirmPasswordError', 'Passwords do not match');
                isValid = false;
            } else {
                hideError('confirmPasswordError');
            }

            return isValid;
        }

        function showError(elementId, message) {
            const element = document.getElementById(elementId);
            if (element) {
                element.textContent = message;
                element.classList.remove('hidden');
            }
        }

        function hideError(elementId) {
            const element = document.getElementById(elementId);
            if (element) {
                element.classList.add('hidden');
            }
        }

        function updatePasswordStrength() {
            const password = document.getElementById('password').value;
            const strengthBar = document.getElementById('strengthBar');
            let strength = 0;

            if (password.length >= 8) strength += 25;
            if (/[A-Z]/.test(password)) strength += 25;
            if (/[0-9]/.test(password)) strength += 25;
            if (/[!@#$%^&*]/.test(password)) strength += 25;

            strengthBar.style.width = strength + '%';

            if (strength < 50) {
                strengthBar.className = 'password-strength-bar bg-red-500';
            } else if (strength < 75) {
                strengthBar.className = 'password-strength-bar bg-yellow-500';
            } else {
                strengthBar.className = 'password-strength-bar bg-green-500';
            }
        }

        function togglePasswordVisibility(inputId, iconId) {
            const input = document.getElementById(inputId);
            const icon = document.getElementById(iconId);
            if (input.type === 'password') {
                input.type = 'text';
                icon.textContent = 'visibility_off';
            } else {
                input.type = 'password';
                icon.textContent = 'visibility';
            }
        }

        function handleSubmit(e) {
            e.preventDefault();
            if (validateForm()) {
                document.getElementById('registerForm').submit();
            }
        }
    </script>
</head>
<body class="min-h-screen flex flex-col bg-gradient-to-b from-gray-950 to-black">
    <!-- Navigation -->
    <nav class="bg-gray-950 border-b border-gray-800 sticky top-0 z-40">
        <div class="max-w-7xl mx-auto px-6 py-4 flex justify-between items-center">
            <a href="../index.jsp" class="flex items-center gap-3 hover:text-green-400 transition">
                <span class="material-symbols-outlined text-2xl text-green-500">trending_up</span>
                <h1 class="text-xl font-bold text-white">InternLink</h1>
            </a>
            <div class="flex items-center gap-4">
                <a href="login.jsp" class="text-gray-300 hover:text-green-400 transition">Already have an account?</a>
                <a href="login.jsp" class="border-2 border-green-600 text-green-400 px-4 py-2 rounded-lg hover:bg-green-600/10 transition">Sign In</a>
            </div>
        </div>
    </nav>

    <!-- Main Content -->
    <div class="flex-1 flex items-center justify-center py-12 px-4">
        <div class="register-card fade-in">
            <!-- Header -->
            <div class="text-center mb-8">
                <div class="flex justify-center mb-4">
                    <div class="w-16 h-16 bg-gradient-to-br from-green-600 to-green-500 rounded-2xl flex items-center justify-center text-3xl">
                        🎓
                    </div>
                </div>
                <h2 class="text-3xl font-bold text-white mb-2">Create Account</h2>
                <p class="text-gray-400">Start your internship journey with InternLink</p>
            </div>

            <!-- Registration Form -->
            <form id="registerForm" method="POST" action="<%= request.getContextPath() %>/StudentRegisterServlet" onsubmit="handleSubmit(event)" class="space-y-5">
                
                <!-- Full Name -->
                <div>
                    <label class="form-label" for="fullName">Full Name</label>
                    <div class="input-group">
                        <input type="text" id="fullName" name="fullName" class="form-input" placeholder="John Doe" required>
                        <span class="material-symbols-outlined input-icon">person</span>
                    </div>
                    <div class="error-text" id="fullNameError"></div>
                </div>

                <!-- University ID -->
                <div>
                    <label class="form-label" for="universityId">University ID / Roll Number</label>
                    <div class="input-group">
                        <input type="text" id="universityId" name="universityId" class="form-input" placeholder="21BIT001" required>
                        <span class="material-symbols-outlined input-icon">school</span>
                    </div>
                    <div class="error-text" id="universityIdError"></div>
                </div>

                <!-- Email -->
                <div>
                    <label class="form-label" for="email">Email Address</label>
                    <div class="input-group">
                        <input type="email" id="email" name="email" class="form-input" placeholder="john@university.edu" required>
                        <span class="material-symbols-outlined input-icon">mail</span>
                    </div>
                    <div class="error-text" id="emailError"></div>
                </div>

                <!-- Phone -->
                <div>
                    <label class="form-label" for="phone">Phone Number</label>
                    <div class="input-group">
                        <input type="tel" id="phone" name="phone" class="form-input" placeholder="9876543210" required>
                        <span class="material-symbols-outlined input-icon">phone</span>
                    </div>
                    <div class="error-text" id="phoneError"></div>
                </div>

                <!-- Password -->
                <div>
                    <label class="form-label" for="password">Password</label>
                    <div class="input-group">
                        <input type="password" id="password" name="password" class="form-input" placeholder="••••••••" oninput="updatePasswordStrength()" required>
                        <button type="button" onclick="togglePasswordVisibility('password', 'passwordToggle')" class="input-icon hover:text-green-400 transition" style="pointer-events: auto;">
                            <span class="material-symbols-outlined" id="passwordToggle">visibility</span>
                        </button>
                    </div>
                    <div class="password-strength">
                        <div class="password-strength-bar bg-red-500" id="strengthBar" style="width: 0%"></div>
                    </div>
                    <p class="text-xs text-gray-500 mt-2">Min 8 characters, uppercase, number & special character</p>
                    <div class="error-text" id="passwordError"></div>
                </div>

                <!-- Confirm Password -->
                <div>
                    <label class="form-label" for="confirmPassword">Confirm Password</label>
                    <div class="input-group">
                        <input type="password" id="confirmPassword" name="confirmPassword" class="form-input" placeholder="••••••••" required>
                        <button type="button" onclick="togglePasswordVisibility('confirmPassword', 'confirmPasswordToggle')" class="input-icon hover:text-green-400 transition" style="pointer-events: auto;">
                            <span class="material-symbols-outlined" id="confirmPasswordToggle">visibility</span>
                        </button>
                    </div>
                    <div class="error-text" id="confirmPasswordError"></div>
                </div>

                <!-- Terms & Conditions -->
                <label class="flex items-start gap-3 text-gray-300 cursor-pointer hover:text-white transition">
                    <input type="checkbox" name="terms" class="w-4 h-4 mt-1 accent-green-600" required>
                    <span class="text-sm">I agree to the <a href="#" class="text-green-400 hover:text-green-300">Terms of Service</a> and <a href="#" class="text-green-400 hover:text-green-300">Privacy Policy</a></span>
                </label>

                <!-- Sign Up Button -->
                <button type="submit" class="btn-primary mt-6">
                    <span class="flex items-center justify-center gap-2">
                        <span class="material-symbols-outlined">person_add</span>
                        Create Account
                    </span>
                </button>
            </form>

            <!-- Divider -->
            <div class="divider">or</div>

            <!-- Sign In Link -->
            <div class="text-center">
                <p class="text-gray-300">
                    Already have an account?
                    <a href="login.jsp" class="text-green-400 font-semibold hover:text-green-300 transition">
                        Sign In
                    </a>
                </p>
            </div>

            <!-- Security Info -->
            <div class="mt-8 p-4 bg-green-600/10 border border-green-600/20 rounded-lg">
                <div class="flex gap-3">
                    <span class="material-symbols-outlined text-green-400 flex-shrink-0 mt-0.5">verified_user</span>
                    <div class="text-sm text-gray-300">
                        <p class="font-semibold text-green-400 mb-1">🔒 Your information is secure</p>
                        <p>All personal data is encrypted and stored securely. We never share your information with third parties.</p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Footer Note -->
    <div class="text-center py-6 text-gray-500 text-sm border-t border-gray-800">
        <p>© 2026 InternLink. Building careers, one internship at a time. 🚀</p>
    </div>
</body>
</html>
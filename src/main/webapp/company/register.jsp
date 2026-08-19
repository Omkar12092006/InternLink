<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<html class="scroll-smooth" lang="en"><head>
        <link rel="stylesheet"
      href="<%= request.getContextPath() %>/css/dark-theme.css">
<meta charset="utf-8"/>
<meta content="width=device-width, initial-scale=1.0" name="viewport"/>
<title>Company Registration | InternLink</title>
<script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&amp;display=swap" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
<style>
        .material-symbols-outlined {
            font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
        }
        body {
            font-family: 'Inter', sans-serif;
        }
        /* Custom scrollbar for professional feel */
        ::-webkit-scrollbar {
            width: 8px;
        }
        ::-webkit-scrollbar-track {
            background: #f1f1f1;
        }
        ::-webkit-scrollbar-thumb {
            background: #d1d5db;
            border-radius: 4px;
        }
        ::-webkit-scrollbar-thumb:hover {
            background: #9ca3af;
        }
    </style>
<script id="tailwind-config">
      tailwind.config = {
        darkMode: "class",
        theme: {
          extend: {
            "colors": {
                    "tertiary-container": "#151c27",
                    "on-secondary": "#ffffff",
                    "surface-variant": "#e5e2e3",
                    "error": "#ba1a1a",
                    "tertiary-fixed": "#dce2f3",
                    "surface-container-high": "#eae7e9",
                    "surface-container-lowest": "#ffffff",
                    "on-secondary-container": "#00714e",
                    "on-error": "#ffffff",
                    "surface-tint": "#575e70",
                    "outline-variant": "#c6c6cd",
                    "primary-fixed": "#dce2f7",
                    "primary-fixed-dim": "#c0c6db",
                    "tertiary-fixed-dim": "#c0c7d6",
                    "surface-dim": "#dcd9db",
                    "secondary-fixed": "#85f8c4",
                    "on-secondary-fixed": "#002114",
                    "on-tertiary-fixed-variant": "#404754",
                    "surface-bright": "#fcf8fa",
                    "on-primary-fixed": "#141b2b",
                    "on-error-container": "#93000a",
                    "on-background": "#1b1b1d",
                    "surface": "#fcf8fa",
                    "on-surface-variant": "#45464c",
                    "secondary": "#006c4a",
                    "inverse-on-surface": "#f3f0f1",
                    "outline": "#76777d",
                    "background": "#fcf8fa",
                    "surface-container": "#f0edee",
                    "primary-container": "#141b2b",
                    "on-secondary-fixed-variant": "#005137",
                    "inverse-primary": "#c0c6db",
                    "tertiary": "#000000",
                    "surface-container-highest": "#e5e2e3",
                    "on-primary-container": "#7d8497",
                    "surface-container-low": "#f6f3f4",
                    "on-tertiary-fixed": "#151c27",
                    "on-primary": "#ffffff",
                    "error-container": "#ffdad6",
                    "on-tertiary": "#ffffff",
                    "secondary-container": "#82f5c1",
                    "on-tertiary-container": "#7d8492",
                    "on-primary-fixed-variant": "#404758",
                    "on-surface": "#1b1b1d",
                    "inverse-surface": "#303031",
                    "secondary-fixed-dim": "#68dba9",
                    "primary": "#000000"
            },
            "borderRadius": {
                    "DEFAULT": "0.25rem",
                    "lg": "0.5rem",
                    "xl": "0.75rem",
                    "full": "9999px"
            },
            "spacing": {
                    "lg": "24px",
                    "container-max": "1280px",
                    "gutter": "20px",
                    "md": "16px",
                    "base": "4px",
                    "sm": "12px",
                    "xxl": "48px",
                    "xs": "8px",
                    "xl": "32px"
            },
            "fontFamily": {
                    "label-sm": ["Inter"],
                    "h1-mobile": ["Inter"],
                    "body-md": ["Inter"],
                    "label-md": ["Inter"],
                    "display": ["Inter"],
                    "body-lg": ["Inter"],
                    "h3": ["Inter"],
                    "h2": ["Inter"],
                    "h1": ["Inter"],
                    "body-sm": ["Inter"]
            },
            "fontSize": {
                    "label-sm": ["12px", {"lineHeight": "1.2", "fontWeight": "500"}],
                    "h1-mobile": ["24px", {"lineHeight": "1.3", "fontWeight": "700"}],
                    "body-md": ["16px", {"lineHeight": "1.6", "fontWeight": "400"}],
                    "label-md": ["14px", {"lineHeight": "1.2", "letterSpacing": "0.01em", "fontWeight": "600"}],
                    "display": ["48px", {"lineHeight": "1.2", "letterSpacing": "-0.02em", "fontWeight": "700"}],
                    "body-lg": ["18px", {"lineHeight": "1.6", "fontWeight": "400"}],
                    "h3": ["20px", {"lineHeight": "1.4", "fontWeight": "600"}],
                    "h2": ["24px", {"lineHeight": "1.4", "fontWeight": "600"}],
                    "h1": ["32px", {"lineHeight": "1.3", "fontWeight": "700"}],
                    "body-sm": ["14px", {"lineHeight": "1.5", "fontWeight": "400"}]
            }
          },
        },
      }
    </script>
</head>
<body class="bg-[#FAF8F5] text-primary flex flex-col min-h-screen">
<!-- TopNavBar -->
<header class="bg-surface-container-lowest dark:bg-surface-container-high shadow-sm docked full-width top-0 sticky z-50">
<div class="flex justify-between items-center h-16 px-gutter max-w-container-max mx-auto">
<div class="flex items-center gap-xl">
<span class="font-h2 text-h2 font-bold text-primary dark:text-primary-fixed">InternLink</span>
<nav class="hidden md:flex gap-lg">
<a class="font-label-md text-label-md text-on-surface-variant dark:text-on-primary-container hover:text-secondary dark:hover:text-secondary-fixed transition-colors active:scale-95 duration-100" href="../index.jsp">Home</a>
<a class="font-label-md text-label-md text-on-surface-variant dark:text-on-primary-container hover:text-secondary dark:hover:text-secondary-fixed transition-colors active:scale-95 duration-100" href="#">Internships</a>
<a class="font-label-md text-label-md text-on-surface-variant dark:text-on-primary-container hover:text-secondary dark:hover:text-secondary-fixed transition-colors active:scale-95 duration-100" href="#">Companies</a>
</nav>
</div>
<div class="flex items-center gap-md">
    <div>
</div>
</header>
<main class="flex-grow flex items-center justify-center py-xxl px-gutter relative">
<!-- Background Subtle Element -->
<div class="absolute top-0 left-0 w-full h-96 bg-gradient-to-b from-surface-container-low to-transparent opacity-50 -z-10"></div>
<!-- Registration Card Container -->
<div class="w-full max-w-[800px] bg-white rounded-xl shadow-[0_1px_3px_rgba(0,0,0,0.05),0_1px_2px_rgba(0,0,0,0.03)] overflow-hidden border border-outline-variant/30">
<!-- Card Header -->
<div class="p-xl text-center border-b border-outline-variant/20">
<h1 class="font-h1 text-h1 text-primary mb-xs">Company Registration</h1>
<p class="font-body-md text-body-md text-outline">Join InternLink to connect with top student talent.</p>
</div>
<!-- Form Content -->
<form action="#" class="p-xl space-y-lg" onsubmit="event.preventDefault();">
<div class="grid grid-cols-1 md:grid-cols-2 gap-lg">
<!-- Company Name - Full Width -->
<div class="md:col-span-2">
<label class="block font-label-md text-label-md text-primary mb-base" for="company_name">Company Name</label>
<input class="w-full bg-white rounded-lg border border-outline-variant px-md py-sm focus:ring-2 focus:ring-secondary focus:border-secondary transition-all outline-none" id="company_name" placeholder="e.g. Acme Corporation" type="text"/>
</div>
<!-- HR Name & Industry -->
<div>
<label class="block font-label-md text-label-md text-primary mb-base" for="hr_name">HR Contact Name</label>
<input class="w-full bg-white rounded-lg border border-outline-variant px-md py-sm focus:ring-2 focus:ring-secondary focus:border-secondary transition-all outline-none" id="hr_name" placeholder="Full Name" type="text"/>
</div>
<div>
<label class="block font-label-md text-label-md text-primary mb-base" for="industry">Industry</label>
<select class="w-full bg-white rounded-lg border border-outline-variant px-md py-sm focus:ring-2 focus:ring-secondary focus:border-secondary transition-all outline-none appearance-none" id="industry">
<option value="">Select Industry</option>
<option value="tech">Technology</option>
<option value="finance">Finance</option>
<option value="healthcare">Healthcare</option>
<option value="education">Education</option>
<option value="manufacturing">Manufacturing</option>
</select>
</div>
<!-- Email & Phone -->
<div>
<label class="block font-label-md text-label-md text-primary mb-base" for="email">Company Email</label>
<input class="w-full bg-white rounded-lg border border-outline-variant px-md py-sm focus:ring-2 focus:ring-secondary focus:border-secondary transition-all outline-none" id="email" placeholder="hr@company.com" type="email"/>
</div>
<div>
<label class="block font-label-md text-label-md text-primary mb-base" for="phone">Phone Number</label>
<input class="w-full bg-white rounded-lg border border-outline-variant px-md py-sm focus:ring-2 focus:ring-secondary focus:border-secondary transition-all outline-none" id="phone" placeholder="+1 (555) 000-0000" type="tel"/>
</div>
<!-- Website - Full Width -->
<div class="md:col-span-2">
<label class="block font-label-md text-label-md text-primary mb-base" for="website">Company Website</label>
<div class="relative">
<span class="absolute left-md top-1/2 -translate-y-1/2 text-outline material-symbols-outlined text-[18px]">language</span>
<input class="w-full bg-white rounded-lg border border-outline-variant pl-[44px] pr-md py-sm focus:ring-2 focus:ring-secondary focus:border-secondary transition-all outline-none" id="website" placeholder="https://www.company.com" type="url"/>
</div>
</div>
<!-- Location - Full Width -->
<div class="md:col-span-2">
<label class="block font-label-md text-label-md text-primary mb-base" for="location">Company Location</label>
<div class="relative">
<span class="absolute left-md top-1/2 -translate-y-1/2 text-outline material-symbols-outlined text-[18px]">location_on</span>
<input class="w-full bg-white rounded-lg border border-outline-variant pl-[44px] pr-md py-sm focus:ring-2 focus:ring-secondary focus:border-secondary transition-all outline-none" data-location="Mumbai, India" id="location" placeholder="City, Country" type="text"/>
</div>
</div>
<!-- Description - Full Width -->
<div class="md:col-span-2">
<label class="block font-label-md text-label-md text-primary mb-base" for="description">Company Description</label>
<textarea class="w-full bg-white rounded-lg border border-outline-variant px-md py-sm focus:ring-2 focus:ring-secondary focus:border-secondary transition-all outline-none resize-none" id="description" placeholder="Briefly describe your company's mission and intern culture..." rows="4"></textarea>
</div>
<!-- Passwords -->
<div>
<label class="block font-label-md text-label-md text-primary mb-base" for="password">Password</label>
<input class="w-full bg-white rounded-lg border border-outline-variant px-md py-sm focus:ring-2 focus:ring-secondary focus:border-secondary transition-all outline-none" id="password" placeholder="••••••••" type="password"/>
</div>
<div>
<label class="block font-label-md text-label-md text-primary mb-base" for="confirm_password">Confirm Password</label>
<input class="w-full bg-white rounded-lg border border-outline-variant px-md py-sm focus:ring-2 focus:ring-secondary focus:border-secondary transition-all outline-none" id="confirm_password" placeholder="••••••••" type="password"/>
</div>
</div>
<!-- Action Area -->
<div class="pt-lg flex flex-col items-center gap-md">
<button class="w-full bg-secondary text-on-secondary font-label-md text-label-md py-md rounded-lg shadow-sm hover:opacity-90 active:scale-[0.98] transition-all duration-200" type="submit">
                        Register Company
                    </button>
<div class="flex flex-col md:flex-row items-center gap-md font-body-sm text-body-sm">
    <a href="company/login.jsp"
   class="text-secondary font-semibold hover:underline">
    Already have an account? Login
</a>
<span class="hidden md:block text-outline-variant">|</span>
<a class="text-on-surface-variant hover:text-primary transition-colors flex items-center gap-xs" href="#">
    <a href="../index.jsp">Back to Home</a>
                        </a>
</div>
</div>
</form>
</div>
</main>
<!-- Footer -->
<footer class="bg-surface-container-highest dark:bg-surface-container-low border-t border-outline-variant mt-auto">
<div class="w-full py-xl px-gutter max-w-container-max mx-auto grid grid-cols-1 md:grid-cols-3 gap-lg">
<div class="space-y-sm">
<span class="font-label-md text-label-md font-bold text-primary">InternLink</span>
<p class="font-body-sm text-body-sm text-on-surface-variant leading-relaxed">Connecting future professionals with leading industries through a structured internship placement ecosystem.</p>
</div>
<div class="space-y-sm">
<span class="font-label-md text-label-md font-bold text-primary">Quick Links</span>
<ul class="space-y-xs">
<li><a class="font-body-sm text-body-sm text-on-surface-variant hover:text-secondary underline transition-all" href="#">Contact Info</a></li>
<li><a class="font-body-sm text-body-sm text-on-surface-variant hover:text-secondary underline transition-all" href="#">Department Credit</a></li>
<li><a class="font-body-sm text-body-sm text-on-surface-variant hover:text-secondary underline transition-all" href="#">Privacy Policy</a></li>
</ul>
</div>
<div class="space-y-sm">
<span class="font-label-md text-label-md font-bold text-primary">Placement Cell</span>
<p class="font-body-sm text-body-sm text-on-surface-variant">© 2024 University Placement Cell. All rights reserved.</p>
<div class="flex gap-md pt-xs">
<span class="material-symbols-outlined text-outline cursor-pointer hover:text-primary">qr_code_2</span>
<span class="material-symbols-outlined text-outline cursor-pointer hover:text-primary">language</span>
<span class="material-symbols-outlined text-outline cursor-pointer hover:text-primary">mail</span>
</div>
</div>
</div>
</footer>
<script>
        // Micro-interaction for form focus states
        const inputs = document.querySelectorAll('input, select, textarea');
        inputs.forEach(input => {
            input.addEventListener('focus', () => {
                input.parentElement.querySelector('label')?.classList.add('text-secondary');
            });
            input.addEventListener('blur', () => {
                input.parentElement.querySelector('label')?.classList.remove('text-secondary');
            });
        });

        // Simple validation feedback visual
        const submitBtn = document.querySelector('button[type="submit"]');
        submitBtn.addEventListener('click', () => {
            let hasEmpty = false;
            inputs.forEach(input => {
                if (input.required && !input.value) {
                    input.classList.add('border-error');
                    hasEmpty = true;
                } else {
                    input.classList.remove('border-error');
                }
            });
            if (!hasEmpty) {
                // Handle form submission logic
                console.log("Registration attempted");
            }
        });
    </script>
</body></html>

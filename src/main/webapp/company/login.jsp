<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<html class="light" lang="en"><head>
        <link rel="stylesheet"
      href="<%= request.getContextPath() %>/css/dark-theme.css">
<meta charset="utf-8"/>
<meta content="width=device-width, initial-scale=1.0" name="viewport"/>
<title>Company Login | InternLink</title>
<!-- Google Fonts: Inter & Material Symbols -->
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&amp;display=swap" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
<script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
<!-- Tailwind Configuration -->
<script id="tailwind-config">
      tailwind.config = {
        darkMode: "class",
        theme: {
          extend: {
            "colors": {
                    "surface-container-lowest": "#ffffff",
                    "on-secondary": "#ffffff",
                    "secondary-fixed-dim": "#68dba9",
                    "secondary-container": "#82f5c1",
                    "surface": "#fcf8fa",
                    "on-tertiary-fixed-variant": "#404754",
                    "on-surface": "#1b1b1d",
                    "inverse-primary": "#c0c6db",
                    "on-surface-variant": "#45464c",
                    "on-primary-fixed-variant": "#404758",
                    "tertiary-container": "#151c27",
                    "inverse-surface": "#303031",
                    "outline-variant": "#c6c6cd",
                    "on-secondary-fixed-variant": "#005137",
                    "tertiary": "#000000",
                    "background": "#FAF8F5", /* Light Sand per style guidance */
                    "surface-container-high": "#eae7e9",
                    "on-primary-container": "#7d8497",
                    "surface-tint": "#575e70",
                    "secondary": "#059669", /* Emerald per style guidance */
                    "surface-bright": "#fcf8fa",
                    "tertiary-fixed": "#dce2f3",
                    "on-tertiary-fixed": "#151c27",
                    "on-secondary-fixed": "#002114",
                    "surface-container": "#f0edee",
                    "on-secondary-container": "#00714e",
                    "on-primary": "#ffffff",
                    "primary-fixed": "#dce2f7",
                    "on-background": "#1b1b1d",
                    "surface-variant": "#e5e2e3",
                    "surface-container-highest": "#e5e2e3",
                    "surface-dim": "#dcd9db",
                    "on-primary-fixed": "#141b2b",
                    "primary-container": "#141b2b",
                    "primary": "#111827", /* Charcoal per style guidance */
                    "on-error-container": "#93000a",
                    "error": "#ba1a1a",
                    "secondary-fixed": "#85f8c4",
                    "error-container": "#ffdad6",
                    "surface-container-low": "#f6f3f4",
                    "on-tertiary": "#ffffff",
                    "on-error": "#ffffff",
                    "outline": "#D1D5DB",
                    "on-tertiary-container": "#7d8492",
                    "inverse-on-surface": "#f3f0f1",
                    "primary-fixed-dim": "#c0c6db",
                    "tertiary-fixed-dim": "#c0c7d6"
            },
            "borderRadius": {
                    "DEFAULT": "0.25rem",
                    "lg": "0.5rem",
                    "xl": "0.75rem",
                    "full": "9999px"
            },
            "spacing": {
                    "sm": "12px",
                    "gutter": "20px",
                    "xl": "32px",
                    "xs": "8px",
                    "lg": "24px",
                    "container-max": "1280px",
                    "base": "4px",
                    "xxl": "48px",
                    "md": "16px"
            },
            "fontFamily": {
                    "label-sm": ["Inter"],
                    "display": ["Inter"],
                    "label-md": ["Inter"],
                    "body-lg": ["Inter"],
                    "h3": ["Inter"],
                    "h2": ["Inter"],
                    "body-md": ["Inter"],
                    "h1": ["Inter"],
                    "h1-mobile": ["Inter"],
                    "body-sm": ["Inter"]
            },
            "fontSize": {
                    "label-sm": ["12px", {"lineHeight": "1.2", "fontWeight": "500"}],
                    "display": ["48px", {"lineHeight": "1.2", "letterSpacing": "-0.02em", "fontWeight": "700"}],
                    "label-md": ["14px", {"lineHeight": "1.2", "letterSpacing": "0.01em", "fontWeight": "600"}],
                    "body-lg": ["18px", {"lineHeight": "1.6", "fontWeight": "400"}],
                    "h3": ["20px", {"lineHeight": "1.4", "fontWeight": "600"}],
                    "h2": ["24px", {"lineHeight": "1.4", "fontWeight": "600"}],
                    "body-md": ["16px", {"lineHeight": "1.6", "fontWeight": "400"}],
                    "h1": ["32px", {"lineHeight": "1.3", "fontWeight": "700"}],
                    "h1-mobile": ["24px", {"lineHeight": "1.3", "fontWeight": "700"}],
                    "body-sm": ["14px", {"lineHeight": "1.5", "fontWeight": "400"}]
            }
          },
        },
      }
    </script>
<style>
        body { font-family: 'Inter', sans-serif; }
        .material-symbols-outlined {
            font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
        }
        /* Custom elevation matching Level 1 from style guidance */
        .elevation-l1 {
            box-shadow: 0 1px 3px rgba(0,0,0,0.05), 0 1px 2px rgba(0,0,0,0.03);
        }
        /* Custom elevation matching Level 2 from style guidance */
        .elevation-l2 {
            box-shadow: 0 4px 6px -1px rgba(0,0,0,0.1), 0 2px 4px -1px rgba(0,0,0,0.06);
        }
    </style>
</head>
<body class="bg-background min-h-screen flex flex-col selection:bg-secondary/30">
<!-- TopNavBar (Shared Component) -->
<!-- Suppression logic: Since this is a login page, the prompt explicitly asks to use TopNavBar from JSON -->
<header class="bg-surface-container-lowest sticky top-0 z-50 shadow-sm border-b border-outline-variant/30">
<nav class="flex justify-between items-center h-16 px-gutter max-w-container-max mx-auto">
<div class="flex items-center gap-xs">
<span class="material-symbols-outlined text-secondary text-h2">link</span>
<span class="font-h2 text-h2 font-bold text-primary">InternLink</span>
</div>
<div class="hidden md:flex items-center gap-xl">
<a class="font-label-md text-label-md text-on-surface-variant hover:text-secondary transition-colors duration-100 active:scale-95" href="../index.jsp">Home</a>
<a class="font-label-md text-label-md text-on-surface-variant hover:text-secondary transition-colors duration-100 active:scale-95" href="register.jsp">Internships</a>
<a class="font-label-md text-label-md text-on-surface-variant hover:text-secondary transition-colors duration-100 active:scale-95" href="#">Companies</a>
</div>
<div class="flex items-center gap-md">
<form action="<%= request.getContextPath() %>/student/login.jsp">
    <button type="submit">Student Login</button>
</form>
</div>
</nav>
</header>
<main class="flex-grow flex items-center justify-center px-gutter py-xxl relative overflow-hidden">
<!-- Subtle Abstract Background Elements -->
<div class="absolute top-0 left-0 w-full h-full -z-10 pointer-events-none opacity-40">
<div class="absolute top-[-10%] right-[-5%] w-[400px] h-[400px] rounded-full bg-secondary/10 blur-[100px]"></div>
<div class="absolute bottom-[-10%] left-[-5%] w-[300px] h-[300px] rounded-full bg-primary/5 blur-[80px]"></div>
</div>
<!-- Login Card -->
<div class="w-full max-w-[480px] bg-white rounded-lg elevation-l1 p-xl md:p-xxl animate-in fade-in slide-in-from-bottom-4 duration-700">
<div class="flex flex-col items-center mb-xl">
<div class="w-16 h-16 bg-secondary/10 rounded-full flex items-center justify-center mb-md">
<span class="material-symbols-outlined text-secondary text-[32px]">corporate_fare</span>
</div>
<h1 class="font-h1 text-h1 text-primary mb-xs">Company Login</h1>
<p class="font-body-sm text-body-sm text-on-surface-variant text-center max-w-[320px]">
                    Enter your corporate credentials to manage your internship listings.
                </p>
</div>
<form class="space-y-lg" onsubmit="event.preventDefault();">
<!-- Email Field -->
<div class="space-y-xs">
<label class="font-label-md text-label-md text-primary block" for="email">Company Email</label>
<div class="relative">
<span class="material-symbols-outlined absolute left-sm top-1/2 -translate-y-1/2 text-outline text-[20px]">mail</span>
<input class="w-full pl-[44px] pr-md py-sm bg-white border border-outline rounded-lg focus:ring-2 focus:ring-secondary/20 focus:border-secondary outline-none transition-all font-body-md text-body-md placeholder:text-outline" id="email" placeholder="hr@company.com" type="email"/>
</div>
</div>
<!-- Password Field -->
<div class="space-y-xs">
<div class="flex justify-between items-center">
<label class="font-label-md text-label-md text-primary block" for="password">Password</label>
<a class="font-label-sm text-label-sm text-secondary hover:underline" href="#">Forgot Password?</a>
</div>
<div class="relative">
<span class="material-symbols-outlined absolute left-sm top-1/2 -translate-y-1/2 text-outline text-[20px]">lock</span>
<input class="w-full pl-[44px] pr-md py-sm bg-white border border-outline rounded-lg focus:ring-2 focus:ring-secondary/20 focus:border-secondary outline-none transition-all font-body-md text-body-md placeholder:text-outline" id="password" placeholder="••••••••" type="password"/>
</div>
</div>
<!-- Login Button -->
<button class="w-full py-md bg-secondary text-white font-label-md text-label-md rounded-lg elevation-l1 hover:elevation-l2 hover:opacity-95 active:scale-[0.98] transition-all flex items-center justify-center gap-xs" type="submit">
                    Login
                    <span class="material-symbols-outlined text-[18px]">arrow_forward</span>
</button>
</form>
<!-- Divider -->
<div class="relative my-xl">
<div class="absolute inset-0 flex items-center">
<div class="w-full border-t border-outline-variant"></div>
</div>
<div class="relative flex justify-center text-label-sm">
<span class="px-md bg-white text-on-surface-variant font-label-sm">OR</span>
</div>
</div>
<!-- Secondary Actions -->
<div class="space-y-md text-center">
<p class="font-body-sm text-body-sm text-on-surface-variant">
                    New corporate partner? 
                    <a href="register.jsp">Register Company</a>
</p>
<a class="inline-flex items-center gap-xs font-label-md text-label-md text-on-surface-variant hover:text-primary transition-colors group" href="#">
    <a href="../index.jsp">Back to Home</a>
</div>
</div>
</main>
<!-- Footer (Shared Component) -->
<footer class="bg-surface-container-highest border-t border-outline-variant mt-auto">
<div class="w-full py-xl px-gutter max-w-container-max mx-auto grid grid-cols-1 md:grid-cols-3 gap-lg">
<div class="space-y-sm">
<div class="flex items-center gap-xs">
<span class="material-symbols-outlined text-primary text-[24px]">link</span>
<span class="font-label-md text-label-md font-bold text-primary">InternLink</span>
</div>
<p class="font-body-sm text-body-sm text-on-surface-variant max-w-xs">
                    Empowering students and companies through meaningful connections and seamless internship placements.
                </p>
</div>
<div class="flex flex-col gap-sm">
<h4 class="font-label-md text-label-md text-primary">Quick Links</h4>
<div class="flex flex-col gap-xs">
<a class="font-body-sm text-body-sm text-on-surface-variant hover:text-secondary underline transition-all" href="#">Contact Info</a>
<a class="font-body-sm text-body-sm text-on-surface-variant hover:text-secondary underline transition-all" href="#">Quick Links</a>
<a class="font-body-sm text-body-sm text-on-surface-variant hover:text-secondary underline transition-all" href="#">Department Credit</a>
</div>
</div>
<div class="flex flex-col gap-sm">
<h4 class="font-label-md text-label-md text-primary">Legal</h4>
<p class="font-body-sm text-body-sm text-on-surface-variant">
                    © 2024 University Placement Cell. All rights reserved.
                </p>
<div class="flex gap-md mt-xs">
<a class="text-on-surface-variant hover:text-secondary transition-colors" href="#">
<span class="material-symbols-outlined text-[20px]">language</span>
</a>
<a class="text-on-surface-variant hover:text-secondary transition-colors" href="#">
<span class="material-symbols-outlined text-[20px]">share</span>
</a>
</div>
</div>
</div>
</footer>
<script>
        // Micro-interaction for input fields
        const inputs = document.querySelectorAll('input');
        inputs.forEach(input => {
            input.addEventListener('focus', () => {
                input.parentElement.querySelector('.material-symbols-outlined').style.color = '#059669';
            });
            input.addEventListener('blur', () => {
                input.parentElement.querySelector('.material-symbols-outlined').style.color = '#76777d';
            });
        });
    </script>
</body></html>
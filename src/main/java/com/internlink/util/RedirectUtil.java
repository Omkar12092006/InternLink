package com.internlink.util;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public final class RedirectUtil {

    private static final Pattern STUDENT_APPLICATION = Pattern.compile("applyInternship\\.jsp\\?id=([1-9][0-9]*)");
    private static final Pattern COMPANY_EDIT_POSTING = Pattern.compile("company/postInternship\\.jsp\\?id=([1-9][0-9]*)");

    private RedirectUtil() {
    }

    public static String studentAfterLogin(String contextPath, String destination) {
        return contextPath + "/" + studentDestination(destination);
    }

    public static String studentDestination(String destination) {
        if ("browseInternships.jsp".equals(destination)) {
            return "browseInternships.jsp";
        }
        if ("student/dashboard.jsp".equals(destination)) {
            return "student/dashboard.jsp";
        }

        Matcher application = matcher(STUDENT_APPLICATION, destination);
        if (application != null) {
            return "applyInternship.jsp?id=" + application.group(1);
        }
        return "student/dashboard.jsp";
    }

    public static String companyAfterLogin(String contextPath, String destination) {
        return contextPath + "/" + companyDestination(destination);
    }

    public static String companyDestination(String destination) {
        if ("company/dashboard.jsp".equals(destination)
                || "company/postings.jsp".equals(destination)
                || "company/profile.jsp".equals(destination)
                || "company/candidates.jsp".equals(destination)
                || "CompanyCandidatesServlet".equals(destination)
                || "ReviewApplicationsServlet".equals(destination)) {
            return destination;
        }

        Matcher editPosting = matcher(COMPANY_EDIT_POSTING, destination);
        if (editPosting != null) {
            return "company/postInternship.jsp?id=" + editPosting.group(1);
        }
        if ("company/postInternship.jsp".equals(destination)) {
            return "company/postInternship.jsp";
        }
        return "company/dashboard.jsp";
    }

    public static String studentLoginUrl(String contextPath, String destination) {
        return contextPath + "/student/login.jsp?redirect=" + encode(studentDestination(destination));
    }

    public static String companyLoginUrl(String contextPath, String destination) {
        return contextPath + "/company/login.jsp?redirect=" + encode(companyDestination(destination));
    }

    private static Matcher matcher(Pattern pattern, String value) {
        if (value == null) {
            return null;
        }
        Matcher matcher = pattern.matcher(value);
        return matcher.matches() ? matcher : null;
    }

    private static String encode(String value) {
        return URLEncoder.encode(value, StandardCharsets.UTF_8);
    }
}

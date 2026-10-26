package com.internlink.util;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

class RedirectUtilTest {

    @Test
    void studentAfterLoginReturnsToApplicationAndRejectsExternalDestinations() {
        assertEquals("/InternLink/applyInternship.jsp?id=42",
                RedirectUtil.studentAfterLogin("/InternLink", "applyInternship.jsp?id=42"));
        assertEquals("/InternLink/student/dashboard.jsp",
                RedirectUtil.studentAfterLogin("/InternLink", "https://example.com"));
    }

    @Test
    void companyAfterLoginReturnsToAllowedPageAndRejectsExternalDestinations() {
        assertEquals("/InternLink/company/postInternship.jsp?id=12",
                RedirectUtil.companyAfterLogin("/InternLink", "company/postInternship.jsp?id=12"));
        assertEquals("/InternLink/CompanyCandidatesServlet",
                RedirectUtil.companyAfterLogin("/InternLink", "CompanyCandidatesServlet"));
        assertEquals("/InternLink/company/dashboard.jsp",
                RedirectUtil.companyAfterLogin("/InternLink", "//example.com"));
        assertEquals("/InternLink/ScheduleInterviewServlet",
                RedirectUtil.companyAfterLogin("/InternLink", "ScheduleInterviewServlet"));
    }

    @Test
    void loginUrlsEncodeNestedReturnDestinations() {
        assertEquals("/InternLink/student/login.jsp?redirect=applyInternship.jsp%3Fid%3D42",
                RedirectUtil.studentLoginUrl("/InternLink", "applyInternship.jsp?id=42"));
        assertEquals("/InternLink/student/login.jsp?redirect=StudentInterviewsServlet",
                RedirectUtil.studentLoginUrl("/InternLink", "StudentInterviewsServlet"));
    }

    @Test
    void loginDestinationsAreCanonicalizedForSafeFormValues() {
        assertEquals("company/dashboard.jsp",
                RedirectUtil.companyDestination("\" onfocus=\"alert(1)"));
        assertEquals("student/dashboard.jsp",
                RedirectUtil.studentDestination("//example.com"));
    }
}

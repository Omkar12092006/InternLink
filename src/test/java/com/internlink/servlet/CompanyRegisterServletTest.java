package com.internlink.servlet;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNull;

class CompanyRegisterServletTest {

    @Test
    void validateRegistration_shouldRejectPasswordMismatch() {
        String error = CompanyRegisterServlet.validateRegistration(
                "Acme",
                "Jane",
                "Technology",
                "hr@acme.com",
                "secret123",
                "secret456",
                "+123",
                "https://acme.com",
                "New York",
                "AI company"
        );

        assertEquals("Password and confirm password do not match.", error);
    }

    @Test
    void validateRegistration_shouldAcceptValidPayload() {
        String error = CompanyRegisterServlet.validateRegistration(
                "Acme",
                "Jane",
                "Technology",
                "hr@acme.com",
                "secret123",
                "secret123",
                "+123",
                "https://acme.com",
                "New York",
                "AI company"
        );

        assertNull(error);
    }
}

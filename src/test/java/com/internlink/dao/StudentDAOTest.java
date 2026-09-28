package com.internlink.dao;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

class StudentDAOTest {

    @Test
    void normalizeEmail_shouldTrimAndLowercase() {
        assertEquals("alex@example.com", StudentDAO.normalizeEmail("  Alex@Example.com  "));
    }
}

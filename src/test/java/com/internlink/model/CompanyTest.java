package com.internlink.model;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class CompanyTest {

    @Test
    void companyShouldStoreProfileFields() {
        Company company = new Company();
        company.setId(7);
        company.setCompanyName("Acme Labs");
        company.setEmail("talent@acme.com");
        company.setPassword("secret123");
        company.setPhone("+1-555-0101");
        company.setWebsite("https://acme.com");
        company.setLocation("New York, USA");
        company.setIndustry("Technology");
        company.setDescription("Builds next-gen developer tools.");
        company.setHrName("Jane Smith");

        assertEquals(7, company.getId());
        assertEquals("Acme Labs", company.getCompanyName());
        assertEquals("talent@acme.com", company.getEmail());
        assertEquals("secret123", company.getPassword());
        assertEquals("+1-555-0101", company.getPhone());
        assertEquals("https://acme.com", company.getWebsite());
        assertEquals("New York, USA", company.getLocation());
        assertEquals("Technology", company.getIndustry());
        assertEquals("Builds next-gen developer tools.", company.getDescription());
        assertEquals("Jane Smith", company.getHrName());
    }
}

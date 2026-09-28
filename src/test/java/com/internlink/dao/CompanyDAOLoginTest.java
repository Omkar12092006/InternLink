package com.internlink.dao;

import com.internlink.model.Company;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertEquals;

class CompanyDAOLoginTest {

    @Test
    void login_should_trim_email_and_password_and_accept_valid_credentials() {
        CompanyDAO dao = new CompanyDAO();
        String uniqueEmail = "trimtest." + System.currentTimeMillis() + "@example.com";
        String rawPassword = "TrimPass!123";

        Company company = new Company();
        company.setCompanyName("Trim Test Co");
        company.setHrName("HR User");
        company.setIndustry("Technology");
        company.setEmail(uniqueEmail);
        company.setPhone("+15551234567");
        company.setWebsite("https://example.com");
        company.setLocation("Boston");
        company.setDescription("Test company");
        company.setPassword(rawPassword);

        assertEquals(true, dao.register(company));

        Company loginResult = dao.login("  " + uniqueEmail.toUpperCase() + "  ", "  " + rawPassword + "  ");
        assertNotNull(loginResult);
        assertEquals(uniqueEmail, loginResult.getEmail());
    }
}

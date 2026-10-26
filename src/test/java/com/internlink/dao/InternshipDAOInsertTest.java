package com.internlink.dao;

import com.internlink.model.Company;
import com.internlink.model.Internship;
import org.junit.jupiter.api.Test;

import java.time.LocalDate;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

class InternshipDAOInsertTest {

    @Test
    void insert_should_persist_internship_for_company() throws Exception {
        CompanyDAO companyDAO = new CompanyDAO();
        String email = "internship-test-" + System.currentTimeMillis() + "@example.com";
        String password = "TestPass!123";

        Company company = new Company();
        company.setCompanyName("Test Company");
        company.setHrName("Test HR");
        company.setIndustry("Technology");
        company.setEmail(email);
        company.setPhone("+15550000000");
        company.setWebsite("https://example.com");
        company.setLocation("Boston");
        company.setDescription("Test company");
        company.setPassword(password);

        assertTrue(companyDAO.register(company));

        Company created = companyDAO.login(email, password);
        InternshipDAO dao = new InternshipDAO();

        Internship internship = new Internship();
        internship.setCompanyId(created.getId());
        internship.setCompany(created.getCompanyName());
        internship.setTitle("QA Intern");
        internship.setCategory("Software Engineering");
        internship.setLocation("Remote");
        internship.setDuration("Summer (3 months)");
        internship.setDescription("Test internship description");
        internship.setSkills("Java, Selenium, SQL");
        internship.setPaid(true);
        internship.setStipend("$5000");
        internship.setApplicants(0);
        internship.setPostedDate(LocalDate.now());

        assertTrue(dao.insert(internship));
        Internship createdInternship = dao.getByCompanyId(created.getId()).stream()
                .filter(item -> "QA Intern".equals(item.getTitle()))
                .findFirst()
                .orElseThrow();
        assertFalse(createdInternship.isApproved());
        AdminDAO adminDAO = new AdminDAO();
        assertTrue(adminDAO.approveInternship(createdInternship.getId()));
        assertNotNull(dao.getApprovedInternshipById(createdInternship.getId()));
    }
}

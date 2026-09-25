package com.internlink.dao;

import com.internlink.model.Application;
import com.internlink.model.Company;
import com.internlink.model.Internship;
import org.junit.jupiter.api.Test;

import java.time.LocalDate;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

class ApplicationDAOTest {

    @Test
    void getApplicationsByCompanyId_should_return_company_applications_and_update_status() {
        CompanyDAO companyDAO = new CompanyDAO();
        String email = "app-review-test-" + System.currentTimeMillis() + "@example.com";
        String password = "TestPass!123";

        Company company = new Company();
        company.setCompanyName("Review Company");
        company.setHrName("Review HR");
        company.setIndustry("Technology");
        company.setEmail(email);
        company.setPhone("+15550001111");
        company.setWebsite("https://review.example.com");
        company.setLocation("Austin");
        company.setDescription("Review company");
        company.setPassword(password);
        assertTrue(companyDAO.register(company));

        Company createdCompany = companyDAO.login(email, password);
        assertNotNull(createdCompany);

        InternshipDAO internshipDAO = new InternshipDAO();
        Internship internship = new Internship();
        internship.setCompanyId(createdCompany.getId());
        internship.setCompany(createdCompany.getCompanyName());
        internship.setTitle("Application Review Intern");
        internship.setCategory("Software Engineering");
        internship.setLocation("Remote");
        internship.setDuration("Summer (3 months)");
        internship.setDescription("Review internship");
        internship.setSkills("Java, SQL");
        internship.setPaid(true);
        internship.setStipend("$6000");
        internship.setApplicants(0);
        internship.setPostedDate(LocalDate.now());
        assertTrue(internshipDAO.insert(internship));

        List<Internship> internshipList = internshipDAO.getByCompanyId(createdCompany.getId());
        Internship savedInternship = internshipList.stream()
                .filter(item -> "Application Review Intern".equals(item.getTitle()))
                .findFirst()
                .orElseThrow();

        ApplicationDAO applicationDAO = new ApplicationDAO();
        assertTrue(applicationDAO.apply(savedInternship.getId(), "Test Student", "student-review@example.com", "Example University", "I am excited to join."));

        List<Application> applications = applicationDAO.getApplicationsByCompanyId(createdCompany.getId());
        assertFalse(applications.isEmpty());
        assertTrue(applications.stream().anyMatch(app -> "Test Student".equals(app.getApplicantName()) && "Pending".equals(app.getStatus())));

        Application application = applications.stream()
                .filter(app -> "Test Student".equals(app.getApplicantName()))
                .findFirst()
                .orElseThrow();

        assertTrue(applicationDAO.updateStatus(application.getId(), "Shortlisted"));
        List<Application> updatedApplications = applicationDAO.getApplicationsByCompanyId(createdCompany.getId());
        assertTrue(updatedApplications.stream().anyMatch(app -> app.getId() == application.getId() && "Shortlisted".equals(app.getStatus())));
    }
}

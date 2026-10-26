package com.internlink.dao;

import com.internlink.model.Application;
import com.internlink.model.Company;
import com.internlink.model.Interview;
import com.internlink.model.Internship;
import com.internlink.model.Student;
import com.internlink.util.DBConnection;
import org.junit.jupiter.api.Test;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

class InterviewDAOTest {

    @Test
    void scheduleAndUpdate_shouldShowInterviewToOwningCompanyAndStudent() throws Exception {
        String suffix = UUID.randomUUID().toString().replace("-", "");
        StudentDAO studentDAO = new StudentDAO();
        Student student = new Student();
        student.setFullName("Interview Test Student");
        student.setEmail("interview-student-" + suffix + "@example.com");
        student.setPassword("test-password");
        student.setPhone("+15550004444");
        assertTrue(studentDAO.registerStudent(student));
        Student savedStudent = studentDAO.getStudentByEmailAndPassword(student.getEmail(), student.getPassword());
        assertNotNull(savedStudent);

        Company company = new Company();
        company.setCompanyName("Interview Test Company");
        company.setHrName("Interview Test HR");
        company.setIndustry("Technology");
        company.setEmail("interview-company-" + suffix + "@example.com");
        company.setPhone("+15550005555");
        company.setLocation("Remote");
        company.setDescription("Interview DAO test");
        company.setPassword("test-password");
        CompanyDAO companyDAO = new CompanyDAO();
        assertTrue(companyDAO.register(company));
        Company savedCompany = companyDAO.login(company.getEmail(), company.getPassword());
        assertNotNull(savedCompany);

        try {
            Internship internship = new Internship();
            internship.setCompanyId(savedCompany.getId());
            internship.setCompany(savedCompany.getCompanyName());
            internship.setTitle("Interview DAO Test Intern");
            internship.setCategory("Engineering");
            internship.setLocation("Remote");
            internship.setDuration("Three months");
            internship.setDescription("Interview DAO test posting");
            internship.setSkills("Java");
            internship.setPaid(true);
            internship.setStipend("$1000");
            internship.setApplicants(0);
            internship.setPostedDate(LocalDate.now());
            InternshipDAO internshipDAO = new InternshipDAO();
            assertTrue(internshipDAO.insert(internship));
            Internship savedInternship = internshipDAO.getByCompanyId(savedCompany.getId()).stream()
                    .filter(item -> "Interview DAO Test Intern".equals(item.getTitle()))
                    .findFirst()
                    .orElseThrow();
            assertTrue(new AdminDAO().approveInternship(savedInternship.getId()));
            assertTrue(new ApplicationDAO().apply(savedInternship.getId(), savedStudent.getFullName(),
                    savedStudent.getEmail(), "Test University", "Interview test application"));

            Application savedApplication = new ApplicationDAO()
                    .getApplicationsByStudent(savedStudent.getEmail()).get(0);
            InterviewDAO interviewDAO = new InterviewDAO();
            Interview interview = new Interview();
            interview.setApplicationId(savedApplication.getId());
            interview.setScheduledAt(LocalDateTime.now().plusDays(2).withSecond(0).withNano(0));
            interview.setMode("Online");
            interview.setMeetingLink("https://meet.example.com/interview");
            interview.setNotes("Please bring a portfolio.");
            assertTrue(interviewDAO.schedule(interview, savedCompany.getId()));

            List<Interview> companyInterviews = interviewDAO.getByCompanyId(savedCompany.getId());
            assertEquals(1, companyInterviews.size());
            assertEquals(savedStudent.getEmail(), companyInterviews.get(0).getApplicantEmail());
            List<Interview> studentInterviews = interviewDAO.getByStudentId(savedStudent.getId());
            assertEquals(1, studentInterviews.size());

            Interview scheduledInterview = companyInterviews.get(0);
            scheduledInterview.setStatus("Completed");
            assertTrue(interviewDAO.update(scheduledInterview, savedCompany.getId()));
            assertEquals("Completed", interviewDAO.getByStudentId(savedStudent.getId()).get(0).getStatus());
            assertEquals("Interview Completed",
                    new ApplicationDAO().getApplicationsByStudent(savedStudent.getEmail()).get(0).getStatus());
            assertFalse(interviewDAO.getByCompanyId(savedCompany.getId()).isEmpty());
        } finally {
            try (Connection connection = DBConnection.getConnection();
                 PreparedStatement studentDelete = connection.prepareStatement("DELETE FROM students WHERE id=?");
                 PreparedStatement companyDelete = connection.prepareStatement("DELETE FROM companies WHERE id=?")) {
                try (PreparedStatement applicationsDelete = connection.prepareStatement(
                        "DELETE FROM applications WHERE applicant_email=?")) {
                    applicationsDelete.setString(1, savedStudent.getEmail());
                    applicationsDelete.executeUpdate();
                }
                try (PreparedStatement internshipDelete = connection.prepareStatement(
                        "DELETE FROM internships WHERE company_id=?")) {
                    internshipDelete.setInt(1, savedCompany.getId());
                    internshipDelete.executeUpdate();
                }
                studentDelete.setInt(1, savedStudent.getId());
                studentDelete.executeUpdate();
                companyDelete.setInt(1, savedCompany.getId());
                companyDelete.executeUpdate();
            }
        }
    }
}

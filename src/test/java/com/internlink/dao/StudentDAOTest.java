package com.internlink.dao;

import com.internlink.model.Student;
import com.internlink.util.DBConnection;
import org.junit.jupiter.api.Test;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

class StudentDAOTest {

    @Test
    void normalizeEmail_shouldTrimAndLowercase() {
        assertEquals("alex@example.com", StudentDAO.normalizeEmail("  Alex@Example.com  "));
    }

    @Test
    void updateStudent_shouldPersistProfileAndResume() throws Exception {
        StudentDAO studentDAO = new StudentDAO();
        String originalEmail = "profile-test-" + System.currentTimeMillis() + "@example.com";
        Student student = new Student();
        student.setFullName("Profile Test");
        student.setEmail(originalEmail);
        student.setPassword("test-password");
        student.setPhone("+15550002222");
        assertTrue(studentDAO.registerStudent(student));

        Student savedStudent = studentDAO.getStudentByEmailAndPassword(originalEmail, "test-password");
        assertNotNull(savedStudent);
        try {
            String updatedEmail = "profile-updated-" + System.currentTimeMillis() + "@example.com";
            savedStudent.setFullName("Updated Profile");
            savedStudent.setEmail(updatedEmail);
            savedStudent.setPhone("+15550003333");
            savedStudent.setCourse("Computer Science");
            assertTrue(studentDAO.updateStudent(savedStudent, originalEmail));

            String resumeFile = savedStudent.getId() + "-" + UUID.randomUUID() + ".pdf";
            assertTrue(studentDAO.updateResumeFile(savedStudent.getId(), resumeFile));
            Student reloadedStudent = studentDAO.getStudentById(savedStudent.getId());
            assertNotNull(reloadedStudent);
            assertEquals("Updated Profile", reloadedStudent.getFullName());
            assertEquals(updatedEmail, reloadedStudent.getEmail());
            assertEquals("Computer Science", reloadedStudent.getCourse());
            assertEquals(resumeFile, reloadedStudent.getResumeFile());
        } finally {
            try (Connection connection = DBConnection.getConnection();
                 PreparedStatement statement = connection.prepareStatement("DELETE FROM students WHERE id=?")) {
                statement.setInt(1, savedStudent.getId());
                statement.executeUpdate();
            }
        }
    }
}

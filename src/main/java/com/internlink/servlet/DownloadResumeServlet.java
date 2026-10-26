package com.internlink.servlet;

import com.internlink.dao.StudentDAO;
import com.internlink.model.Student;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.sql.SQLException;

@WebServlet("/DownloadResumeServlet")
public class DownloadResumeServlet extends HttpServlet {

    private final StudentDAO studentDAO = new StudentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Student sessionStudent = getLoggedInStudent(request);
        if (sessionStudent == null) {
            response.sendRedirect(request.getContextPath() + "/student/login.jsp");
            return;
        }

        try {
            Student student = studentDAO.getStudentById(sessionStudent.getId());
            String resumeFile = student == null ? null : student.getResumeFile();
            if (resumeFile == null || !resumeFile.matches("[0-9]+-[a-f0-9-]+\\.(pdf|doc|docx)")
                    || !resumeFile.startsWith(sessionStudent.getId() + "-")) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
            }

            Path resumeDirectory = getResumeDirectory();
            Path resumePath = resumeDirectory.resolve(resumeFile).normalize();
            if (!resumePath.getParent().equals(resumeDirectory)
                    || !Files.isRegularFile(resumePath)) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
            }

            String extension = resumeFile.substring(resumeFile.lastIndexOf('.') + 1);
            response.setContentType("application/octet-stream");
            response.setHeader("X-Content-Type-Options", "nosniff");
            response.setHeader("Content-Disposition", "attachment; filename=\"resume." + extension + "\"");
            response.setContentLengthLong(Files.size(resumePath));
            Files.copy(resumePath, response.getOutputStream());
        } catch (SQLException e) {
            getServletContext().log("Unable to load student resume metadata.", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    private Student getLoggedInStudent(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return null;
        }
        Object value = session.getAttribute("student");
        return value instanceof Student ? (Student) value : null;
    }

    private Path getResumeDirectory() throws IOException {
        String userHome = System.getProperty("user.home");
        if (userHome == null || userHome.isBlank()) {
            throw new IOException("The application user home directory is not configured.");
        }
        return Path.of(userHome, "InternLink", "uploads", "resumes").toAbsolutePath().normalize();
    }
}

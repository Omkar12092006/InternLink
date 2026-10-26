package com.internlink.servlet;

import com.internlink.dao.ApplicationDAO;
import com.internlink.model.Application;
import com.internlink.model.Student;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/MyApplicationsServlet")
public class MyApplicationsServlet extends HttpServlet {

    private final ApplicationDAO applicationDAO = new ApplicationDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Student student = getLoggedInStudent(request);
        if (student == null) {
            response.sendRedirect(request.getContextPath() + "/student/login.jsp");
            return;
        }

        try {
            List<Application> applications = applicationDAO.getApplicationsByStudent(student.getEmail());
            request.setAttribute("applications", applications);
            request.setAttribute("applicationsReady", Boolean.TRUE);
        } catch (SQLException e) {
            getServletContext().log("Unable to load student application history.", e);
            request.setAttribute("applicationsError", "Your applications are temporarily unavailable.");
        }
        request.setAttribute("student", student);
        request.getRequestDispatcher("/student/myApplications.jsp").forward(request, response);
    }

    private Student getLoggedInStudent(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return null;
        }
        Object value = session.getAttribute("student");
        return value instanceof Student ? (Student) value : null;
    }
}

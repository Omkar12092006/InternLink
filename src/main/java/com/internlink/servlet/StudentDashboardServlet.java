package com.internlink.servlet;

import com.internlink.dao.ApplicationDAO;
import com.internlink.dao.BookmarkDAO;
import com.internlink.dao.InternshipDAO;
import com.internlink.model.Application;
import com.internlink.model.Internship;
import com.internlink.model.Student;
import com.internlink.util.RedirectUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/StudentDashboardServlet")
public class StudentDashboardServlet extends HttpServlet {

    private final ApplicationDAO applicationDAO = new ApplicationDAO();
    private final BookmarkDAO bookmarkDAO = new BookmarkDAO();
    private final InternshipDAO internshipDAO = new InternshipDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Student student = getLoggedInStudent(request);
        if (student == null) {
            response.sendRedirect(RedirectUtil.studentLoginUrl(
                    request.getContextPath(), "student/dashboard.jsp"));
            return;
        }

        List<Application> applications;
        try {
            applications = applicationDAO.getApplicationsByStudent(student.getEmail());
        } catch (SQLException e) {
            getServletContext().log("Unable to load student applications.", e);
            applications = List.of();
            request.setAttribute("dashboardError", "Your applications are temporarily unavailable.");
        }
        List<Internship> savedInternships = internshipDAO.getBookmarkedByStudentId(student.getId());
        long pendingApplications = applications.stream()
                .filter(application -> "pending".equalsIgnoreCase(application.getStatus())
                        || "shortlisted".equalsIgnoreCase(application.getStatus()))
                .count();
        long offers = applications.stream()
                .filter(application -> "selected".equalsIgnoreCase(application.getStatus()))
                .count();

        request.setAttribute("student", student);
        request.setAttribute("applications", applications);
        request.setAttribute("savedInternships", savedInternships);
        request.setAttribute("pendingApplications", pendingApplications);
        request.setAttribute("offers", offers);
        request.setAttribute("dashboardReady", Boolean.TRUE);
        request.getRequestDispatcher("/student/dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Student student = getLoggedInStudent(request);
        if (student == null) {
            response.sendRedirect(RedirectUtil.studentLoginUrl(
                    request.getContextPath(), "student/dashboard.jsp"));
            return;
        }

        String internshipId = request.getParameter("internshipId");
        boolean removed = false;
        try {
            int id = Integer.parseInt(internshipId);
            if (id > 0) {
                removed = bookmarkDAO.removeBookmark(student.getId(), id);
            }
        } catch (NumberFormatException ignored) {
            removed = false;
        }
        response.sendRedirect(request.getContextPath() + "/StudentDashboardServlet?saved="
                + (removed ? "removed" : "error") + "#saved");
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

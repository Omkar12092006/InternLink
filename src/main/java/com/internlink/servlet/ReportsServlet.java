package com.internlink.servlet;

import com.internlink.dao.AdminDAO;
import com.internlink.dao.ApplicationDAO;
import com.internlink.model.Admin;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.Map;

@WebServlet("/ReportsServlet")
public class ReportsServlet extends HttpServlet {

    private final AdminDAO adminDAO = new AdminDAO();
    private final ApplicationDAO applicationDAO = new ApplicationDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !(session.getAttribute("admin") instanceof Admin)) {
            response.sendRedirect(request.getContextPath() + "/admin/login.jsp");
            return;
        }

        try {
            Map<String, Integer> statusCounts = applicationDAO.getApplicationCountsByStatus();
            int totalApplications = statusCounts.values().stream().mapToInt(Integer::intValue).sum();
            int selectedApplications = statusCounts.entrySet().stream()
                    .filter(entry -> "selected".equalsIgnoreCase(entry.getKey()))
                    .mapToInt(Map.Entry::getValue)
                    .sum();

            request.setAttribute("statusCounts", statusCounts);
            request.setAttribute("totalApplications", totalApplications);
            request.setAttribute("selectedApplications", selectedApplications);
            request.setAttribute("selectionRate", totalApplications == 0
                    ? 0 : Math.round(selectedApplications * 100.0 / totalApplications));
            request.setAttribute("internshipCount", adminDAO.getInternshipCount());
            request.setAttribute("reportsReady", Boolean.TRUE);
        } catch (SQLException e) {
            getServletContext().log("Unable to load admin placement reports.", e);
            request.setAttribute("reportsError", "Placement reports are temporarily unavailable.");
        }

        request.getRequestDispatcher("/admin/reports.jsp").forward(request, response);
    }
}

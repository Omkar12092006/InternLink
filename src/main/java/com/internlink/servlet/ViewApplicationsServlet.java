package com.internlink.servlet;

import com.internlink.dao.AdminDAO;
import com.internlink.model.Admin;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/ViewApplicationsServlet")
public class ViewApplicationsServlet extends HttpServlet {

    private final AdminDAO adminDAO = new AdminDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !(session.getAttribute("admin") instanceof Admin)) {
            response.sendRedirect(request.getContextPath() + "/admin/login.jsp");
            return;
        }

        request.setAttribute("applicationsReady", Boolean.TRUE);
        try {
            request.setAttribute("applications", adminDAO.getAllApplications());
        } catch (SQLException e) {
            getServletContext().log("Unable to load admin application list.", e);
            request.setAttribute("applicationsError", "Applications are temporarily unavailable.");
        }
        request.getRequestDispatcher("/admin/viewApplications.jsp").forward(request, response);
    }
}

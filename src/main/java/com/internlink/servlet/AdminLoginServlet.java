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

@WebServlet("/AdminLoginServlet")
public class AdminLoginServlet extends HttpServlet {

    private final AdminDAO adminDAO = new AdminDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        email = email == null ? "" : email.trim();
        String password = request.getParameter("password");

        Admin admin = adminDAO.login(email, password);
        if (admin == null) {
            request.setAttribute("errorMessage", "Invalid email or password.");
            request.getRequestDispatcher("/admin/login.jsp").forward(request, response);
            return;
        }

        HttpSession existingSession = request.getSession(false);
        if (existingSession != null) {
            existingSession.invalidate();
        }
        admin.setPassword(null);
        request.getSession(true).setAttribute("admin", admin);
        response.sendRedirect(request.getContextPath() + "/AdminDashboardServlet");
    }
}

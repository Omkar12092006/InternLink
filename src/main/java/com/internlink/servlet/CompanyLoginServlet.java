package com.internlink.servlet;

import com.internlink.dao.CompanyDAO;
import com.internlink.model.Company;
import com.internlink.util.RedirectUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/CompanyLoginServlet")
public class CompanyLoginServlet extends HttpServlet {
    private final CompanyDAO companyDAO = new CompanyDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email") == null ? "" : request.getParameter("email").trim();
        String password = request.getParameter("password") == null ? "" : request.getParameter("password").trim();

        Company company = companyDAO.authenticate(email, password);
        if (company != null) {
            HttpSession existingSession = request.getSession(false);
            if (existingSession != null) {
                existingSession.invalidate();
            }
            HttpSession session = request.getSession(true);
            session.setAttribute("company", company);
            session.setAttribute("companyId", company.getId());
            session.setAttribute("companyName", company.getCompanyName());
            response.sendRedirect(RedirectUtil.companyAfterLogin(
                    request.getContextPath(), request.getParameter("redirect")));
        } else {
            request.setAttribute("errorMessage", "Invalid company email or password.");
            request.getRequestDispatcher("/company/login.jsp").forward(request, response);
        }
    }
}

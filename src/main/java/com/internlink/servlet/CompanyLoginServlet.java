package com.internlink.servlet;

import com.internlink.dao.CompanyDAO;
import com.internlink.model.Company;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/CompanyLoginServlet")
public class CompanyLoginServlet extends HttpServlet {
    private final CompanyDAO companyDAO = new CompanyDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Company company = companyDAO.authenticate(request.getParameter("email"), request.getParameter("password"));
        if (company != null) {
            HttpSession session = request.getSession(true);
            session.setAttribute("company", company);
            session.setAttribute("companyId", company.getId());
            session.setAttribute("companyName", company.getCompanyName());
            response.sendRedirect(request.getContextPath() + "/company/dashboard.jsp");
        } else {
            request.setAttribute("errorMessage", "Invalid company email or password.");
            request.getRequestDispatcher("/company/login.jsp").forward(request, response);
        }
    }
}

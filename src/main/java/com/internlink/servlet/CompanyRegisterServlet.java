package com.internlink.servlet;

import com.internlink.dao.CompanyDAO;
import com.internlink.model.Company;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/CompanyRegisterServlet")
public class CompanyRegisterServlet extends HttpServlet {
    private final CompanyDAO companyDAO = new CompanyDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String password = request.getParameter("password");
        if (password == null || !password.equals(request.getParameter("confirm_password"))) {
            request.setAttribute("errorMessage", "Passwords do not match.");
            request.getRequestDispatcher("/company/register.jsp").forward(request, response);
            return;
        }
        Company company = new Company();
        company.setCompanyName(request.getParameter("company_name"));
        company.setHrName(request.getParameter("hr_name"));
        company.setIndustry(request.getParameter("industry"));
        company.setEmail(request.getParameter("email"));
        company.setPhone(request.getParameter("phone"));
        company.setWebsite(request.getParameter("website"));
        company.setLocation(request.getParameter("location"));
        company.setDescription(request.getParameter("description"));
        company.setPassword(password);
        if (companyDAO.register(company)) {
            request.setAttribute("successMessage", "Registration successful. You can now sign in.");
            request.getRequestDispatcher("/company/login.jsp").forward(request, response);
        } else {
            request.setAttribute("errorMessage", "Registration failed. Company email may already exist.");
            request.getRequestDispatcher("/company/register.jsp").forward(request, response);
        }
    }
}

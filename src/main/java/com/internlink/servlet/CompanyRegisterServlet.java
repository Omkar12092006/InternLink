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

    public static String validateRegistration(
            String companyName,
            String hrName,
            String industry,
            String email,
            String password,
            String confirmPassword,
            String phone,
            String website,
            String location,
            String description
    ) {
        if (password == null || confirmPassword == null || !password.equals(confirmPassword)) {
            return "Password and confirm password do not match.";
        }
        return null;
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String companyName = request.getParameter("company_name");
        String hrName = request.getParameter("hr_name");
        String industry = request.getParameter("industry");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirm_password");
        String phone = request.getParameter("phone");
        String website = request.getParameter("website");
        String location = request.getParameter("location");
        String description = request.getParameter("description");

        String validationError = validateRegistration(companyName, hrName, industry, email, password, confirmPassword, phone, website, location, description);
        if (validationError != null) {
            request.setAttribute("errorMessage", validationError);
            request.getRequestDispatcher("/company/register.jsp").forward(request, response);
            return;
        }

        Company company = new Company();
        company.setCompanyName(companyName);
        company.setHrName(hrName);
        company.setIndustry(industry);
        company.setEmail(email);
        company.setPhone(phone);
        company.setWebsite(website);
        company.setLocation(location);
        company.setDescription(description);
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

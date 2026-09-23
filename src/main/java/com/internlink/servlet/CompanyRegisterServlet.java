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
            String description) {

        if (companyName == null || companyName.trim().isEmpty()) {
            return "Company name is required.";
        }
        if (hrName == null || hrName.trim().isEmpty()) {
            return "HR contact name is required.";
        }
        if (industry == null || industry.trim().isEmpty()) {
            return "Industry is required.";
        }
        if (email == null || email.trim().isEmpty()) {
            return "Company email is required.";
        }
        if (password == null || password.trim().isEmpty()) {
            return "Password is required.";
        }
        if (confirmPassword == null || confirmPassword.trim().isEmpty()) {
            return "Please confirm your password.";
        }
        if (!password.equals(confirmPassword)) {
            return "Password and confirm password do not match.";
        }
        if (phone == null || phone.trim().isEmpty()) {
            return "Phone number is required.";
        }
        if (location == null || location.trim().isEmpty()) {
            return "Location is required.";
        }
        if (description == null || description.trim().isEmpty()) {
            return "Company description is required.";
        }
        return null;
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String companyName = trimToNull(request.getParameter("company_name"));
        String hrName = trimToNull(request.getParameter("hr_name"));
        String industry = trimToNull(request.getParameter("industry"));
        String email = trimToNull(request.getParameter("email"));
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirm_password");
        String phone = trimToNull(request.getParameter("phone"));
        String website = trimToNull(request.getParameter("website"));
        String location = trimToNull(request.getParameter("location"));
        String description = trimToNull(request.getParameter("description"));

        String validationError = validateRegistration(
                companyName, hrName, industry, email, password, confirmPassword, phone, website, location, description);
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
        company.setPassword(password);
        company.setPhone(phone);
        company.setWebsite(website);
        company.setLocation(location);
        company.setDescription(description);

        boolean success = companyDAO.registerCompany(company);
        if (success) {
            request.setAttribute("successMessage", "Registration successful! Please log in.");
            request.getRequestDispatcher("/company/login.jsp").forward(request, response);
        } else {
            request.setAttribute("errorMessage", "Registration failed. The email may already be registered or the database is unavailable.");
            request.getRequestDispatcher("/company/register.jsp").forward(request, response);
        }
    }

    private String trimToNull(String value) {
        return value == null ? null : value.trim();
    }
}

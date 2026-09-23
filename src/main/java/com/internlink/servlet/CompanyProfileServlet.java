package com.internlink.servlet;

import com.internlink.dao.CompanyDAO;
import com.internlink.model.Company;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "CompanyProfileServlet", urlPatterns = {"/CompanyProfileServlet"})
public class CompanyProfileServlet extends HttpServlet {

    private final CompanyDAO companyDAO = new CompanyDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Company company = getLoggedInCompany(request);

        if (company == null) {
            response.sendRedirect(request.getContextPath() + "/company/login.jsp");
            return;
        }

        request.setAttribute("company", company);
        request.getRequestDispatcher("/company/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Company company = getLoggedInCompany(request);

        if (company == null) {
            response.sendRedirect(request.getContextPath() + "/company/login.jsp");
            return;
        }

        company.setCompanyName(trimToNull(request.getParameter("companyName")));
        company.setHrName(trimToNull(request.getParameter("hrName")));
        company.setIndustry(trimToNull(request.getParameter("industry")));
        company.setEmail(trimToNull(request.getParameter("email")));
        company.setPhone(trimToNull(request.getParameter("phone")));
        company.setWebsite(trimToNull(request.getParameter("website")));
        company.setLocation(trimToNull(request.getParameter("location")));
        company.setDescription(trimToNull(request.getParameter("description")));

        boolean success = companyDAO.updateCompany(company);
        if (success) {
            HttpSession session = request.getSession();
            session.setAttribute("company", company);
            session.setAttribute("companyName", company.getCompanyName());
            session.setAttribute("companyEmail", company.getEmail());
            request.setAttribute("successMessage", "Profile updated successfully.");
        } else {
            request.setAttribute("errorMessage", "Unable to update your profile.");
        }

        request.setAttribute("company", company);
        request.getRequestDispatcher("/company/profile.jsp").forward(request, response);
    }

    private Company getLoggedInCompany(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return null;
        }
        Object value = session.getAttribute("company");
        return value instanceof Company ? (Company) value : null;
    }

    private String trimToNull(String value) {
        if (value == null) {
            return null;
        }
        String trimmed = value.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }
}

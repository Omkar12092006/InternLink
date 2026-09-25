package com.internlink.servlet;

import com.internlink.dao.ApplicationDAO;
import com.internlink.model.Application;
import com.internlink.model.Company;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/ReviewApplicationsServlet")
public class ReviewApplicationsServlet extends HttpServlet {

    private final ApplicationDAO applicationDAO = new ApplicationDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Company company = getLoggedInCompany(request);
        if (company == null) {
            response.sendRedirect(request.getContextPath() + "/company/login.jsp");
            return;
        }

        List<Application> applications = applicationDAO.getApplicationsByCompanyId(company.getId());
        request.setAttribute("applications", applications);
        request.getRequestDispatcher("/company/reviewApplications.jsp").forward(request, response);
    }

    private Company getLoggedInCompany(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return null;
        }

        Object value = session.getAttribute("company");
        return value instanceof Company ? (Company) value : null;
    }
}

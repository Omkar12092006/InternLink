package com.internlink.servlet;

import com.internlink.dao.ApplicationDAO;
import com.internlink.model.Application;
import com.internlink.model.Company;
import com.internlink.util.RedirectUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/UpdateApplicationStatusServlet")
public class UpdateApplicationStatusServlet extends HttpServlet {

    private final ApplicationDAO applicationDAO = new ApplicationDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Company company = getLoggedInCompany(request);
        if (company == null) {
            response.sendRedirect(RedirectUtil.companyLoginUrl(
                    request.getContextPath(), "ReviewApplicationsServlet"));
            return;
        }

        String applicationIdParam = request.getParameter("applicationId");
        String action = request.getParameter("action");
        String status = request.getParameter("status");

        if (applicationIdParam == null || applicationIdParam.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/ReviewApplicationsServlet?error=missing_application");
            return;
        }

        try {
            int applicationId = Integer.parseInt(applicationIdParam);
            String requestedStatus = resolveStatus(action, status);

            if (requestedStatus == null) {
                response.sendRedirect(request.getContextPath() + "/ReviewApplicationsServlet?error=invalid_status");
                return;
            }

            List<Application> companyApplications = applicationDAO.getApplicationsByCompanyId(company.getId());
            boolean belongsToCompany = companyApplications.stream().anyMatch(app -> app.getId() == applicationId);
            if (!belongsToCompany) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "You do not have permission to update this application.");
                return;
            }

            boolean updated = applicationDAO.updateStatus(applicationId, requestedStatus);
            if (updated) {
                response.sendRedirect(request.getContextPath() + "/ReviewApplicationsServlet?success=updated");
            } else {
                response.sendRedirect(request.getContextPath() + "/ReviewApplicationsServlet?error=not_updated");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/ReviewApplicationsServlet?error=invalid_application");
        }
    }

    private String resolveStatus(String action, String status) {
        String requested = status != null && !status.isBlank() ? status : action;
        if (requested == null || requested.isBlank()) {
            return null;
        }

        switch (requested.toLowerCase()) {
            case "shortlist":
            case "shortlisted":
                return "Shortlisted";
            case "reject":
            case "rejected":
                return "Rejected";
            case "select":
            case "selected":
                return "Selected";
            case "pending":
                return "Pending";
            default:
                return requested;
        }
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

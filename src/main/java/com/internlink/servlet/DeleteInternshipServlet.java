package com.internlink.servlet;

import com.internlink.dao.InternshipDAO;
import com.internlink.model.Company;
import com.internlink.model.Internship;
import com.internlink.util.RedirectUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/DeleteInternshipServlet")
public class DeleteInternshipServlet extends HttpServlet {

    private final InternshipDAO internshipDAO = new InternshipDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Company company = getLoggedInCompany(request);
        if (company == null) {
            response.sendRedirect(RedirectUtil.companyLoginUrl(
                    request.getContextPath(), "company/postings.jsp"));
            return;
        }

        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/company/postings.jsp?success=error");
            return;
        }

        int internshipId;
        try {
            internshipId = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/company/postings.jsp?success=error");
            return;
        }

        Internship internship = internshipDAO.getInternshipById(internshipId);
        if (internship == null || internship.getCompanyId() != company.getId()) {
            response.sendRedirect(request.getContextPath() + "/company/postings.jsp?success=error");
            return;
        }

        boolean success = internshipDAO.delete(internship.getId());
        response.sendRedirect(request.getContextPath() + "/company/postings.jsp?success=" + (success ? "deleted" : "error"));
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

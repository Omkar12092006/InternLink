package com.internlink.servlet;

import com.internlink.dao.InternshipDAO;
import com.internlink.model.Company;
import com.internlink.model.Internship;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.LocalDate;

@WebServlet("/EditInternshipServlet")
public class EditInternshipServlet extends HttpServlet {

    private final InternshipDAO internshipDAO = new InternshipDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Company company = getLoggedInCompany(request);
        if (company == null) {
            response.sendRedirect(request.getContextPath() + "/company/login.jsp");
            return;
        }

        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/company/postings.jsp");
            return;
        }

        int internshipId;
        try {
            internshipId = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/company/postings.jsp");
            return;
        }

        Internship existing = internshipDAO.getInternshipById(internshipId);
        if (existing == null || existing.getCompanyId() != company.getId()) {
            response.sendRedirect(request.getContextPath() + "/company/postings.jsp");
            return;
        }

        Internship updated = buildInternshipFromRequest(request, company, existing);
        if (updated == null) {
            request.setAttribute("errorMessage", "Please fill in the required internship details.");
            request.setAttribute("internship", existing);
            request.getRequestDispatcher("/company/postInternship.jsp").forward(request, response);
            return;
        }

        boolean success = internshipDAO.update(updated);
        if (success) {
            response.sendRedirect(request.getContextPath() + "/company/postings.jsp?success=updated");
        } else {
            request.setAttribute("errorMessage", "Unable to update this internship listing.");
            request.setAttribute("internship", existing);
            request.getRequestDispatcher("/company/postInternship.jsp").forward(request, response);
        }
    }

    private Internship buildInternshipFromRequest(HttpServletRequest request, Company company, Internship existing) {
        String title = trimToNull(request.getParameter("title"));
        String category = trimToNull(request.getParameter("category"));
        String location = trimToNull(request.getParameter("location"));
        String duration = trimToNull(request.getParameter("duration"));
        String description = trimToNull(request.getParameter("description"));
        String skills = trimToNull(request.getParameter("skills"));
        String stipend = trimToNull(request.getParameter("stipend"));

        if (title == null || category == null || location == null || duration == null || description == null || skills == null) {
            return null;
        }

        Internship internship = new Internship();
        internship.setId(existing.getId());
        internship.setCompanyId(company.getId());
        internship.setCompany(company.getCompanyName());
        internship.setTitle(title);
        internship.setCategory(category);
        internship.setLocation(location);
        internship.setDuration(duration);
        internship.setDescription(description);
        internship.setSkills(skills);
        internship.setPaid("paid".equalsIgnoreCase(request.getParameter("payType")));
        internship.setStipend(internship.isPaid() ? (stipend == null ? "$0" : stipend) : "Unpaid");
        internship.setApplicants(existing.getApplicants());
        internship.setPostedDate(existing.getPostedDate() != null ? existing.getPostedDate() : LocalDate.now());
        internship.setEmoji(request.getParameter("emoji") == null || request.getParameter("emoji").trim().isEmpty() ? "work" : request.getParameter("emoji").trim());
        internship.setColor(request.getParameter("color") == null || request.getParameter("color").trim().isEmpty() ? "#22C55E" : request.getParameter("color").trim());
        return internship;
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

package com.internlink.servlet;

import com.internlink.dao.ApplicationDAO;
import com.internlink.model.Company;
import com.internlink.util.RedirectUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/CompanyCandidatesServlet")
public class CompanyCandidatesServlet extends HttpServlet {

    private final ApplicationDAO applicationDAO = new ApplicationDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Object value = session == null ? null : session.getAttribute("company");
        if (!(value instanceof Company)) {
            response.sendRedirect(RedirectUtil.companyLoginUrl(
                    request.getContextPath(), "company/candidates.jsp"));
            return;
        }

        Company company = (Company) value;
        request.setAttribute("company", company);
        request.setAttribute("applications", applicationDAO.getApplicationsByCompanyId(company.getId()));
        request.getRequestDispatcher("/company/candidates.jsp").forward(request, response);
    }
}

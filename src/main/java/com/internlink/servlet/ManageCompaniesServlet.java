package com.internlink.servlet;

import com.internlink.dao.AdminDAO;
import com.internlink.model.Admin;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/ManageCompaniesServlet")
public class ManageCompaniesServlet extends HttpServlet {

    private final AdminDAO adminDAO = new AdminDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!requireAdmin(request, response)) {
            return;
        }

        request.setAttribute("managementReady", Boolean.TRUE);
        try {
            request.setAttribute("companies", adminDAO.getAllCompanies());
        } catch (SQLException e) {
            getServletContext().log("Unable to load company account management.", e);
            request.setAttribute("managementError", "Company accounts are temporarily unavailable.");
        }

        setResultMessage(request);
        request.getRequestDispatcher("/admin/manageCompanies.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!requireAdmin(request, response)) {
            return;
        }

        String result = "failed";
        try {
            int companyId = parseId(request.getParameter("companyId"));
            String action = request.getParameter("action");
            if ("verify".equals(action)) {
                result = adminDAO.verifyCompany(companyId) ? "verified" : "not-found";
            } else if ("reject".equals(action)) {
                result = adminDAO.rejectCompany(companyId) ? "rejected" : "not-found";
            } else if ("delete".equals(action)) {
                result = adminDAO.deleteCompany(companyId) ? "deleted" : "not-found";
            } else {
                result = "invalid-action";
            }
        } catch (SQLException e) {
            getServletContext().log("Unable to update company account.", e);
        } catch (IllegalArgumentException e) {
            result = "invalid-input";
        }

        response.sendRedirect(request.getContextPath() + "/ManageCompaniesServlet?result=" + result);
    }

    private boolean requireAdmin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !(session.getAttribute("admin") instanceof Admin)) {
            response.sendRedirect(request.getContextPath() + "/admin/login.jsp");
            return false;
        }
        return true;
    }

    private int parseId(String value) {
        try {
            int id = Integer.parseInt(value);
            if (id > 0) {
                return id;
            }
        } catch (NumberFormatException ignored) {
            // Report malformed IDs as invalid input to the admin UI.
        }
        throw new IllegalArgumentException("A valid company ID is required.");
    }

    private void setResultMessage(HttpServletRequest request) {
        switch (String.valueOf(request.getParameter("result"))) {
            case "verified":
                request.setAttribute("managementMessage", "Company verified.");
                break;
            case "rejected":
                request.setAttribute("managementMessage", "Company verification rejected.");
                break;
            case "deleted":
                request.setAttribute("managementMessage", "Company account deleted.");
                break;
            case "not-found":
                request.setAttribute("managementError", "The company account was not found.");
                break;
            case "invalid-input":
                request.setAttribute("managementError", "Select a valid company account.");
                break;
            case "invalid-action":
                request.setAttribute("managementError", "The requested action is not supported.");
                break;
            case "failed":
                if (request.getParameter("result") != null) {
                    request.setAttribute("managementError", "The company account could not be updated.");
                }
                break;
            default:
                break;
        }
    }
}

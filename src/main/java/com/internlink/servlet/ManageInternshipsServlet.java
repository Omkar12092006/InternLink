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

@WebServlet("/ManageInternshipsServlet")
public class ManageInternshipsServlet extends HttpServlet {

    private final AdminDAO adminDAO = new AdminDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!requireAdmin(request, response)) {
            return;
        }

        request.setAttribute("moderationReady", Boolean.TRUE);
        try {
            request.setAttribute("internships", adminDAO.getAllInternships());
        } catch (SQLException e) {
            getServletContext().log("Unable to load internship moderation.", e);
            request.setAttribute("moderationError", "Internship postings are temporarily unavailable.");
        }
        setResultMessage(request);
        request.getRequestDispatcher("/admin/manageInternships.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!requireAdmin(request, response)) {
            return;
        }

        String result = "failed";
        try {
            int internshipId = parseId(request.getParameter("internshipId"));
            String action = request.getParameter("action");
            if ("approve".equals(action)) {
                result = adminDAO.approveInternship(internshipId) ? "approved" : "not-found";
            } else if ("delete".equals(action)) {
                result = adminDAO.deleteInternship(internshipId) ? "deleted" : "not-found";
            } else {
                result = "invalid-action";
            }
        } catch (SQLException e) {
            getServletContext().log("Unable to moderate internship posting.", e);
        } catch (IllegalArgumentException e) {
            result = "invalid-input";
        }

        response.sendRedirect(request.getContextPath() + "/ManageInternshipsServlet?result=" + result);
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
        throw new IllegalArgumentException("A valid internship ID is required.");
    }

    private void setResultMessage(HttpServletRequest request) {
        switch (String.valueOf(request.getParameter("result"))) {
            case "approved":
                request.setAttribute("moderationMessage", "Internship posting approved and published.");
                break;
            case "deleted":
                request.setAttribute("moderationMessage", "Internship posting removed.");
                break;
            case "not-found":
                request.setAttribute("moderationError", "The internship posting was not found.");
                break;
            case "invalid-input":
                request.setAttribute("moderationError", "Select a valid internship posting.");
                break;
            case "invalid-action":
                request.setAttribute("moderationError", "The requested action is not supported.");
                break;
            case "failed":
                if (request.getParameter("result") != null) {
                    request.setAttribute("moderationError", "The internship posting could not be updated.");
                }
                break;
            default:
                break;
        }
    }
}

package com.internlink.servlet;

import com.internlink.dao.InterviewDAO;
import com.internlink.model.Application;
import com.internlink.model.Company;
import com.internlink.model.Interview;
import com.internlink.util.RedirectUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/ScheduleInterviewServlet")
public class ScheduleInterviewServlet extends HttpServlet {

    private final InterviewDAO interviewDAO = new InterviewDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Company company = getLoggedInCompany(request);
        if (company == null) {
            response.sendRedirect(RedirectUtil.companyLoginUrl(
                    request.getContextPath(), "ScheduleInterviewServlet"));
            return;
        }

        try {
            List<Application> applications = interviewDAO.getApplicationsForSchedulingByCompanyId(company.getId());
            List<Interview> interviews = interviewDAO.getByCompanyId(company.getId());
            Map<Integer, Interview> interviewsByApplication = new HashMap<>();
            for (Interview interview : interviews) {
                interviewsByApplication.put(interview.getApplicationId(), interview);
            }
            request.setAttribute("applications", applications);
            request.setAttribute("interviews", interviews);
            request.setAttribute("interviewsByApplication", interviewsByApplication);
            request.setAttribute("scheduleReady", Boolean.TRUE);
        } catch (SQLException e) {
            getServletContext().log("Unable to load company interview scheduling.", e);
            request.setAttribute("scheduleError", "Interview scheduling is temporarily unavailable.");
        }
        setResultMessage(request);
        request.getRequestDispatcher("/company/scheduleInterview.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Company company = getLoggedInCompany(request);
        if (company == null) {
            response.sendRedirect(RedirectUtil.companyLoginUrl(
                    request.getContextPath(), "ScheduleInterviewServlet"));
            return;
        }

        String result;
        try {
            String action = request.getParameter("action");
            Interview interview = readInterview(request);
            boolean updated;
            if ("schedule".equals(action)) {
                updated = interviewDAO.schedule(interview, company.getId());
            } else if ("update".equals(action)) {
                interview.setId(parseId(request.getParameter("interviewId")));
                interview.setStatus(normalizeInterviewStatus(request.getParameter("status")));
                updated = interviewDAO.update(interview, company.getId());
            } else {
                result = "invalid";
                response.sendRedirect(request.getContextPath() + "/ScheduleInterviewServlet?result=" + result);
                return;
            }
            result = updated ? ("schedule".equals(action) ? "scheduled" : "updated") : "failed";
        } catch (IllegalArgumentException e) {
            result = "invalid";
        } catch (SQLException e) {
            getServletContext().log("Unable to save company interview.", e);
            result = "failed";
        }
        response.sendRedirect(request.getContextPath() + "/ScheduleInterviewServlet?result=" + result);
    }

    private Interview readInterview(HttpServletRequest request) {
        Interview interview = new Interview();
        interview.setApplicationId(parseId(request.getParameter("applicationId")));
        String scheduledAt = request.getParameter("scheduledAt");
        if (scheduledAt == null || scheduledAt.isBlank()) {
            throw new IllegalArgumentException("Select an interview date and time.");
        }
        interview.setScheduledAt(LocalDateTime.parse(scheduledAt));
        interview.setMode(request.getParameter("mode"));
        interview.setMeetingLink(trimToNull(request.getParameter("meetingLink")));
        interview.setNotes(trimToNull(request.getParameter("notes")));
        return interview;
    }

    private String normalizeInterviewStatus(String status) {
        if ("Scheduled".equals(status) || "Completed".equals(status) || "Cancelled".equals(status)) {
            return status;
        }
        throw new IllegalArgumentException("Select a valid interview status.");
    }

    private int parseId(String value) {
        try {
            int id = Integer.parseInt(value);
            if (id > 0) {
                return id;
            }
        } catch (NumberFormatException ignored) {
            // Invalid IDs are shown as a form validation message.
        }
        throw new IllegalArgumentException("A valid application is required.");
    }

    private String trimToNull(String value) {
        String trimmed = value == null ? "" : value.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }

    private Company getLoggedInCompany(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return null;
        }
        Object value = session.getAttribute("company");
        return value instanceof Company ? (Company) value : null;
    }

    private void setResultMessage(HttpServletRequest request) {
        switch (String.valueOf(request.getParameter("result"))) {
            case "scheduled":
                request.setAttribute("scheduleMessage", "Interview scheduled and applicant notified in their workspace.");
                break;
            case "updated":
                request.setAttribute("scheduleMessage", "Interview details and status updated.");
                break;
            case "invalid":
                request.setAttribute("scheduleError", "Check the application, future date/time, interview mode, and meeting link.");
                break;
            case "failed":
                request.setAttribute("scheduleError", "The interview could not be saved. It may already be scheduled.");
                break;
            default:
                break;
        }
    }
}

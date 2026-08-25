package com.internlink.servlet;

import com.internlink.dao.ApplicationDAO;
import com.internlink.dao.InternshipDAO;
import com.internlink.model.Application;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/ApplyServlet")
public class ApplyServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String jobIdStr = request.getParameter("jobId");
        String applicantName = request.getParameter("applicantName");
        String applicantEmail = request.getParameter("applicantEmail");
        String university = request.getParameter("university");
        String coverLetter = request.getParameter("coverLetter");
        String resumeLink = request.getParameter("resumeLink");

        try {
            int jobId = Integer.parseInt(jobIdStr);

            ApplicationDAO applicationDAO = new ApplicationDAO();
            InternshipDAO internshipDAO = new InternshipDAO();

            if (applicationDAO.hasAlreadyApplied(jobId, applicantEmail)) {
                response.sendRedirect(request.getContextPath() + "/browseInternships.jsp?error=already_applied");
                return;
            }

            Application application = new Application(jobId, applicantName, applicantEmail, university, coverLetter, resumeLink);
            boolean success = applicationDAO.submitApplication(application);

            if (success) {
                internshipDAO.incrementApplicants(jobId);
                response.sendRedirect(request.getContextPath() + "/browseInternships.jsp?success=true");
            } else {
                response.sendRedirect(request.getContextPath() + "/browseInternships.jsp?error=failed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/browseInternships.jsp?error=exception");
        }
    }
}

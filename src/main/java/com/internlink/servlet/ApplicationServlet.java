package com.internlink.servlet;

import com.internlink.dao.ApplicationDAO;
import com.internlink.model.Student;
import com.google.gson.Gson;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/ApplicationServlet")
public class ApplicationServlet extends HttpServlet {

    private final ApplicationDAO applicationDAO = new ApplicationDAO();
    private final Gson gson = new Gson();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        Map<String, Object> result = new HashMap<>();

        HttpSession session = request.getSession(false);
        Student student = (session != null) ? (Student) session.getAttribute("student") : null;

        if (student == null) {
            response.setStatus(401);
            result.put("success", false);
            result.put("redirect", request.getContextPath() + "/student/login.jsp");
            result.put("message", "Please log in to apply for internships.");
            out.print(gson.toJson(result));
            return;
        }

        try {
            int internshipId = Integer.parseInt(request.getParameter("internshipId"));
            String email = student.getEmail();
            String name = request.getParameter("name");
            if (name == null || name.trim().isEmpty()) name = student.getFullName();
            String university = request.getParameter("university");
            if (university == null) university = "";
            String coverLetter = request.getParameter("coverLetter");
            if (coverLetter == null) coverLetter = "";

            if (applicationDAO.hasApplied(internshipId, email)) {
                result.put("success", false);
                result.put("alreadyApplied", true);
                result.put("message", "You have already applied for this internship.");
            } else {
                boolean applied = applicationDAO.apply(internshipId, name, email, university, coverLetter);
                if (applied) {
                    result.put("success", true);
                    result.put("message", "Application submitted successfully!");
                } else {
                    result.put("success", false);
                    result.put("message", "Failed to submit application. You may have already applied.");
                }
            }
        } catch (NumberFormatException e) {
            response.setStatus(400);
            result.put("success", false);
            result.put("message", "Invalid internship ID.");
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(500);
            result.put("success", false);
            result.put("message", "An error occurred. Please try again.");
        }

        out.print(gson.toJson(result));
    }
}

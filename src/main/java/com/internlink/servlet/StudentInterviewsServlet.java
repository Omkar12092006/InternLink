package com.internlink.servlet;

import com.internlink.dao.InterviewDAO;
import com.internlink.model.Interview;
import com.internlink.model.Student;
import com.internlink.util.RedirectUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/StudentInterviewsServlet")
public class StudentInterviewsServlet extends HttpServlet {

    private final InterviewDAO interviewDAO = new InterviewDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Student student = getLoggedInStudent(request);
        if (student == null) {
            response.sendRedirect(RedirectUtil.studentLoginUrl(
                    request.getContextPath(), "StudentInterviewsServlet"));
            return;
        }

        try {
            List<Interview> interviews = interviewDAO.getByStudentId(student.getId());
            request.setAttribute("interviews", interviews);
            request.setAttribute("interviewsReady", Boolean.TRUE);
        } catch (SQLException e) {
            getServletContext().log("Unable to load student interviews.", e);
            request.setAttribute("interviewsError", "Your interviews are temporarily unavailable.");
        }
        request.setAttribute("student", student);
        request.getRequestDispatcher("/student/interviews.jsp").forward(request, response);
    }

    private Student getLoggedInStudent(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return null;
        }
        Object value = session.getAttribute("student");
        return value instanceof Student ? (Student) value : null;
    }
}

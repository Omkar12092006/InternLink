package com.internlink.servlet;

import com.internlink.dao.StudentDAO;
import com.internlink.model.Student;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/StudentLoginServlet")
public class StudentLoginServlet extends HttpServlet {

    private final StudentDAO studentDAO = new StudentDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {
            Student student = studentDAO.getStudentByEmailAndPassword(email, password);

            if (student != null) {
                HttpSession session = request.getSession(true);
                session.setAttribute("student", student);
                session.setAttribute("studentId", student.getId());
                session.setAttribute("studentName", student.getFullName());
                session.setAttribute("studentEmail", student.getEmail());
                response.sendRedirect(request.getContextPath() + "/student/dashboard.jsp");
            } else {
                request.setAttribute("errorMessage", "Invalid Email or Password");
                request.getRequestDispatcher("/student/login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "A system error occurred. Please try again later.");
            request.getRequestDispatcher("/student/login.jsp").forward(request, response);
        }
    }
}

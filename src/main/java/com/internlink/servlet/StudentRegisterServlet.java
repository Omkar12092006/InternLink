package com.internlink.servlet;

import com.internlink.dao.StudentDAO;
import com.internlink.model.Student;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/StudentRegisterServlet")
public class StudentRegisterServlet extends HttpServlet {

    private final StudentDAO studentDAO = new StudentDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String phone = request.getParameter("phone");
        String course = request.getParameter("course");

        try {
            Student student = new Student();
            student.setFullName(fullName);
            student.setEmail(email);
            student.setPassword(password);
            student.setPhone(phone);
            student.setCourse(course);

            boolean success = studentDAO.registerStudent(student);

            if (success) {
                request.setAttribute("successMessage", "Registration successful! Please log in.");
                request.getRequestDispatcher("/student/login.jsp").forward(request, response);
            } else {
                request.setAttribute("errorMessage", "Registration failed. Email may already exist.");
                request.getRequestDispatcher("/student/register.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred. Please try again.");
            request.getRequestDispatcher("/student/register.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Student Registration Servlet";
    }
}

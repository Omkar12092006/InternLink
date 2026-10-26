package com.internlink.servlet;

import com.internlink.dao.StudentDAO;
import com.internlink.model.Student;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/StudentProfileServlet")
public class StudentProfileServlet extends HttpServlet {

    private final StudentDAO studentDAO = new StudentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Student student = getLoggedInStudent(request);
        if (student == null) {
            response.sendRedirect(request.getContextPath() + "/student/login.jsp");
            return;
        }

        try {
            Student savedStudent = studentDAO.getStudentById(student.getId());
            if (savedStudent == null) {
                response.sendRedirect(request.getContextPath() + "/LogoutServlet");
                return;
            }
            savedStudent.setPassword(null);
            request.getSession(false).setAttribute("student", savedStudent);
            request.setAttribute("student", savedStudent);
        } catch (SQLException e) {
            getServletContext().log("Unable to load student profile.", e);
            request.setAttribute("profileError", "Your profile is temporarily unavailable.");
            request.setAttribute("student", student);
        }

        setResultMessage(request);
        request.getRequestDispatcher("/student/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Student student = getLoggedInStudent(request);
        if (student == null) {
            response.sendRedirect(request.getContextPath() + "/student/login.jsp");
            return;
        }

        String result;
        try {
            String previousEmail = student.getEmail();
            student.setFullName(request.getParameter("fullName"));
            student.setEmail(request.getParameter("email"));
            student.setPhone(request.getParameter("phone"));
            student.setCourse(request.getParameter("course"));
            if (studentDAO.updateStudent(student, previousEmail)) {
                HttpSession session = request.getSession(false);
                session.setAttribute("student", student);
                session.setAttribute("studentName", student.getFullName());
                session.setAttribute("studentEmail", student.getEmail());
                result = "updated";
            } else {
                result = "not-found";
            }
        } catch (IllegalArgumentException e) {
            result = "invalid";
        } catch (SQLException e) {
            getServletContext().log("Unable to update student profile.", e);
            result = "failed";
        }

        response.sendRedirect(request.getContextPath() + "/StudentProfileServlet?result=" + result);
    }

    private Student getLoggedInStudent(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return null;
        }
        Object value = session.getAttribute("student");
        return value instanceof Student ? (Student) value : null;
    }

    private void setResultMessage(HttpServletRequest request) {
        switch (String.valueOf(request.getParameter("result"))) {
            case "updated":
                request.setAttribute("profileMessage", "Your profile was updated.");
                break;
            case "not-found":
                request.setAttribute("profileError", "Your student account could not be found.");
                break;
            case "invalid":
                request.setAttribute("profileError", "Enter a valid name and email address.");
                break;
            case "failed":
                request.setAttribute("profileError", "Your profile could not be updated. Check whether the email is already in use.");
                break;
            default:
                break;
        }
    }
}

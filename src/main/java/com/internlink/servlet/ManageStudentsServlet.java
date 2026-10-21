package com.internlink.servlet;

import com.internlink.dao.AdminDAO;
import com.internlink.model.Admin;
import com.internlink.model.Student;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/ManageStudentsServlet")
public class ManageStudentsServlet extends HttpServlet {

    private final AdminDAO adminDAO = new AdminDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!requireAdmin(request, response)) {
            return;
        }

        request.setAttribute("managementReady", Boolean.TRUE);
        try {
            List<Student> students = adminDAO.getAllStudents();
            request.setAttribute("students", students);

            String editId = request.getParameter("edit");
            if (editId != null) {
                try {
                    int studentId = parseId(editId);
                    Student editingStudent = students.stream()
                            .filter(student -> student.getId() == studentId)
                            .findFirst()
                            .orElse(null);
                    if (editingStudent == null) {
                        request.setAttribute("managementError", "The student account was not found.");
                    } else {
                        request.setAttribute("editingStudent", editingStudent);
                    }
                } catch (IllegalArgumentException e) {
                    request.setAttribute("managementError", "Select a valid student account to edit.");
                }
            }
        } catch (SQLException e) {
            getServletContext().log("Unable to load student account management.", e);
            request.setAttribute("managementError", "Student accounts are temporarily unavailable.");
        }

        setResultMessage(request);
        request.getRequestDispatcher("/admin/manageStudents.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!requireAdmin(request, response)) {
            return;
        }

        String result = "failed";
        try {
            String action = request.getParameter("action");
            int studentId = parseId(request.getParameter("studentId"));
            if ("delete".equals(action)) {
                result = adminDAO.deleteStudent(studentId) ? "deleted" : "not-found";
            } else if ("update".equals(action)) {
                Student student = new Student();
                student.setId(studentId);
                student.setFullName(required(request.getParameter("fullName"), "Full name"));
                student.setEmail(required(request.getParameter("email"), "Email").toLowerCase(java.util.Locale.ROOT));
                student.setPhone(trimToNull(request.getParameter("phone")));
                student.setCourse(trimToNull(request.getParameter("course")));
                if (!student.getEmail().matches("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$")) {
                    throw new IllegalArgumentException("Enter a valid email address.");
                }
                result = adminDAO.updateStudent(student) ? "updated" : "not-found";
            } else {
                result = "invalid-action";
            }
        } catch (SQLException e) {
            getServletContext().log("Unable to update student account.", e);
        } catch (IllegalArgumentException e) {
            result = "invalid-input";
        }

        response.sendRedirect(request.getContextPath() + "/ManageStudentsServlet?result=" + result);
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
        throw new IllegalArgumentException("A valid student ID is required.");
    }

    private String required(String value, String fieldName) {
        String trimmed = value == null ? "" : value.trim();
        if (trimmed.isEmpty()) {
            throw new IllegalArgumentException(fieldName + " is required.");
        }
        return trimmed;
    }

    private String trimToNull(String value) {
        String trimmed = value == null ? "" : value.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }

    private void setResultMessage(HttpServletRequest request) {
        switch (String.valueOf(request.getParameter("result"))) {
            case "updated":
                request.setAttribute("managementMessage", "Student account updated.");
                break;
            case "deleted":
                request.setAttribute("managementMessage", "Student account deleted.");
                break;
            case "not-found":
                request.setAttribute("managementError", "The student account was not found.");
                break;
            case "invalid-input":
                request.setAttribute("managementError", "Enter valid student details and try again.");
                break;
            case "invalid-action":
                request.setAttribute("managementError", "The requested action is not supported.");
                break;
            case "failed":
                if (request.getParameter("result") != null) {
                    request.setAttribute("managementError", "The student account could not be updated.");
                }
                break;
            default:
                break;
        }
    }
}

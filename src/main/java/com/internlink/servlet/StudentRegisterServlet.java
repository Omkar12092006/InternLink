package com.internlink.servlet;

import com.internlink.util.DBConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/StudentRegisterServlet")
public class StudentRegisterServlet extends HttpServlet {
@Override
protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    String fullName = request.getParameter("fullName");
    String email = request.getParameter("email");
    String password = request.getParameter("password");
    String phone = request.getParameter("phone");
    String course = request.getParameter("course");

    System.out.println("Full Name: " + fullName);
    System.out.println("Email: " + email);
    System.out.println("Phone: " + phone);
    System.out.println("Course: " + course);

    try {
        Connection con = DBConnection.getConnection();

        String sql = "INSERT INTO students(full_name,email,password,phone,course) VALUES(?,?,?,?,?)";

        PreparedStatement ps = con.prepareStatement(sql);

        ps.setString(1, fullName);
        ps.setString(2, email);
        ps.setString(3, password);
        ps.setString(4, phone);
        ps.setString(5, course);

        int result = ps.executeUpdate();

        if (result > 0) {
            response.sendRedirect("student/login.jsp");
        } else {
            response.getWriter().println("Registration Failed!");
        }

        ps.close();
        con.close();

    } catch (Exception e) {
        e.printStackTrace();
        response.getWriter().println("Error: " + e.getMessage());
    }
}
    @Override
    public String getServletInfo() {
        return "Student Registration Servlet";
    }
}
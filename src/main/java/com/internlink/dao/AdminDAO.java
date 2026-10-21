package com.internlink.dao;

import com.internlink.model.Admin;
import com.internlink.model.Company;
import com.internlink.model.Student;
import com.internlink.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AdminDAO {
    public Admin login(String email, String password) {
        String sql = "SELECT * FROM admins WHERE email=? AND password=?";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email); ps.setString(2, password);
            try (ResultSet rs = ps.executeQuery()) { return rs.next() ? mapAdmin(rs) : null; }
        } catch (SQLException e) { e.printStackTrace(); return null; }
    }

    public int getStudentCount() throws SQLException {
        return getCount("SELECT COUNT(*) FROM students");
    }

    public int getCompanyCount() throws SQLException {
        return getCount("SELECT COUNT(*) FROM companies");
    }

    public int getInternshipCount() throws SQLException {
        return getCount("SELECT COUNT(*) FROM internships");
    }

    public int getApplicationCount() throws SQLException {
        return getCount("SELECT COUNT(*) FROM applications");
    }

    private int getCount(String sql) throws SQLException {
        Connection connection = DBConnection.getConnection();
        if (connection == null) {
            throw new SQLException("Could not connect to the database.");
        }
        try (Connection con = connection;
             PreparedStatement statement = con.prepareStatement(sql);
             ResultSet result = statement.executeQuery()) {
            if (!result.next()) {
                throw new SQLException("The dashboard count query returned no result.");
            }
            return result.getInt(1);
        }
    }

    public Admin getById(int id) {
        String sql = "SELECT * FROM admins WHERE id=?";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) { return rs.next() ? mapAdmin(rs) : null; }
        } catch (SQLException e) { e.printStackTrace(); return null; }
    }

    public List<Student> getAllStudents() throws SQLException {
        List<Student> students = new ArrayList<>();
        Connection connection = DBConnection.getConnection();
        if (connection == null) {
            throw new SQLException("Could not connect to the database.");
        }
        try (Connection con = connection;
             PreparedStatement ps = con.prepareStatement("SELECT id, full_name, email, phone, course FROM students ORDER BY created_at DESC");
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Student s = new Student();
                s.setId(rs.getInt("id")); s.setFullName(rs.getString("full_name"));
                s.setEmail(rs.getString("email")); s.setPhone(rs.getString("phone"));
                s.setCourse(rs.getString("course")); students.add(s);
            }
        }
        return students;
    }

    public List<Company> getAllCompanies() throws SQLException {
        return new CompanyDAO().getAll();
    }

    public boolean updateStudent(Student student) throws SQLException {
        String sql = "UPDATE students SET full_name=?, email=?, phone=?, course=? WHERE id=?";
        Connection connection = DBConnection.getConnection();
        if (connection == null) {
            throw new SQLException("Could not connect to the database.");
        }
        try (Connection con = connection; PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, student.getFullName());
            ps.setString(2, student.getEmail());
            ps.setString(3, student.getPhone());
            ps.setString(4, student.getCourse());
            ps.setInt(5, student.getId());
            return ps.executeUpdate() > 0;
        }
    }

    public boolean deleteStudent(int studentId) throws SQLException {
        return executeAccountUpdate("DELETE FROM students WHERE id=?", studentId);
    }

    public boolean verifyCompany(int companyId) throws SQLException {
        return executeAccountUpdate("UPDATE companies SET verified=1 WHERE id=?", companyId);
    }

    public boolean rejectCompany(int companyId) throws SQLException {
        return executeAccountUpdate("UPDATE companies SET verified=0 WHERE id=?", companyId);
    }

    public boolean deleteCompany(int companyId) throws SQLException {
        return executeAccountUpdate("DELETE FROM companies WHERE id=?", companyId);
    }

    private boolean executeAccountUpdate(String sql, int accountId) throws SQLException {
        Connection connection = DBConnection.getConnection();
        if (connection == null) {
            throw new SQLException("Could not connect to the database.");
        }
        try (Connection con = connection; PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, accountId);
            return ps.executeUpdate() > 0;
        }
    }

    private Admin mapAdmin(ResultSet rs) throws SQLException {
        Admin admin = new Admin();
        admin.setId(rs.getInt("id")); admin.setFullName(rs.getString("full_name"));
        admin.setEmail(rs.getString("email")); admin.setPassword(rs.getString("password"));
        return admin;
    }
}

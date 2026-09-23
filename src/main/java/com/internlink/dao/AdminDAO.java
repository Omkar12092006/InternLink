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

    public Admin getById(int id) {
        String sql = "SELECT * FROM admins WHERE id=?";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) { return rs.next() ? mapAdmin(rs) : null; }
        } catch (SQLException e) { e.printStackTrace(); return null; }
    }

    public List<Student> getAllStudents() {
        List<Student> students = new ArrayList<>();
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement("SELECT * FROM students ORDER BY created_at DESC"); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Student s = new Student();
                s.setId(rs.getInt("id")); s.setFullName(rs.getString("full_name"));
                s.setEmail(rs.getString("email")); s.setPhone(rs.getString("phone"));
                s.setCourse(rs.getString("course")); students.add(s);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return students;
    }

    public List<Company> getAllCompanies() {
        return new CompanyDAO().getAll();
    }

    public boolean verifyCompany(int companyId) {
        return executeCompanyUpdate("UPDATE companies SET verified=1 WHERE id=?", companyId);
    }

    public boolean deleteCompany(int companyId) {
        return executeCompanyUpdate("DELETE FROM companies WHERE id=?", companyId);
    }

    private boolean executeCompanyUpdate(String sql, int companyId) {
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, companyId); return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    private Admin mapAdmin(ResultSet rs) throws SQLException {
        Admin admin = new Admin();
        admin.setId(rs.getInt("id")); admin.setFullName(rs.getString("full_name"));
        admin.setEmail(rs.getString("email")); admin.setPassword(rs.getString("password"));
        return admin;
    }
}

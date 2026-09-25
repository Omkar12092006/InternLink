package com.internlink.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.Locale;

import com.internlink.model.Student;
import com.internlink.util.DBConnection;

public class StudentDAO {

    public static String normalizeEmail(String email) {
        if (email == null) {
            return null;
        }
        return email.trim().toLowerCase(Locale.ROOT);
    }

    public boolean emailExists(String email) {
        String normalizedEmail = normalizeEmail(email);
        if (normalizedEmail == null || normalizedEmail.isBlank()) {
            return false;
        }

        String sql = "SELECT 1 FROM students WHERE LOWER(email) = ? LIMIT 1";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, normalizedEmail);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public Student getStudentByEmailAndPassword(String email, String password) {
        Student student = null;
        String normalizedEmail = normalizeEmail(email);
        String sql = "SELECT * FROM students WHERE LOWER(email) = ? AND password = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, normalizedEmail);
            ps.setString(2, password);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    student = mapRow(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return student;
    }

    public Student getStudentById(int id) {
        Student student = null;
        String sql = "SELECT * FROM students WHERE id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                student = mapRow(rs);
            }
            rs.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return student;
    }

    public boolean registerStudent(Student student) {
        if (student == null) {
            return false;
        }

        String normalizedEmail = normalizeEmail(student.getEmail());
        if (normalizedEmail == null || normalizedEmail.isBlank()) {
            return false;
        }

        if (emailExists(normalizedEmail)) {
            return false;
        }

        student.setEmail(normalizedEmail);

        String sql = "INSERT INTO students(full_name, email, password, phone) VALUES(?,?,?,?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, student.getFullName());
            ps.setString(2, student.getEmail());
            ps.setString(3, student.getPassword());
            ps.setString(4, student.getPhone());
            int result = ps.executeUpdate();
            return result > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    private Student mapRow(ResultSet rs) throws SQLException {
        Student s = new Student();
        s.setId(rs.getInt("id"));
        s.setFullName(rs.getString("full_name"));
        s.setEmail(rs.getString("email"));
        s.setPassword(rs.getString("password"));
        s.setPhone(rs.getString("phone"));
        if (hasColumn(rs, "course")) {
            s.setCourse(rs.getString("course"));
        }
        return s;
    }

    private boolean hasColumn(ResultSet rs, String columnName) {
        try {
            ResultSetMetaData metaData = rs.getMetaData();
            int columnCount = metaData.getColumnCount();
            for (int i = 1; i <= columnCount; i++) {
                if (columnName.equalsIgnoreCase(metaData.getColumnName(i))) {
                    return true;
                }
            }
        } catch (SQLException ignored) {
            // Ignore metadata issues and treat missing optional columns as null.
        }
        return false;
    }
}

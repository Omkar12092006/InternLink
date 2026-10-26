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

    private static volatile boolean resumeColumnReady;

    private static synchronized void ensureResumeColumn() throws SQLException {
        if (resumeColumnReady) {
            return;
        }
        Connection connection = DBConnection.getConnection();
        if (connection == null) {
            throw new SQLException("Could not connect to the database.");
        }
        try (Connection con = connection;
             PreparedStatement ps = con.prepareStatement(
                     "SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() " +
                             "AND table_name = 'students' AND column_name = 'resume_file'");
             ResultSet rs = ps.executeQuery()) {
            if (!rs.next()) {
                throw new SQLException("Could not verify the student resume column.");
            }
            if (rs.getInt(1) == 0) {
                try (java.sql.Statement statement = con.createStatement()) {
                    statement.execute("ALTER TABLE students ADD COLUMN resume_file VARCHAR(255) NULL");
                }
            }
        }
        resumeColumnReady = true;
    }

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
        try {
            ensureResumeColumn();
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
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

    public Student getStudentById(int id) throws SQLException {
        ensureResumeColumn();
        String sql = "SELECT * FROM students WHERE id = ?";
        Connection connection = DBConnection.getConnection();
        if (connection == null) {
            throw new SQLException("Could not connect to the database.");
        }
        try (Connection con = connection;
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapRow(rs) : null;
            }
        }
    }

    public boolean updateStudent(Student student) throws SQLException {
        return updateStudent(student, student == null ? null : student.getEmail());
    }

    public boolean updateStudent(Student student, String previousEmail) throws SQLException {
        if (student == null || student.getId() <= 0) {
            throw new IllegalArgumentException("A valid student is required.");
        }
        String fullName = student.getFullName() == null ? "" : student.getFullName().trim();
        String email = normalizeEmail(student.getEmail());
        String phone = trimToNull(student.getPhone());
        String course = trimToNull(student.getCourse());
        if (fullName.isEmpty() || fullName.length() > 100 || email == null
                || email.length() > 100 || !email.matches("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$")
                || (phone != null && phone.length() > 30)
                || (course != null && course.length() > 100)) {
            throw new IllegalArgumentException("Enter a valid name and email address.");
        }

        ensureResumeColumn();
        String updateStudentSql = "UPDATE students SET full_name=?, email=?, phone=?, course=? WHERE id=?";
        String updateApplicationsSql = "UPDATE applications SET applicant_email=? WHERE LOWER(applicant_email)=LOWER(?)";
        Connection connection = DBConnection.getConnection();
        if (connection == null) {
            throw new SQLException("Could not connect to the database.");
        }
        try (Connection con = connection) {
            con.setAutoCommit(false);
            try (PreparedStatement studentStatement = con.prepareStatement(updateStudentSql);
                 PreparedStatement applicationsStatement = con.prepareStatement(updateApplicationsSql)) {
                studentStatement.setString(1, fullName);
                studentStatement.setString(2, email);
                studentStatement.setString(3, phone);
                studentStatement.setString(4, course);
                studentStatement.setInt(5, student.getId());
                if (studentStatement.executeUpdate() == 0) {
                    con.rollback();
                    return false;
                }
                applicationsStatement.setString(1, email);
                applicationsStatement.setString(2, previousEmail);
                applicationsStatement.executeUpdate();
                con.commit();
            } catch (SQLException e) {
                con.rollback();
                throw e;
            }
        }
        student.setFullName(fullName);
        student.setEmail(email);
        student.setPhone(phone);
        student.setCourse(course);
        return true;
    }

    public boolean updateResumeFile(int studentId, String resumeFile) throws SQLException {
        if (studentId <= 0 || resumeFile == null || !resumeFile.matches("[0-9]+-[a-f0-9-]+\\.(pdf|doc|docx)")) {
            throw new IllegalArgumentException("A valid resume file is required.");
        }
        ensureResumeColumn();
        Connection connection = DBConnection.getConnection();
        if (connection == null) {
            throw new SQLException("Could not connect to the database.");
        }
        try (Connection con = connection;
             PreparedStatement ps = con.prepareStatement("UPDATE students SET resume_file=? WHERE id=?")) {
            ps.setString(1, resumeFile);
            ps.setInt(2, studentId);
            return ps.executeUpdate() > 0;
        }
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
        if (hasColumn(rs, "resume_file")) {
            s.setResumeFile(rs.getString("resume_file"));
        }
        return s;
    }

    private String trimToNull(String value) {
        String trimmed = value == null ? "" : value.trim();
        return trimmed.isEmpty() ? null : trimmed;
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

package com.internlink.dao;

import com.internlink.model.Application;
import com.internlink.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ApplicationDAO {

    public boolean hasApplied(int internshipId, String email) {
        String sql = "SELECT COUNT(*) FROM applications WHERE internship_id = ? AND applicant_email = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, internshipId);
            ps.setString(2, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            rs.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean apply(int internshipId, String name, String email, String university, String coverLetter) {
        String sql = "INSERT INTO applications(internship_id, applicant_name, applicant_email, university, cover_letter, status) VALUES(?, ?, ?, ?, ?, 'Pending')";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, internshipId);
            ps.setString(2, name);
            ps.setString(3, email);
            ps.setString(4, university);
            ps.setString(5, coverLetter);
            int result = ps.executeUpdate();
            return result > 0;
        } catch (SQLIntegrityConstraintViolationException e) {
            return false;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Application> getApplicationsByCompanyId(int companyId) {
        List<Application> applications = new ArrayList<>();
        String sql = "SELECT a.id, a.internship_id, a.applicant_name, a.applicant_email, a.university, a.cover_letter, a.status, a.applied_date AS applied_at, " +
                     "i.title AS internship_title, i.location AS internship_location, i.company AS internship_company " +
                     "FROM applications a JOIN internships i ON a.internship_id = i.id " +
                     "WHERE i.company_id = ? ORDER BY a.id DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, companyId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    applications.add(mapRow(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return applications;
    }

    public List<Application> getApplicationsByStudentEmail(String email) {
        List<Application> applications = new ArrayList<>();
        String sql = "SELECT a.id, a.internship_id, a.applicant_name, a.applicant_email, a.university, a.cover_letter, a.status, a.applied_date AS applied_at, " +
                     "i.title AS internship_title, i.location AS internship_location, i.company AS internship_company " +
                     "FROM applications a JOIN internships i ON a.internship_id = i.id " +
                     "WHERE LOWER(a.applicant_email) = LOWER(?) ORDER BY a.applied_date DESC, a.id DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    applications.add(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return applications;
    }

    public boolean updateStatus(int applicationId, String status) {
        String normalizedStatus = normalizeStatus(status);
        String sql = "UPDATE applications SET status = ? WHERE id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, normalizedStatus);
            ps.setInt(2, applicationId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    private String normalizeStatus(String status) {
        if (status == null || status.trim().isEmpty()) {
            return "Pending";
        }

        String trimmed = status.trim();
        switch (trimmed.toLowerCase()) {
            case "shortlist":
                return "Shortlisted";
            case "shortlisted":
                return "Shortlisted";
            case "reject":
                return "Rejected";
            case "rejected":
                return "Rejected";
            case "select":
                return "Selected";
            case "selected":
                return "Selected";
            case "pending":
                return "Pending";
            default:
                return trimmed.substring(0, 1).toUpperCase() + trimmed.substring(1).toLowerCase();
        }
    }

    private Application mapRow(ResultSet rs) throws SQLException {
        Application app = new Application();
        app.setId(rs.getInt("id"));
        app.setInternshipId(rs.getInt("internship_id"));
        app.setApplicantName(rs.getString("applicant_name"));
        app.setApplicantEmail(rs.getString("applicant_email"));
        app.setUniversity(rs.getString("university"));
        app.setCoverLetter(rs.getString("cover_letter"));
        app.setResumeLink(null);
        app.setStatus(rs.getString("status"));
        app.setInternshipTitle(rs.getString("internship_title"));
        app.setInternshipLocation(rs.getString("internship_location"));
        app.setInternshipCompany(rs.getString("internship_company"));

        Timestamp appliedAt = rs.getTimestamp("applied_at");
        if (appliedAt != null) {
            app.setAppliedDate(appliedAt.toLocalDateTime());
        }

        return app;
    }
}

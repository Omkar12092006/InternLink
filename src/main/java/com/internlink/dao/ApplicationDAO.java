package com.internlink.dao;

import com.internlink.model.Application;
import com.internlink.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ApplicationDAO {

    public boolean submitApplication(Application application) {
        String sql = "INSERT INTO applications (internship_id, applicant_name, applicant_email, university, cover_letter, resume_link, status) VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, application.getInternshipId());
            ps.setString(2, application.getApplicantName());
            ps.setString(3, application.getApplicantEmail());
            ps.setString(4, application.getUniversity());
            ps.setString(5, application.getCoverLetter());
            ps.setString(6, application.getResumeLink());
            ps.setString(7, "Under Review");

            int result = ps.executeUpdate();
            return result > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean hasAlreadyApplied(int internshipId, String email) {
        String sql = "SELECT COUNT(*) FROM applications WHERE internship_id = ? AND applicant_email = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, internshipId);
            ps.setString(2, email);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public List<Application> getApplicationsByEmail(String email) {
        List<Application> applications = new ArrayList<>();
        String sql = "SELECT * FROM applications WHERE applicant_email = ? ORDER BY applied_date DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    applications.add(mapResultSetToApplication(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return applications;
    }

    public List<Application> getApplicationsByInternshipId(int internshipId) {
        List<Application> applications = new ArrayList<>();
        String sql = "SELECT * FROM applications WHERE internship_id = ? ORDER BY applied_date DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, internshipId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    applications.add(mapResultSetToApplication(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return applications;
    }

    public int getApplicationCountByInternship(int internshipId) {
        String sql = "SELECT COUNT(*) FROM applications WHERE internship_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, internshipId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }

    private Application mapResultSetToApplication(ResultSet rs) throws Exception {
        Application app = new Application();
        app.setId(rs.getInt("id"));
        app.setInternshipId(rs.getInt("internship_id"));
        app.setApplicantName(rs.getString("applicant_name"));
        app.setApplicantEmail(rs.getString("applicant_email"));
        app.setUniversity(rs.getString("university"));
        app.setCoverLetter(rs.getString("cover_letter"));
        app.setResumeLink(rs.getString("resume_link"));
        app.setStatus(rs.getString("status"));
        app.setAppliedDate(rs.getTimestamp("applied_date"));
        return app;
    }
}

package com.internlink.dao;

import com.internlink.util.DBConnection;
import java.sql.*;

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
}

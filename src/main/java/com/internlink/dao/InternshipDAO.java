package com.internlink.dao;

import com.internlink.model.Internship;
import com.internlink.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class InternshipDAO {

    public List<Internship> getAllInternships() {
        List<Internship> internships = new ArrayList<>();
        String sql = "SELECT * FROM internships ORDER BY created_at DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Internship internship = mapResultSetToInternship(rs);
                internships.add(internship);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return internships;
    }

    public List<Internship> getInternshipsByCategory(String category) {
        List<Internship> internships = new ArrayList<>();
        String sql = "SELECT * FROM internships WHERE category = ? ORDER BY created_at DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, category);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    internships.add(mapResultSetToInternship(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return internships;
    }

    public List<Internship> getInternshipsByLocation(String location) {
        List<Internship> internships = new ArrayList<>();
        String sql = "SELECT * FROM internships WHERE location = ? ORDER BY created_at DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, location);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    internships.add(mapResultSetToInternship(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return internships;
    }

    public List<Internship> searchInternships(String keyword) {
        List<Internship> internships = new ArrayList<>();
        String sql = "SELECT * FROM internships WHERE title LIKE ? OR company LIKE ? OR description LIKE ? OR skills LIKE ? ORDER BY created_at DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            String searchPattern = "%" + keyword + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ps.setString(3, searchPattern);
            ps.setString(4, searchPattern);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    internships.add(mapResultSetToInternship(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return internships;
    }

    public Internship getInternshipById(int id) {
        String sql = "SELECT * FROM internships WHERE id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToInternship(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public List<Internship> getPaidInternships() {
        List<Internship> internships = new ArrayList<>();
        String sql = "SELECT * FROM internships WHERE paid = TRUE ORDER BY created_at DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                internships.add(mapResultSetToInternship(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return internships;
    }

    public List<Internship> getUnpaidInternships() {
        List<Internship> internships = new ArrayList<>();
        String sql = "SELECT * FROM internships WHERE paid = FALSE ORDER BY created_at DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                internships.add(mapResultSetToInternship(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return internships;
    }

    public void incrementApplicants(int internshipId) {
        String sql = "UPDATE internships SET applicants = applicants + 1 WHERE id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, internshipId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private Internship mapResultSetToInternship(ResultSet rs) throws Exception {
        Internship internship = new Internship();
        internship.setId(rs.getInt("id"));
        internship.setTitle(rs.getString("title"));
        internship.setCompany(rs.getString("company"));
        internship.setPaid(rs.getBoolean("paid"));
        internship.setLocation(rs.getString("location"));
        internship.setDuration(rs.getString("duration"));
        internship.setCategory(rs.getString("category"));
        internship.setDescription(rs.getString("description"));
        internship.setSkills(rs.getString("skills"));
        internship.setApplicants(rs.getInt("applicants"));
        internship.setPostedDate(rs.getDate("posted_date"));
        internship.setStipend(rs.getString("stipend"));
        internship.setEmoji(rs.getString("emoji"));
        internship.setColor(rs.getString("color"));
        return internship;
    }
}

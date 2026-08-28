package com.internlink.dao;

import com.internlink.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BookmarkDAO {

    public boolean isBookmarked(int studentId, int internshipId) {
        String sql = "SELECT COUNT(*) FROM bookmarks WHERE student_id = ? AND internship_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ps.setInt(2, internshipId);
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

    public boolean addBookmark(int studentId, int internshipId) {
        String sql = "INSERT INTO bookmarks(student_id, internship_id) VALUES(?, ?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ps.setInt(2, internshipId);
            int result = ps.executeUpdate();
            return result > 0;
        } catch (SQLIntegrityConstraintViolationException e) {
            return false;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean removeBookmark(int studentId, int internshipId) {
        String sql = "DELETE FROM bookmarks WHERE student_id = ? AND internship_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ps.setInt(2, internshipId);
            int result = ps.executeUpdate();
            return result > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Integer> getBookmarkedInternshipIds(int studentId) {
        List<Integer> ids = new ArrayList<>();
        String sql = "SELECT internship_id FROM bookmarks WHERE student_id = ? ORDER BY created_at DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ids.add(rs.getInt("internship_id"));
            }
            rs.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return ids;
    }
}

package com.internlink.dao;

import com.internlink.model.Internship;
import com.internlink.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class InternshipDAO {

    public List<Internship> searchInternships(String keyword, List<String> categories,
            List<String> locations, String duration, String stipendType, int offset, int limit) {
        List<Internship> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM internships WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (title LIKE ? OR company LIKE ? OR skills LIKE ? OR description LIKE ?)");
            String kw = "%" + keyword.trim() + "%";
            params.add(kw);
            params.add(kw);
            params.add(kw);
            params.add(kw);
        }

        if (categories != null && !categories.isEmpty()) {
            sql.append(" AND category IN (");
            for (int i = 0; i < categories.size(); i++) {
                sql.append(i == 0 ? "?" : ",?");
                params.add(categories.get(i));
            }
            sql.append(")");
        }

        if (locations != null && !locations.isEmpty()) {
            sql.append(" AND location IN (");
            for (int i = 0; i < locations.size(); i++) {
                sql.append(i == 0 ? "?" : ",?");
                params.add(locations.get(i));
            }
            sql.append(")");
        }

        if (duration != null && !duration.isEmpty() && !"Any".equalsIgnoreCase(duration)) {
            if (duration.toLowerCase().contains("summer") || duration.contains("3")) {
                sql.append(" AND (duration LIKE '%3%' OR duration LIKE '%Summer%')");
            } else if (duration.toLowerCase().contains("co-op") || duration.contains("6")) {
                sql.append(" AND (duration LIKE '%6%' OR duration LIKE '%Co-op%')");
            }
        }

        if (stipendType != null && !stipendType.isEmpty()) {
            if ("Paid".equalsIgnoreCase(stipendType)) {
                sql.append(" AND paid = 1");
            } else if ("Unpaid".equalsIgnoreCase(stipendType)) {
                sql.append(" AND paid = 0");
            }
        }

        sql.append(" ORDER BY posted_date DESC");
        sql.append(" LIMIT ? OFFSET ?");
        params.add(limit);
        params.add(offset);

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRow(rs));
            }
            rs.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public int countInternships(String keyword, List<String> categories,
            List<String> locations, String duration, String stipendType) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM internships WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (title LIKE ? OR company LIKE ? OR skills LIKE ? OR description LIKE ?)");
            String kw = "%" + keyword.trim() + "%";
            params.add(kw);
            params.add(kw);
            params.add(kw);
            params.add(kw);
        }

        if (categories != null && !categories.isEmpty()) {
            sql.append(" AND category IN (");
            for (int i = 0; i < categories.size(); i++) {
                sql.append(i == 0 ? "?" : ",?");
                params.add(categories.get(i));
            }
            sql.append(")");
        }

        if (locations != null && !locations.isEmpty()) {
            sql.append(" AND location IN (");
            for (int i = 0; i < locations.size(); i++) {
                sql.append(i == 0 ? "?" : ",?");
                params.add(locations.get(i));
            }
            sql.append(")");
        }

        if (duration != null && !duration.isEmpty() && !"Any".equalsIgnoreCase(duration)) {
            if (duration.toLowerCase().contains("summer") || duration.contains("3")) {
                sql.append(" AND (duration LIKE '%3%' OR duration LIKE '%Summer%')");
            } else if (duration.toLowerCase().contains("co-op") || duration.contains("6")) {
                sql.append(" AND (duration LIKE '%6%' OR duration LIKE '%Co-op%')");
            }
        }

        if (stipendType != null && !stipendType.isEmpty()) {
            if ("Paid".equalsIgnoreCase(stipendType)) {
                sql.append(" AND paid = 1");
            } else if ("Unpaid".equalsIgnoreCase(stipendType)) {
                sql.append(" AND paid = 0");
            }
        }

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
            rs.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public Internship getInternshipById(int id) {
        String sql = "SELECT * FROM internships WHERE id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapRow(rs);
            }
            rs.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    private Internship mapRow(ResultSet rs) throws SQLException {
        Internship i = new Internship();
        i.setId(rs.getInt("id"));
        i.setTitle(rs.getString("title"));
        i.setCompany(rs.getString("company"));
        i.setPaid(rs.getBoolean("paid"));
        i.setLocation(rs.getString("location"));
        i.setDuration(rs.getString("duration"));
        i.setCategory(rs.getString("category"));
        i.setDescription(rs.getString("description"));
        i.setSkills(rs.getString("skills"));
        i.setApplicants(rs.getInt("applicants"));
        Date posted = rs.getDate("posted_date");
        if (posted != null) i.setPostedDate(posted.toLocalDate());
        i.setStipend(rs.getString("stipend"));
        i.setEmoji(rs.getString("emoji"));
        i.setColor(rs.getString("color"));
        return i;
    }
}

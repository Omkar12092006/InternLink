package com.internlink.dao;

import com.internlink.model.Internship;
import com.internlink.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class InternshipDAO {

    private static volatile boolean approvalColumnReady;

    public static synchronized void ensureApprovalColumn() throws SQLException {
        if (approvalColumnReady) {
            return;
        }
        Connection connection = DBConnection.getConnection();
        if (connection == null) {
            throw new SQLException("Could not connect to the database.");
        }
        try (Connection con = connection) {
            boolean columnMissing;
            try (PreparedStatement ps = con.prepareStatement(
                    "SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'internships' AND column_name = 'approved'");
                 ResultSet rs = ps.executeQuery()) {
                columnMissing = !rs.next() || rs.getInt(1) == 0;
            }
            if (columnMissing) {
                try (Statement statement = con.createStatement()) {
                    statement.execute("ALTER TABLE internships ADD COLUMN approved TINYINT(1) NOT NULL DEFAULT 1");
                }
            }
        }
        approvalColumnReady = true;
    }

    private void ensureCompanyIdColumn() {
        String checkSql = "SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'internships' AND column_name = 'company_id'";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(checkSql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next() && rs.getInt(1) == 0) {
                try (Statement st = con.createStatement()) {
                    st.execute("ALTER TABLE internships ADD COLUMN company_id INT NULL");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public boolean insert(Internship internship) {
        ensureCompanyIdColumn();
        try {
            ensureApprovalColumn();
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
        String sql = "INSERT INTO internships (company_id, title, company, category, location, duration, description, skills, paid, stipend, applicants, emoji, color, approved, posted_date) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 0, ?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, internship.getCompanyId());
            ps.setString(2, internship.getTitle());
            ps.setString(3, internship.getCompany());
            ps.setString(4, internship.getCategory());
            ps.setString(5, internship.getLocation());
            ps.setString(6, internship.getDuration());
            ps.setString(7, internship.getDescription());
            ps.setString(8, internship.getSkills());
            ps.setBoolean(9, internship.isPaid());
            ps.setString(10, internship.getStipend());
            ps.setInt(11, internship.getApplicants());
            ps.setString(12, internship.getEmoji() == null || internship.getEmoji().isEmpty() ? "work" : internship.getEmoji());
            ps.setString(13, internship.getColor() == null || internship.getColor().isEmpty() ? "#22C55E" : internship.getColor());
            if (internship.getPostedDate() != null) {
                ps.setDate(14, Date.valueOf(internship.getPostedDate()));
            } else {
                ps.setDate(14, Date.valueOf(java.time.LocalDate.now()));
            }
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean update(Internship internship) {
        ensureCompanyIdColumn();
        try {
            ensureApprovalColumn();
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
        String sql = "UPDATE internships SET company_id=?, title=?, company=?, category=?, location=?, duration=?, description=?, skills=?, paid=?, stipend=?, applicants=?, emoji=?, color=?, approved=0, posted_date=? WHERE id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, internship.getCompanyId());
            ps.setString(2, internship.getTitle());
            ps.setString(3, internship.getCompany());
            ps.setString(4, internship.getCategory());
            ps.setString(5, internship.getLocation());
            ps.setString(6, internship.getDuration());
            ps.setString(7, internship.getDescription());
            ps.setString(8, internship.getSkills());
            ps.setBoolean(9, internship.isPaid());
            ps.setString(10, internship.getStipend());
            ps.setInt(11, internship.getApplicants());
            ps.setString(12, internship.getEmoji() == null || internship.getEmoji().isEmpty() ? "work" : internship.getEmoji());
            ps.setString(13, internship.getColor() == null || internship.getColor().isEmpty() ? "#22C55E" : internship.getColor());
            if (internship.getPostedDate() != null) {
                ps.setDate(14, Date.valueOf(internship.getPostedDate()));
            } else {
                ps.setDate(14, Date.valueOf(java.time.LocalDate.now()));
            }
            ps.setInt(15, internship.getId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM internships WHERE id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Internship> getByCompanyId(int companyId) {
        ensureCompanyIdColumn();
        try {
            ensureApprovalColumn();
        } catch (SQLException e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
        List<Internship> list = new ArrayList<>();
        String sql = "SELECT * FROM internships WHERE company_id = ? ORDER BY posted_date DESC, id DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, companyId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Internship> getBookmarkedByStudentId(int studentId) {
        try {
            ensureApprovalColumn();
        } catch (SQLException e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
        List<Internship> list = new ArrayList<>();
        String sql = "SELECT i.* FROM bookmarks b JOIN internships i ON i.id = b.internship_id " +
                     "WHERE b.student_id = ? AND i.approved = 1 ORDER BY b.created_at DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Internship> searchInternships(String keyword, List<String> categories,
            List<String> locations, String duration, String stipendType, int offset, int limit) {
        try {
            ensureApprovalColumn();
        } catch (SQLException e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
        List<Internship> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM internships WHERE approved = 1");
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
        try {
            ensureApprovalColumn();
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM internships WHERE approved = 1");
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
        try {
            ensureApprovalColumn();
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
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

    public Internship getApprovedInternshipById(int id) throws SQLException {
        ensureApprovalColumn();
        String sql = "SELECT * FROM internships WHERE id = ? AND approved = 1";
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

    public List<Internship> getAllForAdmin() throws SQLException {
        ensureApprovalColumn();
        List<Internship> internships = new ArrayList<>();
        String sql = "SELECT * FROM internships ORDER BY created_at DESC, id DESC";
        Connection connection = DBConnection.getConnection();
        if (connection == null) {
            throw new SQLException("Could not connect to the database.");
        }
        try (Connection con = connection;
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                internships.add(mapRow(rs));
            }
        }
        return internships;
    }

    private Internship mapRow(ResultSet rs) throws SQLException {
        Internship i = new Internship();
        i.setId(rs.getInt("id"));
        i.setCompanyId(rs.getInt("company_id"));
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
        i.setApproved(rs.getBoolean("approved"));
        return i;
    }
}

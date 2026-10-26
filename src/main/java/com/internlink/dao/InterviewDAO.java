package com.internlink.dao;

import com.internlink.model.Application;
import com.internlink.model.Interview;
import com.internlink.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

public class InterviewDAO {

    private static volatile boolean tableReady;

    private static synchronized void ensureTable() throws SQLException {
        if (tableReady) {
            return;
        }
        Connection connection = DBConnection.getConnection();
        if (connection == null) {
            throw new SQLException("Could not connect to the database.");
        }
        try (Connection con = connection; Statement statement = con.createStatement()) {
            statement.execute("CREATE TABLE IF NOT EXISTS interviews (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "application_id INT NOT NULL UNIQUE, " +
                    "scheduled_at DATETIME NOT NULL, " +
                    "mode VARCHAR(20) NOT NULL, " +
                    "meeting_link VARCHAR(500), " +
                    "status VARCHAR(20) NOT NULL DEFAULT 'Scheduled', " +
                    "notes TEXT, " +
                    "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
                    "updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, " +
                    "CONSTRAINT fk_interview_application FOREIGN KEY (application_id) " +
                    "REFERENCES applications(id) ON DELETE CASCADE)");
        }
        tableReady = true;
    }

    public boolean schedule(Interview interview, int companyId) throws SQLException {
        validateInterview(interview, true);
        if (companyId <= 0) {
            throw new IllegalArgumentException("A valid company is required.");
        }
        ensureTable();

        String applicationSql = "SELECT a.status FROM applications a " +
                "JOIN internships i ON i.id = a.internship_id " +
                "WHERE a.id=? AND i.company_id=? FOR UPDATE";
        String interviewSql = "INSERT INTO interviews " +
                "(application_id, scheduled_at, mode, meeting_link, status, notes) VALUES (?, ?, ?, ?, 'Scheduled', ?)";
        String statusSql = "UPDATE applications SET status='Interview Scheduled' WHERE id=?";

        Connection connection = DBConnection.getConnection();
        if (connection == null) {
            throw new SQLException("Could not connect to the database.");
        }
        try (Connection con = connection) {
            con.setAutoCommit(false);
            try (PreparedStatement applicationStatement = con.prepareStatement(applicationSql);
                 PreparedStatement interviewStatement = con.prepareStatement(interviewSql);
                 PreparedStatement statusStatement = con.prepareStatement(statusSql)) {
                applicationStatement.setInt(1, interview.getApplicationId());
                applicationStatement.setInt(2, companyId);
                try (ResultSet rs = applicationStatement.executeQuery()) {
                    if (!rs.next()) {
                        throw new IllegalArgumentException("Application not found for this company.");
                    }
                    String currentStatus = rs.getString("status");
                    if ("Rejected".equalsIgnoreCase(currentStatus) || "Selected".equalsIgnoreCase(currentStatus)) {
                        throw new IllegalArgumentException("This application cannot be scheduled for an interview.");
                    }
                }

                interviewStatement.setInt(1, interview.getApplicationId());
                interviewStatement.setTimestamp(2, Timestamp.valueOf(interview.getScheduledAt()));
                interviewStatement.setString(3, interview.getMode());
                if (interview.getMeetingLink() == null) {
                    interviewStatement.setNull(4, Types.VARCHAR);
                } else {
                    interviewStatement.setString(4, interview.getMeetingLink());
                }
                if (interview.getNotes() == null) {
                    interviewStatement.setNull(5, Types.VARCHAR);
                } else {
                    interviewStatement.setString(5, interview.getNotes());
                }
                interviewStatement.executeUpdate();

                statusStatement.setInt(1, interview.getApplicationId());
                statusStatement.executeUpdate();
                con.commit();
                return true;
            } catch (SQLException | RuntimeException e) {
                con.rollback();
                throw e;
            }
        }
    }

    public boolean update(Interview interview, int companyId) throws SQLException {
        validateInterview(interview, "Scheduled".equals(interview.getStatus()));
        if (interview.getId() <= 0 || companyId <= 0) {
            throw new IllegalArgumentException("A valid interview and company are required.");
        }
        if (!"Scheduled".equals(interview.getStatus())
                && !"Completed".equals(interview.getStatus())
                && !"Cancelled".equals(interview.getStatus())) {
            throw new IllegalArgumentException("Unsupported interview status.");
        }
        ensureTable();

        String ownershipSql = "SELECT i.application_id FROM interviews i " +
                "JOIN applications a ON a.id = i.application_id " +
                "JOIN internships p ON p.id = a.internship_id " +
                "WHERE i.id=? AND p.company_id=? FOR UPDATE";
        String updateSql = "UPDATE interviews SET scheduled_at=?, mode=?, meeting_link=?, status=?, notes=? WHERE id=?";
        String applicationStatusSql = "UPDATE applications SET status=? WHERE id=?";

        Connection connection = DBConnection.getConnection();
        if (connection == null) {
            throw new SQLException("Could not connect to the database.");
        }
        try (Connection con = connection) {
            con.setAutoCommit(false);
            try (PreparedStatement ownershipStatement = con.prepareStatement(ownershipSql);
                 PreparedStatement updateStatement = con.prepareStatement(updateSql);
                 PreparedStatement applicationStatusStatement = con.prepareStatement(applicationStatusSql)) {
                ownershipStatement.setInt(1, interview.getId());
                ownershipStatement.setInt(2, companyId);
                int applicationId;
                try (ResultSet rs = ownershipStatement.executeQuery()) {
                    if (!rs.next()) {
                        throw new IllegalArgumentException("Interview not found for this company.");
                    }
                    applicationId = rs.getInt("application_id");
                }

                updateStatement.setTimestamp(1, Timestamp.valueOf(interview.getScheduledAt()));
                updateStatement.setString(2, interview.getMode());
                if (interview.getMeetingLink() == null) {
                    updateStatement.setNull(3, Types.VARCHAR);
                } else {
                    updateStatement.setString(3, interview.getMeetingLink());
                }
                updateStatement.setString(4, interview.getStatus());
                if (interview.getNotes() == null) {
                    updateStatement.setNull(5, Types.VARCHAR);
                } else {
                    updateStatement.setString(5, interview.getNotes());
                }
                updateStatement.setInt(6, interview.getId());
                if (updateStatement.executeUpdate() == 0) {
                    con.rollback();
                    return false;
                }

                String applicationStatus = "Scheduled".equals(interview.getStatus())
                        ? "Interview Scheduled"
                        : "Completed".equals(interview.getStatus())
                                ? "Interview Completed" : "Interview Cancelled";
                applicationStatusStatement.setString(1, applicationStatus);
                applicationStatusStatement.setInt(2, applicationId);
                applicationStatusStatement.executeUpdate();
                con.commit();
                return true;
            } catch (SQLException | RuntimeException e) {
                con.rollback();
                throw e;
            }
        }
    }

    public List<Interview> getByCompanyId(int companyId) throws SQLException {
        if (companyId <= 0) {
            throw new IllegalArgumentException("A valid company is required.");
        }
        ensureTable();
        String sql = "SELECT v.id, v.application_id, v.scheduled_at, v.mode, v.meeting_link, v.status, v.notes, " +
                "a.applicant_name, a.applicant_email, p.title AS internship_title, p.company AS internship_company " +
                "FROM interviews v JOIN applications a ON a.id=v.application_id " +
                "JOIN internships p ON p.id=a.internship_id " +
                "WHERE p.company_id=? ORDER BY v.scheduled_at DESC, v.id DESC";
        Connection connection = DBConnection.getConnection();
        if (connection == null) {
            throw new SQLException("Could not connect to the database.");
        }
        List<Interview> interviews = new ArrayList<>();
        try (Connection con = connection;
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, companyId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    interviews.add(mapRow(rs));
                }
            }
        }
        return interviews;
    }

    public List<Application> getApplicationsForSchedulingByCompanyId(int companyId) throws SQLException {
        if (companyId <= 0) {
            throw new IllegalArgumentException("A valid company is required.");
        }
        String sql = "SELECT a.id, a.internship_id, a.applicant_name, a.applicant_email, a.university, a.status, " +
                "p.title AS internship_title, p.location AS internship_location, p.company AS internship_company " +
                "FROM applications a JOIN internships p ON p.id=a.internship_id " +
                "WHERE p.company_id=? ORDER BY a.applied_date DESC, a.id DESC";
        Connection connection = DBConnection.getConnection();
        if (connection == null) {
            throw new SQLException("Could not connect to the database.");
        }
        List<Application> applications = new ArrayList<>();
        try (Connection con = connection;
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, companyId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Application application = new Application();
                    application.setId(rs.getInt("id"));
                    application.setInternshipId(rs.getInt("internship_id"));
                    application.setApplicantName(rs.getString("applicant_name"));
                    application.setApplicantEmail(rs.getString("applicant_email"));
                    application.setUniversity(rs.getString("university"));
                    application.setStatus(rs.getString("status"));
                    application.setInternshipTitle(rs.getString("internship_title"));
                    application.setInternshipLocation(rs.getString("internship_location"));
                    application.setInternshipCompany(rs.getString("internship_company"));
                    applications.add(application);
                }
            }
        }
        return applications;
    }

    public List<Interview> getByStudentId(int studentId) throws SQLException {
        if (studentId <= 0) {
            throw new IllegalArgumentException("A valid student is required.");
        }
        ensureTable();
        String sql = "SELECT v.id, v.application_id, v.scheduled_at, v.mode, v.meeting_link, v.status, v.notes, " +
                "a.applicant_name, a.applicant_email, p.title AS internship_title, p.company AS internship_company " +
                "FROM interviews v JOIN applications a ON a.id=v.application_id " +
                "JOIN internships p ON p.id=a.internship_id " +
                "WHERE LOWER(a.applicant_email)=" +
                "(SELECT LOWER(email) FROM students WHERE id=?) " +
                "ORDER BY v.scheduled_at DESC, v.id DESC";
        Connection connection = DBConnection.getConnection();
        if (connection == null) {
            throw new SQLException("Could not connect to the database.");
        }
        List<Interview> interviews = new ArrayList<>();
        try (Connection con = connection;
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    interviews.add(mapRow(rs));
                }
            }
        }
        return interviews;
    }

    private void validateInterview(Interview interview, boolean requireFutureDate) {
        if (interview == null || interview.getApplicationId() <= 0
                || interview.getScheduledAt() == null
                || requireFutureDate && interview.getScheduledAt().isBefore(java.time.LocalDateTime.now())) {
            throw new IllegalArgumentException("Select a valid interview date and time.");
        }
        if (!"Online".equals(interview.getMode())
                && !"In person".equals(interview.getMode())
                && !"Phone".equals(interview.getMode())) {
            throw new IllegalArgumentException("Select a valid interview mode.");
        }
        String meetingLink = interview.getMeetingLink();
        if (meetingLink != null && (meetingLink.length() > 500
                || !meetingLink.isBlank() && !meetingLink.matches("https?://[^\\s]+"))) {
            throw new IllegalArgumentException("Enter a valid HTTP or HTTPS meeting link.");
        }
        String notes = interview.getNotes();
        if (notes != null && notes.length() > 5000) {
            throw new IllegalArgumentException("Interview notes must be 5000 characters or fewer.");
        }
    }

    private Interview mapRow(ResultSet rs) throws SQLException {
        Interview interview = new Interview();
        interview.setId(rs.getInt("id"));
        interview.setApplicationId(rs.getInt("application_id"));
        Timestamp scheduledAt = rs.getTimestamp("scheduled_at");
        if (scheduledAt != null) {
            interview.setScheduledAt(scheduledAt.toLocalDateTime());
        }
        interview.setMode(rs.getString("mode"));
        interview.setMeetingLink(rs.getString("meeting_link"));
        interview.setStatus(rs.getString("status"));
        interview.setNotes(rs.getString("notes"));
        interview.setApplicantName(rs.getString("applicant_name"));
        interview.setApplicantEmail(rs.getString("applicant_email"));
        interview.setInternshipTitle(rs.getString("internship_title"));
        interview.setInternshipCompany(rs.getString("internship_company"));
        return interview;
    }
}

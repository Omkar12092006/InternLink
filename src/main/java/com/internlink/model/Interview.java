package com.internlink.model;

import java.time.LocalDateTime;

public class Interview {
    private int id;
    private int applicationId;
    private LocalDateTime scheduledAt;
    private String mode;
    private String meetingLink;
    private String status;
    private String notes;
    private String applicantName;
    private String applicantEmail;
    private String internshipTitle;
    private String internshipCompany;

    public Interview() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getApplicationId() { return applicationId; }
    public void setApplicationId(int applicationId) { this.applicationId = applicationId; }
    public LocalDateTime getScheduledAt() { return scheduledAt; }
    public void setScheduledAt(LocalDateTime scheduledAt) { this.scheduledAt = scheduledAt; }
    public String getMode() { return mode; }
    public void setMode(String mode) { this.mode = mode; }
    public String getMeetingLink() { return meetingLink; }
    public void setMeetingLink(String meetingLink) { this.meetingLink = meetingLink; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }
    public String getApplicantName() { return applicantName; }
    public void setApplicantName(String applicantName) { this.applicantName = applicantName; }
    public String getApplicantEmail() { return applicantEmail; }
    public void setApplicantEmail(String applicantEmail) { this.applicantEmail = applicantEmail; }
    public String getInternshipTitle() { return internshipTitle; }
    public void setInternshipTitle(String internshipTitle) { this.internshipTitle = internshipTitle; }
    public String getInternshipCompany() { return internshipCompany; }
    public void setInternshipCompany(String internshipCompany) { this.internshipCompany = internshipCompany; }
}

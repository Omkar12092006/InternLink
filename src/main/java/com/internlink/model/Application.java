package com.internlink.model;

import java.time.LocalDateTime;

public class Application {
    private int id;
    private int internshipId;
    private String applicantName;
    private String applicantEmail;
    private String university;
    private String coverLetter;
    private String resumeLink;
    private String status;
    private LocalDateTime appliedDate;

    public Application() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getInternshipId() { return internshipId; }
    public void setInternshipId(int internshipId) { this.internshipId = internshipId; }

    public String getApplicantName() { return applicantName; }
    public void setApplicantName(String applicantName) { this.applicantName = applicantName; }

    public String getApplicantEmail() { return applicantEmail; }
    public void setApplicantEmail(String applicantEmail) { this.applicantEmail = applicantEmail; }

    public String getUniversity() { return university; }
    public void setUniversity(String university) { this.university = university; }

    public String getCoverLetter() { return coverLetter; }
    public void setCoverLetter(String coverLetter) { this.coverLetter = coverLetter; }

    public String getResumeLink() { return resumeLink; }
    public void setResumeLink(String resumeLink) { this.resumeLink = resumeLink; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public LocalDateTime getAppliedDate() { return appliedDate; }
    public void setAppliedDate(LocalDateTime appliedDate) { this.appliedDate = appliedDate; }
}

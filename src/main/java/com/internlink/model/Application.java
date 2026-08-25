package com.internlink.model;

import java.sql.Timestamp;

public class Application {
    private int id;
    private int internshipId;
    private String applicantName;
    private String applicantEmail;
    private String university;
    private String coverLetter;
    private String resumeLink;
    private String status;
    private Timestamp appliedDate;

    public Application() {
    }

    public Application(int internshipId, String applicantName, String applicantEmail, String university, String coverLetter, String resumeLink) {
        this.internshipId = internshipId;
        this.applicantName = applicantName;
        this.applicantEmail = applicantEmail;
        this.university = university;
        this.coverLetter = coverLetter;
        this.resumeLink = resumeLink;
        this.status = "Under Review";
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getInternshipId() {
        return internshipId;
    }

    public void setInternshipId(int internshipId) {
        this.internshipId = internshipId;
    }

    public String getApplicantName() {
        return applicantName;
    }

    public void setApplicantName(String applicantName) {
        this.applicantName = applicantName;
    }

    public String getApplicantEmail() {
        return applicantEmail;
    }

    public void setApplicantEmail(String applicantEmail) {
        this.applicantEmail = applicantEmail;
    }

    public String getUniversity() {
        return university;
    }

    public void setUniversity(String university) {
        this.university = university;
    }

    public String getCoverLetter() {
        return coverLetter;
    }

    public void setCoverLetter(String coverLetter) {
        this.coverLetter = coverLetter;
    }

    public String getResumeLink() {
        return resumeLink;
    }

    public void setResumeLink(String resumeLink) {
        this.resumeLink = resumeLink;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getAppliedDate() {
        return appliedDate;
    }

    public void setAppliedDate(Timestamp appliedDate) {
        this.appliedDate = appliedDate;
    }
}

package com.internlink.model;

import java.sql.Date;

public class Internship {
    private int id;
    private String title;
    private String company;
    private boolean paid;
    private String location;
    private String duration;
    private String category;
    private String description;
    private String skills;
    private int applicants;
    private Date postedDate;
    private String stipend;
    private String emoji;
    private String color;

    public Internship() {
    }

    public Internship(int id, String title, String company, boolean paid, String location, String duration, String category, String description, String skills, int applicants, Date postedDate, String stipend, String emoji, String color) {
        this.id = id;
        this.title = title;
        this.company = company;
        this.paid = paid;
        this.location = location;
        this.duration = duration;
        this.category = category;
        this.description = description;
        this.skills = skills;
        this.applicants = applicants;
        this.postedDate = postedDate;
        this.stipend = stipend;
        this.emoji = emoji;
        this.color = color;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getCompany() {
        return company;
    }

    public void setCompany(String company) {
        this.company = company;
    }

    public boolean isPaid() {
        return paid;
    }

    public void setPaid(boolean paid) {
        this.paid = paid;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public String getDuration() {
        return duration;
    }

    public void setDuration(String duration) {
        this.duration = duration;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getSkills() {
        return skills;
    }

    public void setSkills(String skills) {
        this.skills = skills;
    }

    public int getApplicants() {
        return applicants;
    }

    public void setApplicants(int applicants) {
        this.applicants = applicants;
    }

    public Date getPostedDate() {
        return postedDate;
    }

    public void setPostedDate(Date postedDate) {
        this.postedDate = postedDate;
    }

    public String getStipend() {
        return stipend;
    }

    public void setStipend(String stipend) {
        this.stipend = stipend;
    }

    public String getEmoji() {
        return emoji;
    }

    public void setEmoji(String emoji) {
        this.emoji = emoji;
    }

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }

    public String[] getSkillsArray() {
        if (skills == null || skills.isEmpty()) {
            return new String[0];
        }
        return skills.split(",");
    }

    public String getPostedAgo() {
        if (postedDate == null) {
            return "";
        }
        long diffInMillis = System.currentTimeMillis() - postedDate.getTime();
        long diffInDays = diffInMillis / (1000 * 60 * 60 * 24);
        if (diffInDays == 0) {
            return "Today";
        } else if (diffInDays == 1) {
            return "1 day ago";
        } else if (diffInDays < 7) {
            return diffInDays + " days ago";
        } else if (diffInDays < 14) {
            return "1 week ago";
        } else {
            return (diffInDays / 7) + " weeks ago";
        }
    }
}

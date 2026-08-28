package com.internlink.model;

public class Student {
    private int id;
    private String fullName;
    private String email;
    private String password;
    private String phone;
    private String course;

    public Student() {}

    public Student(int id, String fullName, String email, String phone, String course) {
        this.id = id;
        this.fullName = fullName;
        this.email = email;
        this.phone = phone;
        this.course = course;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getCourse() { return course; }
    public void setCourse(String course) { this.course = course; }
}

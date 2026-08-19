package com.internlink.util;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {

    private static final String URL = "jdbc:mysql://localhost:3306/internlink";
    private static final String USER = "root";
    private static final String PASSWORD = "omkar"; // Put your MySQL password here if you have one

    public static Connection getConnection() {
        Connection con = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection(URL, USER, PASSWORD);
            System.out.println("Database Connected Successfully!");
        } 
       catch (Exception e) {
    e.printStackTrace();
}

        return con;
    }
}
package com.internlink.test;

import com.internlink.util.DBConnection;
import java.sql.Connection;

public class TestConnection {
    public static void main(String[] args) {
        try {
            Connection con = DBConnection.getConnection();

            if (con != null) {
                System.out.println("Database Connected Successfully!");
                con.close();
            } else {
                System.out.println("Database Connection Failed!");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
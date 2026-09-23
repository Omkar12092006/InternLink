package com.internlink.dao;

import com.internlink.model.Company;
import com.internlink.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class CompanyDAO {

    public Company getCompanyByEmailAndPassword(String email, String password) {
        String sql = "SELECT * FROM companies WHERE email = ? AND password = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapRow(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public Company getCompanyById(int id) {
        String sql = "SELECT * FROM companies WHERE id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapRow(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean registerCompany(Company company) {
        String fullSql = "INSERT INTO companies(company_name, hr_name, industry, email, password, phone, website, location, description) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?)";
        String legacySql = "INSERT INTO companies(company_name, email, passwordd) VALUES(?, ?, ?)";

        try (Connection con = DBConnection.getConnection()) {
            try (PreparedStatement ps = con.prepareStatement(fullSql)) {
                ps.setString(1, company.getCompanyName());
                ps.setString(2, company.getHrName());
                ps.setString(3, company.getIndustry());
                ps.setString(4, company.getEmail());
                ps.setString(5, company.getPassword());
                ps.setString(6, company.getPhone());
                ps.setString(7, company.getWebsite());
                ps.setString(8, company.getLocation());
                ps.setString(9, company.getDescription());
                if (ps.executeUpdate() > 0) {
                    return true;
                }
            } catch (SQLException fullSqlException) {
                // Legacy schema fallback: older table used `passwordd` and only stored a subset of company columns.
            }

            try (PreparedStatement ps = con.prepareStatement(legacySql)) {
                ps.setString(1, company.getCompanyName());
                ps.setString(2, company.getEmail());
                ps.setString(3, company.getPassword());
                return ps.executeUpdate() > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateCompany(Company company) {
        String sql = "UPDATE companies SET company_name = ?, hr_name = ?, industry = ?, email = ?, phone = ?, website = ?, location = ?, description = ? WHERE id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, company.getCompanyName());
            ps.setString(2, company.getHrName());
            ps.setString(3, company.getIndustry());
            ps.setString(4, company.getEmail());
            ps.setString(5, company.getPhone());
            ps.setString(6, company.getWebsite());
            ps.setString(7, company.getLocation());
            ps.setString(8, company.getDescription());
            ps.setInt(9, company.getId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    private Company mapRow(ResultSet rs) throws SQLException {
        Company company = new Company();
        company.setId(rs.getInt("id"));
        company.setCompanyName(rs.getString("company_name"));
        company.setHrName(rs.getString("hr_name"));
        company.setIndustry(rs.getString("industry"));
        company.setEmail(rs.getString("email"));

        company.setPassword(rs.getString("password"));

        try {
            company.setPhone(rs.getString("phone"));
        } catch (SQLException ignored) {
            company.setPhone(null);
        }

        try {
            company.setWebsite(rs.getString("website"));
        } catch (SQLException ignored) {
            company.setWebsite(null);
        }

        try {
            company.setLocation(rs.getString("location"));
        } catch (SQLException ignored) {
            company.setLocation(null);
        }

        try {
            company.setDescription(rs.getString("description"));
        } catch (SQLException ignored) {
            company.setDescription(null);
        }

        return company;
    }
}

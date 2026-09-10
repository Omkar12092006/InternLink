package com.internlink.dao;

import com.internlink.model.Company;
import com.internlink.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CompanyDAO {
    public boolean register(Company company) {
        String sql = "INSERT INTO companies (company_name, hr_name, industry, email, phone, website, location, description, password) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, company.getCompanyName());
            ps.setString(2, company.getHrName());
            ps.setString(3, company.getIndustry());
            ps.setString(4, company.getEmail());
            ps.setString(5, company.getPhone());
            ps.setString(6, company.getWebsite());
            ps.setString(7, company.getLocation());
            ps.setString(8, company.getDescription());
            ps.setString(9, company.getPassword());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public Company authenticate(String email, String password) {
        return login(email, password);
    }

    public Company login(String email, String password) {
        String sql = "SELECT * FROM companies WHERE email = ? AND password = ?";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, password);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapRow(rs) : null;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

    public Company getById(int id) {
        String sql = "SELECT * FROM companies WHERE id = ?";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapRow(rs) : null;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

    public boolean update(Company company) {
        String sql = "UPDATE companies SET company_name=?, hr_name=?, industry=?, email=?, phone=?, website=?, location=?, description=? WHERE id=?";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
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
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Company> getAll() {
        List<Company> companies = new ArrayList<>();
        String sql = "SELECT * FROM companies ORDER BY created_at DESC";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) companies.add(mapRow(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return companies;
    }

    private Company mapRow(ResultSet rs) throws SQLException {
        Company c = new Company();
        c.setId(rs.getInt("id"));
        c.setCompanyName(rs.getString("company_name"));
        c.setHrName(rs.getString("hr_name"));
        c.setIndustry(rs.getString("industry"));
        c.setEmail(rs.getString("email"));
        c.setPhone(rs.getString("phone"));
        c.setWebsite(rs.getString("website"));
        c.setLocation(rs.getString("location"));
        c.setDescription(rs.getString("description"));
        c.setPassword(rs.getString("password"));
        c.setVerified(rs.getBoolean("verified"));
        return c;
    }
}

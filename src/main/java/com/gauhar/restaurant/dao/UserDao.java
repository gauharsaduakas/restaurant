package com.gauhar.restaurant.dao;

import com.gauhar.restaurant.db.Db;
import com.gauhar.restaurant.model.User;

import java.sql.*;

public class UserDao {

    public User findByEmail(String email) {
        String sql = "SELECT id, full_name, email, password_hash, role FROM users WHERE email = ?";
        try (Connection cn = Db.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User u = new User();
                    u.setId(rs.getLong("id"));
                    u.setFullName(rs.getString("full_name"));
                    u.setEmail(rs.getString("email"));
                    u.setPasswordHash(rs.getString("password_hash"));
                    u.setRole(rs.getString("role"));
                    return u;
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("UserDao.findByEmail failed", e);
        }
        return null;
    }

    public void create(User user) {
        String sql = "INSERT INTO users (full_name, email, password_hash, role) VALUES (?, ?, ?, ?)";
        try (Connection cn = Db.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, user.getFullName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPasswordHash());
            ps.setString(4, user.getRole());
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("UserDao.create failed", e);
        }
    }
}


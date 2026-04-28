package com.gauhar.restaurant.dao;

import com.gauhar.restaurant.db.Db;
import com.gauhar.restaurant.model.MenuItem;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import org.springframework.stereotype.Repository;

@Repository
public class MenuItemDao {

    public List<MenuItem> findAll() {
        List<MenuItem> list = new ArrayList<>();
        String sql = "SELECT id, name, category, price, image_url, available FROM menu_items ORDER BY id";
        try (Connection cn = Db.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(map(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException("MenuItemDao.findAll failed", e);
        }
        return list;
    }

    public Optional<MenuItem> findById(int id) {
        String sql = "SELECT id, name, category, price, image_url, available FROM menu_items WHERE id = ?";
        try (Connection cn = Db.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return Optional.of(map(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException("MenuItemDao.findById failed", e);
        }
        return Optional.empty();
    }

    public MenuItem insert(String name, String category, double price, boolean available, String imageUrl) {
        String sql = "INSERT INTO menu_items (name, category, price, available, image_url) VALUES (?, ?, ?, ?, ?)";
        try (Connection cn = Db.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, name);
            ps.setString(2, category);
            ps.setDouble(3, price);
            ps.setBoolean(4, available);
            ps.setString(5, imageUrl == null ? "" : imageUrl);
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    int newId = rs.getInt(1);
                    return new MenuItem(newId, name, category, price, available, imageUrl);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("MenuItemDao.insert failed", e);
        }
        throw new RuntimeException("Insert returned no generated key");
    }

    public boolean update(int id, String name, String category, double price, boolean available, String imageUrl) {
        String sql = "UPDATE menu_items SET name=?, category=?, price=?, available=?, image_url=? WHERE id=?";
        try (Connection cn = Db.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setString(2, category);
            ps.setDouble(3, price);
            ps.setBoolean(4, available);
            ps.setString(5, imageUrl);
            ps.setInt(6, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new RuntimeException("MenuItemDao.update failed", e);
        }
    }

    public boolean setAvailable(int id, boolean available) {
        String sql = "UPDATE menu_items SET available=? WHERE id=?";
        try (Connection cn = Db.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setBoolean(1, available);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new RuntimeException("MenuItemDao.setAvailable failed", e);
        }
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM menu_items WHERE id=?";
        try (Connection cn = Db.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new RuntimeException("MenuItemDao.delete failed", e);
        }
    }

    public MenuItem getMenuItemById(Long id) {
        return findById(id.intValue()).orElse(null);
    }

    private MenuItem map(ResultSet rs) throws SQLException {
        return new MenuItem(
                rs.getInt("id"),
                rs.getString("name"),
                rs.getString("category"),
                rs.getDouble("price"),
                rs.getBoolean("available"),
                rs.getString("image_url")
        );
    }
}


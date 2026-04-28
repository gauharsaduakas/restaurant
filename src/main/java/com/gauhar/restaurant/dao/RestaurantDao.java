package com.gauhar.restaurant.dao;

import com.gauhar.restaurant.db.Db;
import com.gauhar.restaurant.model.Restaurant;
import org.springframework.stereotype.Repository;
import java.sql.*;

@Repository
public class RestaurantDao {

    public Restaurant findById(int id) {
        String sql = "SELECT id, name, address, phone, work_hours, description FROM restaurant WHERE id = ?";
        try (Connection cn = Db.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return map(rs);
            }
        } catch (SQLException e) {
            throw new RuntimeException("RestaurantDao.findById failed", e);
        }
        return null;
    }

    public void insert(Restaurant r) {
        String sql = "INSERT INTO restaurant (id, name, address, phone, work_hours, description) VALUES (?,?,?,?,?,?)";
        try (Connection cn = Db.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, r.getId());
            ps.setString(2, r.getName());
            ps.setString(3, r.getAddress());
            ps.setString(4, r.getPhone());
            ps.setString(5, r.getWorkHours());
            ps.setString(6, r.getDescription());
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("RestaurantDao.insert failed", e);
        }
    }

    public void update(Restaurant r) {
        String sql = "UPDATE restaurant SET name=?, address=?, phone=?, work_hours=?, description=? WHERE id=?";
        try (Connection cn = Db.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, r.getName());
            ps.setString(2, r.getAddress());
            ps.setString(3, r.getPhone());
            ps.setString(4, r.getWorkHours());
            ps.setString(5, r.getDescription());
            ps.setInt(6, r.getId());
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("RestaurantDao.update failed", e);
        }
    }

    public void save(Restaurant r) {
        if (findById(r.getId()) != null) {
            update(r);
        } else {
            insert(r);
        }
    }

    public Restaurant getOrCreateDefault() {
        Restaurant r = findById(1);
        if (r == null) {
            r = new Restaurant();
            r.setId(1);
            r.setName("Restaurant");
            r.setAddress("Astana, Kabanbay Batyr 53");
            r.setPhone("+7 700 000 00 00");
            r.setWorkHours("10:00 - 23:00");
            r.setDescription("Cafe & Restaurant");
            try { insert(r); } catch (Exception ignored) {}
        }
        return r;
    }

    private Restaurant map(ResultSet rs) throws SQLException {
        Restaurant r = new Restaurant();
        r.setId(rs.getInt("id"));
        r.setName(rs.getString("name"));
        r.setAddress(rs.getString("address"));
        r.setPhone(rs.getString("phone"));
        r.setWorkHours(rs.getString("work_hours"));
        r.setDescription(rs.getString("description"));
        return r;
    }
}


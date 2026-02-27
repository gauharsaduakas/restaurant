package com.gauhar.restaurant.dao;

import com.gauhar.restaurant.db.Db;
import com.gauhar.restaurant.model.*;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.*;

public class OrderDao {

    private final MenuItemDao menuItemDao = new MenuItemDao();

    public Order createOrder(String customerName, String phone, int menuItemId, int qty) {
        String insertOrder = "INSERT INTO orders (customer_name, phone, status, created_at) " +
                             "VALUES (?, ?, ?, SYSUTCDATETIME())";
        String insertItem  = "INSERT INTO order_items (order_id, menu_item_id, qty, price) VALUES (?, ?, ?, ?)";

        MenuItem item = menuItemDao.findById(menuItemId)
                .orElseThrow(() -> new RuntimeException("MenuItem not found: " + menuItemId));

        try (Connection cn = Db.getConnection()) {
            cn.setAutoCommit(false);
            try {
                int orderId;
                try (PreparedStatement ps = cn.prepareStatement(insertOrder, Statement.RETURN_GENERATED_KEYS)) {
                    ps.setString(1, customerName);
                    ps.setString(2, phone == null ? "" : phone);
                    ps.setString(3, OrderStatus.PENDING.name());
                    ps.executeUpdate();
                    try (ResultSet rs = ps.getGeneratedKeys()) {
                        if (!rs.next()) throw new RuntimeException("No generated id for order");
                        orderId = rs.getInt(1);
                    }
                }
                try (PreparedStatement ps = cn.prepareStatement(insertItem)) {
                    ps.setInt(1, orderId);
                    ps.setInt(2, menuItemId);
                    ps.setInt(3, qty);
                    ps.setDouble(4, item.getPrice());
                    ps.executeUpdate();
                }
                cn.commit();
                Order order = new Order(orderId, customerName, phone, OrderStatus.PENDING, LocalDateTime.now());
                order.getItems().add(new OrderItem(item, qty));
                return order;
            } catch (Exception ex) {
                cn.rollback();
                throw ex;
            }
        } catch (SQLException e) {
            throw new RuntimeException("OrderDao.createOrder failed", e);
        }
    }

    public List<Order> findAll() {
        return findByStatuses(null);
    }

    public List<Order> findByStatus(OrderStatus status) {
        return findByStatuses(new OrderStatus[]{status});
    }

    public List<Order> findByStatuses(OrderStatus[] statuses) {
        StringBuilder sql = new StringBuilder(
            "SELECT o.id, o.customer_name, o.phone, o.status, o.created_at, " +
            "       oi.id as oi_id, oi.menu_item_id, oi.qty, oi.price, " +
            "       m.name as m_name, m.category, m.image_url, m.available " +
            "FROM orders o " +
            "LEFT JOIN order_items oi ON oi.order_id = o.id " +
            "LEFT JOIN menu_items m ON m.id = oi.menu_item_id"
        );
        if (statuses != null && statuses.length > 0) {
            sql.append(" WHERE o.status IN (");
            for (int i = 0; i < statuses.length; i++) {
                sql.append(i == 0 ? "?" : ",?");
            }
            sql.append(")");
        }
        sql.append(" ORDER BY o.id DESC, oi.id");

        Map<Integer, Order> map = new LinkedHashMap<>();
        try (Connection cn = Db.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql.toString())) {
            if (statuses != null) {
                for (int i = 0; i < statuses.length; i++) {
                    ps.setString(i + 1, statuses[i].name());
                }
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    int ordId = rs.getInt("id");
                    Order order = map.computeIfAbsent(ordId, id -> {
                        try {
                            String statusStr = rs.getString("status");
                            OrderStatus st = parseStatus(statusStr);
                            Timestamp ts = rs.getTimestamp("created_at");
                            LocalDateTime dt = ts != null ? ts.toLocalDateTime() : LocalDateTime.now();
                            return new Order(id, rs.getString("customer_name"),
                                    rs.getString("phone"), st, dt);
                        } catch (SQLException ex) {
                            throw new RuntimeException(ex);
                        }
                    });
                    int oiId = rs.getInt("oi_id");
                    if (oiId > 0) {
                        int miId = rs.getInt("menu_item_id");
                        int qty = rs.getInt("qty");
                        double price = rs.getDouble("price");
                        String miName = rs.getString("m_name");
                        String miCat = rs.getString("category");
                        String miImg = rs.getString("image_url");
                        boolean miAvail = rs.getBoolean("available");
                        MenuItem mi = new MenuItem(miId, miName, miCat, price, miAvail, miImg);
                        OrderItem oi = new OrderItem(oiId, ordId, mi, qty, price);
                        order.getItems().add(oi);
                    }
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("OrderDao.findByStatuses failed", e);
        }
        return new ArrayList<>(map.values());
    }

    public boolean updateStatus(int orderId, OrderStatus newStatus) {
        String sql = "UPDATE orders SET status=? WHERE id=?";
        try (Connection cn = Db.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, newStatus.name());
            ps.setInt(2, orderId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new RuntimeException("OrderDao.updateStatus failed", e);
        }
    }

    private static OrderStatus parseStatus(String s) {
        if (s == null) return OrderStatus.PENDING;
        try { return OrderStatus.valueOf(s.toUpperCase()); }
        catch (IllegalArgumentException e) { return OrderStatus.PENDING; }
    }
}


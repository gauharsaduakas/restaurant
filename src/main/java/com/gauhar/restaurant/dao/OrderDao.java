package com.gauhar.restaurant.dao;

import com.gauhar.restaurant.db.Db;
import com.gauhar.restaurant.model.*;
import org.springframework.stereotype.Repository;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.*;

@Repository
public class OrderDao {
    private final MenuItemDao menuItemDao;

    public OrderDao(MenuItemDao menuItemDao) {
        this.menuItemDao = menuItemDao;
    }

    // 1. Жаңа заказ жасау (Order объектісі арқылы)
    public Order createOrder(Order order) {
        String insertOrder = "INSERT INTO orders (customer_name, phone, status, created_at, user_id, customer_email, toppings) VALUES (?, ?, ?, CURRENT_TIMESTAMP, ?, ?, ?)";
        String insertItem = "INSERT INTO order_items (order_id, menu_item_id, qty, price, options, options_price) VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection cn = Db.getConnection()) {
            cn.setAutoCommit(false);
            try {
                int orderId;
                try (PreparedStatement ps = cn.prepareStatement(insertOrder, Statement.RETURN_GENERATED_KEYS)) {
                    ps.setString(1, order.getCustomerName());
                    ps.setString(2, order.getPhone());
                    ps.setString(3, OrderStatus.PENDING.name());
                    if (order.getUserId() != null) ps.setLong(4, order.getUserId()); else ps.setNull(4, Types.BIGINT);
                    ps.setString(5, order.getCustomerEmail());
                    ps.setString(6, order.getToppings());
                    ps.executeUpdate();
                    ResultSet rs = ps.getGeneratedKeys();
                    if (rs.next()) orderId = rs.getInt(1); else throw new SQLException("ID алынбады");
                }

                for (OrderItem item : order.getItems()) {
                    try (PreparedStatement ps = cn.prepareStatement(insertItem)) {
                        ps.setInt(1, orderId);
                        ps.setInt(2, item.getMenuItem().getId());
                        ps.setInt(3, item.getQuantity());
                        ps.setDouble(4, item.getPriceAtMoment());
                        String opts = (item.getOptions() != null) ? String.join(",", item.getOptions()) : null;
                        ps.setString(5, opts);
                        ps.setDouble(6, item.getOptionsPrice());
                        ps.executeUpdate();
                    }
                }
                cn.commit();
                order.setId(orderId);
                return order;
            } catch (Exception ex) {
                cn.rollback();
                throw ex;
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    // 2. ID бойынша іздеу (Сенің қатең осы жерде болған)
    public Order findById(int orderId) {
        return findAll().stream()
                .filter(o -> o.getId() == orderId)
                .findFirst()
                .orElse(null);
    }

    public List<Order> findAll() {
        return findByStatuses(null);
    }

    public boolean updateStatus(int orderId, OrderStatus status) {
        String sql = "UPDATE orders SET status = ? WHERE id = ?";
        try (Connection cn = Db.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, status.name());
            ps.setInt(2, orderId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new RuntimeException("Error updating order status", e);
        }
    }

    public List<Order> findByStatus(OrderStatus status) {
        if (status == null) return findAll();
        return findByStatuses(new OrderStatus[]{status});
    }

    public List<Order> findByStatuses(OrderStatus[] statuses) {
        Map<Integer, Order> map = new LinkedHashMap<>();

        StringBuilder sql = new StringBuilder(
                "SELECT o.id, o.customer_name, o.phone, o.status, o.created_at, " + // Поля из таблицы orders (o)
                        "o.user_id, o.customer_email, o.toppings, " +
                        "oi.id as oi_id, oi.menu_item_id, oi.qty, oi.price as oi_price, " + // Поля из таблицы order_items (oi)
                        "oi.options, oi.options_price, m.name as m_name " +
                        "FROM orders o " +
                        "LEFT JOIN order_items oi ON o.id = oi.order_id " +
                        "LEFT JOIN menu_items m ON oi.menu_item_id = m.id "
        );
        if (statuses != null && statuses.length > 0) {
            sql.append(" WHERE o.status IN (");
            for (int i = 0; i < statuses.length; i++) {
                sql.append("'").append(statuses[i].name()).append("'");
                if (i < statuses.length - 1) sql.append(",");
            }
            sql.append(") ");
        }
        sql.append(" ORDER BY o.id DESC");

        try (Connection cn = Db.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql.toString());
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                int id = rs.getInt("id");
                Order order = map.computeIfAbsent(id, k -> {
                    try {
                        Order o = new Order(
                                id,
                                rs.getString("customer_name"),
                                rs.getString("phone"),
                                OrderStatus.valueOf(rs.getString("status")),
                                rs.getTimestamp("created_at").toLocalDateTime()
                        );
                        o.setCustomerEmail(rs.getString("customer_email"));
                        o.setToppings(rs.getString("toppings"));
                        if (rs.getObject("user_id") != null) {
                            o.setUserId(rs.getLong("user_id"));
                        }
                        return o;
                    } catch (SQLException e) {
                        throw new RuntimeException(e);
                    }
                });

                int oiId = rs.getInt("oi_id");
                if (oiId > 0) {
                    MenuItem mi = new MenuItem();
                    mi.setId(rs.getInt("menu_item_id"));
                    mi.setName(rs.getString("m_name"));

                    String optStr = rs.getString("options");
                    List<String> opts = (optStr != null && !optStr.isBlank())
                            ? Arrays.asList(optStr.split(","))
                            : new ArrayList<>();

                    order.getItems().add(new OrderItem(
                            oiId,
                            id,
                            mi,
                            rs.getInt("qty"),
                            rs.getDouble("oi_price"),
                            opts,
                            rs.getDouble("options_price")
                    ));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return new ArrayList<>(map.values());
    }

    public Order createOrder(Long userId, String email, String customerName, String phone, int menuItemId, int quantity, String toppings) {
        Order order = new Order();
        order.setUserId(userId);
        order.setCustomerEmail(email);
        order.setCustomerName(customerName);
        order.setPhone(phone);
        order.setToppings(toppings);

        MenuItem mi = menuItemDao.findById(menuItemId).orElseThrow(() -> new RuntimeException("Item not found"));
        OrderItem item = new OrderItem(mi, quantity, mi.getPrice(), new ArrayList<>(), 0);
        order.getItems().add(item);

        return createOrder(order);
    }

    public List<Order> findByUserId(Long userId) {
        List<Order> result = new ArrayList<>();
        for (Order o : findAll()) {
            if (Objects.equals(o.getUserId(), userId)) {
                result.add(o);
            }
        }
        return result;
    }
}


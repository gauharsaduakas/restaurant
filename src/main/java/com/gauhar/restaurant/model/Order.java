package com.gauhar.restaurant.model;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class Order {
    private Integer id; // int-тен Integer-ге ауыстырдық (null-мен жұмыс істеу үшін)
    private String customerName;
    private String phone;
    private LocalDateTime createdAt;
    private OrderStatus status;
    private List<OrderItem> items = new ArrayList<>();
    private Long userId;
    private String customerEmail;
    private String toppings;

    public Order() {
        this.createdAt = LocalDateTime.now();
        this.status = OrderStatus.PENDING;
    }

    public Order(int id, String customerName, String phone, OrderStatus status, LocalDateTime createdAt) {
        this.id = id;
        this.customerName = customerName;
        this.phone = phone;
        this.status = status;
        this.createdAt = createdAt != null ? createdAt : LocalDateTime.now();
    }

    // Бағаны есептеу әдісі (JSP-де қате бермес үшін)
    public double getTotalAmount() {
        if (items == null || items.isEmpty()) return 0.0;
        return items.stream()
                .mapToDouble(item -> (item.getPriceAtMoment() + item.getOptionsPrice()) * item.getQuantity())
                .sum();
    }

    // Геттерлер мен сеттерлер
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    public OrderStatus getStatus() { return status; }
    public void setStatus(OrderStatus status) { this.status = status; }
    public List<OrderItem> getItems() { return items; }
    public void setItems(List<OrderItem> items) { this.items = items; }
    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }
    public String getCustomerEmail() { return customerEmail; }
    public void setCustomerEmail(String customerEmail) { this.customerEmail = customerEmail; }
    public String getToppings() { return toppings; }
    public void setToppings(String toppings) { this.toppings = toppings; }
}
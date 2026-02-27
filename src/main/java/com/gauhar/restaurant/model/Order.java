package com.gauhar.restaurant.model;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class Order {
    private int id;
    private String customerName;
    private String phone;
    private LocalDateTime createdAt;
    private OrderStatus status;
    private List<OrderItem> items = new ArrayList<>();

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

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

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

    public double getTotalAmount() {
        return items.stream().mapToDouble(OrderItem::getLineTotal).sum();
    }
}

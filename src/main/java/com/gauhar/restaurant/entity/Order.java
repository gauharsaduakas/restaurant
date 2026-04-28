package com.gauhar.restaurant.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "orders") // Убедитесь, что таблица в БД называется именно так
public class Order {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // В базе у вас customer_email (судя по OrderDao)
    @Column(name = "customer_email", nullable = false)
    private String userEmail;

    // В базе это поле часто называют total_price
    @Column(name = "total_price")
    private double totalAmount;

    // Вы получили ошибку 'created_at', значит в БД колонка называется так
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime orderDate;

    @Column(name = "status", length = 50)
    private String status;

    @Column(name = "customer_name")
    private String customerName;

    @Column(name = "phone")
    private String phone;

    @Column(name = "toppings")
    private String toppings;

    @Column(name = "user_id")
    private Long userId;

    // Связь с элементами заказа
    @OneToMany(mappedBy = "order", cascade = CascadeType.ALL, fetch = FetchType.LAZY, orphanRemoval = true)
    private List<OrderItem> items = new ArrayList<>();

    // Конструктор по умолчанию (обязателен для JPA)
    public Order() {
        this.orderDate = LocalDateTime.now();
    }

    // Вспомогательный метод для добавления элементов
    public void addItem(OrderItem item) {
        items.add(item);
        item.setOrder(this);
    }

    // --- Геттеры и Сеттеры ---

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getUserEmail() { return userEmail; }
    public void setUserEmail(String userEmail) { this.userEmail = userEmail; }

    public double getTotalAmount() { return totalAmount; }
    public void setTotalAmount(double totalAmount) { this.totalAmount = totalAmount; }

    public LocalDateTime getOrderDate() { return orderDate; }
    public void setOrderDate(LocalDateTime orderDate) { this.orderDate = orderDate; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public List<OrderItem> getItems() { return items; }
    public void setItems(List<OrderItem> items) { this.items = items; }

    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getToppings() { return toppings; }
    public void setToppings(String toppings) { this.toppings = toppings; }

    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }
}
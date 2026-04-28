package com.gauhar.restaurant.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "order_items")
public class OrderItem {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "order_id", nullable = false)
    private Order order;

    // Обычно мы храним ID блюда из таблицы menu_items
    @Column(name = "menu_item_id")
    private Integer menuItemId;

    // Название блюда на момент заказа (чтобы осталось в истории)
    @Column(name = "item_name")
    private String itemName;

    @Column(name = "qty")
    private int quantity;

    @Column(name = "price")
    private double price;

    @Column(name = "options")
    private String options;

    @Column(name = "options_price")
    private double optionsPrice;

    // Конструктор по умолчанию для JPA
    public OrderItem() {}

    // Геттеры и сеттеры
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Order getOrder() { return order; }
    public void setOrder(Order order) { this.order = order; }

    public Integer getMenuItemId() { return menuItemId; }
    public void setMenuItemId(Integer menuItemId) { this.menuItemId = menuItemId; }

    public String getItemName() { return itemName; }
    public void setItemName(String itemName) { this.itemName = itemName; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }

    public String getOptions() { return options; }
    public void setOptions(String options) { this.options = options; }

    public double getOptionsPrice() { return optionsPrice; }
    public void setOptionsPrice(double optionsPrice) { this.optionsPrice = optionsPrice; }
}
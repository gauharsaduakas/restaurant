package com.gauhar.restaurant.model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

public class OrderItem implements Serializable {
    private int id;
    private int orderId;
    private MenuItem menuItem;
    private int quantity;
    private double priceAtMoment; // Заказ жасалған кездегі тағам бағасы
    private List<String> options = new ArrayList<>();
    private double optionsPrice; // Қосымша ингредиенттердің жалпы бағасы

    // Пустой конструктор для сериализации
    public OrderItem() {
        this.options = new ArrayList<>();
    }

    // Конструктор: Жаңа заказ жасау үшін корзинадан (CartItem -> OrderItem)
    public OrderItem(MenuItem menuItem, int quantity, List<String> options) {
        this.menuItem = menuItem;
        this.quantity = quantity;
        this.priceAtMoment = (menuItem != null) ? menuItem.getPrice() : 0;
        this.options = options != null ? options : new ArrayList<>();
        this.optionsPrice = calculateOptionsPrice(this.options);
    }

    // Конструктор: С полными параметрами (для DAO и создания из форм)
    public OrderItem(MenuItem menuItem, int quantity, double priceAtMoment, List<String> options, double optionsPrice) {
        this.menuItem = menuItem;
        this.quantity = quantity;
        this.priceAtMoment = priceAtMoment;
        this.options = options != null ? options : new ArrayList<>();
        this.optionsPrice = optionsPrice;
    }

    // Конструктор: С ID (для загрузки из базы)
    public OrderItem(int id, int orderId, MenuItem menuItem, int quantity, double priceAtMoment, List<String> options, double optionsPrice) {
        this.id = id;
        this.orderId = orderId;
        this.menuItem = menuItem;
        this.quantity = quantity;
        this.priceAtMoment = priceAtMoment;
        this.options = options != null ? options : new ArrayList<>();
        this.optionsPrice = optionsPrice;
    }


    private double calculateOptionsPrice(List<String> options) {
        double total = 0;
        if (options == null) return 0;
        for (String opt : options) {
            switch (opt.toLowerCase()) {
                case "cheese":    total += 50.0;  break;
                case "pepperoni": total += 100.0; break;
                case "mushrooms": total += 80.0;  break;
                case "olives":    total += 70.0;  break;
                case "patty":     total += 120.0; break;
                case "onion":     total += 30.0;  break;
                case "sauce":     total += 20.0;  break;
            }
        }
        return total;
    }

    // Бір тағамның жалпы бағасы (Тағам + Опциялар) * Саны
    public double getLineTotal() {
        return (priceAtMoment + optionsPrice) * quantity;
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }

    public MenuItem getMenuItem() { return menuItem; }
    public void setMenuItem(MenuItem menuItem) { this.menuItem = menuItem; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public double getPriceAtMoment() { return priceAtMoment; }
    public void setPriceAtMoment(double priceAtMoment) { this.priceAtMoment = priceAtMoment; }

    public List<String> getOptions() { return options; }
    public void setOptions(List<String> options) { this.options = options; }

    public double getOptionsPrice() { return optionsPrice; }
    public void setOptionsPrice(double optionsPrice) { this.optionsPrice = optionsPrice; }
}
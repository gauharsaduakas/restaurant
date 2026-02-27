package com.gauhar.restaurant.model;

public class OrderItem {
    private int id;
    private int orderId;
    private MenuItem menuItem;
    private int quantity;
    private double priceAtMoment;

    public OrderItem() {}

    public OrderItem(MenuItem menuItem, int quantity) {
        this.menuItem = menuItem;
        this.quantity = quantity;
        this.priceAtMoment = menuItem != null ? menuItem.getPrice() : 0;
    }

    public OrderItem(int id, int orderId, MenuItem menuItem, int quantity, double priceAtMoment) {
        this.id = id;
        this.orderId = orderId;
        this.menuItem = menuItem;
        this.quantity = quantity;
        this.priceAtMoment = priceAtMoment;
    }

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

    public double getLineTotal() {
        return priceAtMoment * quantity;
    }
}

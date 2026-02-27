package com.gauhar.restaurant.model;

public class MenuItem {
    private int id;
    private String name;
    private String category;
    private double price;
    private boolean available;
    private String imageUrl;

    public MenuItem(int id, String name, String category, double price, boolean available) {
        this(id, name, category, price, available, "");
    }

    public MenuItem(int id, String name, String category, double price, boolean available, String imageUrl) {
        this.id = id;
        this.name = name;
        this.category = category;
        this.price = price;
        this.available = available;
        this.imageUrl = imageUrl == null ? "" : imageUrl.trim();
    }

    public int getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public String getCategory() {
        return category;
    }

    public double getPrice() {
        return price;
    }

    public boolean isAvailable() {
        return available;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setId(int id) {
        this.id = id;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public void setAvailable(boolean available) {
        this.available = available;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl == null ? "" : imageUrl.trim();
    }
}

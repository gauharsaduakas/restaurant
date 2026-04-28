package com.gauhar.restaurant.model;

import java.io.Serializable;
import java.util.List;

public class CartItem implements Serializable {
    private Long menuItemId;
    private String name;
    private double price;
    private int quantity;
    private List<String> options;

    public CartItem(Long menuItemId, String name, double price, int quantity, List<String> options) {
        this.menuItemId = menuItemId;
        this.name = name;
        this.price = price;
        this.quantity = quantity;
        this.options = options;
    }

    public double getTotalPrice() {
        double optionPrice = 0;
        if (options != null) {
            for (String opt : options) {
                // JSP-дегі value мен бағаларға сәйкестендіру
                switch (opt.toLowerCase()) {
                    case "cheese":    optionPrice += 50.0;  break;
                    case "pepperoni": optionPrice += 100.0; break;
                    case "mushrooms": optionPrice += 80.0;  break;
                    case "olives":    optionPrice += 70.0;  break;
                    case "patty":     optionPrice += 120.0; break;
                    case "onion":     optionPrice += 30.0;  break;
                    case "sauce":     optionPrice += 20.0;  break;
                }
            }
        }
        return (this.price + optionPrice) * this.quantity;
    }

    // Геттерлер мен Сеттерлер
    public Long getMenuItemId() { return menuItemId; }
    public String getName() { return name; }
    public double getPrice() { return price; }
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
    public List<String> getOptions() { return options; }
}
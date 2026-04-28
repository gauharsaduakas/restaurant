package com.gauhar.restaurant.model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

public class Cart implements Serializable {

    private List<CartItem> items = new ArrayList<>();

    public void addItem(CartItem newItem) {
        for (CartItem item : items) {
            if (Objects.equals(item.getMenuItemId(), newItem.getMenuItemId()) &&
                    Objects.equals(item.getOptions(), newItem.getOptions())) {
                item.setQuantity(item.getQuantity() + newItem.getQuantity());
                return;
            }
        }
        items.add(newItem);
    }

    public void removeItem(Long menuItemId, List<String> options) {
        items.removeIf(item -> Objects.equals(item.getMenuItemId(), menuItemId) &&
                Objects.equals(item.getOptions(), options));
    }

    public void updateQuantity(Long menuItemId, List<String> options, int quantity) {
        for (CartItem item : items) {
            if (Objects.equals(item.getMenuItemId(), menuItemId) &&
                    Objects.equals(item.getOptions(), options)) {
                if (quantity <= 0) {
                    items.remove(item);
                } else {
                    item.setQuantity(quantity);
                }
                return;
            }
        }
    }

    public List<CartItem> getItems() {
        return items;
    }

    public double getTotal() {
        return items.stream()
                .mapToDouble(CartItem::getTotalPrice)
                .sum();
    }

    public void clear() {
        items.clear();
    }
}


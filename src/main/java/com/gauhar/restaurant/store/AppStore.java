package com.gauhar.restaurant.store;

import com.gauhar.restaurant.model.*;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class AppStore {

    private static int menuSeq = 1;
    private static int orderSeq = 1;

    private static final Restaurant restaurant =
            new Restaurant(1, "My Restaurant", "Astana, Main St 1", "+7 777 777 77 77");

    private static final List<MenuItem> menuItems = new ArrayList<>();
    private static final List<Order> orders = new ArrayList<>();

    static {
        menuItems.add(new MenuItem(menuSeq++, "Burger", "FastFood", 1500, true, "/assets/img/burger.jpg"));
        menuItems.add(new MenuItem(menuSeq++, "Pizza", "FastFood", 2500, true, "/assets/img/pizza.jpg"));
        menuItems.add(new MenuItem(menuSeq++, "Coffee", "Drinks", 800, true, "/assets/img/coffee.jpg"));
    }



    public static Restaurant getRestaurant() {
        return restaurant;
    }

    public static void updateRestaurant(String name, String address, String phone) {
        restaurant.setName(name);
        restaurant.setAddress(address);
        restaurant.setPhone(phone);
    }

    public static List<MenuItem> getMenuItems() {
        return menuItems;
    }

    public static void addMenuItem(String name, String category, double price, boolean available, String imageUrl) {
        menuItems.add(new MenuItem(menuSeq++, name, category, price, available, imageUrl));
    }

    public static void addMenuItem(String name, String category, double price, boolean available) {
        addMenuItem(name, category, price, available, "");
    }

    public static Optional<MenuItem> findMenuItem(int id) {
        return menuItems.stream().filter(m -> m.getId() == id).findFirst();
    }

    public static boolean updateMenuItem(int id, String name, String category, double price, boolean available, String imageUrl) {
        Optional<MenuItem> opt = findMenuItem(id);
        if (opt.isEmpty()) return false;

        MenuItem m = opt.get();
        m.setName(name);
        m.setCategory(category);
        m.setPrice(price);
        m.setAvailable(available);
        m.setImageUrl(imageUrl);
        return true;
    }

    public static boolean updateMenuItem(int id, String name, String category, double price, boolean available) {
        return updateMenuItem(id, name, category, price, available, "");
    }

    public static boolean deleteMenuItem(int id) {
        return menuItems.removeIf(m -> m.getId() == id);
    }

    public static List<Order> getOrders() {
        return orders;
    }

    public static void createOrder(String customerName, int menuItemId, int quantity) {
        if (quantity <= 0) throw new IllegalArgumentException("Quantity must be > 0");
        MenuItem item = findMenuItem(menuItemId).orElseThrow();
        Order order = new Order(orderSeq++, customerName, "", OrderStatus.PENDING, java.time.LocalDateTime.now());
        order.getItems().add(new OrderItem(item, quantity));
        orders.add(order);
    }

    public static boolean cancelOrder(int orderId) {
        for (Order o : orders) {
            if (o.getId() == orderId) {
                if (o.getStatus() == OrderStatus.CANCELLED) return true;
                o.setStatus(OrderStatus.CANCELLED);
                return true;
            }
        }
        return false;
    }
}

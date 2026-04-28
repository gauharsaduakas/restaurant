package com.gauhar.restaurant.controller;

import com.gauhar.restaurant.dao.MenuItemDao;
import com.gauhar.restaurant.model.Cart;
import com.gauhar.restaurant.model.CartItem;
import com.gauhar.restaurant.model.MenuItem;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

@Controller
@RequestMapping("/cart")
public class CartController {

    @Autowired
    private MenuItemDao menuItemDao;
    // ❌ ПЛОХО — создаёт новый объект вручную, минуя Spring DI
    com.gauhar.restaurant.dao.RestaurantDao restaurantDao = new com.gauhar.restaurant.dao.RestaurantDao();
    @PostMapping("/add")
    public String addToCart(
            @RequestParam Long menuItemId,
            @RequestParam(defaultValue = "1") int quantity,
            @RequestParam(required = false) String[] options, // Массив ретінде қабылдаймыз
            HttpSession session) {

        MenuItem menuItem = menuItemDao.findById(menuItemId.intValue()).orElse(null);

        if (menuItem != null) {
            Cart cart = (Cart) session.getAttribute("cart");
            if (cart == null) {
                cart = new Cart();
                session.setAttribute("cart", cart);
            }

            List<String> opts = (options != null) ? Arrays.asList(options) : new ArrayList<>();

            CartItem item = new CartItem(
                    (long) menuItem.getId(),
                    menuItem.getName(),
                    menuItem.getPrice(),
                    quantity,
                    opts
            );

            cart.addItem(item);
        }
        return "redirect:/cart";
    }

    @PostMapping("/update")
    public String updateQuantity(
            @RequestParam Long menuItemId,
            @RequestParam(required = false) String[] options,
            @RequestParam int quantity,
            HttpSession session) {
        Cart cart = (Cart) session.getAttribute("cart");
        if (cart != null) {
            List<String> opts = (options != null) ? Arrays.asList(options) : new ArrayList<>();
            cart.updateQuantity(menuItemId, opts, quantity);
        }
        return "redirect:/cart";
    }

    @PostMapping("/remove")
    public String removeFromCart(
            @RequestParam Long menuItemId,
            @RequestParam(required = false) String[] options,
            HttpSession session) {
        Cart cart = (Cart) session.getAttribute("cart");
        if (cart != null) {
            List<String> opts = (options != null) ? Arrays.asList(options) : new ArrayList<>();
            cart.removeItem(menuItemId, opts);
        }
        return "redirect:/cart";
    }

    @GetMapping
    public String viewCart(HttpSession session, org.springframework.ui.Model model) {
        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null) {
            cart = new Cart();
            session.setAttribute("cart", cart);
        }
        model.addAttribute("cart", cart);

        try {
            com.gauhar.restaurant.dao.RestaurantDao restaurantDao = new com.gauhar.restaurant.dao.RestaurantDao();
            com.gauhar.restaurant.model.Restaurant restaurant = restaurantDao.getOrCreateDefault();
            model.addAttribute("restaurant", restaurant);
        } catch (Exception e) {
            model.addAttribute("restaurant", new com.gauhar.restaurant.model.Restaurant());
        }
        return "cart"; // ✅ JSP view name
    }
}
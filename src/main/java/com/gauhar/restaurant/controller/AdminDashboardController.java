package com.gauhar.restaurant.controller;

import com.gauhar.restaurant.entity.User;
import com.gauhar.restaurant.entity.Order; // Предположим, у вас есть сущность Order
import com.gauhar.restaurant.service.UserService;
import com.gauhar.restaurant.service.OrderService; // Предположим, у вас есть OrderService
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;

@Controller
@RequestMapping("/admin")
public class AdminDashboardController {

    private final UserService userService;
    // private final OrderService orderService; // Раскомментируйте, когда создадите сервис

    public AdminDashboardController(UserService userService) {
        this.userService = userService;
        // this.orderService = orderService;
    }

    @GetMapping
    public String adminHome() {
        return "admin/dashboard";
    }

    @GetMapping("/users")
    public String listUsers(Model model) {
        model.addAttribute("users", userService.getAllUsers());
        return "admin/users";
    }

    @GetMapping("/users/{id}")
    public String userDetail(@PathVariable Long id, Model model) {
        User user = userService.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Пользователь не найден"));
        model.addAttribute("user", user);
        return "admin/user-detail";
    }

    @PostMapping("/users/{id}/delete")
    public String deleteUser(@PathVariable Long id) {
        userService.deleteUser(id);
        return "redirect:/admin/users";
    }

    @GetMapping("/menu-items")
    public String menuItems(Model model) {
        // Здесь можно добавить menuService.getAllItems()
        return "admin/menu-items";
    }

    /**
     * ИСПРАВЛЕННЫЙ МЕТОД ДЛЯ ЗАКАЗОВ
     */
    @GetMapping("/orders")
    public String orders(Model model) {
        // Передаем пустой список, чтобы JSTL не падал при итерации
        List<Order> allOrders = new ArrayList<>();
        // allOrders = orderService.getAllOrders(); // Раскомментируйте позже

        model.addAttribute("orders", allOrders);

        // ВНИМАНИЕ: убедитесь, что файл лежит в /WEB-INF/views/admin/orders.jsp
        return "admin/orders";
    }

    @GetMapping("/statistics")
    public String statistics(Model model) {
        return "admin/statistics";
    }
}
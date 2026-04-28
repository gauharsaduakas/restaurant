package com.gauhar.restaurant.controller;

import com.gauhar.restaurant.dao.OrderDao;
import com.gauhar.restaurant.dao.RestaurantDao;
import com.gauhar.restaurant.model.Order;
import com.gauhar.restaurant.model.OrderStatus;
import com.gauhar.restaurant.model.Restaurant;
import com.gauhar.restaurant.service.EmailService;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.ArrayList;
import java.util.List;

@Controller
@RequestMapping("/kitchen")
public class KitchenController {

    private final OrderDao orderDao;
    private final RestaurantDao restaurantDao;
    private final EmailService emailService;

    public KitchenController(OrderDao orderDao, RestaurantDao restaurantDao, EmailService emailService) {
        this.orderDao = orderDao;
        this.restaurantDao = restaurantDao;
        this.emailService = emailService;
    }

    @GetMapping
    public String kitchenDashboard(Model model, Authentication auth) {
        try {
            // Получаем заказы в готовке и готовые
            List<Order> cooking = orderDao.findByStatus(OrderStatus.PREPARING);
            List<Order> ready = orderDao.findByStatus(OrderStatus.READY);

            if (cooking == null) cooking = new ArrayList<>();
            if (ready == null) ready = new ArrayList<>();

            model.addAttribute("cooking", cooking);
            model.addAttribute("ready", ready);

            // Добавляем информацию о ресторане
            try {
                Restaurant restaurant = restaurantDao.getOrCreateDefault();
                model.addAttribute("restaurant", restaurant);
            } catch (Exception ignored) {
                Restaurant defaultRest = new Restaurant();
                model.addAttribute("restaurant", defaultRest);
            }

            // Определяем роль пользователя
            String role = getRole(auth);
            model.addAttribute("role", role);
            model.addAttribute("isAdmin", "ADMIN".equals(role));

        } catch (Exception e) {
            model.addAttribute("cooking", new ArrayList<>());
            model.addAttribute("ready", new ArrayList<>());
            model.addAttribute("restaurant", new Restaurant());
            model.addAttribute("role", getRole(auth));
            model.addAttribute("isAdmin", false);
        }

        return "kitchen"; // ✅ JSP view name
    }

    @PostMapping("/{orderId}/start")
    public String startCooking(@PathVariable int orderId, RedirectAttributes flash) {
        try {
            Order order = orderDao.findById(orderId);
            if (order != null) {
                order.setStatus(OrderStatus.PREPARING);
                orderDao.updateStatus(orderId, OrderStatus.PREPARING);
                flash.addFlashAttribute("successMsg", "Заказ #" + orderId + " поставлен в готовку");
            }
        } catch (Exception e) {
            flash.addFlashAttribute("errorMsg", "Ошибка: " + e.getMessage());
        }
        return "redirect:/kitchen";
    }

    @PostMapping("/{orderId}/ready")
    public String markReady(@PathVariable int orderId, RedirectAttributes flash) {
        try {
            Order order = orderDao.findById(orderId);
            if (order != null) {
                order.setStatus(OrderStatus.READY);
                orderDao.updateStatus(orderId, OrderStatus.READY);

                // Отправляем уведомление клиенту если есть email
                if (order.getCustomerEmail() != null && !order.getCustomerEmail().isBlank()) {
                    try {
                        String customerName = order.getCustomerName() != null ? order.getCustomerName() : "Клиент";
                        emailService.sendOrderReadyEmail(order.getCustomerEmail(), customerName, orderId);
                    } catch (Exception ignored) {}
                }

                flash.addFlashAttribute("successMsg", "Заказ #" + orderId + " готов к выдаче");
            }
        } catch (Exception e) {
            flash.addFlashAttribute("errorMsg", "Ошибка: " + e.getMessage());
        }
        return "redirect:/kitchen";
    }

    @PostMapping("/{orderId}/done")
    public String markDone(@PathVariable int orderId, RedirectAttributes flash) {
        try {
            Order order = orderDao.findById(orderId);
            if (order != null) {
                order.setStatus(OrderStatus.DONE);
                orderDao.updateStatus(orderId, OrderStatus.DONE);

                // Отправляем уведомление клиенту если есть email
                if (order.getCustomerEmail() != null && !order.getCustomerEmail().isBlank()) {
                    try {
                        String customerName = order.getCustomerName() != null ? order.getCustomerName() : "Клиент";
                        emailService.sendOrderDoneEmail(order.getCustomerEmail(), customerName, orderId);
                    } catch (Exception ignored) {}
                }

                flash.addFlashAttribute("successMsg", "Заказ #" + orderId + " выдан клиенту");
            }
        } catch (Exception e) {
            flash.addFlashAttribute("errorMsg", "Ошибка: " + e.getMessage());
        }
        return "redirect:/kitchen";
    }

    @PostMapping("/action")
    public String handleAction(@RequestParam int id,
                              @RequestParam String action,
                              RedirectAttributes flash) {
        try {
            if ("toReady".equals(action)) {
                return markReady(id, flash);
            } else if ("toDone".equals(action)) {
                return markDone(id, flash);
            }
        } catch (Exception e) {
            flash.addFlashAttribute("errorMsg", "Неизвестное действие");
        }
        return "redirect:/kitchen";
    }

    private String getRole(Authentication auth) {
        if (auth == null) return "CLIENT";
        for (GrantedAuthority a : auth.getAuthorities()) {
            String authority = a.getAuthority();
            if (authority != null && authority.startsWith("ROLE_")) {
                return authority.substring(5);
            }
        }
        return "CLIENT";
    }
}


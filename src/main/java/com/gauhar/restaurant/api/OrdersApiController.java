package com.gauhar.restaurant.api;

import com.gauhar.restaurant.dao.MenuItemDao;
import com.gauhar.restaurant.dao.OrderDao;
import com.gauhar.restaurant.model.Order;
import com.gauhar.restaurant.model.OrderStatus;
import com.gauhar.restaurant.service.EmailService;
import com.gauhar.restaurant.util.SecurityUtils;
import org.springframework.web.bind.annotation.*;

import java.util.Map;
import com.gauhar.restaurant.entity.User;

@RestController
@RequestMapping("/api/orders")
public class OrdersApiController {

    private final OrderDao orderDao;
    private final SecurityUtils securityUtils;
    private final EmailService emailService;

    public OrdersApiController(SecurityUtils securityUtils, EmailService emailService) {
        this.securityUtils = securityUtils;
        this.emailService = emailService;
        this.orderDao = new OrderDao(new MenuItemDao());
    }

    @GetMapping
    public Object all() {
        User currentUser = securityUtils.getCurrentUser();
        if (currentUser == null) {
            return Map.of("error", "unauthorized", "message", "Login required");
        }

        if ("ADMIN".equals(currentUser.getRole())) {
            return orderDao.findAll();
        } else {
            return orderDao.findByUserId(currentUser.getId());
        }
    }

    @PostMapping
    public Map<String, Object> create(@RequestBody Map<String, Object> body) {
        User currentUser = securityUtils.getCurrentUser();
        if (currentUser == null) {
            return Map.of("error", "unauthorized", "message", "Login required");
        }

        String customerName = str(body.get("customerName"));
        String phone = str(body.get("phone"));
        int menuItemId = integer(body.get("menuItemId"));
        int quantity = integer(body.get("quantity"));

        if (customerName.isBlank() || menuItemId <= 0 || quantity <= 0) {
            return Map.of("error", "validation", "message", "customerName/menuItemId/quantity required");
        }

        try {
            Order created = orderDao.createOrder(
                    currentUser.getId(),
                    currentUser.getEmail(),
                    customerName,
                    phone,
                    menuItemId,
                    quantity
                    , ""
            );

            try {
                emailService.sendOrderAcceptedEmail(
                        currentUser.getEmail(),
                        currentUser.getFullName(),
                        created.getId()
                );
            } catch (Exception ignored) {
            }

            return Map.of("status", "created", "order", created);
        } catch (Exception e) {
            return Map.of("error", "create_failed", "message", e.getMessage());
        }
    }

    @PostMapping("/{id}/status")
    public Map<String, Object> status(@PathVariable int id, @RequestParam String status) {
        User currentUser = securityUtils.getCurrentUser();
        if (currentUser == null) {
            return Map.of("error", "unauthorized", "message", "Login required");
        }
        if (!"ADMIN".equals(currentUser.getRole())) {
            return Map.of("error", "forbidden", "message", "Admin only");
        }

        try {
            OrderStatus st = OrderStatus.valueOf(status.toUpperCase());
            boolean ok = orderDao.updateStatus(id, st);

            Order order = orderDao.findById(id);
            if (ok && order != null && order.getCustomerEmail() != null && !order.getCustomerEmail().isBlank()) {
                String customerName = order.getCustomerName() != null ? order.getCustomerName() : "Клиент";
                try {
                    switch (st) {
                        case CONFIRMED -> emailService.sendOrderAcceptedEmail(order.getCustomerEmail(), customerName, id);
                        case PREPARING -> emailService.sendOrderPreparingEmail(order.getCustomerEmail(), customerName, id);
                        case READY -> emailService.sendOrderReadyEmail(order.getCustomerEmail(), customerName, id);
                        case DONE -> emailService.sendOrderDoneEmail(order.getCustomerEmail(), customerName, id);
                    }
                } catch (Exception ignored) {
                }
            }

            return Map.of("status", ok ? "ok" : "not_found", "id", id, "newStatus", st.name());
        } catch (Exception e) {
            return Map.of("error", "bad_status", "message", "Use: PENDING, CONFIRMED, PREPARING, READY, DONE, CANCELLED");
        }
    }

    private static String str(Object o) {
        return o == null ? "" : String.valueOf(o).trim();
    }

    private static int integer(Object o) {
        try {
            return o == null ? -1 : Integer.parseInt(String.valueOf(o));
        } catch (Exception e) {
            return -1;
        }
    }
}
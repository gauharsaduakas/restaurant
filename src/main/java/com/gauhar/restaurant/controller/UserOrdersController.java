package com.gauhar.restaurant.controller;
import com.gauhar.restaurant.entity.User;
import com.gauhar.restaurant.dao.OrderDao;
import com.gauhar.restaurant.dao.RestaurantDao;
import com.gauhar.restaurant.model.Order;
import com.gauhar.restaurant.model.Restaurant;
import com.gauhar.restaurant.repository.UserRepository;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.ArrayList;
import java.util.List;

@Controller
@RequestMapping("/my-orders")
public class UserOrdersController {

    private final OrderDao orderDao;
    private final UserRepository userRepository;
    private final RestaurantDao restaurantDao;

    public UserOrdersController(OrderDao orderDao, UserRepository userRepository, RestaurantDao restaurantDao) {
        this.orderDao = orderDao;
        this.userRepository = userRepository;
        this.restaurantDao = restaurantDao;
    }

    @GetMapping
    public String myOrders(Model model, Authentication auth) {
        try {
            String email = auth.getName();
            User user = userRepository.findByEmail(email).orElse(null);

            List<Order> userOrders = new ArrayList<>();
            if (user != null) {
                // Получаем все заказы пользователя
                List<Order> allOrders = orderDao.findAll();
                for (Order order : allOrders) {
                    if (order.getUserId() != null && order.getUserId().equals(user.getId())) {
                        userOrders.add(order);
                    }
                }
            }

            model.addAttribute("orders", userOrders);
            model.addAttribute("userName", user != null ? user.getFullName() : email);

        } catch (Exception e) {
            model.addAttribute("orders", new ArrayList<>());
        }

        try {
            Restaurant restaurant = restaurantDao.getOrCreateDefault();
            model.addAttribute("restaurant", restaurant);
        } catch (Exception e) {
            model.addAttribute("restaurant", new Restaurant());
        }

        return "my-orders"; // ✅ JSP view name
    }

    @GetMapping("/{orderId}")
    public String orderDetail(@PathVariable int orderId, Model model, Authentication auth) {
        try {
            Order order = orderDao.findById(orderId);
            if (order != null) {
                String email = auth.getName();
                User user = userRepository.findByEmail(email).orElse(null);

                // Проверяем, что заказ принадлежит текущему пользователю
                if (user != null && order.getUserId() != null && order.getUserId().equals(user.getId())) {
                    model.addAttribute("order", order);
                    model.addAttribute("userName", user.getFullName());
                } else {
                    return "redirect:/my-orders";
                }
            }
        } catch (Exception e) {
            return "redirect:/my-orders";
        }

        try {
            Restaurant restaurant = restaurantDao.getOrCreateDefault();
            model.addAttribute("restaurant", restaurant);
        } catch (Exception e) {
            model.addAttribute("restaurant", new Restaurant());
        }

        return "order-detail"; // ✅ JSP view name
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


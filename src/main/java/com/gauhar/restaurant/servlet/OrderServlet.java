package com.gauhar.restaurant.servlet;

import com.gauhar.restaurant.dao.MenuItemDao;
import com.gauhar.restaurant.dao.OrderDao;
import com.gauhar.restaurant.dao.RestaurantDao;
import com.gauhar.restaurant.model.OrderStatus;
import com.gauhar.restaurant.model.Restaurant;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;

import java.io.IOException;
import java.util.ArrayList;

//@WebServlet(urlPatterns = {"/orders", "/orders/status"})
public class OrderServlet extends HttpServlet {

    private static final String CTX_RESTAURANT_KEY = "restaurant";

    private final MenuItemDao menuItemDao = new MenuItemDao();
    private final OrderDao orderDao = new OrderDao(new MenuItemDao());
    private final RestaurantDao restaurantDao = new RestaurantDao();

    private String getCurrentRole() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth == null || !auth.isAuthenticated()) return "";
        return auth.getAuthorities().stream()
                .map(GrantedAuthority::getAuthority)
                .filter(a -> a.startsWith("ROLE_"))
                .map(a -> a.substring(5))
                .findFirst().orElse("");
    }

    private boolean isAdmin() {
        return "ADMIN".equals(getCurrentRole());
    }

    private String getCurrentUsername() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        return auth != null ? auth.getName() : "";
    }

    private boolean requireAdmin(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        if (!isAdmin()) {
            req.getSession().setAttribute("flash_error", "❌ Доступ только для администратора");
            resp.sendRedirect(req.getContextPath() + "/orders");
            return false;
        }
        return true;
    }

    private Restaurant getCurrentRestaurant() {
        Restaurant r = (Restaurant) getServletContext().getAttribute(CTX_RESTAURANT_KEY);
        if (r == null) {
            try {
                r = restaurantDao.getOrCreateDefault();
            } catch (Exception e) {
                r = new Restaurant(1, "Restaurant",
                        "Astana, Kabanbay Batyr 53", "+7 700 000 00 00", "10:00 - 23:00", "Cafe & Restaurant");
            }
            getServletContext().setAttribute(CTX_RESTAURANT_KEY, r);
        }
        return r;
    }

    private void setRestaurant(HttpServletRequest req) {
        req.setAttribute("restaurant", getCurrentRestaurant());
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        setRestaurant(req);
        req.setAttribute("menu", menuItemDao.findAll());

        if (isAdmin()) {
            req.setAttribute("orders", orderDao.findAll());
        } else {
            req.setAttribute("orders", new ArrayList<>());
        }

        req.getRequestDispatcher("/WEB-INF/views/orders.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        req.setCharacterEncoding("UTF-8");

        String path = req.getServletPath();

        if ("/orders".equals(path)) {
            String customer = isAdmin()
                    ? safe(req.getParameter("customerName"))
                    : getCurrentUsername();

            String phone = safe(req.getParameter("phone"));
            int itemId = parseInt(req.getParameter("menuItemId"), -1);
            int qty = parseInt(req.getParameter("quantity"), -1);

            String[] toppingsArr = req.getParameterValues("toppings");
            String toppings = toppingsArr == null ? "" : String.join(", ", toppingsArr);

            if (customer.isEmpty() || itemId <= 0 || qty <= 0) {
                req.getSession().setAttribute("flash_error", "❌ Заполни форму");
                resp.sendRedirect(req.getContextPath() + "/orders");
                return;
            }

            try {
                orderDao.createOrder(null, null, customer, phone, itemId, qty, toppings);
                req.getSession().setAttribute("flash_success", "✅ Заказ оформлен");
            } catch (Exception e) {
                req.getSession().setAttribute("flash_error", "❌ " + e.getMessage());
            }

            resp.sendRedirect(req.getContextPath() + "/orders");
            return;
        }

        if ("/orders/status".equals(path)) {
            if (!requireAdmin(req, resp)) return;

            int orderId = parseInt(req.getParameter("id"), -1);
            String statusStr = safe(req.getParameter("status"));

            try {
                OrderStatus newStatus = OrderStatus.valueOf(statusStr);
                orderDao.updateStatus(orderId, newStatus);
                req.getSession().setAttribute("flash_success", "✅ Статус изменён → " + newStatus);
            } catch (Exception e) {
                req.getSession().setAttribute("flash_error", "❌ Неверный статус: " + statusStr);
            }

            resp.sendRedirect(req.getContextPath() + "/orders");
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/orders");
    }

    private static int parseInt(String s, int def) {
        try {
            return Integer.parseInt(s);
        } catch (Exception e) {
            return def;
        }
    }

    private static String safe(String s) {
        return s == null ? "" : s.trim();
    }
}
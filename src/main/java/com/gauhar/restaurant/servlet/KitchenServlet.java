package com.gauhar.restaurant.servlet;

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

@WebServlet(urlPatterns = {"/kitchen", "/kitchen/action"})
public class KitchenServlet extends HttpServlet {

    private static final String CTX_RESTAURANT_KEY = "restaurant";

    private final OrderDao orderDao = new OrderDao();
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

    private boolean isAdmin() { return "ADMIN".equals(getCurrentRole()); }

    private boolean requireAdmin(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        if (!isAdmin()) {
            req.getSession().setAttribute("flash_error", "❌ Доступ только для администратора");
            resp.sendRedirect(req.getContextPath() + "/kitchen");
            return false;
        }
        return true;
    }

    private Restaurant getCurrentRestaurant() {
        Restaurant r = (Restaurant) getServletContext().getAttribute(CTX_RESTAURANT_KEY);
        if (r == null) {
            try { r = restaurantDao.getOrCreateDefault(); }
            catch (Exception e) {
                r = new Restaurant(1, "Gauhar Restaurant",
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
        req.setAttribute("cooking", orderDao.findByStatus(OrderStatus.PREPARING));
        req.setAttribute("ready",   orderDao.findByStatus(OrderStatus.READY));
        req.getRequestDispatcher("/WEB-INF/views/kitchen.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        req.setCharacterEncoding("UTF-8");
        if (!requireAdmin(req, resp)) return;

        int orderId = parseInt(req.getParameter("id"), -1);
        String action = safe(req.getParameter("action"));

        if (orderId > 0) {
            if ("toReady".equals(action)) {
                orderDao.updateStatus(orderId, OrderStatus.READY);
                req.getSession().setAttribute("flash_success", "✅ Заказ перемещён в ГОТОВ");
            } else if ("toDone".equals(action)) {
                orderDao.updateStatus(orderId, OrderStatus.DONE);
                req.getSession().setAttribute("flash_success", "✅ Заказ выдан");
            } else {
                req.getSession().setAttribute("flash_error", "❌ Неизвестное действие");
            }
        }
        resp.sendRedirect(req.getContextPath() + "/kitchen");
    }

    private static int parseInt(String s, int def) {
        try { return Integer.parseInt(s); } catch (Exception e) { return def; }
    }

    private static String safe(String s) { return s == null ? "" : s.trim(); }
}


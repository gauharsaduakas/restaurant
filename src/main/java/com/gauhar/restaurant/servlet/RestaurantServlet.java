package com.gauhar.restaurant.servlet;

import com.gauhar.restaurant.dao.RestaurantDao;
import com.gauhar.restaurant.model.Restaurant;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;

import java.io.IOException;

//@WebServlet("/restaurant")
public class RestaurantServlet extends HttpServlet {

    private static final String CTX_RESTAURANT_KEY = "restaurant";

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
            resp.sendRedirect(req.getContextPath() + "/home");
            return false;
        }
        return true;
    }

    private Restaurant getCurrentRestaurant() {
        Restaurant r = (Restaurant) getServletContext().getAttribute(CTX_RESTAURANT_KEY);
        if (r == null) {
            try { r = restaurantDao.getOrCreateDefault(); }
            catch (Exception e) {
                r = new Restaurant(1, "Restaurant",
                        "Astana, Kabanbay Batyr 53", "+7 700 000 00 00", "10:00 - 23:00", "Best burgers, pizzas and coffee");
            }
            getServletContext().setAttribute(CTX_RESTAURANT_KEY, r);
        }
        return r;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {
        req.setAttribute("restaurant", getCurrentRestaurant());
        req.getRequestDispatcher("/WEB-INF/views/restaurant.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        req.setCharacterEncoding("UTF-8");
        if (!requireAdmin(req, resp)) return;

        Restaurant r = getCurrentRestaurant();
        r.setName(safe(req.getParameter("name")));
        r.setAddress(safe(req.getParameter("address")));
        r.setPhone(safe(req.getParameter("phone")));
        r.setWorkHours(safe(req.getParameter("workHours")));
        r.setDescription(safe(req.getParameter("description")));
        getServletContext().setAttribute(CTX_RESTAURANT_KEY, r);

        req.getSession().setAttribute("flash_success", "✅ Сақталды");
        resp.sendRedirect(req.getContextPath() + "/restaurant");
    }

    private static String safe(String s) { return s == null ? "" : s.trim(); }
}
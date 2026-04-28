package com.gauhar.restaurant.servlet;

import com.gauhar.restaurant.dao.MenuItemDao;
import com.gauhar.restaurant.dao.RestaurantDao;
import com.gauhar.restaurant.model.MenuItem;
import com.gauhar.restaurant.model.Restaurant;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;

import java.io.IOException;
import java.util.Optional;

//@WebServlet(urlPatterns = {
//        "/menu-items",
//        "/menu-items/new",
//        "/menu-items/edit",
//        "/menu-items/update",
//        "/menu-items/delete",
//        "/menu-items/toggle"
//})
public class MenuItemServlet extends HttpServlet {

    private static final String CTX_RESTAURANT_KEY = "restaurant";

    private final MenuItemDao dao = new MenuItemDao();
    private final RestaurantDao restaurantDao = new RestaurantDao();

    private Authentication getAuthentication() {
        return SecurityContextHolder.getContext().getAuthentication();
    }

    private boolean requireLogin(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        Authentication auth = getAuthentication();

        if (auth == null || !auth.isAuthenticated() || auth instanceof AnonymousAuthenticationToken) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return false;
        }
        return true;
    }

    private boolean requireAdmin(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        Authentication auth = getAuthentication();

        if (auth == null || !auth.isAuthenticated() || auth instanceof AnonymousAuthenticationToken) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return false;
        }

        boolean isAdmin = auth.getAuthorities().stream()
                .anyMatch(a -> "ROLE_ADMIN".equals(a.getAuthority()));

        if (!isAdmin) {
            req.getSession().setAttribute("flash_error", "❌ Доступ только для администратора");
            resp.sendRedirect(req.getContextPath() + "/home");
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
                r = new Restaurant(
                        1,
                        " Restaurant",
                        "Astana, Kabanbay Batyr 53",
                        "+7 700 000 00 00",
                        "10:00 - 23:00",
                        "Cafe & Restaurant"
                );
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

        if (!requireLogin(req, resp)) {
            return;
        }

        String path = req.getServletPath();

        if ("/menu-items".equals(path)) {
            setRestaurant(req);
            req.setAttribute("items", dao.findAll());
            req.getRequestDispatcher("/WEB-INF/views/menu-items.jsp").forward(req, resp);
            return;
        }

        if ("/menu-items/new".equals(path)) {
            if (!requireAdmin(req, resp)) {
                return;
            }
            setRestaurant(req);
            req.setAttribute("mode", "new");
            req.getRequestDispatcher("/WEB-INF/views/menu-item-form.jsp").forward(req, resp);
            return;
        }

        if ("/menu-items/edit".equals(path)) {
            if (!requireAdmin(req, resp)) {
                return;
            }

            int id = parseInt(req.getParameter("id"), -1);
            Optional<MenuItem> opt = dao.findById(id);

            if (opt.isEmpty()) {
                req.getSession().setAttribute("flash_error", "❌ Блюдо не найдено");
                resp.sendRedirect(req.getContextPath() + "/menu-items");
                return;
            }

            setRestaurant(req);
            req.setAttribute("mode", "edit");
            req.setAttribute("item", opt.get());
            req.getRequestDispatcher("/WEB-INF/views/menu-item-form.jsp").forward(req, resp);
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/menu-items");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        req.setCharacterEncoding("UTF-8");

        if (!requireAdmin(req, resp)) {
            return;
        }

        String path = req.getServletPath();

        if ("/menu-items".equals(path)) {
            String name = safe(req.getParameter("name"));
            String category = safe(req.getParameter("category"));
            double price = parseDouble(req.getParameter("price"), -1);
            boolean available = req.getParameter("isAvailable") != null;
            String imageUrl = safe(req.getParameter("imageUrl"));

            if (name.isEmpty() || category.isEmpty() || price <= 0) {
                req.getSession().setAttribute("flash_error", "❌ Заполни name/category/price");
                resp.sendRedirect(req.getContextPath() + "/menu-items/new");
                return;
            }

            dao.insert(name, category, price, available, imageUrl);
            req.getSession().setAttribute("flash_success", "✅ Блюдо добавлено");
            resp.sendRedirect(req.getContextPath() + "/menu-items");
            return;
        }

        if ("/menu-items/update".equals(path)) {
            int id = parseInt(req.getParameter("id"), -1);
            String name = safe(req.getParameter("name"));
            String category = safe(req.getParameter("category"));
            double price = parseDouble(req.getParameter("price"), -1);
            boolean available = req.getParameter("isAvailable") != null;
            String imageUrl = safe(req.getParameter("imageUrl"));

            if (id <= 0 || name.isEmpty() || category.isEmpty() || price <= 0) {
                req.getSession().setAttribute("flash_error", "❌ Неверные данные");
                resp.sendRedirect(req.getContextPath() + "/menu-items");
                return;
            }

            boolean ok = dao.update(id, name, category, price, available, imageUrl);
            req.getSession().setAttribute(
                    ok ? "flash_success" : "flash_error",
                    ok ? "✅ Блюдо обновлено" : "❌ Блюдо не найдено"
            );
            resp.sendRedirect(req.getContextPath() + "/menu-items");
            return;
        }

        if ("/menu-items/delete".equals(path)) {
            int id = parseInt(req.getParameter("id"), -1);
            boolean ok = dao.delete(id);

            req.getSession().setAttribute(
                    ok ? "flash_success" : "flash_error",
                    ok ? "🗑 Блюдо удалено" : "❌ Блюдо не найдено"
            );

            resp.sendRedirect(req.getContextPath() + "/menu-items");
            return;
        }

        if ("/menu-items/toggle".equals(path)) {
            int id = parseInt(req.getParameter("id"), -1);
            boolean avail = "true".equals(req.getParameter("available"));
            dao.setAvailable(id, avail);

            req.getSession().setAttribute("flash_success", "✅ Наличие блюда изменено");
            resp.sendRedirect(req.getContextPath() + "/menu-items");
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/menu-items");
    }

    private static int parseInt(String s, int def) {
        try {
            return Integer.parseInt(s);
        } catch (Exception e) {
            return def;
        }
    }

    private static double parseDouble(String s, double def) {
        try {
            return Double.parseDouble(s);
        } catch (Exception e) {
            return def;
        }
    }

    private static String safe(String s) {
        return s == null ? "" : s.trim();
    }
}
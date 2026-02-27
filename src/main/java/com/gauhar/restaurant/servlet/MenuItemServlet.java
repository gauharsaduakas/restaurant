package com.gauhar.restaurant.servlet;

import com.gauhar.restaurant.dao.MenuItemDao;
import com.gauhar.restaurant.model.MenuItem;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.Optional;

@WebServlet(urlPatterns = {
        "/menu-items",
        "/menu-items/new",
        "/menu-items/edit",
        "/menu-items/update",
        "/menu-items/delete",
        "/menu-items/toggle"
})
public class MenuItemServlet extends HttpServlet {

    private final MenuItemDao dao = new MenuItemDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String path = req.getServletPath();

        if ("/menu-items".equals(path)) {
            req.setAttribute("items", dao.findAll());
            req.getRequestDispatcher("/WEB-INF/views/menu-items.jsp").forward(req, resp);
            return;
        }
        if ("/menu-items/new".equals(path)) {
            req.setAttribute("mode", "new");
            req.getRequestDispatcher("/WEB-INF/views/menu-item-form.jsp").forward(req, resp);
            return;
        }
        if ("/menu-items/edit".equals(path)) {
            int id = parseInt(req.getParameter("id"), -1);
            Optional<MenuItem> opt = dao.findById(id);
            if (opt.isEmpty()) {
                req.getSession().setAttribute("flash_error", "Блюдо не найдено");
                resp.sendRedirect(req.getContextPath() + "/menu-items");
                return;
            }
            req.setAttribute("mode", "edit");
            req.setAttribute("item", opt.get());
            req.getRequestDispatcher("/WEB-INF/views/menu-item-form.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        req.setCharacterEncoding("UTF-8");
        String path = req.getServletPath();

        if ("/menu-items".equals(path)) {
            String name      = safe(req.getParameter("name"));
            String category  = safe(req.getParameter("category"));
            double price     = parseDouble(req.getParameter("price"), -1);
            boolean available = req.getParameter("isAvailable") != null;
            String imageUrl  = safe(req.getParameter("imageUrl"));

            if (name.isEmpty() || category.isEmpty() || price <= 0) {
                req.getSession().setAttribute("flash_error", "Ошибка: заполни name/category/price");
                resp.sendRedirect(req.getContextPath() + "/menu-items/new");
                return;
            }
            dao.insert(name, category, price, available, imageUrl);
            req.getSession().setAttribute("flash_success", "✅ Блюдо добавлено");
            resp.sendRedirect(req.getContextPath() + "/menu-items");
            return;
        }

        if ("/menu-items/update".equals(path)) {
            int id           = parseInt(req.getParameter("id"), -1);
            String name      = safe(req.getParameter("name"));
            String category  = safe(req.getParameter("category"));
            double price     = parseDouble(req.getParameter("price"), -1);
            boolean available = req.getParameter("isAvailable") != null;
            String imageUrl  = safe(req.getParameter("imageUrl"));

            if (id <= 0 || name.isEmpty() || category.isEmpty() || price <= 0) {
                req.getSession().setAttribute("flash_error", "Ошибка: неверные данные");
                resp.sendRedirect(req.getContextPath() + "/menu-items");
                return;
            }
            boolean ok = dao.update(id, name, category, price, available, imageUrl);
            req.getSession().setAttribute(ok ? "flash_success" : "flash_error",
                    ok ? "✅ Блюдо обновлено" : "❌ Блюдо не найдено");
            resp.sendRedirect(req.getContextPath() + "/menu-items");
            return;
        }

        if ("/menu-items/delete".equals(path)) {
            int id = parseInt(req.getParameter("id"), -1);
            boolean ok = dao.delete(id);
            req.getSession().setAttribute(ok ? "flash_success" : "flash_error",
                    ok ? "🗑 Блюдо удалено" : "❌ Блюдо не найдено");
            resp.sendRedirect(req.getContextPath() + "/menu-items");
            return;
        }

        if ("/menu-items/toggle".equals(path)) {
            int id = parseInt(req.getParameter("id"), -1);
            boolean avail = "true".equals(req.getParameter("available"));
            dao.setAvailable(id, avail);
            resp.sendRedirect(req.getContextPath() + "/menu-items");
        }
    }

    private static int parseInt(String s, int def) {
        try { return Integer.parseInt(s); } catch (Exception e) { return def; }
    }
    private static double parseDouble(String s, double def) {
        try { return Double.parseDouble(s); } catch (Exception e) { return def; }
    }
    private static String safe(String s) { return s == null ? "" : s.trim(); }
}

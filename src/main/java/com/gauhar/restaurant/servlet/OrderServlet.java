package com.gauhar.restaurant.servlet;

import com.gauhar.restaurant.dao.MenuItemDao;
import com.gauhar.restaurant.dao.OrderDao;
import com.gauhar.restaurant.model.OrderStatus;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet(urlPatterns = {"/orders", "/orders/status"})
public class OrderServlet extends HttpServlet {

    private final MenuItemDao menuItemDao = new MenuItemDao();
    private final OrderDao orderDao = new OrderDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setAttribute("menuItems", menuItemDao.findAll());
        req.setAttribute("orders", orderDao.findAll());
        req.getRequestDispatcher("/WEB-INF/views/orders.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        req.setCharacterEncoding("UTF-8");
        String path = req.getServletPath();

        if ("/orders".equals(path)) {
            String customer = safe(req.getParameter("customerName"));
            String phone    = safe(req.getParameter("phone"));
            int itemId      = parseInt(req.getParameter("menuItemId"), -1);
            int qty         = parseInt(req.getParameter("quantity"), -1);

            if (customer.isEmpty() || itemId <= 0 || qty <= 0) {
                req.getSession().setAttribute("flash_error", "Ошибка: заполни форму");
                resp.sendRedirect(req.getContextPath() + "/orders");
                return;
            }
            try {
                orderDao.createOrder(customer, phone, itemId, qty);
                req.getSession().setAttribute("flash_success", "✅ Заказ оформлен");
            } catch (Exception e) {
                req.getSession().setAttribute("flash_error", "❌ " + e.getMessage());
            }
            resp.sendRedirect(req.getContextPath() + "/orders");
            return;
        }

        if ("/orders/status".equals(path)) {
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
        }
    }

    private static int parseInt(String s, int def) {
        try { return Integer.parseInt(s); } catch (Exception e) { return def; }
    }
    private static String safe(String s) { return s == null ? "" : s.trim(); }
}

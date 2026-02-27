package com.gauhar.restaurant.servlet;

import com.gauhar.restaurant.dao.OrderDao;
import com.gauhar.restaurant.model.OrderStatus;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet(urlPatterns = {"/kitchen", "/kitchen/action"})
public class KitchenServlet extends HttpServlet {

    private final OrderDao orderDao = new OrderDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setAttribute("cooking", orderDao.findByStatus(OrderStatus.PREPARING));
        req.setAttribute("ready",   orderDao.findByStatus(OrderStatus.READY));
        req.getRequestDispatcher("/WEB-INF/views/kitchen.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        req.setCharacterEncoding("UTF-8");
        int orderId = parseInt(req.getParameter("id"), -1);
        String action = safe(req.getParameter("action"));

        if (orderId > 0) {
            if ("toReady".equals(action)) {
                orderDao.updateStatus(orderId, OrderStatus.READY);
            } else if ("toDone".equals(action)) {
                orderDao.updateStatus(orderId, OrderStatus.DONE);
            }
        }
        resp.sendRedirect(req.getContextPath() + "/kitchen");
    }

    private static int parseInt(String s, int def) {
        try { return Integer.parseInt(s); } catch (Exception e) { return def; }
    }
    private static String safe(String s) { return s == null ? "" : s.trim(); }
}


package com.gauhar.restaurant.servlet;

import com.gauhar.restaurant.model.Restaurant;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/restaurant")
public class RestaurantServlet extends HttpServlet {

    private static final String CTX_KEY = "restaurant";

    @Override
    public void init() {
        Restaurant r = new Restaurant(
                1,
                "Gauhar Restaurant",
                "Astana, Kabanbay Batyr 53",
                "+7 700 000 00 00",
                "10:00 - 23:00",
                "Best burgers, pizzas and coffee"
        );
        getServletContext().setAttribute(CTX_KEY, r);
    }

    private Restaurant getRestaurant() {
        return (Restaurant) getServletContext().getAttribute(CTX_KEY);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, jakarta.servlet.ServletException {

        req.setAttribute("restaurant", getRestaurant());
        req.getRequestDispatcher("/WEB-INF/views/restaurant.jsp")
                .forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        req.setCharacterEncoding("UTF-8");

        Restaurant r = getRestaurant();
        r.setName(req.getParameter("name"));
        r.setAddress(req.getParameter("address"));
        r.setPhone(req.getParameter("phone"));
        r.setWorkHours(req.getParameter("workHours"));
        r.setDescription(req.getParameter("description"));

        req.getSession().setAttribute("flash_success", "✅ Сақталды");
        resp.sendRedirect(req.getContextPath() + "/restaurant");
    }
}
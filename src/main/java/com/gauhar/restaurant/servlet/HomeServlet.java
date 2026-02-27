package com.gauhar.restaurant.servlet;

import com.gauhar.restaurant.model.Restaurant;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/")
public class HomeServlet extends HttpServlet {

    private static final String CTX_KEY = "restaurant";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // restaurant object application scope-та тұрса, request-ке салып береміз
        Restaurant r = (Restaurant) getServletContext().getAttribute(CTX_KEY);
        req.setAttribute("restaurant", r);

        req.getRequestDispatcher("/WEB-INF/views/index.jsp")
                .forward(req, resp);
    }
}
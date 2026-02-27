package com.gauhar.restaurant.controller;

import com.gauhar.restaurant.model.Restaurant;
import jakarta.servlet.ServletContext;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class PageController {

    private static final String CTX_KEY = "restaurant";
    private final ServletContext servletContext;

    public PageController(ServletContext servletContext) {
        this.servletContext = servletContext;
    }

    private Restaurant getOrInit() {
        Restaurant r = (Restaurant) servletContext.getAttribute(CTX_KEY);
        if (r == null) {
            r = new Restaurant(
                    1,
                    "Gauhar Restaurant",
                    "Astana, Kabanbay Batyr 53",
                    "+7 700 000 00 00",
                    "10:00 - 23:00",
                    "Best burgers, pizzas and coffee"
            );
            servletContext.setAttribute(CTX_KEY, r);
        }
        return r;
    }

    @GetMapping("/")
    public String home(Model model) {
        model.addAttribute("restaurant", getOrInit());
        return "index"; // -> /WEB-INF/views/index.jsp
    }
}
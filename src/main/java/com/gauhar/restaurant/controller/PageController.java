package com.gauhar.restaurant.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class PageController {

    // ✅ Spring Security handles /login via formLogin(), so no need to define it here

    @GetMapping("/access-denied")
    public String accessDenied() {
        return "access-denied"; // ✅ JSP view name without forward
    }
}
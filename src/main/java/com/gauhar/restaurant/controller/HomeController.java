package com.gauhar.restaurant.controller;

import com.gauhar.restaurant.model.User;
import com.gauhar.restaurant.repository.UserRepository;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HomeController {

    private final UserRepository repo;

    public HomeController(UserRepository repo) {
        this.repo = repo;
    }

    @GetMapping("/home")
    public String home(Model model, Authentication auth) {
        String email = auth.getName();

        User user = repo.findByEmail(email).orElse(null);

        model.addAttribute("email", email);
        model.addAttribute("fullName", user != null ? user.getFullName() : email);
        model.addAttribute("role", user != null ? user.getRole() : "CLIENT");

        return "home";
    }
}
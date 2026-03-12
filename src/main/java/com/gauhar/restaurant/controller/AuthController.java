package com.gauhar.restaurant.controller;

import com.gauhar.restaurant.model.User;
import com.gauhar.restaurant.repository.UserRepository;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class AuthController {

    private final UserRepository repo;
    private final PasswordEncoder encoder;

    public AuthController(UserRepository repo, PasswordEncoder encoder) {
        this.repo = repo;
        this.encoder = encoder;
    }

    @GetMapping("/login")
    public String loginPage() {
        return "login";
    }

    @GetMapping("/register")
    public String registerPage() {
        return "register";
    }

    @PostMapping("/register")
    public String register(
            @RequestParam String fullName,
            @RequestParam String email,
            @RequestParam String password
    ) {
        fullName = fullName == null ? "" : fullName.trim();
        email = email == null ? "" : email.trim().toLowerCase();
        password = password == null ? "" : password.trim();

        if (fullName.isEmpty() || email.isEmpty() || password.isEmpty()) {
            return "redirect:/register?error=fill";
        }

        if (repo.findByEmail(email).isPresent()) {
            return "redirect:/register?error=exists";
        }

        User user = new User();
        user.setFullName(fullName);
        user.setEmail(email);
        user.setPasswordHash(encoder.encode(password));
        user.setRole("CLIENT");

        repo.save(user);

        return "redirect:/login?registered=1";
    }
}
package com.gauhar.restaurant.controller;

import com.gauhar.restaurant.dao.RestaurantDao;
import com.gauhar.restaurant.model.Restaurant;
import com.gauhar.restaurant.service.UserService;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import com.gauhar.restaurant.entity.User;

@Controller
public class AuthController {

    private final UserService userService;
    private final RestaurantDao restaurantDao;

    public AuthController(UserService userService, RestaurantDao restaurantDao) {
        this.userService = userService;
        this.restaurantDao = restaurantDao;
    }

    @GetMapping("/login")
    public String loginPage(
            Model model,
            @RequestParam(required = false) String error,
            @RequestParam(required = false) String logout,
            @RequestParam(required = false) String registered) {
        try {
            Restaurant restaurant = restaurantDao.getOrCreateDefault();
            model.addAttribute("restaurant", restaurant);
        } catch (Exception e) {
            model.addAttribute("restaurant", new Restaurant());
        }

        // Обработка ошибок входа
        if (error != null) {
            model.addAttribute("errorMsg", "❌ Неверный Email или пароль");
        }

        // Обработка выхода
        if (logout != null) {
            model.addAttribute("logoutMsg", "✅ Вы успешно вышли из системы");
        }

        // Обработка успешной регистрации
        if (registered != null) {
            model.addAttribute("successMsg", "✅ Аккаунт создан. Войдите в систему.");
        }

        return "login";
    }

    @GetMapping("/register")
    public String registerPage(Model model) {
        try {
            Restaurant restaurant = restaurantDao.getOrCreateDefault();
            model.addAttribute("restaurant", restaurant);
        } catch (Exception e) {
            model.addAttribute("restaurant", new Restaurant());
        }
        return "register";
    }

    @PostMapping("/register")
    public String register(
            @RequestParam String fullName,
            @RequestParam String email,
            @RequestParam String password,
            @RequestParam(required = false) String passwordConfirm,
            Model model
    ) {
        // Валидация
        fullName = fullName == null ? "" : fullName.trim();
        email = email == null ? "" : email.trim().toLowerCase();
        password = password == null ? "" : password.trim();

        if (fullName.isEmpty() || email.isEmpty() || password.isEmpty()) {
            model.addAttribute("error", "Все поля обязательны");
            return "register";
        }

        if (password.length() < 6) {
            model.addAttribute("error", "Пароль должен быть не менее 6 символов");
            return "register";
        }

        if (passwordConfirm != null && !password.equals(passwordConfirm)) {
            model.addAttribute("error", "Пароли не совпадают");
            return "register";
        }

        try {
            User user = userService.registerUser(fullName, email, password);
            return "redirect:/login?registered=1";
        } catch (IllegalArgumentException e) {
            model.addAttribute("error", e.getMessage());
            return "register";
        } catch (Exception e) {
            model.addAttribute("error", "Ошибка при регистрации");
            e.printStackTrace();
            return "register";
        }
    }
}


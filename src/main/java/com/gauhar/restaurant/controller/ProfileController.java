package com.gauhar.restaurant.controller;

import com.gauhar.restaurant.entity.User;
import com.gauhar.restaurant.repository.UserRepository;
import com.gauhar.restaurant.service.UserService;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@RequestMapping("/profile")
public class ProfileController {

    private final UserService userService;
    private final UserRepository userRepository;

    public ProfileController(UserService userService, UserRepository userRepository) {
        this.userService = userService;
        this.userRepository = userRepository;
    }

    /**
     * Отображение страницы профиля пользователя
     */
    @GetMapping
    public String profile(Model model) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String email = auth.getName();

        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new IllegalArgumentException("Пользователь не найден"));

        model.addAttribute("user", user);
        return "profile";
    }

    /**
     * Обновление информации профиля
     */
    @PostMapping("/update")
    public String updateProfile(
            @RequestParam String fullName,
            @RequestParam String email,
            Model model
    ) {
        try {
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            String currentEmail = auth.getName();

            User user = userRepository.findByEmail(currentEmail)
                    .orElseThrow(() -> new IllegalArgumentException("Пользователь не найден"));

            User updatedUser = userService.updateUser(user.getId(), fullName, email);
            model.addAttribute("user", updatedUser);
            model.addAttribute("success", "Информация профиля успешно обновлена");
            return "profile";
        } catch (Exception e) {
            model.addAttribute("error", "Ошибка при обновлении профиля");
            return "profile";
        }
    }

    /**
     * Отображение страницы смены пароля
     */
    @GetMapping("/change-password")
    public String changePasswordPage() {
        return "change-password";
    }

    /**
     * Обработка смены пароля
     */
    @PostMapping("/change-password")
    public String changePassword(
            @RequestParam String oldPassword,
            @RequestParam String newPassword,
            @RequestParam String confirmPassword,
            Model model
    ) {
        try {
            if (!newPassword.equals(confirmPassword)) {
                model.addAttribute("error", "Новые пароли не совпадают");
                return "change-password";
            }

            if (newPassword.length() < 6) {
                model.addAttribute("error", "Пароль должен быть не менее 6 символов");
                return "change-password";
            }

            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            String email = auth.getName();

            User user = userRepository.findByEmail(email)
                    .orElseThrow(() -> new IllegalArgumentException("Пользователь не найден"));

            userService.changePassword(user.getId(), oldPassword, newPassword);
            model.addAttribute("success", "Пароль успешно изменен");
            return "change-password";
        } catch (IllegalArgumentException e) {
            model.addAttribute("error", e.getMessage());
            return "change-password";
        } catch (Exception e) {
            model.addAttribute("error", "Ошибка при смене пароля");
            e.printStackTrace();
            return "change-password";
        }
    }
}


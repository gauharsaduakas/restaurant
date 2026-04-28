package com.gauhar.restaurant.controller;
import com.gauhar.restaurant.entity.User;
import com.gauhar.restaurant.dao.MenuItemDao;
import com.gauhar.restaurant.dao.RestaurantDao;
import com.gauhar.restaurant.model.MenuItem;
import com.gauhar.restaurant.model.Restaurant;
import com.gauhar.restaurant.repository.UserRepository;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.List;
import java.util.stream.Collectors;

@Controller
public class HomeController {

    private final UserRepository repo;
    private final RestaurantDao restaurantDao;
    private final MenuItemDao menuItemDao;

    public HomeController(UserRepository repo,
                          RestaurantDao restaurantDao,
                          MenuItemDao menuItemDao) {
        this.repo = repo;
        this.restaurantDao = restaurantDao;
        this.menuItemDao = menuItemDao;
    }

    // =========================
    // ROOT → просто редирект
    // =========================
    @GetMapping("/")
    public String root() {
        return "redirect:/home";
    }

    // =========================
    // HOME PAGE
    // =========================
    @GetMapping("/home")
    public String home(Model model, Authentication auth) {

        String email = (auth != null) ? auth.getName() : "guest";

        User user = (auth != null)
                ? repo.findByEmail(email).orElse(null)
                : null;

        model.addAttribute("email", email);
        model.addAttribute("fullName",
                user != null ? user.getFullName() : email);
        model.addAttribute("role",
                user != null ? user.getRole() : "CLIENT");

        // =========================
        // RESTAURANT INFO
        // =========================
        try {
            Restaurant restaurant = restaurantDao.getOrCreateDefault();

            model.addAttribute("restaurant", restaurant);
            model.addAttribute("restaurantName",
                    restaurant.getName() != null && !restaurant.getName().isBlank()
                            ? restaurant.getName()
                            : "🎍 Ресторан");

            model.addAttribute("restaurantAddress",
                    restaurant.getAddress() != null
                            ? restaurant.getAddress()
                            : "Astana, Kabanbay Batyr 53");

            model.addAttribute("restaurantPhone",
                    restaurant.getPhone() != null
                            ? restaurant.getPhone()
                            : "+7 700 000 00 00");

            model.addAttribute("restaurantHours",
                    restaurant.getWorkHours() != null
                            ? restaurant.getWorkHours()
                            : "10:00 - 23:00");

        } catch (Exception e) {
            model.addAttribute("restaurant", new Restaurant());
            model.addAttribute("restaurantName", "🎍 Ресторан");
            model.addAttribute("restaurantAddress", "Astana, Kabanbay Batyr 53");
            model.addAttribute("restaurantPhone", "+7 700 000 00 00");
            model.addAttribute("restaurantHours", "10:00 - 23:00");
        }

        // =========================
        // POPULAR ITEMS
        // =========================
        try {
            List<MenuItem> popularItems = menuItemDao.findAll()
                    .stream()
                    .filter(MenuItem::isAvailable)
                    .limit(6)
                    .collect(Collectors.toList());

            model.addAttribute("popularItems", popularItems);

        } catch (Exception e) {
            model.addAttribute("popularItems", List.of());
        }

        return "home";
    }

    // =========================
    // ORDER SUCCESS PAGE
    // =========================
    @GetMapping("/order-success")
    public String orderSuccess() {
        return "order-success";
    }
}
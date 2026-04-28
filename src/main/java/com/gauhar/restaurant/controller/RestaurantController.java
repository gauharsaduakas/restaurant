package com.gauhar.restaurant.controller;

import com.gauhar.restaurant.dao.RestaurantDao;
import com.gauhar.restaurant.model.Restaurant;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class RestaurantController {

    private final RestaurantDao restaurantDao;

    public RestaurantController(RestaurantDao restaurantDao) {
        this.restaurantDao = restaurantDao;
    }

    @GetMapping("/restaurant")
    public String restaurant(Model model, Authentication auth) {
        try {
            Restaurant restaurant = restaurantDao.getOrCreateDefault();
            model.addAttribute("restaurant", restaurant);
        } catch (Exception e) {
            model.addAttribute("restaurant", new Restaurant());
        }
        return "restaurant"; // ✅ JSP view name
    }

    @PostMapping("/restaurant")
    public String updateRestaurant(
            @RequestParam String name,
            @RequestParam String address,
            @RequestParam String phone,
            @RequestParam String workHours,
            @RequestParam String description,
            Model model
    ) {
        try {
            Restaurant r = restaurantDao.getOrCreateDefault();
            r.setName(name);
            r.setAddress(address);
            r.setPhone(phone);
            r.setWorkHours(workHours);
            r.setDescription(description);
            restaurantDao.save(r);
            model.addAttribute("flash_success", "✓ Информация обновлена");
        } catch (Exception e) {
            model.addAttribute("flash_error", "✗ Ошибка: " + e.getMessage());
        }
        return "restaurant"; // ✅ JSP view name
    }
}

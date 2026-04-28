package com.gauhar.restaurant.controller;

import com.gauhar.restaurant.dao.MenuItemDao;
import com.gauhar.restaurant.dao.RestaurantDao;
import com.gauhar.restaurant.model.MenuItem;
import com.gauhar.restaurant.model.Restaurant;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
public class MenuController {

    private final MenuItemDao menuItemDao;
    private final RestaurantDao restaurantDao;

    public MenuController(MenuItemDao menuItemDao, RestaurantDao restaurantDao) {
        this.menuItemDao = menuItemDao;
        this.restaurantDao = restaurantDao;
    }

    // ========================
    // СПИСОК МЕНЮ
    // ========================
    @GetMapping("/menu-items")
    public String menu(Model model) {
        List<MenuItem> items = menuItemDao.findAll();
        model.addAttribute("items", items);
        model.addAttribute("restaurant", getRestaurant());
        return "menu-items";
    }

    // ========================
    // ФОРМА ДОБАВЛЕНИЯ
    // ========================
    @GetMapping("/menu-items/new")
    public String newForm(Model model) {
        model.addAttribute("item", new MenuItem());
        model.addAttribute("restaurant", getRestaurant());
        model.addAttribute("mode", "new");
        return "menu-item-form";
    }

    // ========================
    // СОХРАНИТЬ НОВОЕ БЛЮДО
    // ========================
    @PostMapping("/menu-items/new")
    public String create(@RequestParam String name,
                         @RequestParam String category,
                         @RequestParam double price,
                         @RequestParam(defaultValue = "false") boolean available,
                         @RequestParam(required = false) String imageUrl) {
        menuItemDao.insert(name, category, price, available, imageUrl);
        return "redirect:/menu-items";
    }

    // ========================
    // ФОРМА РЕДАКТИРОВАНИЯ
    // ========================
    @GetMapping("/menu-items/edit")
    public String editForm(@RequestParam int id, Model model) {
        MenuItem item = menuItemDao.findById(id).orElse(null);
        if (item == null) return "redirect:/menu-items";
        model.addAttribute("item", item);
        model.addAttribute("restaurant", getRestaurant());
        model.addAttribute("mode", "edit"); // ← добавь это
        return "menu-item-form";
    }

    // ========================
    // ОБНОВИТЬ БЛЮДО
    // ========================
    @PostMapping("/menu-items/update")
    public String update(@RequestParam int id,
                         @RequestParam String name,
                         @RequestParam String category,
                         @RequestParam double price,
                         @RequestParam(defaultValue = "false") boolean available,
                         @RequestParam(required = false) String imageUrl) {
        menuItemDao.update(id, name, category, price, available, imageUrl);
        return "redirect:/menu-items";
    }

    // ========================
    // УДАЛИТЬ БЛЮДО
    // ========================
    @PostMapping("/menu-items/delete")
    public String delete(@RequestParam int id) {
        menuItemDao.delete(id);
        return "redirect:/menu-items";
    }

    // ========================
    // ВКЛЮЧИТЬ/ВЫКЛЮЧИТЬ
    // ========================
    @PostMapping("/menu-items/toggle")
    public String toggle(@RequestParam int id,
                         @RequestParam boolean available) {
        menuItemDao.setAvailable(id, available);
        return "redirect:/menu-items";
    }

    // ========================
    // ВСПОМОГАТЕЛЬНЫЙ МЕТОД
    // ========================
    private Restaurant getRestaurant() {
        try {
            return restaurantDao.getOrCreateDefault();
        } catch (Exception e) {
            return new Restaurant();
        }
    }
}
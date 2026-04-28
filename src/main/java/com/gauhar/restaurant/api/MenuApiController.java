package com.gauhar.restaurant.api;

import com.gauhar.restaurant.dao.MenuItemDao;
import com.gauhar.restaurant.model.MenuItem;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/menu-items")
public class MenuApiController {

    private final MenuItemDao dao;

    public MenuApiController(MenuItemDao dao) {
        this.dao = dao;
    }

    @GetMapping
    public List<MenuItem> all() {
        return dao.findAll();
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> one(@PathVariable int id) {
        return dao.findById(id)
                .<ResponseEntity<?>>map(ResponseEntity::ok)
                .orElseGet(() -> ResponseEntity.status(404)
                        .body(Map.of("error", "not_found", "id", id)));
    }

    @PostMapping
    public ResponseEntity<?> create(@RequestBody Map<String, Object> body) {
        String name = str(body.get("name"));
        String category = str(body.get("category"));
        double price = dbl(body.get("price"));
        boolean available = bool(body.get("available"));
        String imageUrl = str(body.get("imageUrl"));

        if (name.isBlank() || category.isBlank() || price <= 0) {
            return ResponseEntity.badRequest()
                    .body(Map.of("error", "validation", "message", "name/category/price required"));
        }

        MenuItem created = dao.insert(name, category, price, available, imageUrl);
        return ResponseEntity.status(201).body(Map.of("status", "created", "item", created));
    }

    private static String str(Object o) { return o == null ? "" : String.valueOf(o).trim(); }
    private static double dbl(Object o) {
        try { return o == null ? -1 : Double.parseDouble(String.valueOf(o)); }
        catch (Exception e) { return -1; }
    }
    private static boolean bool(Object o) {
        if (o == null) return false;
        String s = String.valueOf(o).trim().toLowerCase();
        return s.equals("true") || s.equals("1") || s.equals("yes") || s.equals("on");
    }
}
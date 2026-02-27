package com.gauhar.restaurant.controller;

import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/restaurant")
public class RestaurantController {

    @GetMapping("/ping")
    public Map<String, String> ping() {
        return Map.of("status", "pong");
    }

    @GetMapping
    public Map<String, String> get(@RequestParam(defaultValue = "1") String id) {
        return Map.of("id", id, "name", "Gauhar Restaurant");
    }

    @GetMapping("/search")
    public Map<String, String> search(@RequestParam String q) {
        return Map.of("query", q);
    }

    @PostMapping
    public Map<String, Object> create(@RequestBody Map<String, Object> body) {
        return Map.of("status", "created", "body", body);
    }

    @PostMapping("/update")
    public Map<String, Object> update(@RequestBody Map<String, Object> body) {
        return Map.of("status", "updated", "body", body);
    }
}
package com.gauhar.restaurant.dto;

public class UserResponse {
    private Long id;
    private String fullName;
    private String email;
    private String role;
    private boolean enabled; // 1. Добавляем новое поле

    // 2. Обновляем конструктор: теперь он принимает 5 аргументов
    public UserResponse(Long id, String fullName, String email, String role, boolean enabled) {
        this.id = id;
        this.fullName = fullName;
        this.email = email;
        this.role = role;
        this.enabled = enabled;
    }

    // 3. Геттеры и сеттеры
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public boolean isEnabled() { return enabled; }
    public void setEnabled(boolean enabled) { this.enabled = enabled; }
}
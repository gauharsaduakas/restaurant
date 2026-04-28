package com.gauhar.restaurant.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;

@Entity
@Table(name = "users")
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotBlank(message = "ФИ обязательно")
    @Column(name = "full_name", nullable = false)
    private String fullName;

    @NotBlank(message = "Email обязателен")
    @Email(message = "Email должен быть валидным")
    @Column(name = "email", nullable = false, unique = true)
    private String email;

    @NotBlank(message = "Пароль обязателен")
    @Column(name = "password_hash", nullable = false)
    private String passwordHash;

    @NotBlank(message = "Роль обязательна")
    @Column(name = "role", nullable = false)
    private String role;

    // --- НОВЫЕ ПОЛЯ ДЛЯ ВЕРИФИКАЦИИ ---
    @Column(name = "verification_code")
    private String verificationCode;

    @Column(name = "enabled", nullable = false)
    private boolean enabled = false;

    // Конструкторы
    public User() {
    }

    public User(Long id, String fullName, String email, String passwordHash, String role) {
        this.id = id;
        this.fullName = fullName;
        this.email = email;
        this.passwordHash = passwordHash;
        this.role = role;
    }

    public User(String fullName, String email, String passwordHash, String role) {
        this.fullName = fullName;
        this.email = email;
        this.passwordHash = passwordHash;
        this.role = role;
    }

    // Getter'ы
    public Long getId() {
        return id;
    }

    public String getFullName() {
        return fullName;
    }

    public String getEmail() {
        return email;
    }

    public String getPasswordHash() {
        return passwordHash;
    }

    public String getRole() {
        return role;
    }

    // --- НОВЫЕ ГЕТТЕРЫ ---
    public String getVerificationCode() {
        return verificationCode;
    }

    public boolean isEnabled() {
        return enabled;
    }

    // Setter'ы
    public void setId(Long id) {
        this.id = id;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }

    public void setRole(String role) {
        this.role = role;
    }

    // --- НОВЫЕ СЕТТЕРЫ ---
    public void setVerificationCode(String verificationCode) {
        this.verificationCode = verificationCode;
    }

    public void setEnabled(boolean enabled) {
        this.enabled = enabled;
    }

    // toString
    @Override
    public String toString() {
        return "User{" +
                "id=" + id +
                ", fullName='" + fullName + '\'' +
                ", email='" + email + '\'' +
                ", role='" + role + '\'' +
                ", enabled=" + enabled +
                '}';
    }
}
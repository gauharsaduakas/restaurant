package com.gauhar.restaurant.service;

import com.gauhar.restaurant.entity.User;
import com.gauhar.restaurant.repository.UserRepository;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;
import java.util.Random;

@Service
public class UserService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final EmailService emailService;

    public UserService(UserRepository userRepository, PasswordEncoder passwordEncoder, EmailService emailService) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
        this.emailService = emailService;
    }

    /**
     * Регистрация нового пользователя
     */
    @Transactional
    public User registerUser(String fullName, String email, String password) {
        if (userRepository.findByEmail(email).isPresent()) {
            throw new IllegalArgumentException("Пользователь с таким email уже зарегистрирован");
        }

        String code = String.format("%06d", new Random().nextInt(999999));

        User user = new User();
        user.setFullName(fullName);
        user.setEmail(email);
        user.setPasswordHash(passwordEncoder.encode(password));
        user.setRole("USER");
        user.setVerificationCode(code);
        user.setEnabled(false);

        User savedUser = userRepository.save(user);

        try {
            emailService.sendVerificationEmail(email, code);
        } catch (Exception e) {
            System.err.println("!!! ОШИБКА ПОЧТЫ. КОД ДЛЯ ТЕСТА: " + code);
        }

        return savedUser;
    }

    /**
     * ОБНОВЛЕНИЕ ПРОФИЛЯ (Тот самый недостающий метод)
     */
    @Transactional
    public User updateUser(Long userId, String fullName, String email) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("Пользователь не найден"));

        // Проверяем, не занят ли новый email другим пользователем
        Optional<User> existingUser = userRepository.findByEmail(email);
        if (existingUser.isPresent() && !existingUser.get().getId().equals(userId)) {
            throw new IllegalArgumentException("Этот email уже занят другим пользователем");
        }

        user.setFullName(fullName);
        user.setEmail(email);

        return userRepository.save(user);
    }

    /**
     * СМЕНА ПАРОЛЯ
     */
    @Transactional
    public void changePassword(Long userId, String oldPassword, String newPassword) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("Пользователь не найден"));

        if (!passwordEncoder.matches(oldPassword, user.getPasswordHash())) {
            throw new IllegalArgumentException("Неверный текущий пароль");
        }

        user.setPasswordHash(passwordEncoder.encode(newPassword));
        userRepository.save(user);

        try {
            emailService.sendPasswordChangeEmail(user.getEmail(), user.getFullName());
        } catch (Exception e) {
            System.err.println("Письмо о смене пароля не отправлено");
        }
    }

    /**
     * ПОДТВЕРЖДЕНИЕ КОДА
     */
    @Transactional
    public boolean verifyCode(String email, String code) {
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new IllegalArgumentException("Пользователь не найден"));

        if (user.getVerificationCode() != null && user.getVerificationCode().equals(code)) {
            user.setEnabled(true);
            user.setVerificationCode(null);
            userRepository.save(user);
            return true;
        }
        return false;
    }

    // --- Стандартные методы поиска ---

    public Optional<User> findByEmail(String email) {
        return userRepository.findByEmail(email);
    }

    public Optional<User> findById(Long id) {
        return userRepository.findById(id);
    }

    public List<User> getAllUsers() {
        return userRepository.findAll();
    }

    @Transactional
    public void deleteUser(Long id) {
        userRepository.deleteById(id);
    }

    @Transactional
    public void grantAdminRole(Long userId) {
        User user = userRepository.findById(userId).orElseThrow();
        user.setRole("ADMIN");
        userRepository.save(user);
    }

    @Transactional
    public void revokeAdminRole(Long userId) {
        User user = userRepository.findById(userId).orElseThrow();
        user.setRole("USER");
        userRepository.save(user);
    }
}
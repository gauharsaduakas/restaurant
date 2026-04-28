package com.gauhar.restaurant.security;

import com.gauhar.restaurant.entity.User;
import com.gauhar.restaurant.repository.UserRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

@Component
public class AdminInitializer implements CommandLineRunner {

    private final UserRepository repo;
    private final PasswordEncoder encoder;

    public AdminInitializer(UserRepository repo, PasswordEncoder encoder) {
        this.repo = repo;
        this.encoder = encoder;
    }

    @Override
    public void run(String... args) {
        String adminEmail = "admin@restaurant.com";

        // Проверяем наличие админа
        if (repo.findByEmail(adminEmail).isEmpty()) {
            User admin = new User();
            admin.setFullName("Administrator");
            admin.setEmail(adminEmail);

            // Хэшируем пароль "admin123"
            admin.setPasswordHash(encoder.encode("admin123"));

            // Сохраняем с префиксом ROLE_, чтобы избежать проблем с hasRole()
            admin.setRole("ROLE_ADMIN");
            repo.save(admin);
            System.out.println("✅ [AdminInitializer] Аккаунт администратора создан: " + adminEmail);
        } else {
            System.out.println("ℹ️ [AdminInitializer] Администратор уже существует в базе.");
        }
    }
}
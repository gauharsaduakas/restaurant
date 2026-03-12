package com.gauhar.restaurant.security;

import com.gauhar.restaurant.model.User;
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
        String adminEmail = "admin@gauhar.kz";

        if (repo.findByEmail(adminEmail).isEmpty()) {
            User admin = new User();
            admin.setFullName("Administrator");
            admin.setEmail(adminEmail);
            admin.setPasswordHash(encoder.encode("admin123"));
            admin.setRole("ADMIN");
            repo.save(admin);
        }
    }
}
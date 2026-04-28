package com.gauhar.restaurant.security;

import jakarta.servlet.DispatcherType;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
                // Включаем CSRF (в JSP формах он должен быть добавлен)
                .csrf(csrf -> {})

                .authorizeHttpRequests(auth -> auth
                        // Разрешаем FORWARD для корректного рендеринга JSP
                        .dispatcherTypeMatchers(DispatcherType.FORWARD).permitAll()

                        // Открытые ресурсы
                        .requestMatchers(
                                "/", "/home", "/login", "/register",
                                "/styles.css", "/static/**", "/css/**", "/js/**", "/favicon.ico"
                        ).permitAll()

                        // Доступ для администратора. hasRole("ADMIN") ищет "ROLE_ADMIN" в authorities
                        .requestMatchers("/admin/**", "/kitchen/**").hasRole("ADMIN")

                        // Все остальные страницы только для залогиненных пользователей
                        .anyRequest().authenticated()
                )

                .formLogin(form -> form
                        .loginPage("/login")
                        .loginProcessingUrl("/login") // URL для POST-запроса из формы
                        .defaultSuccessUrl("/home", true)
                        .failureUrl("/login?error")
                        .usernameParameter("username") // Соответствует name="username" в JSP
                        .passwordParameter("password") // Соответствует name="password" в JSP
                        .permitAll()
                )

                .logout(logout -> logout

                        .logoutUrl("/logout")
                        .logoutSuccessUrl("/login?logout")

                        .permitAll()
                );

        return http.build();
    }

    @Bean
    public AuthenticationManager authenticationManager(
            AuthenticationConfiguration config) throws Exception {
        return config.getAuthenticationManager();
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
}
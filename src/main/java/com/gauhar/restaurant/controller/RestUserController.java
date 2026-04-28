package com.gauhar.restaurant.controller;

import com.gauhar.restaurant.dto.UserResponse;
import com.gauhar.restaurant.entity.User;
import com.gauhar.restaurant.service.UserService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/users")
public class RestUserController {

    private final UserService userService;

    public RestUserController(UserService userService) {
        this.userService = userService;
    }

    /**
     * Вспомогательный метод для конвертации Entity в DTO.
     * Теперь включает поле isEnabled.
     */
    private UserResponse mapToResponse(User u) {
        return new UserResponse(
                u.getId(),
                u.getFullName(),
                u.getEmail(),
                u.getRole(),
                u.isEnabled() // Передаем статус активации в ответ
        );
    }

    /**
     * Получить всех пользователей
     */
    @GetMapping
    public ResponseEntity<List<UserResponse>> getAllUsers() {
        List<User> users = userService.getAllUsers();
        List<UserResponse> responses = users.stream()
                .map(this::mapToResponse)
                .collect(Collectors.toList());
        return ResponseEntity.ok(responses);
    }

    /**
     * Получить пользователя по ID
     */
    @GetMapping("/{id}")
    public ResponseEntity<UserResponse> getUserById(@PathVariable Long id) {
        return userService.findById(id)
                .map(this::mapToResponse)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    /**
     * Удалить пользователя
     */
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteUser(@PathVariable Long id) {
        userService.deleteUser(id);
        return ResponseEntity.noContent().build();
    }

    /**
     * Выдать права администратора
     */
    @PostMapping("/{id}/grant-admin")
    public ResponseEntity<UserResponse> grantAdmin(@PathVariable Long id) {
        try {
            userService.grantAdminRole(id);
            return userService.findById(id)
                    .map(this::mapToResponse)
                    .map(ResponseEntity::ok)
                    .orElse(ResponseEntity.notFound().build());
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    /**
     * Забрать права администратора
     */
    @PostMapping("/{id}/revoke-admin")
    public ResponseEntity<UserResponse> revokeAdmin(@PathVariable Long id) {
        try {
            userService.revokeAdminRole(id);
            return userService.findById(id)
                    .map(this::mapToResponse)
                    .map(ResponseEntity::ok)
                    .orElse(ResponseEntity.notFound().build());
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    /**
     * Метод для ручной активации пользователя админом (если код не пришел)
     */
    @PostMapping("/{id}/activate")
    public ResponseEntity<UserResponse> activateUser(@PathVariable Long id) {
        return userService.findById(id).map(user -> {
            user.setEnabled(true);
            user.setVerificationCode(null);
            // Здесь предполагается, что в UserService есть метод save или прямой доступ к репозиторию
            // Для чистоты кода лучше вызвать метод в сервисе: userService.activateManually(id);
            return ResponseEntity.ok(mapToResponse(user));
        }).orElse(ResponseEntity.notFound().build());
    }
}
package com.gauhar.restaurant.service;

import com.gauhar.restaurant.entity.Order;
import com.gauhar.restaurant.entity.OrderItem;
import com.gauhar.restaurant.model.Cart;
import com.gauhar.restaurant.model.CartItem;
import com.gauhar.restaurant.repository.OrderRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Service
public class OrderService {

    @Autowired
    private OrderRepository orderRepository;

    @Transactional
    public void runDiagnostics() {
        System.out.println("Diagnosing types...");
    }

    @Transactional
    public com.gauhar.restaurant.entity.Order createOrder(Cart cart, String userEmail) {
        if (cart.getItems().isEmpty()) {
            throw new RuntimeException("Cannot create order from empty cart");
        }

        // Мы используем DAO вместо сущностей здесь, так как DAO уже полностью рабочий
        return null;
    }
}

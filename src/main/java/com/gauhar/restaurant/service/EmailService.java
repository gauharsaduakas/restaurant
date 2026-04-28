package com.gauhar.restaurant.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

@Service
public class EmailService {

    @Autowired
    private JavaMailSender mailSender;

    /**
     * Базовый метод для отправки любого письма
     */
    public void sendEmail(String to, String subject, String text) {
        SimpleMailMessage message = new SimpleMailMessage();
        message.setTo(to);
        message.setSubject(subject);
        message.setText(text);
        mailSender.send(message);
    }

    /**
     * НОВЫЙ МЕТОД: Отправка кода подтверждения
     */
    public void sendVerificationEmail(String to, String code) {
        sendEmail(
                to,
                "Код подтверждения регистрации — Coffito Kitchen",
                "Здравствуйте!\n\n" +
                        "Для завершения регистрации в Coffito Kitchen, пожалуйста, введите следующий код:\n\n" +
                        "ВАШ КОД: " + code + "\n\n" +
                        "Этот код действителен в течение 15 минут.\n" +
                        "Если вы не регистрировались у нас, просто проигнорируйте это письмо.\n\n" +
                        "С уважением,\nкоманда Coffito Kitchen"
        );
    }

    // --- Ваши существующие методы ---

    public void sendWelcomeEmail(String to, String fullName) {
        sendEmail(
                to,
                "Добро пожаловать в Coffito Kitchen",
                "Здравствуйте, " + fullName + "!\n\n" +
                        "Добро пожаловать в Coffito Kitchen!\n\n" +
                        "Мы рады, что вы зарегистрировались в нашем ресторане.\n" +
                        "Теперь вы можете оформлять заказы и следить за их статусом онлайн.\n\n" +
                        "Желаем вам приятного аппетита и отличного настроения!\n\n" +
                        "С уважением,\nCoffito Kitchen"
        );
    }

    public void sendOrderAcceptedEmail(String to, String fullName, int orderId) {
        sendEmail(to, "Ваш заказ принят — Coffito Kitchen",
                "Здравствуйте, " + fullName + "!\n\nВаш заказ #" + orderId + " успешно принят.");
    }

    public void sendOrderPreparingEmail(String to, String fullName, int orderId) {
        sendEmail(to, "Ваш заказ готовится — Coffito Kitchen",
                "Здравствуйте, " + fullName + "!\n\nВаш заказ #" + orderId + " готовится на кухне.");
    }

    public void sendOrderReadyEmail(String to, String fullName, int orderId) {
        sendEmail(to, "Ваш заказ готов — Coffito Kitchen",
                "Здравствуйте, " + fullName + "!\n\nВаш заказ #" + orderId + " готов к выдаче.");
    }

    public void sendOrderDoneEmail(String to, String fullName, int orderId) {
        sendEmail(to, "Ваш заказ выдан — Coffito Kitchen",
                "Здравствуйте, " + fullName + "!\n\nВаш заказ #" + orderId + " выдан. Приятного аппетита!");
    }

    public void sendPasswordChangeEmail(String to, String fullName) {
        sendEmail(to, "Пароль изменен — Coffito Kitchen",
                "Здравствуйте, " + fullName + "!\n\nВаш пароль был успешно изменен.");
    }
}
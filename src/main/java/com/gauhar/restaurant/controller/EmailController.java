package com.gauhar.restaurant.controller;

import com.gauhar.restaurant.service.EmailService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/email")
public class EmailController {

    private final EmailService emailService;

    public EmailController(EmailService emailService) {
        this.emailService = emailService;
    }

    @GetMapping("/send")
    public String send() {
        try {
            emailService.sendEmail(
                    "msaduakasea@gmail.com",
                    "Hello",
                    "Test message"
            );
            return "Email sent";
        } catch (Exception e) {
            e.printStackTrace();
            return "Ошибка отправки: " + e.toString();
        }
    }
}
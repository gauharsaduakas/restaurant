package com.gauhar.restaurant.util;

import com.gauhar.restaurant.model.User;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

@Component
public class SecurityUtils {

    public User getCurrentUser() {
        try {
            ServletRequestAttributes attrs =
                    (ServletRequestAttributes) RequestContextHolder.currentRequestAttributes();
            HttpServletRequest request = attrs.getRequest();
            HttpSession session = request.getSession(false);
            if (session == null) return null;
            return (User) session.getAttribute("currentUser");
        } catch (Exception e) {
            return null;
        }
    }
}


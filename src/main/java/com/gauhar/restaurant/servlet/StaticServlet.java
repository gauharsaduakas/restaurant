package com.gauhar.restaurant.servlet;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.InputStream;

@WebServlet(urlPatterns = {"/styles.css", "/assets/*"})
public class StaticServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String servletPath = req.getServletPath();
        String pathInfo = req.getPathInfo();

        String resourcePath;
        if ("/styles.css".equals(servletPath)) {
            resourcePath = "/styles.css";
            resp.setContentType("text/css; charset=UTF-8");
        } else {
            resourcePath = "/assets" + (pathInfo == null ? "" : pathInfo);
            resp.setContentType(guessContentType(resourcePath));
        }

        try (InputStream is = getServletContext().getResourceAsStream(resourcePath)) {
            if (is == null) {
                resp.setStatus(404);
                return;
            }
            is.transferTo(resp.getOutputStream());
        }
    }

    private String guessContentType(String p) {
        String lower = p.toLowerCase();
        if (lower.endsWith(".css"))  return "text/css; charset=UTF-8";
        if (lower.endsWith(".jpg") || lower.endsWith(".jpeg")) return "image/jpeg";
        if (lower.endsWith(".png"))  return "image/png";
        if (lower.endsWith(".webp")) return "image/webp";
        if (lower.endsWith(".gif"))  return "image/gif";
        if (lower.endsWith(".svg"))  return "image/svg+xml";
        return "application/octet-stream";
    }
}
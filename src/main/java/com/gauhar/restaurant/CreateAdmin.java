package com.gauhar.restaurant;

import com.gauhar.restaurant.util.PasswordUtil;
import java.sql.*;

public class CreateAdmin {
    public static void main(String[] args) throws Exception {
        String url  = "jdbc:sqlserver://localhost:1433;databaseName=restaurant_dbb;encrypt=false;trustServerCertificate=true";
        String user = "sa";
        String pass = "ыф"; // ыф

        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");

        try (Connection cn = DriverManager.getConnection(url, user, pass)) {

            try (PreparedStatement ps = cn.prepareStatement(
                    "DELETE FROM users WHERE email = ?")) {
                ps.setString(1, "admin@gauhar.kz" +
                        "");
                ps.executeUpdate();
            }

            String hash = PasswordUtil.hash("admin123");
            try (PreparedStatement ps = cn.prepareStatement(
                    "INSERT INTO users (full_name, email, password_hash, role) VALUES (?,?,?,?)")) {
                ps.setString(1, "Admin");
                ps.setString(2, "admin@gauhar.kz");
                ps.setString(3, hash);
                ps.setString(4, "ADMIN");
                ps.executeUpdate();
            }
            try (PreparedStatement ps = cn.prepareStatement(
                    "SELECT id, full_name, email, role FROM users");
                 ResultSet rs = ps.executeQuery()) {
                System.out.println("=== USERS IN DATABASE ===");
                while (rs.next()) {
                    System.out.println(
                        "ID=" + rs.getInt("id") +
                        " | Name=" + rs.getString("full_name") +
                        " | Email=" + rs.getString("email") +
                        " | Role=" + rs.getString("role")
                    );
                }
            }

            System.out.println("\n✅ DONE!");
            System.out.println("Login:    admin@gauhar.kz");
            System.out.println("Password: admin123");
        }
    }
}


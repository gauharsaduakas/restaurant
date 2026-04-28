package com.gauhar.restaurant.db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Db {
    private static final String URL = "jdbc:sqlserver://localhost:1433;databaseName=restaurant_dbb;encrypt=false;trustServerCertificate=true";
    private static final String USER = "sa";
    private static final String PASS = "sa";

    static {
        try {
            // Исправлено: загружаем драйвер SQL Server, а не H2
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("SQL Server JDBC Driver not found!", e);
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASS);
    }
}
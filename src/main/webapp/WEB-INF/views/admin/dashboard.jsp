<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!doctype html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Админ панель — Coffito Kitchen</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles.css">
    <style>
        body {
            background: #f5f5f5;
        }
        .admin-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 30px 20px;
        }
        .admin-header {
            background: white;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 30px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .admin-header h1 {
            margin: 0;
            color: #333;
        }
        .admin-nav {
            display: flex;
            gap: 10px;
        }
        .admin-nav a {
            padding: 10px 20px;
            background: #d4a574;
            color: white;
            text-decoration: none;
            border-radius: 4px;
            font-size: 14px;
            font-weight: 600;
        }
        .admin-nav a:hover {
            background: #b8956f;
        }
        .dashboard-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        .dashboard-card {
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            text-align: center;
        }
        .dashboard-card h3 {
            margin: 0 0 10px 0;
            color: #333;
            font-size: 16px;
        }
        .dashboard-card .number {
            font-size: 32px;
            color: #d4a574;
            font-weight: 700;
            margin-bottom: 15px;
        }
        .dashboard-card a {
            display: inline-block;
            padding: 8px 16px;
            background: #f0f0f0;
            color: #333;
            text-decoration: none;
            border-radius: 4px;
            font-size: 12px;
            font-weight: 600;
        }
        .dashboard-card a:hover {
            background: #e0e0e0;
        }
        .logout-btn {
            padding: 10px 20px;
            background: #e74c3c;
            color: white;
            text-decoration: none;
            border-radius: 4px;
            font-size: 14px;
            font-weight: 600;
        }
        .logout-btn:hover {
            background: #c0392b;
        }
    </style>
</head>
<body>
<div class="admin-container">
    <div class="admin-header">
        <h1>📊 Админ Панель</h1>
        <div class="admin-nav">
            <a href="${pageContext.request.contextPath}/admin/users">👥 Пользователи</a>
            <a href="${pageContext.request.contextPath}/admin/menu-items">🍽️ Меню</a>
            <a href="${pageContext.request.contextPath}/admin/orders">📦 Заказы</a>
            <a href="${pageContext.request.contextPath}/profile">⚙️ Профиль</a>
            <a href="${pageContext.request.contextPath}/logout" class="logout-btn">🚪 Выход</a>
        </div>
    </div>

    <div class="dashboard-grid">
        <div class="dashboard-card">
            <h3>Всего пользователей</h3>
            <div class="number">0</div>
            <a href="${pageContext.request.contextPath}/admin/users">Управлять</a>
        </div>

        <div class="dashboard-card">
            <h3>Позиций в меню</h3>
            <div class="number">0</div>
            <a href="${pageContext.request.contextPath}/admin/menu-items">Управлять</a>
        </div>

        <div class="dashboard-card">
            <h3>Активные заказы</h3>
            <div class="number">0</div>
            <a href="${pageContext.request.contextPath}/admin/orders">Просмотреть</a>
        </div>

        <div class="dashboard-card">
            <h3>Статистика</h3>
            <div class="number">📈</div>
            <a href="${pageContext.request.contextPath}/admin/statistics">Подробнее</a>
        </div>
    </div>

    <div style="background: white; padding: 20px; border-radius: 8px;">
        <h2>Добро пожаловать в админ панель!</h2>
        <p>Используйте меню выше для управления пользователями, меню, заказами и просмотра статистики.</p>
    </div>
</div>
</body>
</html>


<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, com.gauhar.restaurant.model.*" %>
<%
    Restaurant _r = (Restaurant) request.getAttribute("restaurant");
    if (_r == null) _r = new Restaurant();
    String restaurantName = (_r.getName() != null && !_r.getName().isBlank()) ? _r.getName() : "🎍 Ресторан";

    Order order = (Order) request.getAttribute("order");
    if (order == null) {
        response.sendRedirect("${pageContext.request.contextPath}/my-orders");
        return;
    }

    List<OrderItem> items = (order.getItems() != null)
            ? order.getItems()
            : Collections.emptyList();

    String status = (order.getStatus() != null)
            ? order.getStatus().name()
            : "PENDING";

    String dt = "";
    if (order.getCreatedAt() != null) {
        String raw = order.getCreatedAt().toString().replace("T", " ");
        dt = raw.length() >= 19 ? raw.substring(0,19) : raw;
    }

    // Отображение статуса
    String statusDisplay = "";
    String statusIcon = "";
    switch (status) {
        case "PENDING": statusDisplay = "Ожидание"; statusIcon = "⏳"; break;
        case "CONFIRMED": statusDisplay = "Подтверждён"; statusIcon = "✅"; break;
        case "PREPARING": statusDisplay = "Готовится"; statusIcon = "👨‍🍳"; break;
        case "READY": statusDisplay = "Готово"; statusIcon = "🔔"; break;
        case "DONE": statusDisplay = "Выдан"; statusIcon = "📦"; break;
    }
%>

<!doctype html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Заказ #<%= order.getId() %> — <%= restaurantName %></title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles.css">
    <style>
        .detail-card {
            background: white;
            border-radius: 12px;
            padding: 24px;
            margin-bottom: 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        .detail-row {
            display: flex;
            justify-content: space-between;
            padding: 12px 0;
            border-bottom: 1px solid #eee;
        }
        .detail-label {
            font-weight: 600;
            color: #666;
        }
        .detail-value {
            text-align: right;
            color: #333;
        }
        .status-badge {
            display: inline-block;
            padding: 8px 16px;
            border-radius: 20px;
            background: #f0f0f0;
            color: #333;
            font-weight: 600;
            font-size: 14px;
        }
        .items-table {
            width: 100%;
            border-collapse: collapse;
            margin: 20px 0;
        }
        .items-table th,
        .items-table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #eee;
        }
        .items-table th {
            background: #f9f9f9;
            font-weight: 600;
        }
    </style>
</head>

<body>

<!-- NAVBAR -->
<div class="navbar">
    <div class="nav-inner">
        <a class="brand" href="<%= ctx %>/home"><%= restaurantName %></a>
        <div class="nav-links">
            <a class="nav-link" href="<%= ctx %>/home">Главная</a>
            <a class="nav-link" href="<%= ctx %>/menu-items">Меню</a>
            <a class="nav-link" href="<%= ctx %>/cart">🛒 Корзина</a>
            <a class="nav-link active" href="<%= ctx %>/my-orders">📋 Мои заказы</a>
            <a class="nav-link" href="<%= ctx %>/logout">🚪 Выход</a>
        </div>
    </div>
</div>

<div class="page-wrapper">

    <!-- HEADER -->
    <div class="page-header-bar">
        <h2 class="page-title">📋 Заказ №<%= order.getId() %></h2>
        <a href="<%= ctx %>/my-orders" class="btn ghost small">← Вернуться</a>
    </div>

    <!-- ОСНОВНАЯ ИНФОРМАЦИЯ -->
    <div class="detail-card">
        <h3 style="margin-top: 0;">Статус заказа</h3>
        <div class="status-badge"><%= statusIcon %> <%= statusDisplay %></div>

        <div class="detail-row">
            <span class="detail-label">ID заказа:</span>
            <span class="detail-value">#<%= order.getId() %></span>
        </div>

        <div class="detail-row">
            <span class="detail-label">Дата заказа:</span>
            <span class="detail-value"><%= dt %></span>
        </div>

        <div class="detail-row">
            <span class="detail-label">Имя клиента:</span>
            <span class="detail-value"><%= order.getCustomerName() != null ? order.getCustomerName() : "Не указано" %></span>
        </div>

        <div class="detail-row">
            <span class="detail-label">Телефон:</span>
            <span class="detail-value"><%= order.getPhone() != null && !order.getPhone().isEmpty() ? order.getPhone() : "Не указан" %></span>
        </div>
    </div>

    <!-- ТОВАРЫ В ЗАКАЗЕ -->
    <div class="detail-card">
        <h3 style="margin-top: 0;">Товары в заказе</h3>

        <% if (items.isEmpty()) { %>
        <p style="color: #999;">Нет товаров</p>
        <% } else { %>
        <table class="items-table">
            <thead>
                <tr>
                    <th>Блюдо</th>
                    <th style="text-align: center;">Кол-во</th>
                    <th style="text-align: right;">Цена за ед.</th>
                    <th style="text-align: right;">Сумма</th>
                </tr>
            </thead>
            <tbody>
                <% for (OrderItem it : items) {
                    String itemName = (it.getMenuItem() != null && it.getMenuItem().getName() != null)
                            ? it.getMenuItem().getName()
                            : "Блюдо";
                    double itemPrice = it.getPriceAtMoment();
                    int qty = it.getQuantity();
                    double itemTotal = (itemPrice + it.getOptionsPrice()) * qty;
                %>
                <tr>
                    <td><%= itemName %></td>
                    <td style="text-align: center;"><%= qty %></td>
                    <td style="text-align: right;"><%= (int)itemPrice %> ₸</td>
                    <td style="text-align: right;"><strong><%= (int)itemTotal %> ₸</strong></td>
                </tr>
                <% } %>
            </tbody>
        </table>
        <% } %>

        <!-- ИТОГИ -->
        <div style="border-top: 2px solid #333; padding-top: 16px; margin-top: 16px;">
            <div class="detail-row" style="border: none;">
                <span class="detail-label" style="font-size: 16px;">Итого:</span>
                <span class="detail-value" style="font-size: 18px; color: #2ecc71;">
                    <strong><%= (int)order.getTotalAmount() %> ₸</strong>
                </span>
            </div>
        </div>
    </div>

    <!-- ДЕЙСТВИЯ -->
    <div class="detail-card" style="text-align: center;">
        <a href="<%= ctx %>/menu-items" class="btn primary">📋 Продолжить покупки</a>
        <a href="<%= ctx %>/my-orders" class="btn ghost">Вернуться к заказам</a>
    </div>

</div>

</body>
</html>


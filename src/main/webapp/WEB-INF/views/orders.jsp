<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page isELIgnored="false" %>
<%@ page import="java.util.*, com.gauhar.restaurant.model.*" %>
<%@ page import="org.springframework.security.core.*" %>
<%@ page import="org.springframework.security.core.context.SecurityContextHolder" %>

<%
    // 1. Безопасное получение контекстного пути
    String contextPath = request.getContextPath();

    // 2. Безопасное получение данных ресторана
    Restaurant r = (Restaurant) request.getAttribute("restaurant");
    String restaurantName = (r != null && r.getName() != null && !r.getName().isBlank()) ? r.getName() : "Ресторан";

    // 3. Безопасное получение списка заказов
    List<Order> orders = (List<Order>) request.getAttribute("orders");
    if (orders == null) {
        orders = new ArrayList<>();
    }

    // 4. Проверка прав администратора
    Authentication auth = SecurityContextHolder.getContext().getAuthentication();
    boolean isAdmin = false;
    if (auth != null && auth.isAuthenticated()) {
        isAdmin = auth.getAuthorities().stream()
                .anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN"));
    }

    // 5. Подсчет выручки с защитой от ошибок
    long totalRevenue = 0;
    for (Order o : orders) {
        if (o != null) {
            try {
                totalRevenue += (long) o.getTotalAmount();
            } catch (Exception e) { /* пропуск некорректных сумм */ }
        }
    }

    request.setAttribute("navRestaurantName", restaurantName);
    request.setAttribute("navActivePage", "orders");
%>

<!doctype html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Заказы — <%= restaurantName %></title>
    <link rel="stylesheet" href="<%= contextPath %>/styles.css">
    <style>
        .orders-container { padding: 20px; max-width: 1200px; margin: 0 auto; }
        .order-card {
            background: white; border: 1px solid #eee; border-radius: 12px;
            padding: 20px; margin-bottom: 20px; box-shadow: 0 2px 8px rgba(0,0,0,0.05);
        }
        .status-badge {
            display: inline-block; padding: 4px 12px; border-radius: 20px;
            font-size: 12px; font-weight: bold; background: #f0f0f0; color: #666;
        }
        .order-meta { display: flex; justify-content: space-between; margin-top: 15px; padding-top: 15px; border-top: 1px solid #f9f9f9; }
        .total-price { color: #2ecc71; font-weight: 800; font-size: 1.1em; }
    </style>
</head>

<body>

<jsp:include page="includes/navbar.jsp" />

<div class="page-wrapper orders-container">

    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px;">
        <h2 style="margin: 0;">📋 История заказов</h2>
        <div style="background: #fff; padding: 10px 20px; border-radius: 8px; border: 1px solid #d4a574; font-weight: bold;">
            Выручка: <%= totalRevenue %> ₸
        </div>
    </div>

    <jsp:include page="includes/flash.jsp" />

    <% if (orders.isEmpty()) { %>
    <div style="text-align: center; padding: 50px; color: #888;">
        <h3>Заказов пока нет</h3>
    </div>
    <% } else { %>

    <div style="display: grid; grid-template-columns: repeat(auto-fill, minmax(350px, 1fr)); gap: 20px;">
        <% for (Order o : orders) {
            if (o == null) continue;

            // Безопасная обработка вложенных данных
            List<OrderItem> items = (o.getItems() != null) ? o.getItems() : Collections.emptyList();
            String statusName = (o.getStatus() != null) ? o.getStatus().name() : "NEW";

            String dateStr = "Дата не указана";
            if (o.getCreatedAt() != null) {
                try {
                    dateStr = o.getCreatedAt().toString().replace("T", " ").substring(0, 16);
                } catch (Exception e) { dateStr = "Некорректная дата"; }
            }
        %>

        <div class="order-card">
            <div style="display: flex; justify-content: space-between;">
                <span style="color: #d4a574; font-weight: bold;">Заказ #<%= o.getId() %></span>
                <span class="status-badge"><%= statusName %></span>
            </div>

            <div style="margin: 15px 0;">
                <strong>👤 <%= (o.getCustomerName() != null) ? o.getCustomerName() : "Гость" %></strong><br>
                <small style="color: #888;">📞 <%= (o.getPhone() != null) ? o.getPhone() : "-" %></small>
            </div>

            <div style="background: #fdfdfd; padding: 10px; border-radius: 6px; font-size: 14px;">
                <% if (items.isEmpty()) { %>
                <span style="color: #ccc;">Список блюд пуст</span>
                <% } else {
                    for (OrderItem it : items) {
                        if (it == null) continue;
                        String itemName = (it.getMenuItem() != null && it.getMenuItem().getName() != null)
                                ? it.getMenuItem().getName() : "Блюдо";
                %>
                <div style="margin-bottom: 4px;">• <%= itemName %> — <strong><%= it.getQuantity() %> шт.</strong></div>
                <% }} %>
            </div>

            <% if (o.getToppings() != null && !o.getToppings().isBlank()) { %>
            <div style="margin-top: 10px; font-size: 12px; color: #666; font-style: italic;">
                📝 Примечание: <%= o.getToppings() %>
            </div>
            <% } %>

            <div class="order-meta">
                <span style="font-size: 12px; color: #aaa;">⏱ <%= dateStr %></span>
                <span class="total-price"><%= (int) o.getTotalAmount() %> ₸</span>
            </div>

            <% if (isAdmin) { %>
            <div style="margin-top: 20px;">
                <form method="post" action="<%= contextPath %>/orders/<%= o.getId() %>/status">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    <select name="status" onchange="this.form.submit()" style="width: 100%; padding: 10px; border-radius: 6px; border: 1px solid #eee; background: #fff; cursor: pointer;">
                        <option disabled selected>Установить статус...</option>
                        <option value="CONFIRMED">✅ Принять</option>
                        <option value="PREPARING">👨‍🍳 Готовится</option>
                        <option value="READY">🔔 Готово</option>
                        <option value="DONE">📦 Выдан</option>
                        <option value="CANCELLED">❌ Отменить</option>
                    </select>
                </form>
            </div>
            <% } %>
        </div>
        <% } %>
    </div>
    <% } %>

</div>

<jsp:include page="includes/footer.jsp" />
</body>
</html>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, com.gauhar.restaurant.model.*" %>
<%
    Restaurant _r = (Restaurant) request.getAttribute("restaurant");
    if (_r == null) _r = new Restaurant();
    String restaurantName = (_r.getName() != null && !_r.getName().isBlank()) ? _r.getName() : "🎍 Ресторан";

    List<Order> orders = (List<Order>) request.getAttribute("orders");
    if (orders == null) orders = new ArrayList<>();

    String userName = (String) request.getAttribute("userName");
    if (userName == null) userName = "Пользователь";

    request.setAttribute("navRestaurantName", restaurantName);
    request.setAttribute("navActivePage", "my-orders");
%>

<!doctype html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Мои заказы — <%= restaurantName %></title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles.css">
</head>

<body>

<jsp:include page="includes/navbar.jsp" />

<div class="page-wrapper">

    <!-- HEADER -->
    <div class="page-header-bar">
        <h2 class="page-title">📋 Мои заказы</h2>
    </div>

    <jsp:include page="includes/flash.jsp" />

    <% if (orders.isEmpty()) { %>

    <div class="kitchen-empty">
        У вас ещё нет заказов 😔<br><br>
        <a href="${pageContext.request.contextPath}/menu-items" class="btn primary">Перейти в меню</a>
    </div>

    <% } else { %>

    <div class="kitchen-grid" style="grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));">

        <% for (Order o : orders) {

            if (o == null) continue;

            List<OrderItem> items = (o.getItems() != null)
                    ? o.getItems()
                    : Collections.emptyList();

            String status = (o.getStatus() != null)
                    ? o.getStatus().name()
                    : "PENDING";

            String dt = "";
            if (o.getCreatedAt() != null) {
                String raw = o.getCreatedAt().toString().replace("T", " ");
                dt = raw.length() >= 16 ? raw.substring(0,16) : raw;
            }

            // Определяем цвет статуса
            String statusColor = "pending";
            switch (status) {
                case "CONFIRMED": statusColor = "confirmed"; break;
                case "PREPARING": statusColor = "preparing"; break;
                case "READY": statusColor = "ready"; break;
                case "DONE": statusColor = "done"; break;
            }

            // Отображение статуса
            String statusDisplay = "";
            switch (status) {
                case "PENDING": statusDisplay = "⏳ Ожидание"; break;
                case "CONFIRMED": statusDisplay = "✅ Подтверждён"; break;
                case "PREPARING": statusDisplay = "👨‍🍳 Готовится"; break;
                case "READY": statusDisplay = "🔔 Готово"; break;
                case "DONE": statusDisplay = "📦 Выдан"; break;
            }
        %>

        <!-- CARD -->
        <div class="kitchen-card">

            <!-- ID + STATUS -->
            <div class="k-id">#<%= o.getId() %></div>
            <div style="font-size: 14px; padding: 8px; border-radius: 6px; background: #f0f0f0; margin: 8px 0; color: #333;">
                <%= statusDisplay %>
            </div>

            <!-- ITEMS -->
            <div class="k-items" style="margin-top: 8px;">
                <% if (items.isEmpty()) { %>
                Нет блюд
                <% } else {
                    for (OrderItem it : items) {

                        String name = (it.getMenuItem() != null && it.getMenuItem().getName() != null)
                                ? it.getMenuItem().getName()
                                : "Блюдо";
                %>
                • <%= name %> × <b><%= it.getQuantity() %></b><br>
                <% }} %>
            </div>

            <!-- META -->
            <div class="k-meta">
                <span>⏱ <%= dt %></span>
                <span class="k-total"><%= (int)o.getTotalAmount() %> ₸</span>
            </div>

            <!-- DETAIL LINK -->
            <a href="${pageContext.request.contextPath}/my-orders/<%= o.getId() %>" class="btn small primary full-width">Подробнее</a>

        </div>

        <% } %>

    </div>

    <% } %>

</div>

<jsp:include page="includes/footer.jsp" />
</body>
</html>


<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, com.gauhar.restaurant.model.*" %>

<%
    String ctx = request.getContextPath();

    // Spring MVC кладёт restaurant через @ModelAttribute в request
    Restaurant r = (Restaurant) request.getAttribute("restaurant");
    String restaurantName = (r != null && r.getName() != null && !r.getName().isBlank())
            ? r.getName() : "Gauhar Restaurant";

    List<Order> cooking = (List<Order>) request.getAttribute("cooking");
    List<Order> ready   = (List<Order>) request.getAttribute("ready");

    if (cooking == null) cooking = new ArrayList<>();
    if (ready == null)   ready   = new ArrayList<>();
%>

<!doctype html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Кухня — <%= restaurantName %></title>
    <link rel="stylesheet" href="<%= ctx %>/styles.css">
    <meta http-equiv="refresh" content="10">
</head>
<body>

<jsp:include page="/WEB-INF/views/fragments/navbar.jsp"/>

<div class="page-wrapper">
    <div class="page-header-bar">
        <h2 class="page-title">👨‍🍳 Табло кухни</h2>
        <a class="btn ghost small" href="<%= ctx %>/kitchen">🔄 Обновить</a>
    </div>

    <p style="color:#7a8a6a;margin:0 0 20px;font-size:13px">
        Авто-обновление каждые 10 сек
    </p>

    <div class="kitchen-grid">

        <div class="kitchen-col">
            <div class="kitchen-col-header preparing">🍳 ГОТОВИТСЯ</div>

            <% if (cooking.isEmpty()) { %>
            <div class="kitchen-empty">Нет заказов в приготовлении</div>
            <% } else {
                for (Order o : cooking) {

                    List<OrderItem> items = (o.getItems() != null) ? o.getItems() : Collections.emptyList();

                    StringBuilder sb = new StringBuilder();
                    for (OrderItem it : items) {
                        if (sb.length() > 0) sb.append(", ");
                        String itemName = (it.getMenuItem() != null && it.getMenuItem().getName() != null)
                                ? it.getMenuItem().getName()
                                : "?";
                        sb.append(itemName).append(" ×").append(it.getQuantity());
                    }

                    String dtStr = "";
                    if (o.getCreatedAt() != null) {
                        String raw = o.getCreatedAt().toString().replace("T", " ");
                        dtStr = (raw.length() >= 16) ? raw.substring(0, 16) : raw;
                    }

                    double total = 0;
                    try {
                        total = o.getTotalAmount();
                    } catch (Exception ignored) { }
            %>
            <div class="kitchen-card preparing-card">
                <div class="k-id">#<%= o.getId() %></div>
                <div class="k-name"><%= o.getCustomerName() %></div>
                <div class="k-items"><%= sb.toString() %></div>

                <div class="k-meta">
                    <span>⏱ <%= dtStr %></span>
                    <span class="k-total"><%= (int) total %> ₸</span>
                </div>

                <form method="post" action="<%= ctx %>/kitchen/action">
                    <input type="hidden" name="id" value="<%= o.getId() %>">
                    <input type="hidden" name="action" value="toReady">
                    <button class="btn primary full-width" type="submit">➡ Переместить в ГОТОВ</button>
                </form>
            </div>
            <%
                    }
                }
            %>
        </div>

        <div class="kitchen-col">
            <div class="kitchen-col-header ready">✅ ГОТОВ</div>

            <% if (ready.isEmpty()) { %>
            <div class="kitchen-empty">Нет готовых заказов</div>
            <% } else {
                for (Order o : ready) {

                    List<OrderItem> items = (o.getItems() != null) ? o.getItems() : Collections.emptyList();

                    StringBuilder sb = new StringBuilder();
                    for (OrderItem it : items) {
                        if (sb.length() > 0) sb.append(", ");
                        String itemName = (it.getMenuItem() != null && it.getMenuItem().getName() != null)
                                ? it.getMenuItem().getName()
                                : "?";
                        sb.append(itemName).append(" ×").append(it.getQuantity());
                    }

                    String dtStr = "";
                    if (o.getCreatedAt() != null) {
                        String raw = o.getCreatedAt().toString().replace("T", " ");
                        dtStr = (raw.length() >= 16) ? raw.substring(0, 16) : raw;
                    }

                    double total = 0;
                    try {
                        total = o.getTotalAmount();
                    } catch (Exception ignored) { }
            %>
            <div class="kitchen-card ready-card">
                <div class="k-id">#<%= o.getId() %></div>
                <div class="k-name"><%= o.getCustomerName() %></div>
                <div class="k-items"><%= sb.toString() %></div>

                <div class="k-meta">
                    <span>⏱ <%= dtStr %></span>
                    <span class="k-total"><%= (int) total %> ₸</span>
                </div>

                <form method="post" action="<%= ctx %>/kitchen/action">
                    <input type="hidden" name="id" value="<%= o.getId() %>">
                    <input type="hidden" name="action" value="toDone">
                    <button class="btn ghost full-width" type="submit">✅ Выдан</button>
                </form>
            </div>
            <%
                    }
                }
            %>
        </div>

    </div>
</div>

</body>
</html>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*,com.gauhar.restaurant.model.*" %>
<%
    String ctx = request.getContextPath();
    List<Order> cooking = (List<Order>) request.getAttribute("cooking");
    List<Order> ready   = (List<Order>) request.getAttribute("ready");
    if (cooking == null) cooking = new ArrayList<>();
    if (ready   == null) ready   = new ArrayList<>();
%>
<!doctype html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Кухня — Табло</title>
    <link rel="stylesheet" href="<%=ctx%>/assets/styles.css">
    <meta http-equiv="refresh" content="10">
</head>
<body>

<div class="navbar">
    <div class="nav-inner">
        <a class="brand" href="<%=ctx%>/">🌿 Gauhar Restaurant</a>
        <div class="nav-links">
            <a class="nav-link" href="<%=ctx%>/">Главная</a>
            <a class="nav-link" href="<%=ctx%>/menu-items">Меню</a>
            <a class="nav-link" href="<%=ctx%>/orders">Заказы</a>
            <a class="nav-link active" href="<%=ctx%>/kitchen">Кухня</a>
            <a class="nav-link" href="<%=ctx%>/restaurant">О ресторане</a>
        </div>
    </div>
</div>

<div class="page-wrapper">
    <div class="page-header-bar">
        <h2 class="page-title">👨‍🍳 Табло кухни</h2>
        <a class="btn ghost small" href="<%=ctx%>/kitchen">🔄 Обновить</a>
    </div>
    <p style="color:#7a8a6a;margin:0 0 20px;font-size:13px">Авто-обновление каждые 10 сек</p>

    <div class="kitchen-grid">

        <!-- LEFT: ГОТОВИТСЯ -->
        <div class="kitchen-col">
            <div class="kitchen-col-header preparing">🍳 ГОТОВИТСЯ</div>
            <% if (cooking.isEmpty()) { %>
            <div class="kitchen-empty">Нет заказов в приготовлении</div>
            <% } else { for (Order o : cooking) {
                StringBuilder sb = new StringBuilder();
                for (OrderItem it : o.getItems()) {
                    if (sb.length() > 0) sb.append(", ");
                    sb.append(it.getMenuItem() != null ? it.getMenuItem().getName() : "?")
                      .append(" ×").append(it.getQuantity());
                }
                String dtStr = o.getCreatedAt() != null
                        ? o.getCreatedAt().toString().replace("T"," ").substring(0,16) : "";
            %>
            <div class="kitchen-card preparing-card">
                <div class="k-id">#<%= o.getId() %></div>
                <div class="k-name"><%= o.getCustomerName() %></div>
                <div class="k-items"><%= sb %></div>
                <div class="k-meta">
                    <span>⏱ <%= dtStr %></span>
                    <span class="k-total"><%= (int)o.getTotalAmount() %> ₸</span>
                </div>
                <form method="post" action="<%=ctx%>/kitchen/action">
                    <input type="hidden" name="id" value="<%= o.getId() %>">
                    <input type="hidden" name="action" value="toReady">
                    <button class="btn primary full-width" type="submit">➡ Переместить в ГОТОВ</button>
                </form>
            </div>
            <% }} %>
        </div>

        <!-- RIGHT: ГОТОВ -->
        <div class="kitchen-col">
            <div class="kitchen-col-header ready">✅ ГОТОВ</div>
            <% if (ready.isEmpty()) { %>
            <div class="kitchen-empty">Нет готовых заказов</div>
            <% } else { for (Order o : ready) {
                StringBuilder sb = new StringBuilder();
                for (OrderItem it : o.getItems()) {
                    if (sb.length() > 0) sb.append(", ");
                    sb.append(it.getMenuItem() != null ? it.getMenuItem().getName() : "?")
                      .append(" ×").append(it.getQuantity());
                }
                String dtStr = o.getCreatedAt() != null
                        ? o.getCreatedAt().toString().replace("T"," ").substring(0,16) : "";
            %>
            <div class="kitchen-card ready-card">
                <div class="k-id">#<%= o.getId() %></div>
                <div class="k-name"><%= o.getCustomerName() %></div>
                <div class="k-items"><%= sb %></div>
                <div class="k-meta">
                    <span>⏱ <%= dtStr %></span>
                    <span class="k-total"><%= (int)o.getTotalAmount() %> ₸</span>
                </div>
                <form method="post" action="<%=ctx%>/kitchen/action">
                    <input type="hidden" name="id" value="<%= o.getId() %>">
                    <input type="hidden" name="action" value="toDone">
                    <button class="btn ghost full-width" type="submit">✅ Выдан</button>
                </form>
            </div>
            <% }} %>
        </div>

    </div>
</div>

</body>
</html>


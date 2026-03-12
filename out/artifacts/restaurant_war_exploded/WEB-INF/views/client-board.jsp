<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, com.gauhar.restaurant.model.*" %>
<%
    String ctx = request.getContextPath();

    Restaurant r = (Restaurant) request.getAttribute("restaurant");
    String restaurantName = (r != null && r.getName() != null && !r.getName().isBlank())
            ? r.getName() : "Gauhar Restaurant";

    User currentUser = (User) session.getAttribute("currentUser");
    String clientName = (currentUser != null && currentUser.getFullName() != null)
            ? currentUser.getFullName() : "Гость";

    List<Order> cookingOrders = (List<Order>) request.getAttribute("cookingOrders");
    List<Order> readyOrders   = (List<Order>) request.getAttribute("readyOrders");
    List<Order> allOrders     = (List<Order>) request.getAttribute("allOrders");

    if (cookingOrders == null) cookingOrders = new ArrayList<>();
    if (readyOrders   == null) readyOrders   = new ArrayList<>();
    if (allOrders     == null) allOrders     = new ArrayList<>();
%>
<!doctype html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Табло — <%= restaurantName %></title>
    <link rel="stylesheet" href="<%= ctx %>/styles.css">
    <%-- Авто-обновление каждые 10 секунд --%>
    <meta http-equiv="refresh" content="10">
    <style>
        /* ── Приветствие ── */
        .board-hero {
            background: var(--card);
            border-radius: var(--radius);
            padding: 24px 28px;
            margin-bottom: 24px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 12px;
        }
        .board-hero-left h2 {
            font-size: 20px;
            font-weight: 800;
            margin-bottom: 4px;
        }
        .board-hero-left p {
            font-size: 13px;
            color: var(--sub);
        }
        .board-refresh-hint {
            font-size: 12px;
            color: var(--sub);
            display: flex;
            align-items: center;
            gap: 6px;
        }

        /* ── Табло ── */
        .board-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 24px;
            margin-bottom: 32px;
        }
        @media (max-width: 680px) { .board-grid { grid-template-columns: 1fr; } }

        .board-col { display: flex; flex-direction: column; gap: 14px; }

        .board-col-header {
            border-radius: var(--radius);
            padding: 14px 20px;
            font-size: 15px;
            font-weight: 800;
            text-align: center;
            letter-spacing: .04em;
        }
        .board-col-header.cooking { background: rgba(249,115,22,.2); color: #fdba74; }
        .board-col-header.ready   { background: rgba(34,197,94,.2);  color: #86efac; }

        .board-card {
            background: var(--card);
            border-radius: var(--radius);
            padding: 18px 20px;
            box-shadow: 0 4px 16px rgba(0,0,0,.3);
        }
        .board-card.cooking-card { border-left: 4px solid #f97316; }
        .board-card.ready-card   { border-left: 4px solid #22c55e; }

        .bc-id     { font-size: 20px; font-weight: 900; color: var(--green); margin-bottom: 4px; }
        .bc-items  { font-size: 13px; color: var(--sub); margin: 6px 0 10px; }
        .bc-status {
            display: inline-block;
            padding: 5px 14px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 800;
            text-transform: uppercase;
        }
        .bc-status.cooking { background: rgba(249,115,22,.2); color: #fdba74; }
        .bc-status.ready   { background: rgba(34,197,94,.2);  color: #86efac; }

        .board-empty {
            background: var(--card);
            border-radius: var(--radius);
            padding: 28px;
            text-align: center;
            color: var(--sub);
            font-size: 14px;
        }

        /* ── История заказов ── */
        .history-section {
            background: var(--card);
            border-radius: var(--radius);
            overflow-x: auto;
        }
        .history-header {
            padding: 16px 20px;
            font-size: 16px;
            font-weight: 700;
            border-bottom: 1px solid var(--border);
        }
        .history-table {
            width: 100%;
            border-collapse: collapse;
        }
        .history-table th, .history-table td {
            padding: 11px 16px;
            text-align: left;
            border-bottom: 1px solid var(--border);
            font-size: 13px;
        }
        .history-table th {
            font-weight: 700;
            color: var(--sub);
            text-transform: uppercase;
            font-size: 11px;
            background: var(--card2);
        }
        .history-table tbody tr:last-child td { border-bottom: none; }
        .history-table tbody tr:hover { background: rgba(255,255,255,.03); }
    </style>
</head>
<body>

<jsp:include page="/WEB-INF/views/fragments/navbar.jsp"/>

<div class="page-wrapper">

    <%-- Приветствие --%>
    <div class="board-hero">
        <div class="board-hero-left">
            <h2>👋 Привет, <%= clientName %>!</h2>
            <p>Здесь вы можете следить за статусом ваших заказов в реальном времени</p>
        </div>
        <div>
            <a class="btn primary" href="<%= ctx %>/orders">+ Новый заказ</a>
        </div>
    </div>

    <%-- Авто-обновление --%>
    <p class="board-refresh-hint" style="margin-bottom:20px;">
        🔄 Страница обновляется автоматически каждые 10 секунд
        &nbsp;·&nbsp;
        <a href="<%= ctx %>/board" style="color:var(--green);">Обновить сейчас</a>
    </p>

    <%-- Если нет активных заказов --%>
    <% if (cookingOrders.isEmpty() && readyOrders.isEmpty()) { %>
    <div class="board-empty" style="margin-bottom:24px;">
        <div style="font-size:40px;margin-bottom:12px;">🍽️</div>
        <div style="font-size:16px;font-weight:700;margin-bottom:6px;">Нет активных заказов</div>
        <div style="font-size:13px;">
            <a href="<%= ctx %>/orders" style="color:var(--green);text-decoration:underline;">
                Сделать заказ →
            </a>
        </div>
    </div>
    <% } else { %>

    <%-- Табло двух колонок --%>
    <div class="board-grid">

        <%-- Колонка ГОТОВИТСЯ --%>
        <div class="board-col">
            <div class="board-col-header cooking">🍳 ГОТОВИТСЯ</div>

            <% if (cookingOrders.isEmpty()) { %>
            <div class="board-empty">Нет заказов в приготовлении</div>
            <% } else {
                for (Order o : cookingOrders) {
                    StringBuilder sb = new StringBuilder();
                    List<OrderItem> its = (o.getItems() != null) ? o.getItems() : Collections.emptyList();
                    for (OrderItem it : its) {
                        if (sb.length() > 0) sb.append(", ");
                        String mn = (it.getMenuItem() != null && it.getMenuItem().getName() != null)
                                ? it.getMenuItem().getName() : "?";
                        sb.append(mn).append(" ×").append(it.getQuantity());
                    }
                    double total = 0;
                    try { total = o.getTotalAmount(); } catch (Exception ignored) {}

                    String stName = o.getStatus() != null ? o.getStatus().name() : "PENDING";
                    String stLabel;
                    switch (stName) {
                        case "PENDING":   stLabel = "⏳ Принимается"; break;
                        case "CONFIRMED": stLabel = "✅ Принят";      break;
                        case "PREPARING": stLabel = "🍳 Готовится";   break;
                        default:          stLabel = stName;
                    }
            %>
            <div class="board-card cooking-card">
                <div class="bc-id">#<%= o.getId() %></div>
                <div class="bc-items"><%= sb.length() > 0 ? sb.toString() : "—" %></div>
                <div style="display:flex;justify-content:space-between;align-items:center;">
                    <span class="bc-status cooking"><%= stLabel %></span>
                    <span style="font-size:13px;color:var(--sub);font-weight:700;">
                        <%= (int) total %> ₸
                    </span>
                </div>
            </div>
            <% }} %>
        </div>

        <%-- Колонка ГОТОВ --%>
        <div class="board-col">
            <div class="board-col-header ready">✅ ГОТОВ — ЗАБЕРИТЕ!</div>

            <% if (readyOrders.isEmpty()) { %>
            <div class="board-empty">Готовых заказов пока нет</div>
            <% } else {
                for (Order o : readyOrders) {
                    StringBuilder sb = new StringBuilder();
                    List<OrderItem> its = (o.getItems() != null) ? o.getItems() : Collections.emptyList();
                    for (OrderItem it : its) {
                        if (sb.length() > 0) sb.append(", ");
                        String mn = (it.getMenuItem() != null && it.getMenuItem().getName() != null)
                                ? it.getMenuItem().getName() : "?";
                        sb.append(mn).append(" ×").append(it.getQuantity());
                    }
                    double total = 0;
                    try { total = o.getTotalAmount(); } catch (Exception ignored) {}
            %>
            <div class="board-card ready-card">
                <div class="bc-id">#<%= o.getId() %></div>
                <div class="bc-items"><%= sb.length() > 0 ? sb.toString() : "—" %></div>
                <div style="display:flex;justify-content:space-between;align-items:center;">
                    <span class="bc-status ready">✅ Заберите!</span>
                    <span style="font-size:13px;color:var(--sub);font-weight:700;">
                        <%= (int) total %> ₸
                    </span>
                </div>
            </div>
            <% }} %>
        </div>

    </div>
    <% } %>

    <%-- История всех заказов --%>
    <% if (!allOrders.isEmpty()) { %>
    <div class="history-section">
        <div class="history-header">📋 История заказов</div>
        <table class="history-table">
            <thead>
            <tr>
                <th>№</th>
                <th>Позиции</th>
                <th>Сумма</th>
                <th>Статус</th>
                <th>Время</th>
            </tr>
            </thead>
            <tbody>
            <% for (Order o : allOrders) {
                StringBuilder sb = new StringBuilder();
                List<OrderItem> its = (o.getItems() != null) ? o.getItems() : Collections.emptyList();
                for (OrderItem it : its) {
                    if (sb.length() > 0) sb.append(", ");
                    String mn = (it.getMenuItem() != null && it.getMenuItem().getName() != null)
                            ? it.getMenuItem().getName() : "?";
                    sb.append(mn).append(" ×").append(it.getQuantity());
                }
                double total = 0;
                try { total = o.getTotalAmount(); } catch (Exception ignored) {}

                String st = (o.getStatus() != null) ? o.getStatus().name() : "PENDING";
                String dtStr = "";
                if (o.getCreatedAt() != null) {
                    String raw = o.getCreatedAt().toString().replace("T", " ");
                    dtStr = raw.length() >= 16 ? raw.substring(0, 16) : raw;
                }
            %>
            <tr>
                <td><strong>#<%= o.getId() %></strong></td>
                <td><%= sb.length() > 0 ? sb.toString() : "—" %></td>
                <td><%= (int) total %> ₸</td>
                <td><span class="status-badge st-<%= st.toLowerCase() %>"><%= st %></span></td>
                <td style="color:var(--sub);"><%= dtStr %></td>
            </tr>
            <% } %>
            </tbody>
        </table>
    </div>
    <% } %>

</div>
</body>
</html>


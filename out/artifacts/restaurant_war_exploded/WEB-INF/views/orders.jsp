<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, com.gauhar.restaurant.model.*" %>
<%
    String ctx = request.getContextPath();

    User currentUser = (User) session.getAttribute("currentUser");
    boolean isAdmin = currentUser != null && "ADMIN".equals(currentUser.getRole());

    // Spring MVC кладёт restaurant через @ModelAttribute в request
    Restaurant r = (Restaurant) request.getAttribute("restaurant");
    String restaurantName = (r != null && r.getName() != null && !r.getName().isBlank())
            ? r.getName() : "Gauhar Restaurant";

    List<MenuItem> menuItems = (List<MenuItem>) request.getAttribute("menuItems");
    List<Order> orders = (List<Order>) request.getAttribute("orders");
    if (menuItems == null) menuItems = new ArrayList<>();
    if (orders == null) orders = new ArrayList<>();

    String ok  = (String) session.getAttribute("flash_success");
    String err = (String) session.getAttribute("flash_error");
    session.removeAttribute("flash_success");
    session.removeAttribute("flash_error");

    boolean hasAvailable = false;
    for (MenuItem mi : menuItems) {
        if (mi != null && mi.isAvailable()) {
            hasAvailable = true;
            break;
        }
    }
%>
<!doctype html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Заказы — <%= restaurantName %></title>
    <link rel="stylesheet" href="<%= ctx %>/styles.css">
</head>
<body>

<jsp:include page="/WEB-INF/views/fragments/navbar.jsp"/>

<div class="page-wrapper">
    <div class="page-header-bar">
        <div class="page-title"><%= isAdmin ? "Все заказы" : "Мои заказы" %></div>
    </div>

    <% if (ok != null) { %><div class="toast success"><%= ok %></div><% } %>
    <% if (err != null) { %><div class="toast error"><%= err %></div><% } %>

    <div class="form-card" style="margin-bottom:24px">
        <h3 class="section-title">Оформить заказ</h3>
        <form method="post" action="<%= ctx %>/orders">
            <div class="order-form-grid">
                <div class="form-row">
                    <input name="customerName" required placeholder="Имя клиента">
                </div>
                <div class="form-row">
                    <input name="phone" placeholder="Телефон">
                </div>
                <div class="form-row">
                    <select name="menuItemId" <%= hasAvailable ? "" : "disabled" %> required>
                        <% if (!hasAvailable) { %>
                        <option value="" selected>Нет доступных блюд</option>
                        <% } else { for (MenuItem m : menuItems) {
                            if (m == null || !m.isAvailable()) continue; %>
                        <option value="<%= m.getId() %>"><%= m.getName() %> - <%= (int)m.getPrice() %> ₸</option>
                        <% }} %>
                    </select>
                </div>
                <div class="form-row">
                    <input name="quantity" type="number" min="1" value="1" required <%= hasAvailable ? "" : "disabled" %>>
                </div>
            </div>
            <button class="btn primary" type="submit" <%= hasAvailable ? "" : "disabled" %>>Оформить</button>
        </form>
    </div>

    <div class="orders-table-wrap">
        <table class="orders-table">
            <thead>
            <tr>
                <th>ID</th><th>Клиент</th><th>Телефон</th><th>Позиции</th>
                <th>Сумма</th><th>Статус</th><th>Создан</th>
                <% if (isAdmin) { %><th>Изменить статус</th><% } %>
            </tr>
            </thead>
            <tbody>
            <% if (orders.isEmpty()) { %>
            <tr><td colspan="<%= isAdmin ? 8 : 7 %>" class="empty-td">Заказов пока нет</td></tr>
            <% } else { for (Order o : orders) {
                if (o == null) continue;
                StringBuilder sb = new StringBuilder();
                List<OrderItem> its = (o.getItems() != null) ? o.getItems() : Collections.emptyList();
                for (OrderItem it : its) {
                    if (sb.length() > 0) sb.append(", ");
                    String itemName = (it.getMenuItem() != null && it.getMenuItem().getName() != null)
                            ? it.getMenuItem().getName() : "?";
                    sb.append(itemName).append(" x").append(it.getQuantity());
                }
                String st = (o.getStatus() != null) ? o.getStatus().name() : "PENDING";
                String dtStr = "";
                if (o.getCreatedAt() != null) {
                    String raw = o.getCreatedAt().toString().replace("T", " ");
                    dtStr = raw.length() >= 16 ? raw.substring(0, 16) : raw;
                }
                double total = 0;
                try { total = o.getTotalAmount(); } catch (Exception ignored) {}
            %>
            <tr>
                <td>#<%= o.getId() %></td>
                <td><%= o.getCustomerName() %></td>
                <td><%= (o.getPhone() != null) ? o.getPhone() : "" %></td>
                <td><%= sb.toString() %></td>
                <td><%= (int) total %> ₸</td>
                <td><span class="status-badge st-<%= st.toLowerCase() %>"><%= st %></span></td>
                <td><%= dtStr %></td>
                <% if (isAdmin) { %>
                <td>
                    <div class="actions-inline">
                        <% if ("PENDING".equals(st)) { %>
                        <form method="post" action="<%= ctx %>/orders/status" style="display:inline">
                            <input type="hidden" name="id" value="<%= o.getId() %>">
                            <input type="hidden" name="status" value="CONFIRMED">
                            <button class="btn small ok-btn" type="submit">✔ Принять</button>
                        </form>
                        <% } else if ("CONFIRMED".equals(st)) { %>
                        <form method="post" action="<%= ctx %>/orders/status" style="display:inline">
                            <input type="hidden" name="id" value="<%= o.getId() %>">
                            <input type="hidden" name="status" value="PREPARING">
                            <button class="btn small warn" type="submit">🍳 Готовить</button>
                        </form>
                        <% } else if ("PREPARING".equals(st)) { %>
                        <form method="post" action="<%= ctx %>/orders/status" style="display:inline">
                            <input type="hidden" name="id" value="<%= o.getId() %>">
                            <input type="hidden" name="status" value="READY">
                            <button class="btn small info" type="submit">✅ Готов</button>
                        </form>
                        <% } else if ("READY".equals(st)) { %>
                        <form method="post" action="<%= ctx %>/orders/status" style="display:inline">
                            <input type="hidden" name="id" value="<%= o.getId() %>">
                            <input type="hidden" name="status" value="DONE">
                            <button class="btn small ghost" type="submit">🏁 Выдан</button>
                        </form>
                        <% } %>
                        <% if (!"CANCELLED".equals(st) && !"DONE".equals(st)) { %>
                        <form method="post" action="<%= ctx %>/orders/status" style="display:inline">
                            <input type="hidden" name="id" value="<%= o.getId() %>">
                            <input type="hidden" name="status" value="CANCELLED">
                            <button class="btn small danger" type="submit">✖ Отмена</button>
                        </form>
                        <% } %>
                    </div>
                </td>
                <% } %>
            </tr>
            <% }} %>
            </tbody>
        </table>
    </div>
</div>

</body>
</html>


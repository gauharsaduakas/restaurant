<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, com.gauhar.restaurant.model.MenuItem, com.gauhar.restaurant.model.Restaurant" %>
<%@ page import="org.springframework.security.core.Authentication" %>
<%@ page import="org.springframework.security.core.context.SecurityContextHolder" %>
<%@ page import="org.springframework.security.core.GrantedAuthority" %>
<%
    String ctx = request.getContextPath(); // Получаем контекст один раз

    Restaurant _r = (Restaurant) request.getAttribute("restaurant");
    String restaurantName = (_r != null && _r.getName() != null && !_r.getName().isBlank()) ? _r.getName() : "Gauhar Restaurant";

    List<MenuItem> items = (List<MenuItem>) request.getAttribute("items");
    if (items == null) items = new ArrayList<>();

    Authentication _auth = SecurityContextHolder.getContext().getAuthentication();
    String currentRole = (_auth != null && _auth.isAuthenticated())
            ? _auth.getAuthorities().stream()
            .map(GrantedAuthority::getAuthority)
            .filter(a -> a.startsWith("ROLE_"))
            .map(a -> a.substring(5))
            .findFirst().orElse("")
            : "";
    boolean isAdmin = "ADMIN".equals(currentRole);

    request.setAttribute("navRestaurantName", restaurantName);
    request.setAttribute("navActivePage", "menu");
%>
<!doctype html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Меню — <%= restaurantName %></title>
    <link rel="stylesheet" href="<%= ctx %>/styles.css">
    <style>
        .options-box { background: #1e1e1e; border-radius: 8px; padding: 10px; margin: 10px 0; font-size: 13px; }
        .options-box label { display: flex; align-items: center; gap: 8px; padding: 4px 0; cursor: pointer; color: #ccc; }
        .qty-row { display: flex; align-items: center; gap: 8px; margin: 8px 0; }
        .qty-row input { width: 55px; padding: 4px; border-radius: 6px; border: 1px solid #444; background: #2a2a2a; color: #fff; text-align: center; }
        .menu-img img { width: 100%; height: 180px; object-fit: cover; border-radius: 8px 8px 0 0; }
    </style>
</head>
<body>

<jsp:include page="includes/navbar.jsp" />

<div class="page-wrapper">
    <div class="page-header-bar">
        <div class="page-title">Меню</div>
    </div>

    <jsp:include page="includes/flash.jsp" />

    <% if (isAdmin) { %>
    <div class="toolbar">
        <a class="btn primary" href="<%= ctx %>/menu-items/new">+ Добавить блюдо</a>
    </div>
    <% } %>

    <div class="menu-grid">
        <% for (MenuItem m : items) {
            if (m == null) continue;
            String title = (m.getName() != null) ? m.getName() : "Без названия";
            String cat = (m.getCategory() != null) ? m.getCategory() : "";
            String catLower = cat.toLowerCase();

            // Исправленная логика формирования пути к картинке
            String imgPath = m.getImageUrl(); // или getImagePath(), проверьте имя метода в вашей модели
            String finalSrc;

            if (imgPath == null || imgPath.isBlank()) {
                finalSrc = ctx + "/static/images/placeholder.png";
            } else if (imgPath.startsWith("http")) {
                finalSrc = imgPath;
            } else {
                // Если в базе лежит "burger.jpg", путь станет "/restaurant/images/burger.jpg"
                // Проверьте, что в WebConfig у вас маппинг на /images/**
                finalSrc = ctx + "/images/" + imgPath;
            }
        %>
        <div class="menu-card">
            <div class="menu-img">
                <img src="<%= finalSrc %>" alt="<%= title %>" onerror="this.src='<%= ctx %>/static/images/placeholder.png'">
            </div>
            <div class="menu-body">
                <h3><%= title %></h3>
                <div class="menu-category"><%= cat.isEmpty() ? "Без категории" : cat %></div>
                <div class="menu-row">
                    <span class="menu-price"><%= (int) m.getPrice() %> ₸</span>
                    <span class="menu-badge <%= m.isAvailable() ? "ok" : "no" %>">
                        <%= m.isAvailable() ? "В наличии" : "Нет" %>
                    </span>
                </div>

                <div class="menu-actions">
                    <% if (isAdmin) { %>
                    <div style="display: flex; gap: 5px;">
                        <a class="btn small ghost" href="<%= ctx %>/menu-items/edit?id=<%= m.getId() %>">✏️</a>
                        <form method="post" action="<%= ctx %>/menu-items/delete" style="display:inline">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                            <input type="hidden" name="id" value="<%= m.getId() %>">
                            <button class="btn small danger" type="submit" onclick="return confirm('Удалить?')">🗑</button>
                        </form>
                    </div>
                    <% } else if (m.isAvailable()) { %>
                    <form method="post" action="<%= ctx %>/cart/add">
                        <%-- Важно: CSRF токен для безопасности --%>
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                        <input type="hidden" name="menuItemId" value="<%= m.getId() %>">

                        <% if (catLower.contains("пицц")) { %>
                        <div class="options-box">
                            <label><input type="checkbox" name="options" value="cheese"> +Сыр</label>
                            <label><input type="checkbox" name="options" value="mushrooms"> +Грибы</label>
                        </div>
                        <% } else if (catLower.contains("бургер")) { %>
                        <div class="options-box">
                            <label><input type="checkbox" name="options" value="patty"> +Котлета</label>
                            <label><input type="checkbox" name="options" value="sauce"> +Соус</label>
                        </div>
                        <% } %>

                        <div class="qty-row">
                            <input type="number" name="quantity" value="1" min="1">
                            <button type="submit" class="btn small primary">🛒 В корзину</button>
                        </div>
                    </form>
                    <% } else { %>
                    <span style="color:#888;">Недоступно</span>
                    <% } %>
                </div>
            </div>
        </div>
        <% } %>
    </div>
</div>

<jsp:include page="includes/footer.jsp" />
</body>
</html>
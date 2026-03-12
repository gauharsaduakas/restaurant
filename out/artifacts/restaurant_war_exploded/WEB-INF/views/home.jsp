<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.gauhar.restaurant.model.Restaurant" %>
<%@ page import="com.gauhar.restaurant.model.User" %>
<%
    String ctx = request.getContextPath();

    Restaurant r = (Restaurant) request.getAttribute("restaurant");
    User currentUser = (User) session.getAttribute("currentUser");

    boolean isAdmin = currentUser != null && "ADMIN".equals(currentUser.getRole());
    boolean isClient = currentUser != null && "CLIENT".equals(currentUser.getRole());

    String name = (r != null && r.getName() != null && !r.getName().isBlank())
            ? r.getName() : "Gauhar Restaurant";
    String address = (r != null && r.getAddress() != null && !r.getAddress().isBlank())
            ? r.getAddress() : "Astana, Kabanbay Batyr 53";
    String phone = (r != null && r.getPhone() != null && !r.getPhone().isBlank())
            ? r.getPhone() : "+7 700 000 00 00";
    String workHours = (r != null && r.getWorkHours() != null && !r.getWorkHours().isBlank())
            ? r.getWorkHours() : "10:00 – 23:00";
%>
<!doctype html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title><%= name %></title>
    <link rel="stylesheet" href="<%= ctx %>/styles.css">
</head>
<body>

<jsp:include page="/WEB-INF/views/fragments/navbar.jsp"/>

<div class="home-hero">
    <div class="hero-logo">🎍</div>
    <h1 class="hero-title"><%= name %></h1>
    <p class="hero-sub">Cafe &amp; Restaurant · Вкусная Европейская и Азиатская кухня</p>

    <div class="hero-tags">
        <span class="hero-tag">🍔 Бургеры</span>
        <span class="hero-tag">🍕 Пицца</span>
        <span class="hero-tag">☕ Кофе</span>
        <span class="hero-tag">🍰 Десерты</span>
    </div>

    <div class="hero-btns">
        <% if (isAdmin) { %>
        <a class="btn primary large" href="<%= ctx %>/menu-items">📋 Управление меню</a>
        <a class="btn ghost large" href="<%= ctx %>/orders">🧾 Все заказы</a>
        <a class="btn ghost large" href="<%= ctx %>/kitchen">👨‍🍳 Кухня</a>
        <a class="btn ghost large" href="<%= ctx %>/restaurant">🏢 О ресторане</a>
        <% } else if (isClient) { %>
        <a class="btn primary large" href="<%= ctx %>/menu-items">📋 Меню</a>
        <a class="btn ghost large" href="<%= ctx %>/orders">🧾 Мои заказы</a>
        <a class="btn ghost large" href="<%= ctx %>/board">📺 Табло</a>
        <% } else { %>
        <a class="btn primary large" href="<%= ctx %>/login">Войти</a>
        <a class="btn ghost large" href="<%= ctx %>/register">Регистрация</a>
        <% } %>
    </div>
</div>

<div class="home-info-grid">
    <div class="info-card">
        <span class="info-icon">📍</span>
        <div>
            <div class="info-label">Адрес</div>
            <div class="info-value"><%= address %></div>
        </div>
    </div>

    <div class="info-card">
        <span class="info-icon">🕐</span>
        <div>
            <div class="info-label">Режим работы</div>
            <div class="info-value"><%= workHours %></div>
        </div>
    </div>

    <div class="info-card">
        <span class="info-icon">📞</span>
        <div>
            <div class="info-label">Контакты</div>
            <div class="info-value"><%= phone %></div>
        </div>
    </div>

    <div class="info-card">
        <span class="info-icon">👨‍🍳</span>
        <div>
            <div class="info-label">Кухня</div>
            <div class="info-value">
                <% if (isAdmin) { %>
                <a class="link" href="<%= ctx %>/kitchen">Табло кухни</a>
                <% } else { %>
                <a class="link" href="<%= ctx %>/board">Статус заказов</a>
                <% } %>
            </div>
        </div>
    </div>
</div>

</body>
</html>
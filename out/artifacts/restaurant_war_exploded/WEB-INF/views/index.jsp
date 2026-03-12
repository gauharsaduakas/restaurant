<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.gauhar.restaurant.model.Restaurant" %>
<%
    String ctx = request.getContextPath();

    // Spring MVC кладёт restaurant через @ModelAttribute (GlobalModelAdvice) в request
    Restaurant r = (Restaurant) request.getAttribute("restaurant");

    String name      = (r != null && r.getName() != null && !r.getName().isBlank()) ? r.getName() : "Gauhar Restaurant";
    String address   = (r != null && r.getAddress() != null && !r.getAddress().isBlank()) ? r.getAddress() : "Astana, Kabanbay Batyr 53";
    String phone     = (r != null && r.getPhone() != null && !r.getPhone().isBlank()) ? r.getPhone() : "+7 700 000 00 00";
    String workHours = (r != null && r.getWorkHours() != null && !r.getWorkHours().isBlank()) ? r.getWorkHours() : "10:00 – 23:00";
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
    <p class="hero-sub">Cafe &amp; Restaurant · Вкусная Европейская Азиатская кухня</p>

    <div class="hero-tags">
        <span class="hero-tag">🍔 Бургеры</span>
        <span class="hero-tag">🍕 Пицца</span>
        <span class="hero-tag">☕ Кофе</span>
        <span class="hero-tag">🍰 Десерты</span>
    </div>

    <div class="hero-btns">
        <a class="btn primary large" href="<%= ctx %>/menu-items">📋 Меню</a>
        <a class="btn ghost large" href="<%= ctx %>/orders">🧾 Заказы</a>
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
                <a class="link" href="<%= ctx %>/kitchen">Табло кухни</a>
            </div>
        </div>
    </div>
</div>

</body>
</html>


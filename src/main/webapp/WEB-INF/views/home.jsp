<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.gauhar.restaurant.model.Restaurant" %>
<%@ page import="org.springframework.security.core.Authentication" %>
<%@ page import="org.springframework.security.core.context.SecurityContextHolder" %>
<%@ page import="org.springframework.security.core.GrantedAuthority" %>
<%
    Restaurant r = (Restaurant) request.getAttribute("restaurant");
    if (r == null) {
        r = new Restaurant();
    }

    Authentication _auth = SecurityContextHolder.getContext().getAuthentication();
    String currentRole = (_auth != null && _auth.isAuthenticated())
            ? _auth.getAuthorities().stream()
            .map(GrantedAuthority::getAuthority)
            .filter(a -> a.startsWith("ROLE_"))
            .map(a -> a.substring(5))
            .findFirst().orElse("")
            : "";
    boolean isAdmin  = "ADMIN".equals(currentRole);
    String userName = (_auth != null) ? _auth.getName() : "Пользователь";

    String name      = (r.getName()      != null && !r.getName().isBlank())      ? r.getName()      : "🎍 Ресторан";
    String address   = (r.getAddress()   != null && !r.getAddress().isBlank())   ? r.getAddress()   : "Astana, Kabanbay Batyr 53";
    String phone     = (r.getPhone()     != null && !r.getPhone().isBlank())     ? r.getPhone()     : "+7 700 000 00 00";
    String workHours = (r.getWorkHours() != null && !r.getWorkHours().isBlank()) ? r.getWorkHours() : "10:00 – 23:00";

    request.setAttribute("navRestaurantName", name);
    request.setAttribute("navActivePage", "home");
%>
<!doctype html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title><%= name %></title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles.css">
</head>
<body>

<jsp:include page="includes/navbar.jsp" />

<div class="home-hero">
    <div class="hero-logo">🎍</div>
    <h1 class="hero-title"><%= name %></h1>
    <p class="hero-sub">
        Здравствуйте, <strong><%= userName %></strong> · Роль: <strong><%= currentRole %></strong>
    </p>

    <div class="hero-tags">
        <span class="hero-tag">🍔 Бургеры</span>
        <span class="hero-tag">🍕 Пицца</span>
        <span class="hero-tag">☕ Кофе</span>
        <span class="hero-tag">🍰 Десерты</span>
    </div>

    <div class="hero-btns">
        <% if (isAdmin) { %>
        <a class="btn primary large" href="${pageContext.request.contextPath}/menu-items">📋 Управлять меню</a>
        <a class="btn ghost large" href="${pageContext.request.contextPath}/orders">🧾 Управлять заказами</a>
        <% } else { %>
        <a class="btn primary large" href="${pageContext.request.contextPath}/menu-items">🍕 Перейти в меню</a>
        <a class="btn ghost large" href="${pageContext.request.contextPath}/cart">🛒 Моя корзина</a>
        <a class="btn ghost large" href="${pageContext.request.contextPath}/profile">👤 Мой профиль</a>
        <% } %>
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
                    <a class="link" href="${pageContext.request.contextPath}/kitchen">Табло кухни</a>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>
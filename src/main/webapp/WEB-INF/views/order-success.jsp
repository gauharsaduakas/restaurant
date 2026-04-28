<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="org.springframework.security.core.Authentication" %>
<%@ page import="org.springframework.security.core.context.SecurityContextHolder" %>
<%
    Authentication auth = SecurityContextHolder.getContext().getAuthentication();
    String userName = (auth != null) ? auth.getName() : "Пользователь";
%>

<!doctype html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Заказ принят</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles.css">
    <style>
        .success-box {
            text-align: center;
            padding: 60px 20px;
        }
        .success-icon {
            font-size: 80px;
            margin-bottom: 20px;
            animation: bounce 0.6s;
        }
        @keyframes bounce {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-20px); }
        }
        .success-title {
            font-size: 32px;
            font-weight: bold;
            color: #2ecc71;
            margin-bottom: 10px;
        }
        .success-text {
            font-size: 16px;
            color: #666;
            margin-bottom: 30px;
            max-width: 500px;
            margin-left: auto;
            margin-right: auto;
        }
        .success-actions {
            display: flex;
            gap: 15px;
            justify-content: center;
            flex-wrap: wrap;
        }
    </style>
</head>

<body>

<div class="navbar">
    <div class="nav-inner">
        <a class="brand" href="${pageContext.request.contextPath}/home">🎍 Ресторан</a>
        <div class="nav-links">
            <a class="nav-link" href="${pageContext.request.contextPath}/home">Главная</a>
            <a class="nav-link" href="${pageContext.request.contextPath}/menu-items">Меню</a>
            <a class="nav-link" href="${pageContext.request.contextPath}/cart">🛒 Корзина</a>
            <a class="nav-link" href="${pageContext.request.contextPath}/my-orders">📋 Мои заказы</a>
            <a class="nav-link" href="${pageContext.request.contextPath}/logout">🚪 Выход</a>
        </div>
    </div>
</div>

<div class="page-wrapper">
    <div class="success-box">
        <div class="success-icon">✅</div>
        <div class="success-title">Заказ успешно принят!</div>
        <div class="success-text">
            Спасибо за ваш заказ, <strong><%= userName %></strong>!<br>
            Вы скоро получите уведомление о статусе приготовления.
        </div>

        <div class="success-actions">
            <a href="${pageContext.request.contextPath}/menu-items" class="btn primary">📋 Продолжить покупки</a>
            <a href="${pageContext.request.contextPath}/my-orders" class="btn ghost">📦 Мои заказы</a>
        </div>
    </div>
</div>

</body>
</html>

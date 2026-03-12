<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.gauhar.restaurant.model.Restaurant" %>
<%
    com.gauhar.restaurant.model.Restaurant _rLogin = (com.gauhar.restaurant.model.Restaurant) request.getAttribute("restaurant");
    String restaurantName = (_rLogin != null && _rLogin.getName() != null && !_rLogin.getName().isBlank()) ? _rLogin.getName() : "Gauhar Restaurant";
%>
<!doctype html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Вход — <%= restaurantName %></title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles.css">
</head>
<body>
<div style="min-height:100vh;display:flex;align-items:center;justify-content:center;padding:24px;">
    <div class="form-card" style="width:100%;max-width:420px;">
        <div style="text-align:center;margin-bottom:28px;">
            <div style="font-size:48px;margin-bottom:12px;">🎍</div>
            <h1 style="font-size:22px;font-weight:800;color:var(--green);margin-bottom:4px;"><%= restaurantName %></h1>
            <p style="color:var(--sub);font-size:13px;">Вход для администратора и клиента</p>
        </div>

        <%
            String error = (String) request.getAttribute("error");
            if (error == null) {
                error = (String) session.getAttribute("flash_error");
                session.removeAttribute("flash_error");
            }
        %>

        <% if (error != null) { %>
        <div class="toast error" style="margin-bottom:16px;">❌ <%= error %></div>
        <% } %>

        <% if (request.getParameter("registered") != null) { %>
        <div class="toast success" style="margin-bottom:16px;">✅ Аккаунт клиента создан. Войдите.</div>
        <% } %>

        <form method="post" action="${pageContext.request.contextPath}/login">
            <div class="form-row">
                <input type="email" name="email" placeholder="Email" required autofocus>
            </div>
            <div class="form-row">
                <input type="password" name="password" placeholder="Пароль" required>
            </div>
            <input type="hidden" name="selectedRole" value="ANY">
            <button class="btn primary full-width" type="submit">Войти</button>
        </form>

        <div style="margin-top:20px;text-align:center;color:var(--sub);font-size:13px;">
            Нет аккаунта?
            <a href="${pageContext.request.contextPath}/register" style="color:var(--green);text-decoration:underline;">
                Зарегистрироваться как клиент
            </a>
        </div>
    </div>
</div>
</body>
</html>
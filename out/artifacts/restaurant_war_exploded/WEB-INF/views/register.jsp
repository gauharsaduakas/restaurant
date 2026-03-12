<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Регистрация — Gauhar Restaurant</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles.css">
</head>
<body>

<div style="min-height:100vh;display:flex;align-items:center;justify-content:center;padding:24px;">
    <div class="form-card" style="width:100%;max-width:420px;">

        <div style="text-align:center;margin-bottom:28px;">
            <div style="font-size:48px;margin-bottom:12px;">🎍</div>
            <h1 style="font-size:22px;font-weight:800;color:var(--green);margin-bottom:4px;">Gauhar Restaurant</h1>
            <p style="color:var(--sub);font-size:13px;">Создайте аккаунт</p>
        </div>

        <%
            String error = (String) request.getAttribute("error");
        %>
        <% if (error != null) { %>
        <div class="toast error" style="margin-bottom:16px;"><%= error %></div>
        <% } %>

        <form method="post" action="${pageContext.request.contextPath}/register">
            <div class="form-row">
                <input type="text" name="fullName" placeholder="Ваше имя" required autofocus>
            </div>
            <div class="form-row">
                <input type="email" name="email" placeholder="Email" required>
            </div>
            <div class="form-row">
                <input type="password" name="password" placeholder="Пароль" required>
            </div>
            <button class="btn primary full-width" type="submit">Зарегистрироваться</button>
        </form>

        <div style="margin-top:20px;text-align:center;color:var(--sub);font-size:13px;">
            Уже есть аккаунт?
            <a href="${pageContext.request.contextPath}/login"
               style="color:var(--green);text-decoration:underline;">Войти</a>
        </div>
    </div>
</div>

</body>
</html>
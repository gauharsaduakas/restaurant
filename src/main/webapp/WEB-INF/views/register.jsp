<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!doctype html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Регистрация — Coffito Kitchen</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles.css">
</head>
<body>
<div style="min-height:100vh;display:flex;align-items:center;justify-content:center;padding:24px;">
    <div class="form-card" style="width:100%;max-width:420px;">
        <div style="text-align:center;margin-bottom:28px;">
            <div style="font-size:48px;margin-bottom:12px;">🍷</div>
            <h1 style="font-size:22px;font-weight:800;color:#d4a574;margin-bottom:4px;">Coffito Kitchen</h1>
            <p style="color:#888;font-size:13px;">Создайте аккаунт для заказов</p>
        </div>

        <!-- Ошибки валидации -->
        <c:if test="${error != null}">
            <div class="alert alert-danger" style="margin-bottom:16px;padding:12px;background:#fee;border:1px solid #fcc;border-radius:4px;color:#c00;">
                ❌ ${error}
            </div>
        </c:if>

        <form method="post" action="${pageContext.request.contextPath}/register">
            <div class="form-row">
                <label for="fullName">Ваше имя:</label>
                <input type="text" id="fullName" name="fullName" placeholder="Иван Иванов" required autofocus>
            </div>
            <div class="form-row">
                <label for="email">Email:</label>
                <input type="email" id="email" name="email" placeholder="your@email.com" required>
            </div>
            <div class="form-row">
                <label for="password">Пароль:</label>
                <input type="password" id="password" name="password" placeholder="Минимум 6 символов" required>
            </div>
            <div class="form-row">
                <label for="passwordConfirm">Подтвердите пароль:</label>
                <input type="password" id="passwordConfirm" name="passwordConfirm" placeholder="Повторите пароль" required>
            </div>

            <button class="btn primary full-width" type="submit" style="padding:12px;background:#d4a574;color:white;border:none;border-radius:4px;cursor:pointer;font-weight:600;">
                Создать аккаунт
            </button>
        </form>

        <div style="margin-top:20px;text-align:center;color:#888;font-size:13px;">
            Уже есть аккаунт?
            <a href="${pageContext.request.contextPath}/login" style="color:#d4a574;text-decoration:none;font-weight:600;">
                Войти
            </a>
        </div>
    </div>
</div>
</body>
</html>
</html>

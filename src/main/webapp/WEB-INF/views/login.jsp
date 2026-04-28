<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!doctype html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Вход — Coffito Kitchen</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles.css">
</head>
<body>
<div style="min-height:100vh;display:flex;align-items:center;justify-content:center;padding:24px;">
    <div class="form-card" style="width:100%;max-width:420px;">
        <div style="text-align:center;margin-bottom:28px;">
            <div style="font-size:48px;margin-bottom:12px;">🍷</div>
            <h1 style="font-size:22px;font-weight:800;color:#d4a574;margin-bottom:4px;">Coffito Kitchen</h1>
            <p style="color:#888;font-size:13px;">Вход в систему</p>
        </div>

        <c:if test="${param.error != null}">
            <div class="alert alert-danger"
                 style="margin-bottom:16px;padding:12px;background:#fee;border:1px solid #fcc;border-radius:4px;color:#c00;">
                ❌ Неверные учетные данные
            </div>
        </c:if>

        <c:if test="${param.logout != null}">
            <div class="alert alert-success"
                 style="margin-bottom:16px;padding:12px;background:#efe;border:1px solid #cfc;border-radius:4px;color:#080;">
                ✅ Вы вышли из системы
            </div>
        </c:if>

        <c:if test="${param.registered != null}">
            <div class="alert alert-success"
                 style="margin-bottom:16px;padding:12px;background:#efe;border:1px solid #cfc;border-radius:4px;color:#080;">
                ✅ Регистрация успешна. Войдите в систему.
            </div>
        </c:if>

        <form method="post" action="${pageContext.request.contextPath}/login">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

            <div class="form-row" style="margin-bottom: 15px;">
                <label for="username" style="display: block; margin-bottom: 5px;">Email:</label>
                <input type="email" id="username" name="username" placeholder="your@email.com"
                       style="width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 4px;" required
                       autofocus>
            </div>

            <div class="form-row" style="margin-bottom: 20px;">
                <label for="password" style="display: block; margin-bottom: 5px;">Пароль:</label>
                <input type="password" id="password" name="password" placeholder="Пароль"
                       style="width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 4px;" required>
            </div>

            <button class="btn primary full-width" type="submit"
                    style="width:100%; padding:12px; background:#d4a574; color:white; border:none; border-radius:4px; cursor:pointer; font-weight:600;">
                Войти
            </button>
        </form>

        <div style="margin-top:20px; text-align:center; color:#888; font-size:13px;">
            Нет аккаунта?
            <a href="${pageContext.request.contextPath}/register"
               style="color:#d4a574; text-decoration:none; font-weight:600;">
                Зарегистрироваться
            </a>
        </div>
    </div>
</div>
</body>
</html>
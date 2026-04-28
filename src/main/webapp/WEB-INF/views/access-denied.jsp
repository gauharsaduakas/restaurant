<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!doctype html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Доступ запрещён — Coffito Kitchen</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles.css">
    <style>
        .error-container {
            max-width: 600px;
            margin: 0 auto;
            padding: 60px 20px;
            text-align: center;
        }
        .error-code {
            font-size: 120px;
            font-weight: 700;
            color: #d4a574;
            margin: 0;
        }
        .error-title {
            font-size: 32px;
            font-weight: 700;
            color: #333;
            margin: 20px 0 10px 0;
        }
        .error-message {
            font-size: 16px;
            color: #666;
            margin-bottom: 30px;
            line-height: 1.6;
        }
        .btn {
            display: inline-block;
            padding: 12px 24px;
            background: #d4a574;
            color: white;
            text-decoration: none;
            border-radius: 4px;
            font-weight: 600;
            margin: 10px;
        }
        .btn:hover {
            background: #b8956f;
        }
    </style>
</head>
<body style="display: flex; align-items: center; justify-content: center; min-height: 100vh; background: #f5f5f5;">
    <div class="error-container">
        <p class="error-code">🚫</p>
        <h1 class="error-title">Доступ запрещён</h1>
        <p class="error-message">
            К сожалению, у вас нет прав для доступа на эту страницу.
            <br>
            Пожалуйста, свяжитесь с администратором если вам нужен доступ.
        </p>
        <a href="${pageContext.request.contextPath}/home" class="btn">← Вернуться на главную</a>
        <a href="${pageContext.request.contextPath}/profile" class="btn">Мой профиль</a>
    </div>
</body>
</html>


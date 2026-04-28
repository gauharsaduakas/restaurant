<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!doctype html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Изменить пароль — Coffito Kitchen</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles.css">
    <style>
        .form-container {
            max-width: 500px;
            margin: 0 auto;
            padding: 40px 20px;
        }
        .form-card {
            background: white;
            border-radius: 8px;
            padding: 30px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        .form-card h1 {
            margin-top: 0;
            color: #333;
            font-size: 24px;
            margin-bottom: 10px;
        }
        .form-card .subtitle {
            color: #666;
            margin-bottom: 30px;
            font-size: 14px;
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #333;
            font-weight: 600;
            font-size: 14px;
        }
        .form-group input {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
            font-family: inherit;
            box-sizing: border-box;
        }
        .form-group input:focus {
            outline: none;
            border-color: #d4a574;
            box-shadow: 0 0 0 3px rgba(212, 165, 116, 0.1);
        }
        .btn {
            display: inline-block;
            padding: 12px 24px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-weight: 600;
            text-decoration: none;
            font-size: 14px;
        }
        .btn-primary {
            background: #d4a574;
            color: white;
            width: 100%;
        }
        .btn-primary:hover {
            background: #b8956f;
        }
        .btn-secondary {
            background: #f0f0f0;
            color: #333;
            margin-top: 10px;
            width: 100%;
        }
        .btn-secondary:hover {
            background: #e0e0e0;
        }
        .alert {
            padding: 15px;
            border-radius: 4px;
            margin-bottom: 20px;
        }
        .alert-success {
            background: #d4edda;
            border: 1px solid #c3e6cb;
            color: #155724;
        }
        .alert-danger {
            background: #f8d7da;
            border: 1px solid #f5c6cb;
            color: #721c24;
        }
        .back-link {
            color: #d4a574;
            text-decoration: none;
            font-size: 14px;
            margin-bottom: 20px;
            display: inline-block;
        }
        .back-link:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
<div class="form-container">
    <a href="${pageContext.request.contextPath}/profile" class="back-link">← Вернуться в профиль</a>

    <div class="form-card">
        <h1>Изменить пароль</h1>
        <p class="subtitle">Укажите ваш текущий пароль и новый пароль</p>

        <c:if test="${success != null}">
            <div class="alert alert-success">✅ ${success}</div>
        </c:if>

        <c:if test="${error != null}">
            <div class="alert alert-danger">❌ ${error}</div>
        </c:if>

        <form method="post" action="${pageContext.request.contextPath}/profile/change-password">
            <div class="form-group">
                <label for="oldPassword">Текущий пароль:</label>
                <input type="password" id="oldPassword" name="oldPassword" placeholder="Введите текущий пароль" required>
            </div>

            <div class="form-group">
                <label for="newPassword">Новый пароль:</label>
                <input type="password" id="newPassword" name="newPassword" placeholder="Минимум 6 символов" required>
            </div>

            <div class="form-group">
                <label for="confirmPassword">Подтвердите новый пароль:</label>
                <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Повторите новый пароль" required>
            </div>

            <button type="submit" class="btn btn-primary">Сохранить новый пароль</button>
            <a href="${pageContext.request.contextPath}/profile" class="btn btn-secondary">Отмена</a>
        </form>
    </div>
</div>
</body>
</html>


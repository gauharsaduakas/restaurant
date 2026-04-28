<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!doctype html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Мой профиль — Coffito Kitchen</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles.css">
    <style>
        .profile-container {
            max-width: 800px;
            margin: 0 auto;
            padding: 30px 20px;
        }
        .profile-card {
            background: white;
            border-radius: 8px;
            padding: 30px;
            margin-bottom: 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        .profile-header {
            display: flex;
            align-items: center;
            gap: 20px;
            border-bottom: 1px solid #eee;
            padding-bottom: 20px;
            margin-bottom: 20px;
        }
        .avatar {
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, #d4a574, #b8956f);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 36px;
            color: white;
        }
        .profile-info h2 {
            margin: 0;
            color: #333;
        }
        .profile-info p {
            margin: 5px 0;
            color: #666;
            font-size: 14px;
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-group label {
            display: block;
            margin-bottom: 5px;
            color: #333;
            font-weight: 600;
            font-size: 14px;
        }
        .form-group input {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
            font-family: inherit;
        }
        .btn {
            display: inline-block;
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-weight: 600;
            text-decoration: none;
            font-size: 14px;
            transition: 0.2s;
        }
        .btn-primary {
            background: #d4a574;
            color: white;
        }
        .btn-primary:hover {
            background: #b8956f;
        }
        .btn-secondary {
            background: #f0f0f0;
            color: #333;
            margin-right: 10px;
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
        .section-title {
            font-size: 18px;
            font-weight: 700;
            color: #333;
            margin-top: 30px;
            margin-bottom: 20px;
            border-bottom: 2px solid #d4a574;
            padding-bottom: 10px;
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
<div class="profile-container">
    <a href="${pageContext.request.contextPath}/home" class="back-link">← Вернуться на главную</a>

    <div class="profile-card">
        <div class="profile-header">
            <div class="avatar">👤</div>
            <div class="profile-info">
                <%-- Защита от null: если объект user пуст, выводим заглушки --%>
                <h2>${not empty user.fullName ? user.fullName : 'Пользователь'}</h2>
                <p>Email: ${not empty user.email ? user.email : 'не указан'}</p>
                <p>Роль: <strong>${user.role == 'ADMIN' ? 'Администратор' : 'Пользователь'}</strong></p>
            </div>
        </div>

        <%-- Сообщения об успехе или ошибке --%>
        <c:if test="${not empty success}">
            <div class="alert alert-success">✅ ${success}</div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-danger">❌ ${error}</div>
        </c:if>

        <div class="section-title">Обновить информацию</div>
        <form method="post" action="${pageContext.request.contextPath}/profile/update">
            <%-- КРИТИЧЕСКИ ВАЖНО: CSRF Токен --%>
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

            <div class="form-group">
                <label for="fullName">Полное имя:</label>
                <input type="text" id="fullName" name="fullName" value="${user.fullName}" required>
            </div>
            <div class="form-group">
                <label for="email">Email:</label>
                <input type="email" id="email" name="email" value="${user.email}" required>
            </div>
            <button type="submit" class="btn btn-primary">Сохранить изменения</button>
        </form>
    </div>

    <div class="profile-card">
        <div class="section-title">Безопасность</div>
        <p style="color: #666; margin-bottom: 20px;">
            Вы можете изменить свой текущий пароль для входа в систему.
        </p>
        <a href="${pageContext.request.contextPath}/profile/change-password" class="btn btn-secondary">
            Изменить пароль
        </a>
    </div>

    <div class="profile-card">
        <div class="section-title">Выход</div>
        <form method="post" action="${pageContext.request.contextPath}/logout">
            <%-- КРИТИЧЕСКИ ВАЖНО: CSRF Токен для Logout --%>
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            <button type="submit" class="btn btn-secondary" style="color: #c00;">Выйти из аккаунта</button>
        </form>
    </div>
</div>
</body>
</html>
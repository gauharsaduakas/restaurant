<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!doctype html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Статистика — Coffito Kitchen</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles.css">
    <style>
        body { background: #f5f5f5; }
        .admin-container { max-width: 1200px; margin: 0 auto; padding: 30px 20px; }
        .admin-header { background: white; padding: 20px; border-radius: 8px; margin-bottom: 30px; display: flex; justify-content: space-between; align-items: center; }
        .admin-header h1 { margin: 0; color: #333; }
        .back-link { color: #d4a574; text-decoration: none; font-weight: 600; }
        .back-link:hover { text-decoration: underline; }
        .placeholder { background: white; padding: 40px; border-radius: 8px; text-align: center; color: #666; }
    </style>
</head>
<body>
<div class="admin-container">
    <div class="admin-header">
        <h1>📈 Статистика</h1>
        <a href="${pageContext.request.contextPath}/admin" class="back-link">← Вернуться в админ панель</a>
    </div>
    <div class="placeholder">
        <p>📊 Функция статистики находится в разработке</p>
    </div>
</div>
</body>
</html>


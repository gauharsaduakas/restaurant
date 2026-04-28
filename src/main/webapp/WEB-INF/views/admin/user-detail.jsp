<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!doctype html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Деталь пользователя — Coffito Kitchen</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles.css">
    <style>
        body {
            background: #f5f5f5;
        }
        .admin-container {
            max-width: 800px;
            margin: 0 auto;
            padding: 30px 20px;
        }
        .admin-header {
            background: white;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .admin-header h1 {
            margin: 0;
            color: #333;
        }
        .back-link {
            color: #d4a574;
            text-decoration: none;
            font-weight: 600;
        }
        .back-link:hover {
            text-decoration: underline;
        }
        .detail-card {
            background: white;
            border-radius: 8px;
            padding: 30px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }
        .detail-row {
            display: flex;
            align-items: center;
            padding: 15px 0;
            border-bottom: 1px solid #eee;
        }
        .detail-row:last-child {
            border-bottom: none;
        }
        .detail-label {
            font-weight: 600;
            color: #666;
            min-width: 150px;
        }
        .detail-value {
            color: #333;
            font-size: 16px;
        }
        .role-badge {
            display: inline-block;
            padding: 6px 14px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: 600;
        }
        .role-badge.admin {
            background: #ffe0e0;
            color: #c00;
        }
        .role-badge.user {
            background: #e0f0ff;
            color: #006;
        }
        .actions {
            background: white;
            border-radius: 8px;
            padding: 20px;
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
        }
        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 600;
            text-decoration: none;
            display: inline-block;
            transition: all 0.3s;
        }
        .btn-primary {
            background: #d4a574;
            color: white;
        }
        .btn-primary:hover {
            background: #c49564;
        }
        .btn-danger {
            background: #c00;
            color: white;
        }
        .btn-danger:hover {
            background: #a00;
        }
        .btn-secondary {
            background: #999;
            color: white;
        }
        .btn-secondary:hover {
            background: #777;
        }
    </style>
</head>
<body>
    <div class="admin-container">
        <div class="admin-header">
            <h1>Пользователь: ${user.fullName}</h1>
            <a href="${pageContext.request.contextPath}/admin/users" class="back-link">← Назад к списку</a>
        </div>

        <div class="detail-card">
            <div class="detail-row">
                <span class="detail-label">ID:</span>
                <span class="detail-value">${user.id}</span>
            </div>
            <div class="detail-row">
                <span class="detail-label">ФИО:</span>
                <span class="detail-value">${user.fullName}</span>
            </div>
            <div class="detail-row">
                <span class="detail-label">Email:</span>
                <span class="detail-value">${user.email}</span>
            </div>
            <div class="detail-row">
                <span class="detail-label">Роль:</span>
                <span class="role-badge <c:if test="${user.role == 'ADMIN'}">admin</c:if><c:if test="${user.role == 'USER'}">user</c:if>">
                    ${user.role}
                </span>
            </div>
        </div>

        <div class="actions">
            <c:if test="${user.role != 'ADMIN'}">
                <form method="post" action="${pageContext.request.contextPath}/admin/users/${user.id}/grant-admin" style="margin: 0;">
                    <button type="submit" class="btn btn-primary">✓ Выдать права администратора</button>
                </form>
            </c:if>
            <c:if test="${user.role == 'ADMIN'}">
                <form method="post" action="${pageContext.request.contextPath}/admin/users/${user.id}/revoke-admin" style="margin: 0;">
                    <button type="submit" class="btn btn-secondary">✗ Забрать права администратора</button>
                </form>
            </c:if>
            <form method="post" action="${pageContext.request.contextPath}/admin/users/${user.id}/delete" style="margin: 0;" onsubmit="return confirm('Вы уверены?');">
                <button type="submit" class="btn btn-danger">🗑 Удалить пользователя</button>
            </form>
        </div>
    </div>
</body>
</html>


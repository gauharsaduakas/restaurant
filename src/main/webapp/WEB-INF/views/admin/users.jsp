<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!doctype html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Управление пользователями — Coffito Kitchen</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles.css">
    <style>
        body {
            background: #f5f5f5;
        }
        .admin-container {
            max-width: 1200px;
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
        .table-container {
            background: white;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            overflow-x: auto;
        }
        table {
            width: 100%;
            border-collapse: collapse;
        }
        table thead {
            background: #f5f5f5;
            border-bottom: 2px solid #ddd;
        }
        table th {
            padding: 15px;
            text-align: left;
            font-weight: 600;
            color: #333;
        }
        table td {
            padding: 12px 15px;
            border-bottom: 1px solid #eee;
        }
        table tbody tr:hover {
            background: #f9f9f9;
        }
        .role-badge {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
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
        .btn {
            padding: 6px 12px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 12px;
            font-weight: 600;
            text-decoration: none;
            display: inline-block;
        }
        .btn-info {
            background: #0066cc;
            color: white;
        }
        .btn-info:hover {
            background: #0052a3;
        }
        .btn-danger {
            background: #e74c3c;
            color: white;
        }
        .btn-danger:hover {
            background: #c0392b;
        }
        .btn-warning {
            background: #f39c12;
            color: white;
        }
        .btn-warning:hover {
            background: #d68910;
        }
        .empty-state {
            text-align: center;
            padding: 40px 20px;
            color: #666;
        }
        .empty-state p {
            margin: 0;
        }
    </style>
</head>
<body>
<div class="admin-container">
    <div class="admin-header">
        <h1>👥 Управление пользователями</h1>
        <a href="${pageContext.request.contextPath}/admin" class="back-link">← Вернуться в админ панель</a>
    </div>

    <div class="table-container">
        <c:if test="${empty users}">
            <div class="empty-state">
                <p>Нет пользователей в системе</p>
            </div>
        </c:if>

        <c:if test="${not empty users}">
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Имя</th>
                        <th>Email</th>
                    <th>Роль</th>
                    <th>Действия</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="user" items="${users}">
                    <tr>
                        <td>${user.id}</td>
                        <td>${user.fullName}</td>
                        <td>${user.email}</td>
                        <td>
                            <span class="role-badge ${user.role == 'ADMIN' ? 'admin' : 'user'}">
                                ${user.role == 'ADMIN' ? '👑 Администратор' : '👤 Пользователь'}
                            </span>
                        </td>
                        <td>
                            <a href="${pageContext.request.contextPath}/admin/users/${user.id}" class="btn btn-info">Просмотреть</a>
                            <c:if test="${user.role != 'ADMIN'}">
                                <form method="post" action="${pageContext.request.contextPath}/admin/users/${user.id}/grant-admin" style="display: inline;">
                                    <button type="submit" class="btn btn-warning">Сделать админом</button>
                                </form>
                            </c:if>
                            <c:if test="${user.role == 'ADMIN'}">
                                <form method="post" action="${pageContext.request.contextPath}/admin/users/${user.id}/revoke-admin" style="display: inline;">
                                    <button type="submit" class="btn btn-warning">Забрать права</button>
                                </form>
                            </c:if>
                            <form method="post" action="${pageContext.request.contextPath}/admin/users/${user.id}/delete" style="display: inline;" onsubmit="return confirm('Вы уверены? Это удалит пользователя безвозвратно.');">
                                <button type="submit" class="btn btn-danger">Удалить</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
        </c:if>
    </div>
</div>
</body>
</html>


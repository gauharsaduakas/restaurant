<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<% String ctx = request.getContextPath(); %>

<!doctype html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>Заказы — Админ панель</title>
    <link rel="stylesheet" href="<%= ctx %>/styles.css">
    <style>
        .badge { padding: 5px 10px; border-radius: 4px; font-size: 12px; font-weight: bold; }
        .status-NEW { background: #f1c40f; color: #000; }
        .status-DONE { background: #2ecc71; color: #fff; }
        .btn-detail { background: #d4a574; color: #000; padding: 6px 12px; border-radius: 4px; text-decoration: none; font-size: 14px; }
    </style>
</head>
<body style="background: #121212; color: white; font-family: sans-serif;">

<div class="admin-container" style="max-width: 1200px; margin: 0 auto; padding: 20px;">
    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px;">
        <h1>📦 Управление заказами</h1>
        <a href="<%= ctx %>/admin" style="color: #d4a574; text-decoration: none;">← Назад в дашборд</a>
    </div>

    <div class="orders-table-wrapper" style="background: #1e1e1e; padding: 25px; border-radius: 12px; border: 1px solid #333;">
        <c:choose>
            <c:when test="${not empty orders}">
                <table style="width: 100%; border-collapse: collapse;">
                    <thead>
                    <tr style="border-bottom: 1px solid #444; text-align: left; color: #888;">
                        <th style="padding: 15px;">ID</th>
                        <th>Клиент</th>
                        <th>Сумма</th>
                        <th>Статус</th>
                        <th style="text-align: right;">Действие</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="o" items="${orders}">
                        <tr style="border-bottom: 1px solid #222;">
                            <td style="padding: 15px;">#${o.id}</td>
                            <td><c:out value="${o.customerName != null ? o.customerName : 'Гость'}"/></td>
                            <td style="font-weight: bold; color: #2ecc71;">${o.totalAmount} ₸</td>
                            <td><span class="badge status-${o.status}">${o.status}</span></td>
                            <td style="text-align: right;">
                                <a href="<%= ctx %>/admin/orders/${o.id}" class="btn-detail">Детали</a>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </c:when>
            <c:otherwise>
                <div style="text-align: center; padding: 60px;">
                    <p style="color: #666; font-size: 18px;">Заказов пока нет в базе данных.</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>
</body>
</html>
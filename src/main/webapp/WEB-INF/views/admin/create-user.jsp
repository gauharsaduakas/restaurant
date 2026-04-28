<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.gauhar.restaurant.entity.User" %>
<%
    User user = (User) request.getAttribute("user");
    if (user == null) user = new User();
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Создать пользователя</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles.css">
</head>
<body>

<%
    request.setAttribute("navActivePage", "admin");
%>

<jsp:include page="../includes/navbar.jsp" />

<div class="page-wrapper">
    <div class="form-card" style="max-width: 500px; margin: 0 auto;">
        <div class="form-card-header">
            <h2 class="page-title">👤 Создать пользователя</h2>
            <a href="${pageContext.request.contextPath}/admin/users" class="btn ghost small">← Назад</a>
        </div>

        <% if (error != null) { %>
        <div class="toast error" style="margin-bottom:16px;">❌ <%= error %></div>
        <% } %>

        <form method="post" action="${pageContext.request.contextPath}/admin/create">
            <div class="form-row">
                <input type="text" name="fullName" placeholder="ФИ" required autofocus>
            </div>
            <div class="form-row">
                <input type="email" name="email" placeholder="Email" required>
            </div>
            <div class="form-row">
                <input type="password" name="password" placeholder="Пароль" required>
            </div>
            <div class="form-row">
                <select name="role" required>
                    <option value="" disabled selected>Выберите роль</option>
                    <option value="CLIENT">Клиент</option>
                    <option value="ADMIN">Администратор</option>
                </select>
            </div>
            <button class="btn primary full-width" type="submit">Создать пользователя</button>
        </form>
    </div>
</div>

<jsp:include page="../includes/footer.jsp" />
</body>
</html>


<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.gauhar.restaurant.entity.User" %>
<%
    User user = (User) request.getAttribute("user");
    if (user == null) user = new User();
%>
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Редактировать пользователя</title>
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
            <h2 class="page-title">✏️ Редактировать пользователя</h2>
            <a href="${pageContext.request.contextPath}/admin/users" class="btn ghost small">← Назад</a>
        </div>

        <form method="post" action="${pageContext.request.contextPath}/admin/edit/<%= user.getId() %>">
            <div class="form-row">
                <input type="text" name="fullName" placeholder="ФИ" value="<%= user.getFullName() %>" required>
            </div>
            <div class="form-row">
                <input type="email" name="email" placeholder="Email" value="<%= user.getEmail() %>" required>
            </div>
            <div class="form-row">
                <input type="password" name="password" placeholder="Новый пароль (оставить пусто для сохранения текущего)">
            </div>
            <div class="form-row">
                <select name="role" required>
                    <option value="CLIENT" <%= "CLIENT".equals(user.getRole()) ? "selected" : "" %>>Клиент</option>
                    <option value="ADMIN" <%= "ADMIN".equals(user.getRole()) ? "selected" : "" %>>Администратор</option>
                </select>
            </div>
            <button class="btn primary full-width" type="submit">Сохранить изменения</button>
        </form>
    </div>
</div>

<jsp:include page="../includes/footer.jsp" />
</body>
</html>


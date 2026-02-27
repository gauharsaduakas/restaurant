<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="com.gauhar.restaurant.model.MenuItem" %>
<%
    String ctx  = request.getContextPath();
    String mode = (String) request.getAttribute("mode");
    MenuItem item = (MenuItem) request.getAttribute("item");
    boolean isEdit = "edit".equals(mode);
    String title  = isEdit ? "Редактировать блюдо" : "Добавить блюдо";
    String action = isEdit ? (ctx + "/menu-items/update") : (ctx + "/menu-items");
%>
<!doctype html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title><%= title %></title>
    <link rel="stylesheet" href="<%=ctx%>/assets/styles.css">
</head>
<body>

<div class="navbar">
    <div class="nav-inner">
        <a class="brand" href="<%=ctx%>/">🌿 Gauhar Restaurant</a>
        <div class="nav-links">
            <a class="nav-link" href="<%=ctx%>/">Главная</a>
            <a class="nav-link active" href="<%=ctx%>/menu-items">Меню</a>
            <a class="nav-link" href="<%=ctx%>/orders">Заказы</a>
            <a class="nav-link" href="<%=ctx%>/restaurant">О ресторане</a>
        </div>
    </div>
</div>

<div class="page-wrapper">
    <div class="form-card">
        <div class="form-card-header">
            <h2 class="page-title"><%= title %></h2>
            <a class="btn ghost small" href="<%=ctx%>/menu-items">Назад</a>
        </div>

        <form method="post" action="<%= action %>">
            <% if (isEdit) { %>
            <input type="hidden" name="id" value="<%= item.getId() %>">
            <% } %>

            <div class="form-row">
                <input name="name" required placeholder="Название"
                       value="<%= isEdit ? item.getName() : "" %>">
            </div>
            <div class="form-row">
                <input name="category" required placeholder="Категория"
                       value="<%= isEdit ? item.getCategory() : "" %>">
            </div>
            <div class="form-row">
                <input name="price" type="number" step="1" required placeholder="Цена (₸)"
                       value="<%= isEdit ? (int)item.getPrice() : "" %>">
            </div>
            <div class="form-row">
                <input name="imageUrl" placeholder="Ссылка на изображение (например: /assets/img/burger.jpg)"
                       value="<%= isEdit ? item.getImageUrl() : "" %>">
            </div>
            <div class="form-row checkbox-row">
                <label class="check-label">
                    <input type="checkbox" name="isAvailable"
                           <%= (!isEdit || item.isAvailable()) ? "checked" : "" %>>
                    <span>В наличии</span>
                </label>
            </div>

            <button class="btn primary full-width" type="submit">Сохранить</button>
        </form>
    </div>
</div>

</body>
</html>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.gauhar.restaurant.model.MenuItem" %>
<%
    String ctx  = request.getContextPath();
    String mode = (String) request.getAttribute("mode");

    MenuItem item = (MenuItem) request.getAttribute("item");

    boolean isEdit = "edit".equals(mode) && item != null;

    String title  = isEdit ? "Редактировать блюдо" : "Добавить блюдо";
    String action = isEdit ? (ctx + "/menu-items/update") : (ctx + "/menu-items");

    String nameVal     = isEdit && item.getName() != null ? item.getName() : "";
    String categoryVal = isEdit && item.getCategory() != null ? item.getCategory() : "";
    String imageVal    = isEdit && item.getImageUrl() != null ? item.getImageUrl() : "";
    String priceVal    = isEdit ? String.valueOf((int) item.getPrice()) : "";
    boolean availableChecked = !isEdit || item.isAvailable();
%>
<!doctype html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title><%= title %></title>
    <link rel="stylesheet" href="<%= ctx %>/styles.css">
</head>
<body>

<div class="navbar">
    <div class="nav-inner">
        <a class="brand" href="<%= ctx %>/">🌿 Gauhar Restaurant</a>
        <div class="nav-links">
            <a class="nav-link" href="<%= ctx %>/">Главная</a>
            <a class="nav-link active" href="<%= ctx %>/menu-items">Меню</a>
            <a class="nav-link" href="<%= ctx %>/orders">Заказы</a>
            <a class="nav-link" href="<%= ctx %>/kitchen">Кухня</a>
            <a class="nav-link" href="<%= ctx %>/restaurant">О ресторане</a>
        </div>
    </div>
</div>

<div class="page-wrapper">
    <div class="form-card">
        <div class="form-card-header">
            <h2 class="page-title"><%= title %></h2>
            <a class="btn ghost small" href="<%= ctx %>/menu-items">Назад</a>
        </div>

        <form method="post" action="<%= action %>">
            <% if (isEdit) { %>
            <input type="hidden" name="id" value="<%= item.getId() %>">
            <% } %>

            <div class="form-row">
                <input name="name" required placeholder="Название" value="<%= nameVal %>">
            </div>

            <div class="form-row">
                <input name="category" required placeholder="Категория" value="<%= categoryVal %>">
            </div>

            <div class="form-row">
                <input name="price" type="number" step="1" min="0" required placeholder="Цена (₸)"
                       value="<%= priceVal %>">
            </div>

            <div class="form-row">
                <input name="imageUrl" placeholder="Ссылка или путь (например: /assets/img/burger.jpg)"
                       value="<%= imageVal %>">
            </div>

            <div class="form-row checkbox-row">
                <label class="check-label">
                    <input type="checkbox" name="isAvailable" <%= availableChecked ? "checked" : "" %>>
                    <span>В наличии</span>
                </label>
            </div>

            <button class="btn primary full-width" type="submit">Сохранить</button>
        </form>
    </div>
</div>

</body>
</html>
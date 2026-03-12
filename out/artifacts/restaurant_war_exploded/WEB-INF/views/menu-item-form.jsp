<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.gauhar.restaurant.model.MenuItem, com.gauhar.restaurant.model.Restaurant" %>
<%
    String ctx  = request.getContextPath();
    String mode = (String) request.getAttribute("mode");

    // Spring MVC кладёт restaurant через @ModelAttribute в request
    Restaurant r = (Restaurant) request.getAttribute("restaurant");
    String restaurantName = (r != null && r.getName() != null && !r.getName().isBlank())
            ? r.getName() : "Gauhar Restaurant";

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
    <title><%= title %> — <%= restaurantName %></title>
    <link rel="stylesheet" href="<%= ctx %>/styles.css">
</head>
<body>

<jsp:include page="/WEB-INF/views/fragments/navbar.jsp"/>

<div class="page-wrapper">
    <div class="form-card">
        <div class="form-card-header">
            <h2 class="page-title"><%= title %></h2>
            <a class="btn ghost small" href="<%= ctx %>/menu-items">← Назад</a>
        </div>

        <form method="post" action="<%= action %>">
            <% if (isEdit) { %>
            <input type="hidden" name="id" value="<%= item.getId() %>">
            <% } %>

            <div class="form-row">
                <input name="name" required placeholder="Название блюда" value="<%= nameVal %>">
            </div>
            <div class="form-row">
                <select name="category">
                    <option value="Main"    <%= "Main".equals(categoryVal)    ? "selected" : "" %>>🍔 Main (Основное)</option>
                    <option value="Drink"   <%= "Drink".equals(categoryVal)   ? "selected" : "" %>>☕ Drink (Напиток)</option>
                    <option value="Dessert" <%= "Dessert".equals(categoryVal) ? "selected" : "" %>>🍰 Dessert (Десерт)</option>
                </select>
            </div>
            <div class="form-row">
                <input name="price" type="number" step="1" min="0" required placeholder="Цена (₸)" value="<%= priceVal %>">
            </div>
            <div class="form-row">
                <input name="imageUrl" placeholder="Ссылка на фото (напр: /assets/img/burger.jpg)" value="<%= imageVal %>">
            </div>
            <div class="form-row checkbox-row">
                <label class="check-label">
                    <input type="checkbox" name="isAvailable" <%= availableChecked ? "checked" : "" %>>
                    <span>В наличии</span>
                </label>
            </div>

            <button class="btn primary full-width" type="submit">💾 Сохранить</button>
        </form>
    </div>
</div>

</body>
</html>


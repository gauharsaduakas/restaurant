<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page isELIgnored="false" %>
<%@ page import="com.gauhar.restaurant.model.MenuItem" %>
<%@ page import="com.gauhar.restaurant.model.Restaurant" %>
<%
    String mode = (String) request.getAttribute("mode");

    Restaurant _r = (Restaurant) request.getAttribute("restaurant");
    String restaurantName = (_r != null && _r.getName() != null && !_r.getName().isBlank()) ? _r.getName() : "Restaurant";

    MenuItem item = (MenuItem) request.getAttribute("item");

    boolean isEdit = "edit".equals(mode) && item != null;

    String title  = isEdit ? "Редактировать блюдо" : "Добавить блюдо";
    String contextPath = request.getContextPath();
    String action = isEdit ? (contextPath + "/menu-items/update") : (contextPath + "/menu-items/new");
    String nameVal     = isEdit && item.getName() != null ? item.getName() : "";
    String categoryVal = isEdit && item.getCategory() != null ? item.getCategory() : "";
    String imageVal    = isEdit && item.getImageUrl() != null ? item.getImageUrl() : "";
    String priceVal    = isEdit ? String.valueOf((int) item.getPrice()) : "";
    boolean availableChecked = !isEdit || item.isAvailable();

    request.setAttribute("navRestaurantName", restaurantName);
    request.setAttribute("navActivePage", "menu");
%>
<!doctype html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title><%= title %> — <%= restaurantName %></title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/styles.css">
</head>
<body>

<jsp:include page="includes/navbar.jsp" />

<div class="page-wrapper">
    <div class="form-card">
        <div class="form-card-header">
            <h2 class="page-title"><%= title %></h2>
            <a class="btn ghost small" href="${pageContext.request.contextPath}/menu-items">Назад</a>
        </div>

        <form method="post" action="<%= action %>">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            <%-- остальной код --%>            <% if (isEdit) { %>
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
                    <input type="checkbox" name="available" <%= availableChecked ? "checked" : "" %>>
                    <span>В наличии</span>
                </label>
            </div>

            <button class="btn primary full-width" type="submit">Сохранить</button>
        </form>
    </div>
</div>

<jsp:include page="includes/footer.jsp" />
</body>
</html>
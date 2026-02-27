<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="com.gauhar.restaurant.model.Restaurant" %>
<%
    String ctx = request.getContextPath();
    Restaurant r = (Restaurant) request.getAttribute("restaurant");
    String ok  = (String) session.getAttribute("flash_success");
    String err = (String) session.getAttribute("flash_error");
    session.removeAttribute("flash_success");
    session.removeAttribute("flash_error");

    String name      = r != null && r.getName()      != null ? r.getName()      : "";
    String address   = r != null && r.getAddress()   != null ? r.getAddress()   : "";
    String phone     = r != null && r.getPhone()     != null ? r.getPhone()     : "";
    String workHours = r != null && r.getWorkHours() != null ? r.getWorkHours() : "";
    String desc      = r != null && r.getDescription() != null ? r.getDescription() : "";
%>
<!doctype html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>О ресторане</title>
    <link rel="stylesheet" href="<%=ctx%>/assets/styles.css">
</head>
<body>

<div class="navbar">
    <div class="nav-inner">
        <a class="brand" href="<%=ctx%>/">🌿 Gauhar Restaurant</a>
        <div class="nav-links">
            <a class="nav-link" href="<%=ctx%>/">Главная</a>
            <a class="nav-link" href="<%=ctx%>/menu-items">Меню</a>
            <a class="nav-link" href="<%=ctx%>/orders">Заказы</a>
            <a class="nav-link active" href="<%=ctx%>/restaurant">О ресторане</a>
        </div>
    </div>
</div>

<div class="page-wrapper">
    <div class="page-header-bar">
        <h2 class="page-title">О ресторане</h2>
        <div class="nav-links">
            <a class="nav-link" href="<%=ctx%>/">Главная</a>
            <a class="nav-link" href="<%=ctx%>/menu-items">Меню</a>
            <a class="nav-link" href="<%=ctx%>/orders">Заказы</a>
        </div>
    </div>

    <% if (ok != null) { %><div class="toast success"><%= ok %></div><% } %>
    <% if (err != null) { %><div class="toast error"><%= err %></div><% } %>

    <div class="form-card" style="max-width:600px;margin:auto">
        <form method="post" action="<%=ctx%>/restaurant">
            <div class="form-row">
                <input name="name" required placeholder="Название ресторана" value="<%= name %>">
            </div>
            <div class="form-row">
                <input name="address" placeholder="Адрес" value="<%= address %>">
            </div>
            <div class="form-row">
                <input name="phone" placeholder="Телефон" value="<%= phone %>">
            </div>
            <div class="form-row">
                <input name="workHours" placeholder="Режим работы (напр: 10:00 - 23:00)" value="<%= workHours %>">
            </div>
            <div class="form-row">
                <textarea name="description" placeholder="Описание ресторана" rows="4"><%= desc %></textarea>
            </div>
            <button class="btn primary full-width" type="submit">Сохранить</button>
        </form>
    </div>
</div>

</body>
</html>

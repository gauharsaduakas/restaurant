<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.gauhar.restaurant.model.Restaurant" %>
<%@ page import="org.springframework.security.core.Authentication" %>
<%@ page import="org.springframework.security.core.context.SecurityContextHolder" %>
<%@ page import="org.springframework.security.core.GrantedAuthority" %>
<%
    String ctx = request.getContextPath();
    Restaurant r = (Restaurant) request.getAttribute("restaurant");

    String ok  = (String) session.getAttribute("flash_success");
    String err = (String) session.getAttribute("flash_error");
    session.removeAttribute("flash_success");
    session.removeAttribute("flash_error");

    String name         = (r != null && r.getName()        != null) ? r.getName()        : "";
    String restaurantName = !name.isBlank() ? name : "Gauhar Restaurant";
    String address      = (r != null && r.getAddress()     != null) ? r.getAddress()     : "";
    String phone        = (r != null && r.getPhone()       != null) ? r.getPhone()       : "";
    String workHours    = (r != null && r.getWorkHours()   != null) ? r.getWorkHours()   : "";
    String desc         = (r != null && r.getDescription() != null) ? r.getDescription() : "";

    Authentication _auth = SecurityContextHolder.getContext().getAuthentication();
    String currentRole = (_auth != null && _auth.isAuthenticated())
            ? _auth.getAuthorities().stream()
                .map(GrantedAuthority::getAuthority)
                .filter(a -> a.startsWith("ROLE_"))
                .map(a -> a.substring(5))
                .findFirst().orElse("")
            : "";
    boolean isAdmin = "ADMIN".equals(currentRole);
%>
<!doctype html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>О ресторане — <%= restaurantName %></title>
    <link rel="stylesheet" href="<%= ctx %>/styles.css">
</head>
<body>

<div class="navbar">
    <div class="nav-inner">
        <a class="brand" href="<%= ctx %>/home">🎍 <%=name %></a>
        <div class="nav-links">
            <a class="nav-link" href="<%= ctx %>/home">Главная</a>
            <a class="nav-link" href="<%= ctx %>/menu-items">Меню</a>
            <a class="nav-link" href="<%= ctx %>/orders"><%= isAdmin ? "Заказы" : "Сделать заказ" %></a>
            <a class="nav-link" href="<%= ctx %>/kitchen">Кухня</a>
            <% if (isAdmin) { %>
            <a class="nav-link active" href="<%= ctx %>/restaurant">О ресторане</a>
            <% } %>
            <a class="nav-link" href="<%= ctx %>/logout">Выход</a>
        </div>
    </div>
</div>

<div class="page-wrapper">
    <div class="page-header-bar">
        <div class="page-title">О ресторане</div>
    </div>

    <% if (ok != null) { %><div class="toast success"><%= ok %></div><% } %>
    <% if (err != null) { %><div class="toast error"><%= err %></div><% } %>

    <div class="form-card" style="max-width:600px;margin:auto">
        <% if (isAdmin) { %>
        <form method="post" action="<%= ctx %>/restaurant">
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
        <% } else { %>
        <div class="form-row"><strong>Название:</strong> <%= name %></div>
        <div class="form-row"><strong>Адрес:</strong> <%= address %></div>
        <div class="form-row"><strong>Телефон:</strong> <%= phone %></div>
        <div class="form-row"><strong>Режим работы:</strong> <%= workHours %></div>
        <div class="form-row"><strong>Описание:</strong> <%= desc %></div>
        <% } %>
    </div>
</div>

</body>
</html>
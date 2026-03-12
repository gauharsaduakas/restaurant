<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, com.gauhar.restaurant.model.*" %>
<%
    String ctx = request.getContextPath();

    User currentUser = (User) session.getAttribute("currentUser");
    boolean isAdmin = currentUser != null && "ADMIN".equals(currentUser.getRole());

    // Spring MVC кладёт restaurant через @ModelAttribute в request
    Restaurant r = (Restaurant) request.getAttribute("restaurant");
    String restaurantName = (r != null && r.getName() != null && !r.getName().isBlank())
            ? r.getName() : "Gauhar Restaurant";

    List<MenuItem> items = (List<MenuItem>) request.getAttribute("items");
    if (items == null) items = new ArrayList<>();

    String ok  = (String) session.getAttribute("flash_success");
    String err = (String) session.getAttribute("flash_error");
    session.removeAttribute("flash_success");
    session.removeAttribute("flash_error");
%>
<!doctype html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Меню — <%= restaurantName %></title>
    <link rel="stylesheet" href="<%= ctx %>/styles.css">
</head>
<body>

<jsp:include page="/WEB-INF/views/fragments/navbar.jsp"/>

<div class="page-wrapper">
    <div class="page-header-bar">
        <div class="page-title">Меню</div>
        <% if (isAdmin) { %>
        <a class="btn primary" href="<%= ctx %>/menu-items/new">+ Добавить блюдо</a>
        <% } %>
    </div>

    <% if (ok != null) { %><div class="toast success"><%= ok %></div><% } %>
    <% if (err != null) { %><div class="toast error"><%= err %></div><% } %>

    <% if (items.isEmpty()) { %>
    <div class="empty-state">Меню пустое. <% if (isAdmin) { %>Добавьте первое блюдо.<% } %></div>
    <% } else { %>
    <div class="menu-grid">
        <% for (MenuItem m : items) {
            if (m == null) continue;

            String img = m.getImageUrl();
            boolean hasImg = (img != null && !img.isBlank());

            String src;
            if (hasImg) {
                if (img.startsWith("http")) src = img;
                else if (img.startsWith("/")) src = ctx + img;
                else src = ctx + "/" + img;
            } else {
                src = ctx + "/assets/img/placeholder.png";
            }

            String title = (m.getName() != null) ? m.getName() : "Без названия";
            String cat   = (m.getCategory() != null && !m.getCategory().isBlank()) ? m.getCategory() : "No category";
        %>
        <div class="menu-card">
            <div class="menu-img">
                <img src="<%= src %>" alt="<%= title %>">
            </div>
            <div class="menu-body">
                <h3><%= title %></h3>
                <div class="menu-category"><%= cat %></div>
                <div class="menu-row">
                    <span class="menu-price"><%= (int) m.getPrice() %> ₸</span>
                    <% if (m.isAvailable()) { %>
                    <span class="menu-badge ok">В наличии</span>
                    <% } else { %>
                    <span class="menu-badge no">Нет</span>
                    <% } %>
                </div>

                <% if (isAdmin) { %>
                <div class="menu-actions">
                    <a class="btn small ghost" href="<%= ctx %>/menu-items/edit?id=<%= m.getId() %>">✏️ Изменить</a>

                    <form method="post" action="<%= ctx %>/menu-items/delete"
                          onsubmit="return confirm('Удалить блюдо?');" style="display:inline">
                        <input type="hidden" name="id" value="<%= m.getId() %>">
                        <button class="btn small danger" type="submit">🗑 Удалить</button>
                    </form>

                    <form method="post" action="<%= ctx %>/menu-items/toggle" style="display:inline">
                        <input type="hidden" name="id" value="<%= m.getId() %>">
                        <input type="hidden" name="available" value="<%= !m.isAvailable() %>">
                        <button class="btn small <%= m.isAvailable() ? "warn" : "ok-btn" %>" type="submit">
                            <%= m.isAvailable() ? "🔴 Выкл" : "🟢 Вкл" %>
                        </button>
                    </form>
                </div>
                <% } %>
            </div>
        </div>
        <% } %>
    </div>
    <% } %>
</div>

</body>
</html>


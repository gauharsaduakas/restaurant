<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, com.gauhar.restaurant.model.MenuItem, com.gauhar.restaurant.model.Restaurant" %>
<%@ page import="org.springframework.security.core.Authentication" %>
<%@ page import="org.springframework.security.core.context.SecurityContextHolder" %>
<%@ page import="org.springframework.security.core.GrantedAuthority" %>
<%
    String ctx = request.getContextPath();

    Restaurant _r = (Restaurant) request.getAttribute("restaurant");
    String restaurantName = (_r != null && _r.getName() != null && !_r.getName().isBlank()) ? _r.getName() : "Gauhar Restaurant";

    List<MenuItem> items = (List<MenuItem>) request.getAttribute("items");
    if (items == null) items = new ArrayList<>();

    String ok  = (String) session.getAttribute("flash_success");
    String err = (String) session.getAttribute("flash_error");
    session.removeAttribute("flash_success");
    session.removeAttribute("flash_error");

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
    <title>Меню — <%= restaurantName %></title>
    <link rel="stylesheet" href="<%= ctx %>/styles.css">
</head>
<body>

<div class="navbar">
    <div class="nav-inner">
        <a class="brand" href="<%= ctx %>/home">🎍 <%= restaurantName %></a>
        <div class="nav-links">
            <a class="nav-link" href="<%= ctx %>/home">Главная</a>            <a class="nav-link active" href="<%= ctx %>/menu-items">Меню</a>
            <a class="nav-link" href="<%= ctx %>/orders"><%= isAdmin ? "Заказы" : "Сделать заказ" %></a>
            <a class="nav-link" href="<%= ctx %>/kitchen">Кухня</a>
            <% if (isAdmin) { %>
            <a class="nav-link" href="<%= ctx %>/restaurant">О ресторане</a>
            <% } %>
            <a class="nav-link" href="<%= ctx %>/logout">Выход</a>
        </div>
    </div>
</div>

<div class="page-wrapper">
    <div class="page-header-bar">
        <div class="page-title">Меню</div>
    </div>

    <% if (ok != null) { %><div class="toast success"><%= ok %></div><% } %>
    <% if (err != null) { %><div class="toast error"><%= err %></div><% } %>

    <% if (isAdmin) { %>
    <div class="toolbar">
        <a class="btn primary" href="<%= ctx %>/menu-items/new">+ Добавить блюдо</a>
    </div>
    <% } %>

    <% if (items.isEmpty()) { %>
    <div class="empty-state">Меню пустое.</div>
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
                src = ctx + "/assets/img/placeholder.jpg";
            }

            String title = (m.getName() != null) ? m.getName() : "Без названия";
            String cat = (m.getCategory() != null && !m.getCategory().isBlank()) ? m.getCategory() : "No category";
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

                <div class="menu-actions">
                    <% if (isAdmin) { %>
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
                    <% } else { %>
                    <a class="btn small primary" href="<%= ctx %>/orders">🧾 Заказать</a>
                    <% } %>
                </div>
            </div>
        </div>
        <% } %>
    </div>
    <% } %>
</div>

</body>
</html>
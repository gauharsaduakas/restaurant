<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.gauhar.restaurant.model.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.NumberFormat" %>

<%
    String ctx = request.getContextPath();

    Restaurant r = (Restaurant) request.getAttribute("restaurant");
    String restaurantName = (r != null && r.getName() != null)
            ? r.getName()
            : "Ресторан";

    List<MenuItem> items = (List<MenuItem>) request.getAttribute("items");
    if (items == null) items = new ArrayList<>();

    NumberFormat nf = NumberFormat.getNumberInstance(new Locale("ru", "KZ"));
%>

<!doctype html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>Меню — <%= restaurantName %></title>
    <link rel="stylesheet" href="<%=ctx%>/styles.css">
    <style>
        /* Добавим немного стилей для изображений, если их нет в styles.css */
        .menu-card img {
            width: 100%;
            height: 200px;
            object-fit: cover;
            border-radius: 8px 8px 0 0;
            margin-bottom: 10px;
        }
        .menu-card {
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 0; /* Чтобы картинка прилегала к краям */
            overflow: hidden;
            background: #fff;
            text-align: center;
        }
        .card-content {
            padding: 15px;
        }
    </style>
</head>

<body>
<div class="navbar">
    <div class="nav-inner">
        <a class="brand" href="<%=ctx%>/home">
            🍳 <%= restaurantName %>
        </a>

        <div class="nav-links">
            <a href="<%=ctx%>/menu">Меню</a>
            <a href="<%=ctx%>/cart">Корзина 🛒</a>
            <a href="<%=ctx%>/orders">Заказы</a>
        </div>
        <div class="toolbar">
            <input type="text" id="menuSearch" placeholder="Поиск блюда..." onkeyup="filterMenu()">
        </div>
    </div>
</div>

<div class="container page-wrapper">

    <h2 style="margin-top: 20px;">Меню</h2>

    <div class="menu-grid">

        <%
            for (MenuItem m : items) {
        %>

        <div class="menu-card">

            <%-- Если путь в базе "burger.jpg", итоговый src будет /restaurant/images/burger.jpg --%>
            <img src="<%=ctx%>/images/<%= m.getImagePath() %>"
                 alt="<%= m.getName() %>"
                 onerror="this.src='<%=ctx%>/static/images/placeholder.png';">

            <div class="card-content">
                <h3><%= m.getName() %></h3>
                <p style="font-weight: bold; color: #d4a574;">Цена: <%= nf.format(m.getPrice()) %> ₸</p>

                <form method="post" action="<%=ctx%>/cart/add">
                    <%-- Добавляем CSRF токен, если он настроен в SecurityConfig --%>
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    <input type="hidden" name="menuItemId" value="<%= m.getId() %>">

                    <div style="margin-bottom: 10px;">
                        <label style="font-size: 0.8em;">Количество:</label>
                        <input type="number" name="quantity" value="1" min="1" style="width: 50px; padding: 5px;">
                    </div>

                    <div class="options-group" style="margin-bottom: 15px; font-size: 0.85em; text-align: left; height: 100px; overflow-y: auto;">
                        <% String cat = m.getCategory() != null ? m.getCategory().toLowerCase() : ""; %>

                        <% if (cat.contains("пицца") || cat.contains("pizza")) { %>
                        <label><input type="checkbox" name="options" value="cheese"> Сыр (+50 ₸)</label><br>
                        <label><input type="checkbox" name="options" value="pepperoni"> Колбаса (+100 ₸)</label><br>
                        <label><input type="checkbox" name="options" value="mushrooms"> Грибы (+70 ₸)</label><br>
                        <label><input type="checkbox" name="options" value="olives"> Оливки (+60 ₸)</label>
                        <% } else if (cat.contains("бургер") || cat.contains("burger")) { %>
                        <label><input type="checkbox" name="options" value="cheese"> Сыр (+50 ₸)</label><br>
                        <label><input type="checkbox" name="options" value="onion"> Лук (+30 ₸)</label><br>
                        <label><input type="checkbox" name="options" value="patty"> Котлета (+150 ₸)</label><br>
                        <label><input type="checkbox" name="options" value="sauce"> Соус (+40 ₸)</label>
                        <% } else if (cat.contains("напитки") || cat.contains("drink")) { %>
                        <label><input type="checkbox" name="options" value="ice"> Со льдом</label><br>
                        <label><input type="checkbox" name="options" value="sugar"> C сахаром</label>
                        <% } else { %>
                        <label><input type="checkbox" name="options" value="cheese"> Доп. сыр (+50 ₸)</label>
                        <% } %>
                    </div>

                    <button type="submit" class="btn-add" style="width: 100%; padding: 10px; background: #d4a574; color: white; border: none; border-radius: 4px; cursor: pointer;">
                        В корзину 🛒
                    </button>
                </form>
            </div>
        </div>

        <%
            }
        %>

    </div>
</div>

<script>
    function filterMenu() {
        let input = document.getElementById('menuSearch').value.toLowerCase();
        let cards = document.getElementsByClassName('menu-card');

        for (let i = 0; i < cards.length; i++) {
            let name = cards[i].getElementsByTagName('h3')[0].innerText.toLowerCase();
            if (name.includes(input)) {
                cards[i].style.display = "";
            } else {
                cards[i].style.display = "none";
            }
        }
    }
</script>

</body>
</html>
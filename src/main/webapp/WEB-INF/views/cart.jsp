<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.gauhar.restaurant.model.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.Optional" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    // Получаем корзину из сессии
    Cart cart = (Cart) session.getAttribute("cart");
    if (cart == null) cart = new Cart();

    List<CartItem> items = Optional.ofNullable(cart.getItems())
            .orElse(new ArrayList<>());

    // Информация о ресторане для заголовка
    com.gauhar.restaurant.model.Restaurant _r =
            (com.gauhar.restaurant.model.Restaurant) request.getAttribute("restaurant");

    if (_r == null) _r = new com.gauhar.restaurant.model.Restaurant();

    String restaurantName =
            (_r.getName() != null && !_r.getName().isBlank())
                    ? _r.getName()
                    : "🎍 Ресторан";

    request.setAttribute("navRestaurantName", restaurantName);
    request.setAttribute("navActivePage", "cart");
%>

<!doctype html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Корзина — <%= restaurantName %></title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles.css">

    <style>
        .qty-box {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 6px;
            margin-top: 8px;
        }

        .qty-btn {
            background: #eee;
            border: none;
            padding: 6px 10px;
            cursor: pointer;
            border-radius: 6px;
            font-weight: bold;
            transition: 0.2s;
        }

        .qty-btn:hover { background: #ddd; }

        .qty-num {
            min-width: 30px;
            text-align: center;
            font-weight: 600;
        }

        .order-checkout-card {
            background: white;
            border-radius: 12px;
            padding: 24px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            border: 2px solid #d4a574;
            position: sticky;
            top: 20px;
        }

        .form-input {
            width: 100%;
            padding: 12px;
            margin-top: 5px;
            margin-bottom: 15px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 14px;
        }

        .form-label {
            font-size: 13px;
            font-weight: 600;
            color: #555;
            display: block;
        }
    </style>
</head>

<body>

<jsp:include page="includes/navbar.jsp" />

<div class="page-wrapper">

    <div class="page-header-bar">
        <h2 class="page-title">🛒 Ваша корзина</h2>
    </div>

    <jsp:include page="includes/flash.jsp" />

    <% if (items.isEmpty()) { %>

    <div class="kitchen-empty">
        <div style="font-size: 64px;">😔</div>
        <h3>Корзина пустая</h3>
        <p>Кажется, вы еще ничего не выбрали.</p>
        <br>
        <a href="${pageContext.request.contextPath}/menu-items" class="btn primary">Перейти в меню</a>
    </div>

    <% } else { %>

    <div style="display: flex; flex-wrap: wrap; gap: 30px; align-items: flex-start;">

        <div style="flex: 2; min-width: 300px;">
            <div class="kitchen-grid" style="grid-template-columns: 1fr;">

                <% for (CartItem item : items) {
                    if (item == null) continue;
                    String name = item.getName() != null ? item.getName() : "Блюдо";
                    int qty = item.getQuantity();
                    double price = item.getTotalPrice();
                    List<String> opts = Optional.ofNullable(item.getOptions()).orElse(Collections.emptyList());
                %>

                <div class="kitchen-card" style="display: flex; justify-content: space-between; align-items: center;">
                    <div>
                        <div class="k-name"><%= name %></div>
                        <div class="k-items" style="font-size: 12px; color: #888;">
                            <% if (opts.isEmpty()) { %>
                            Без добавок
                            <% } else { %>
                            <%= String.join(", ", opts) %>
                            <% } %>
                        </div>
                        <div class="k-total" style="margin-top: 5px;"><%= (int)price %> ₸</div>
                    </div>

                    <div style="text-align: right;">
                        <div class="qty-box">
                            <form action="${pageContext.request.contextPath}/cart/update" method="post">
                                <input type="hidden" name="menuItemId" value="<%= item.getMenuItemId() %>">
                                <input type="hidden" name="quantity" value="<%= qty - 1 %>">
                                <button type="submit" class="qty-btn" <%= qty <= 1 ? "disabled" : "" %>>−</button>
                            </form>

                            <div class="qty-num"><%= qty %></div>

                            <form action="${pageContext.request.contextPath}/cart/update" method="post">
                                <input type="hidden" name="menuItemId" value="<%= item.getMenuItemId() %>">
                                <input type="hidden" name="quantity" value="<%= qty + 1 %>">
                                <button type="submit" class="qty-btn">+</button>
                            </form>
                        </div>

                        <form action="${pageContext.request.contextPath}/cart/remove" method="post" style="margin-top:8px;">
                            <input type="hidden" name="menuItemId" value="<%= item.getMenuItemId() %>">
                            <button type="submit" style="background:none; border:none; color:#c00; cursor:pointer; font-size:12px; text-decoration:underline;">
                                Удалить
                            </button>
                        </form>
                    </div>
                </div>

                <% } %>

            </div>
        </div>

        <div style="flex: 1; min-width: 320px;">
            <div class="order-checkout-card">
                <h3 style="margin-top: 0; color: #333;">Итого к оплате</h3>
                <div style="font-size: 28px; font-weight: 800; color: #d4a574; margin-bottom: 20px;">
                    <%= (int)cart.getTotal() %> ₸
                </div>

                <form action="${pageContext.request.contextPath}/orders/create" method="post">
                    <div class="form-group">
                        <label class="form-label" for="customerName">Ваше имя *</label>
                        <input type="text" id="customerName" name="customerName" class="form-input"
                               placeholder="Александр" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="phone">Контактный телефон *</label>
                        <input type="text" id="phone" name="phone" class="form-input"
                               placeholder="+7 (777) 000-00-00" required>
                    </div>

                    <%-- CSRF Токен для Spring Security --%>
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

                    <button type="submit" class="btn primary full-width" style="padding: 15px; font-size: 16px; margin-top: 10px;">
                        🚀 Подтвердить заказ
                    </button>
                </form>

                <p style="font-size: 11px; color: #999; margin-top: 15px; text-align: center;">
                    Нажимая кнопку, вы подтверждаете согласие с условиями доставки.
                </p>
            </div>
        </div>

    </div>

    <% } %>

</div>

<jsp:include page="includes/footer.jsp" />
</body>
</html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="com.gauhar.restaurant.model.Restaurant" %>
<%
    Restaurant _r = (Restaurant) request.getAttribute("restaurant");
    String restaurantName = (_r != null && _r.getName() != null && !_r.getName().isBlank()) ? _r.getName() : "🎍 Ресторан";
    request.setAttribute("navRestaurantName", restaurantName);
    request.setAttribute("navActivePage", "menu");
%>

<!doctype html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Заказ еды — <%= restaurantName %></title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles.css">
    <style>
        .quantity-selector {
            display: flex; align-items: center; gap: 8px; margin: 12px 0;
        }
        .quantity-selector button {
            background: var(--card); border: 1px solid var(--border); padding: 6px 12px;
            cursor: pointer; border-radius: 6px; color: var(--text); font-weight: bold;
        }
        .quantity-selector input {
            width: 50px; text-align: center; padding: 6px;
            border: 1px solid var(--border); border-radius: 6px; background: var(--card); color: var(--text);
        }
    </style>
</head>
<body>

<jsp:include page="includes/navbar.jsp" />

<div class="page-wrapper">
    <div class="page-header-bar">
        <h2 class="page-title">🛒 Ресторан - Заказ еды</h2>
    </div>

    <jsp:include page="includes/flash.jsp" />

    <div class="menu-grid">
        <c:forEach var="pizza" items="${pizzas}">
            <div class="menu-card">
                <div class="menu-body">
                    <h3>${pizza.name}</h3>
                    <div class="menu-row">
                        <span class="menu-price">${pizza.price} ₸</span>
                    </div>

                    <form method="POST" action="${pageContext.request.contextPath}/cart/add">
                        <div style="margin: 12px 0;">
                            <h4 style="font-size: 14px; color: var(--text-muted); margin-bottom: 8px;">Добавки:</h4>

                            <div style="display: flex; flex-direction: column; gap: 6px;">
                                <label style="display: flex; align-items: center; gap: 8px; cursor: pointer; color: var(--text);">
                                    <input type="checkbox" name="options" value="cheese">
                                    <span>🧀 Сыр (+50 ₸)</span>
                                </label>
                                <label style="display: flex; align-items: center; gap: 8px; cursor: pointer; color: var(--text);">
                                    <input type="checkbox" name="options" value="pepperoni">
                                    <span>🌶️ Колбаса (+100 ₸)</span>
                                </label>
                                <label style="display: flex; align-items: center; gap: 8px; cursor: pointer; color: var(--text);">
                                    <input type="checkbox" name="options" value="mushrooms">
                                    <span>🍄 Грибы (+80 ₸)</span>
                                </label>
                            </div>
                        </div>

                        <div class="quantity-selector">
                            <button type="button" onclick="decreaseQuantity(this)" class="btn ghost small">−</button>
                            <input type="number" name="quantity" value="1" min="1" readonly>
                            <button type="button" onclick="increaseQuantity(this)" class="btn ghost small">+</button>
                        </div>

                        <input type="hidden" name="menuItemId" value="${pizza.id}">
                        <button type="submit" class="btn primary full-width">🛒 В корзину</button>
                    </form>
                </div>
            </div>
        </c:forEach>
    </div>
</div>

<jsp:include page="includes/footer.jsp" />

<script>
    function increaseQuantity(btn) {
        const input = btn.parentElement.querySelector('input');
        input.value = parseInt(input.value) + 1;
    }
    function decreaseQuantity(btn) {
        const input = btn.parentElement.querySelector('input');
        if (input.value > 1) input.value = parseInt(input.value) - 1;
    }
</script>

</body>
</html>

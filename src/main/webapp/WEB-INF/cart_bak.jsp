<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.gauhar.restaurant.model.*" %>
<%@ page import="java.util.*" %>

<%
  Cart cart = (Cart) session.getAttribute("cart");
  if (cart == null) cart = new Cart();

  List<CartItem> items = (cart.getItems() != null)
          ? cart.getItems()
          : new ArrayList<>();
%>

<html>
<head>
  <title>Корзина</title>
</head>

<body>

<h1>🛒 Ваша корзина</h1>

<% if (items.isEmpty()) { %>

<p>Корзина пустая 😔</p>

<% } else { %>

<% for (int i = 0; i < items.size(); i++) {

  CartItem item = items.get(i);
  if (item == null) continue;

  String name = item.getName() != null ? item.getName() : "Блюдо";
  int qty = item.getQuantity();
  double price = item.getTotalPrice();
%>

<div style="margin-bottom:15px;">

  <h3><%= name %></h3>

  <p>Количество: <b><%= qty %></b></p>

  <p>Цена: <b><%= (int)price %> ₸</b></p>

  <form action="cart/remove" method="post" style="display:inline;">
    <input type="hidden" name="index" value="<%= i %>">
    <button type="submit">❌ Удалить</button>
  </form>

</div>

<hr>

<% } %>

<h2>Итого: <%= (int) cart.getTotal() %> ₸</h2>

<form action="<%= request.getContextPath() %>/order/create" method="post">
  <button type="submit">✅ Оформить заказ</button>
</form>

<% } %>

</body>
</html>
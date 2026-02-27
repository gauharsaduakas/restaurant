<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.gauhar.restaurant.model.*" %>
<%@ page import="java.util.*" %>

<%
    String ctx = request.getContextPath();

    Restaurant r = (Restaurant) request.getAttribute("restaurant");
    String restaurantName = (r != null && r.getName() != null) ? r.getName() : "Restaurant";

    List<Order> orders = (List<Order>) request.getAttribute("orders");
    if (orders == null) orders = new ArrayList<>();

    List<MenuItem> menu = (List<MenuItem>) request.getAttribute("menu");
    if (menu == null) menu = new ArrayList<>();

    double revenue = 0.0;
    for (Order o : orders) {
        if (o != null) revenue += o.getTotalAmount();
    }
%>

<!doctype html>
<html lang="kk">
<head>
    <meta charset="UTF-8">
    <title>Orders</title>
    <link rel="stylesheet" href="<%=ctx%>/assets/styles.css">
</head>
<body>

<div class="navbar">
    <div class="nav-inner">
        <a class="brand" href="<%=ctx%>/">
            <span class="logo"></span>
            Restaurant System
        </a>
        <div class="nav-links">
            <a class="nav-link" href="<%=ctx%>/menu">Menu</a>
            <a class="nav-link active" href="<%=ctx%>/orders">Orders</a>
        </div>
    </div>
</div>

<div class="container">
    <div class="card">
        <div class="card-title">
            <div>
                <h2>Orders</h2>
                <p class="sub"><%= restaurantName %> — тапсырыстар</p>
            </div>
            <div class="kpi">
                <span class="badge">Orders: <%= orders.size() %></span>
                <span class="badge">Revenue: <%= revenue %> ₸</span>
            </div>
        </div>

        <div class="grid two">

            <!-- CREATE ORDER -->
            <div class="card">
                <h3>Create Order</h3>
                <div class="hr"></div>

                <form method="post" action="<%=ctx%>/orders">
                    <div class="form-row">
                        <label>Customer</label>
                        <input name="customerName" placeholder="e.g. Ali" required>
                    </div>

                    <div class="form-row">
                        <label>Menu item</label>
                        <select name="menuItemId" required>
                            <% for (MenuItem m : menu) { %>
                            <option value="<%=m.getId()%>">
                                <%=m.getName()%> — <%=m.getPrice()%> ₸
                            </option>
                            <% } %>
                        </select>
                    </div>

                    <div class="form-row">
                        <label>Quantity</label>
                        <input name="quantity" type="number" min="1" value="1" required>
                    </div>

                    <div class="actions">
                        <button class="btn primary" type="submit">Create Order</button>
                        <a class="btn ghost" href="<%=ctx%>/menu">Back to Menu</a>
                    </div>
                </form>
            </div>

            <!-- ORDERS LIST -->
            <div class="card">
                <h3>Orders List</h3>
                <div class="hr"></div>

                <% if (orders.isEmpty()) { %>
                <div class="empty">Әзірге тапсырыс жоқ</div>
                <% } else { %>
                <div class="table-wrap">
                    <table>
                        <thead>
                        <tr>
                            <th>ID</th>
                            <th>Customer</th>
                            <th>Items</th>
                            <th class="right">Total</th>
                            <th>Status</th>
                        </tr>
                        </thead>
                        <tbody>

                        <% for (Order o : orders) { %>
                        <tr>
                            <td>#<%=o.getId()%></td>
                            <td><%=o.getCustomerName()%></td>
                            <td>
                                <% if (o.getItems() == null || o.getItems().isEmpty()) { %>
                                <div class="muted">No items</div>
                                <% } else { %>
                                <% for (OrderItem oi : o.getItems()) { %>
                                <div>
                                    <%= oi.getMenuItem() != null ? oi.getMenuItem().getName() : "Unknown" %>
                                    × <%= oi.getQuantity() %>
                                </div>
                                <% } %>
                                <% } %>
                            </td>
                            <td class="right"><%=o.getTotalAmount()%> ₸</td>
                            <td><%=o.getStatus()%></td>
                        </tr>
                        <% } %>

                        </tbody>
                    </table>
                </div>
                <% } %>

                <div class="hr"></div>
                <div class="actions">
                    <a class="btn ghost" href="<%=ctx%>/">Home</a>
                    <a class="btn primary" href="<%=ctx%>/menu">Add MenuItem</a>
                </div>
            </div>

        </div>
    </div>
</div>

</body>
</html>
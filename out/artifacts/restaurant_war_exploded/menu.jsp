<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="com.gauhar.restaurant.model.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.NumberFormat" %>
<%
    String ctx = request.getContextPath();
    Restaurant r = (Restaurant) request.getAttribute("restaurant");

    List<MenuItem> items = (List<MenuItem>) request.getAttribute("items");
    if (items == null) items = new ArrayList<>();

    NumberFormat nf = NumberFormat.getNumberInstance(new Locale("ru", "KZ"));
%>
<!doctype html>
<html lang="kk">
<head>
    <meta charset="UTF-8">
    <title>Menu</title>
    <link rel="stylesheet" href="<%=ctx%>/styles.css">
</head>
<body>

<div class="navbar">
    <div class="nav-inner">
        <a class="brand" href="<%=ctx%>/">
            <span class="logo"></span>
            Restaurant System
        </a>
        <div class="nav-links">
            <a class="nav-link active" href="<%=ctx%>/menu">Menu</a>
            <a class="nav-link" href="<%=ctx%>/orders">Orders</a>
        </div>
    </div>
</div>

<div class="container">
    <div class="card">
        <div class="card-title">
            <div>
                <h2>Menu</h2>
                <p class="sub">
                    <%= (r != null ? r.getName() : "Restaurant") %> — мәзірді басқару
                </p>
            </div>
            <div class="kpi">
                <span class="badge">Items: <%= items.size() %></span>
            </div>
        </div>

        <div class="grid two">
            <!-- Add MenuItem -->
            <div class="card">
                <h3>Add MenuItem</h3>
                <p class="sub">doPost арқылы жаңа тағам қосылады</p>
                <div class="hr"></div>

                <form method="post" action="<%=ctx%>/menu">
                    <div class="form-row">
                        <label>Item name</label>
                        <input name="name" placeholder="e.g. Pasta" required>
                    </div>

                    <div class="form-row">
                        <label>Category</label>
                        <input name="category" placeholder="e.g. Main dish" required>
                    </div>

                    <div class="form-row">
                        <label>Price</label>
                        <input name="price" type="number" step="0.01" placeholder="e.g. 2500" required>
                    </div>

                    <div class="form-row">
                        <label>Photo URL / Path</label>
                        <input name="imageUrl" placeholder="/assets/img/pasta.jpg">
                    </div>

                    <div class="form-row">
                        <label class="switch">
                            <input type="checkbox" name="isAvailable" checked>
                            <span class="toggle"></span>
                            <span class="hint">Available</span>
                        </label>
                    </div>

                    <div class="actions">
                        <button class="btn primary" type="submit">Add Item</button>
                        <a class="btn ghost" href="<%=ctx%>/orders">Go to Orders</a>
                    </div>
                </form>
            </div>

            <!-- Menu Cards -->
            <div class="card">
                <h3>Menu Items</h3>
                <p class="sub">doGet арқылы тізім көрсетіледі</p>
                <div class="hr"></div>

                <% if (items.isEmpty()) { %>
                <div class="empty">Әзірге тағам жоқ. Сол жақтағы формамен қос.</div>
                <% } else { %>
                <div class="menu-grid">
                    <% for (MenuItem m : items) { %>
                    <div class="menu-card">
                        <div class="menu-img">
                            <%
                                String img = m.getImageUrl();
                                boolean hasImg = (img != null && !img.isBlank());
                                String src = hasImg
                                        ? (img.startsWith("http") ? img : (ctx + img))
                                        : (ctx + "/assets/img/placeholder.jpg");
                            %>
                            <img src="<%= src %>" alt="<%= m.getName() %>">
                        </div>

                        <div class="menu-body">
                            <h3><%= m.getName() %>
                            </h3>
                            <div class="menu-category">
                                <%= (m.getCategory() == null || m.getCategory().isBlank()) ? "No category" : m.getCategory() %>
                            </div>
                            <div class="menu-row">
                                <span class="menu-price"><%= nf.format(m.getPrice()) %> ₸</span>
                                <% if (m.isAvailable()) { %>
                                <span class="menu-badge ok">Available</span>
                                <% } else { %>
                                <span class="menu-badge no">Not available</span>
                                <% } %>
                            </div>
                            <div class="menu-actions">
                                <a class="btn small ghost" href="<%=ctx%>/menu/edit?id=<%=m.getId()%>">✏️ Edit</a>
                                <form method="post" action="<%=ctx%>/menu/delete"
                                      onsubmit="return confirm('Delete this item?');">
                                    <input type="hidden" name="id" value="<%=m.getId()%>">
                                    <button class="btn small danger" type="submit">🗑 Delete</button>
                                </form>
                            </div>
                        </div>
                    </div>
                    <% } %>
                </div>
                <% } %>
            </div>
        </div>
    </div>
</div>
</body>
</html>

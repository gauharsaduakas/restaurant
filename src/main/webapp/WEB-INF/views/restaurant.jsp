<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.gauhar.restaurant.model.Restaurant" %>
<%@ page import="org.springframework.security.core.Authentication" %>
<%@ page import="org.springframework.security.core.context.SecurityContextHolder" %>
<%@ page import="org.springframework.security.core.GrantedAuthority" %>
<%@ page import="org.springframework.security.web.csrf.CsrfToken" %>
<%
    Restaurant r = (Restaurant) request.getAttribute("restaurant");

    String name         = (r != null && r.getName() != null) ? r.getName() : "";
    String restaurantName = !name.isBlank() ? name : "Restaurant";
    String address      = (r != null && r.getAddress() != null) ? r.getAddress() : "";
    String phone        = (r != null && r.getPhone() != null) ? r.getPhone() : "";
    String workHours    = (r != null && r.getWorkHours() != null) ? r.getWorkHours() : "";
    String desc         = (r != null && r.getDescription() != null) ? r.getDescription() : "";

    Authentication auth = SecurityContextHolder.getContext().getAuthentication();
    boolean isAdmin = (auth != null && auth.isAuthenticated())
            ? auth.getAuthorities().stream()
            .map(GrantedAuthority::getAuthority)
            .anyMatch(a -> a.equals("ROLE_ADMIN"))
            : false;

    CsrfToken csrf = (CsrfToken) request.getAttribute(CsrfToken.class.getName());
    String token = csrf != null ? csrf.getToken() : "";
    String headerName = csrf != null ? csrf.getHeaderName() : "_csrf";

    request.setAttribute("navRestaurantName", restaurantName);
    request.setAttribute("navActivePage", "restaurant");
%>
<!doctype html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>О ресторане — <%= restaurantName %></title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles.css">
</head>
<body>

<jsp:include page="includes/navbar.jsp" />

<div class="page-wrapper">
    <div class="page-header-bar">
        <div class="page-title">О ресторане</div>
    </div>

    <jsp:include page="includes/flash.jsp" />

    <div class="form-card" style="max-width:600px;margin:auto">
        <% if (isAdmin) { %>
        <form method="post" action="${pageContext.request.contextPath}/restaurant">
            <input type="hidden" name="<%= headerName %>" value="<%= token %>">
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
        <div class="info-box">
            <div class="form-row"><strong>Название:</strong> <%= name %></div>
            <div class="form-row"><strong>Адрес:</strong> <%= address %></div>
            <div class="form-row"><strong>Телефон:</strong> <%= phone %></div>
            <div class="form-row"><strong>Режим работы:</strong> <%= workHours %></div>
            <div class="form-row"><strong>Описание:</strong> <%= desc %></div>
        </div>
        <% } %>
    </div>
</div>

<jsp:include page="includes/footer.jsp" />
</body>
</html>

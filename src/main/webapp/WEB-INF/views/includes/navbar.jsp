<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%-- NAVBAR: Общий компонент для навигации --%>
<%@ page import="org.springframework.security.core.Authentication" %>
<%@ page import="org.springframework.security.core.GrantedAuthority" %>
<%@ page import="org.springframework.security.core.context.SecurityContextHolder" %>
<%
    String _navCtx = request.getContextPath();
    String _navRestaurantName = (String) request.getAttribute("navRestaurantName");
    if (_navRestaurantName == null || _navRestaurantName.isBlank()) {
        _navRestaurantName = "🎍 Ресторан";
    }

    String _navActivePage = (String) request.getAttribute("navActivePage");
    if (_navActivePage == null) _navActivePage = "";

    Authentication _navAuth = SecurityContextHolder.getContext().getAuthentication();
    boolean _navIsAdmin = (_navAuth != null && _navAuth.isAuthenticated())
            ? _navAuth.getAuthorities().stream()
            .map(GrantedAuthority::getAuthority)
            .anyMatch(a -> a.equals("ROLE_ADMIN"))
            : false;

    boolean _navIsClient = (_navAuth != null && _navAuth.isAuthenticated())
            ? _navAuth.getAuthorities().stream()
            .map(GrantedAuthority::getAuthority)
            // Проверяем и CLIENT, и USER для надежности
            .anyMatch(a -> a.equals("ROLE_CLIENT") || a.equals("ROLE_USER"))
            : false;
%>

<div class="navbar">
    <div class="nav-inner">
        <a class="brand" href="${pageContext.request.contextPath}/home"><%= _navRestaurantName %></a>
        <div class="nav-links">
            <a class="nav-link <%= _navActivePage.equals("home") ? "active" : "" %>" href="${pageContext.request.contextPath}/home">Главная</a>
            <a class="nav-link <%= _navActivePage.equals("menu") ? "active" : "" %>" href="${pageContext.request.contextPath}/menu-items">Меню</a>

            <% if (_navIsAdmin) { %>
            <a class="nav-link <%= _navActivePage.equals("orders") ? "active" : "" %>" href="${pageContext.request.contextPath}/orders">📋 Заказы</a>
            <a class="nav-link <%= _navActivePage.equals("kitchen") ? "active" : "" %>" href="${pageContext.request.contextPath}/kitchen">👨‍🍳 Кухня</a>
            <a class="nav-link <%= _navActivePage.equals("admin") ? "active" : "" %>" href="${pageContext.request.contextPath}/admin/users">👥 Пользователи</a>
            <% } else if (_navIsClient) { %>
            <%-- Эти кнопки теперь появятся у обычного пользователя --%>
            <a class="nav-link <%= _navActivePage.equals("cart") ? "active" : "" %>" href="${pageContext.request.contextPath}/cart">🛒 Корзина</a>
            <a class="nav-link <%= _navActivePage.equals("my-orders") ? "active" : "" %>" href="${pageContext.request.contextPath}/my-orders">📋 Мои заказы</a>
            <a class="nav-link" href="${pageContext.request.contextPath}/profile">👤 Профиль</a>
            <% } %>

            <a class="nav-link" href="${pageContext.request.contextPath}/logout">🚪 Выход</a>
        </div>
    </div>
</div>


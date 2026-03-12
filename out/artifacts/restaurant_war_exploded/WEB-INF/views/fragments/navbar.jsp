<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.gauhar.restaurant.model.Restaurant" %>
<%@ page import="org.springframework.security.core.Authentication" %>
<%@ page import="org.springframework.security.core.context.SecurityContextHolder" %>
<%@ page import="org.springframework.security.core.GrantedAuthority" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%
    String ctx = request.getContextPath();

    Restaurant _r = (Restaurant) request.getAttribute("restaurant");
    String _rName = (_r != null && _r.getName() != null && !_r.getName().isBlank())
            ? _r.getName() : "Gauhar Restaurant";

    String _activePage = (String) request.getAttribute("activePage");
    if (_activePage == null) _activePage = "";

    // Читаем роль из Spring Security (не из сессии)
    Authentication _auth = SecurityContextHolder.getContext().getAuthentication();
    boolean _isLoggedIn = _auth != null && _auth.isAuthenticated()
            && !_auth.getPrincipal().equals("anonymousUser");
    boolean _isAdmin = false;
    boolean _isClient = false;
    if (_isLoggedIn) {
        for (GrantedAuthority ga : _auth.getAuthorities()) {
            if ("ROLE_ADMIN".equals(ga.getAuthority())) { _isAdmin = true; }
            if ("ROLE_CLIENT".equals(ga.getAuthority())) { _isClient = true; }
        }
    }
%>

<div class="navbar">
    <div class="nav-inner">
        <a class="brand" href="<%= ctx %>/home">🎍 <%= _rName %></a>

        <div class="nav-links">

            <% if (_isAdmin) { %>
            <a class="nav-link <%= "home".equals(_activePage) ? "active" : "" %>"
               href="<%= ctx %>/home">Главная</a>
            <a class="nav-link <%= "menu".equals(_activePage) ? "active" : "" %>"
               href="<%= ctx %>/menu-items">Меню</a>
            <a class="nav-link <%= "orders".equals(_activePage) ? "active" : "" %>"
               href="<%= ctx %>/orders">Заказы</a>
            <a class="nav-link <%= "kitchen".equals(_activePage) ? "active" : "" %>"
               href="<%= ctx %>/kitchen">Кухня</a>
            <a class="nav-link <%= "restaurant".equals(_activePage) ? "active" : "" %>"
               href="<%= ctx %>/restaurant">О ресторане</a>

            <% } else if (_isClient) { %>
            <a class="nav-link <%= "home".equals(_activePage) ? "active" : "" %>"
               href="<%= ctx %>/home">Главная</a>
            <a class="nav-link <%= "menu".equals(_activePage) ? "active" : "" %>"
               href="<%= ctx %>/menu-items">Меню</a>
            <a class="nav-link <%= "orders".equals(_activePage) ? "active" : "" %>"
               href="<%= ctx %>/orders">Мои заказы</a>
            <a class="nav-link <%= "board".equals(_activePage) ? "active" : "" %>"
               href="<%= ctx %>/board">Табло</a>

            <% } else { %>
            <a class="nav-link <%= "home".equals(_activePage) ? "active" : "" %>"
               href="<%= ctx %>/home">Главная</a>
            <a class="nav-link <%= "login".equals(_activePage) ? "active" : "" %>"
               href="<%= ctx %>/login">Войти</a>
            <a class="nav-link <%= "register".equals(_activePage) ? "active" : "" %>"
               href="<%= ctx %>/register">Регистрация</a>
            <% } %>

            <% if (_isLoggedIn) { %>
            <form method="post" action="<%= ctx %>/logout" style="display:inline;">
                <sec:csrfInput/>
                <button type="submit" class="nav-link"
                        style="background:none;border:none;cursor:pointer;color:#f87171;padding:0;font:inherit;">Выйти</button>
            </form>
            <% } %>

        </div>
    </div>
</div>


<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.gauhar.restaurant.model.Restaurant" %>
<%
    Restaurant _rStart = (Restaurant) request.getAttribute("restaurant");
    String restaurantName = (_rStart != null && _rStart.getName() != null && !_rStart.getName().isBlank()) ? _rStart.getName() : "Gauhar Restaurant";
%>
<!doctype html>
<html lang="ru">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title><%= restaurantName %> — Вход</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/styles.css">
</head>
<body>
<div style="min-height:100vh;display:flex;align-items:center;justify-content:center;padding:24px;">
  <div class="form-card" style="width:100%;max-width:500px;text-align:center;">
    <div style="margin-bottom:28px;">
      <div style="font-size:56px;margin-bottom:12px;">🎍</div>
      <h1 style="font-size:28px;font-weight:800;color:var(--green);margin-bottom:8px;">
        <%= restaurantName %>
      </h1>
      <p style="color:var(--sub);font-size:14px;">
        Добро пожаловать в систему ресторана
      </p>
    </div>

    <div style="display:flex;flex-direction:column;gap:14px;">
      <a class="btn primary full-width" href="${pageContext.request.contextPath}/login?role=ADMIN">
        Войти как администратор
      </a>

      <a class="btn ghost full-width" href="${pageContext.request.contextPath}/login?role=CLIENT">
        Войти как клиент
      </a>

      <a class="btn full-width" style="background:#f3f7ed;color:#2f4f1f;border:1px solid #d7e5c6;"
         href="${pageContext.request.contextPath}/register">
        Зарегистрироваться как клиент
      </a>
    </div>
  </div>
</div>
</body>
</html>
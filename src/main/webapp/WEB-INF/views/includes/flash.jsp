<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%-- FLASH MESSAGES: Компонент для вывода уведомлений --%>
<%
    String _flashSuccess = (String) session.getAttribute("flash_success");
    String _flashError = (String) session.getAttribute("flash_error");

    if (_flashSuccess != null) {
        session.removeAttribute("flash_success");
    }
    if (_flashError != null) {
        session.removeAttribute("flash_error");
    }
%>

<% if (_flashSuccess != null) { %>
    <div class="toast success">✅ <%= _flashSuccess %></div>
<% } %>

<% if (_flashError != null) { %>
    <div class="toast error">❌ <%= _flashError %></div>
<% } %>


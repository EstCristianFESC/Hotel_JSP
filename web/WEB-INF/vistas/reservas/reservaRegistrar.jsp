<%@ page contentType="text/html;charset=UTF-8" %>
<%@page import="java.util.*, modelo.Cliente"%>
<%@page import="java.util.*, modelo.Habitacion"%>
<%@page import="java.util.*, modelo.Reserva"%>

<h2>Crear Reserva</h2>

<c:if test="${not empty error}">
    <div style="color:red; font-weight:bold;">${error}</div>
</c:if>

<form action="ReservaServlet" method="post">

    <input type="hidden" name="accion" value="guardar" />

    <label>Cliente:</label>
    <select name="clienteId" required>
        <c:forEach var="c" items="${clientes}">
            <option value="${c.id}">${c.nombre} - ${c.documento}</option>
        </c:forEach>
    </select>
    <br /><br />

    <label>Habitación:</label>
    <select name="habitacion" required>
        <c:forEach var="h" items="${habitaciones}">
            <option value="${h.numero}">
                Habitación ${h.numero} — ${h.tipo} — $${h.precio}
            </option>
        </c:forEach>
    </select>
    <br /><br />

    <label>Fecha de entrada:</label>
    <input type="date" name="entrada" required />
    <br /><br />

    <label>Fecha de salida:</label>
    <input type="date" name="salida" required />
    <br /><br />

    <button type="submit">Guardar Reserva</button>

</form>
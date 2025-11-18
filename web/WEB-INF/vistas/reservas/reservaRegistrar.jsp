<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<h2>Registrar Reserva</h2>

<form action="${pageContext.request.contextPath}/ReservaController" method="post">
    <input type="hidden" name="accion" value="guardar">

    <!-- Seleccionar Cliente -->
    <label for="clienteId">Cliente:</label>
    <select name="clienteId" id="clienteId" required>
        <c:forEach var="cliente" items="${clientes}">
            <option value="${cliente.id}">${cliente.nombre}</option>
        </c:forEach>
    </select>
    <br><br>

    <!-- Seleccionar Fechas -->
    <label for="fechaEntrada">Fecha Entrada:</label>
    <input type="date" id="fechaEntrada" name="fechaEntrada" required>
    <br><br>

    <label for="fechaSalida">Fecha Salida:</label>
    <input type="date" id="fechaSalida" name="fechaSalida" required>
    <br><br>

    <!-- Seleccionar Habitación -->
    <label for="habitacionNumero">Habitación:</label>
    <select name="habitacionNumero" id="habitacionNumero" required>
        <c:forEach var="hab" items="${habitacionesDisponibles}">
            <option value="${hab.numero}">${hab.tipo} - ${hab.numero} - $${hab.precioPorNoche}</option>
        </c:forEach>
    </select>
    <br><br>

    <!-- Total (se puede calcular en backend) -->
    <label for="total">Total:</label>
    <input type="text" id="total" name="total" readonly value="${total}">
    <br><br>

    <button type="submit">Registrar Reserva</button>
</form>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="modelo.Cliente" %>

<div class="container mt-4">
    <h3>Registrar Reserva</h3>

    <!-- BUSCAR CLIENTE POR CÉDULA -->
    <form method="get" action="${pageContext.request.contextPath}/ClienteController">
        <input type="hidden" name="accion" value="buscarPorCedula">
        <div class="row mb-3">
            <div class="col-4">
                <label for="clienteIdInput" class="form-label">Cédula Cliente</label>
                <%
                    Cliente c = (Cliente) request.getAttribute("clienteReserva");
                    String cedulaValor = (c != null && c.getId() != null) ? c.getId() : 
                                         (request.getParameter("cedula") != null ? request.getParameter("cedula") : "");
                %>
                <input type="text" class="form-control" id="clienteIdInput" name="cedula"
                       value="<%= cedulaValor %>">
            </div>

            <div class="col-6">
                <label for="clienteNombre" class="form-label">Nombre</label>
                <%
                    String nombreCompleto = "";
                    if (c != null) {
                        nombreCompleto = (c.getNombre() != null ? c.getNombre() : "") + " " +
                                         (c.getApellido() != null ? c.getApellido() : "");
                        nombreCompleto = nombreCompleto.trim();
                    }
                %>
                <input type="text" class="form-control" id="clienteNombre" readonly
                       value="<%= nombreCompleto %>">
            </div>

            <div class="col-2 d-flex align-items-end">
                <button type="submit" class="btn btn-primary w-100">Buscar</button>
            </div>
        </div>
    </form>

    <%-- Mensaje si no se encuentra el cliente --%>
    <% if (c == null && request.getParameter("cedula") != null && !request.getParameter("cedula").isBlank()) { %>
        <div class="alert alert-warning mt-2">
            Cliente no encontrado.
        </div>
    <% } %>
</div>
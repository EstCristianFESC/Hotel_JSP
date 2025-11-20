<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.*, modelo.Habitacion"%>

<div class="container-fluid py-4">
    <h2 class="fw-semibold text-dark mb-4">
        <i class="bi bi-door-closed me-2"></i>Consultar Habitaciones
    </h2>

    <!-- Mensaje -->
    <div id="mensajeHabitacion"
         class="toast align-items-center text-bg-<%= (request.getAttribute("tipoMensaje") != null) ? request.getAttribute("tipoMensaje").toString().replace("alert-", "") : "info" %> border-0"
         role="alert" aria-live="assertive" aria-atomic="true"
         style="position: fixed; top: 1rem; right: 1rem; min-width: 260px; z-index: 9999;">
        <div class="d-flex">
            <div class="toast-body" style="font-size: 0.85rem;">
                <%= (request.getAttribute("mensaje") != null) ? request.getAttribute("mensaje") : "Ingrese criterios de búsqueda." %>
            </div>
            <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
        </div>
    </div>

    <div class="card shadow-lg border-0 rounded-4">
        <div class="card-body px-4 py-4">

            <!-- Formulario de búsqueda -->
            <form id="formBuscarHabitacion" action="${pageContext.request.contextPath}/HabitacionController" method="get" class="row g-3 mb-4">
                <div class="col-md-4">
                    <label for="buscarNumero" class="form-label fw-semibold">Número de Habitación:</label>
                    <input type="number" class="form-control" id="buscarNumero" name="numero" placeholder="Número de habitación"
                           value="<%= request.getParameter("numero") != null ? request.getParameter("numero") : "" %>">
                </div>
                <div class="col-md-4">
                    <label for="buscarEstado" class="form-label fw-semibold">Estado:</label>
                    <select class="form-select" id="buscarEstado" name="estado">
                        <option value="" <%= (request.getParameter("estado") == null || request.getParameter("estado").isEmpty()) ? "selected" : "" %>>Todos</option>
                        <option value="disponible" <%= "disponible".equals(request.getParameter("estado")) ? "selected" : "" %>>Disponible</option>
                        <option value="ocupada" <%= "ocupada".equals(request.getParameter("estado")) ? "selected" : "" %>>Ocupada</option>
                    </select>
                </div>
                <div class="col-12 d-flex align-items-end gap-2">
                    <button type="submit" name="accion" value="consultar" class="btn btn-sm btn-info text-white px-3 py-2">
                        <i class="bi bi-search me-1"></i>Buscar
                    </button>
                    <button type="button" onclick="limpiarBusqueda()" class="btn btn-sm btn-secondary px-3 py-2">
                        <i class="bi bi-eraser-fill me-1"></i>Limpiar
                    </button>
                </div>
            </form>

            <hr>

            <!-- Tabla de resultados -->
            <div class="table-responsive">
                <table class="table table-striped table-hover align-middle">
                    <thead class="table-dark">
                        <tr>
                            <th>Número</th>
                            <th>Tipo</th>
                            <th>Descripción</th>
                            <th>Precio por Noche</th>
                            <th>Disponible</th>
                            <th class="text-center">Acciones</th>
                        </tr>
                    </thead>
                        <tbody>
                            <%
                                List<Habitacion> lista = (List<Habitacion>) request.getAttribute("habitaciones");
                                if (lista == null) lista = new ArrayList<>();

                                if (lista.isEmpty()) {
                            %>
                                <tr>
                                    <td colspan="6" class="text-center">No hay habitaciones para mostrar.</td>
                                </tr>
                            <%
                                } else {
                                    for (Habitacion h : lista) {
                                        String precioFormateado = String.format("%,d", (long) h.getPrecioPorNoche()).replace(',', '.');
                            %>
                                <tr>
                                    <td><%= h.getNumero() %></td>
                                    <td><%= h.getTipo() %></td>
                                    <td><%= h.getDescripcion() != null ? h.getDescripcion() : "-" %></td>
                                    <td>$ <%= precioFormateado %></td>
                                    <td>
                                        <span class="badge <%= h.isDisponible() ? "bg-success" : "bg-danger" %>">
                                            <%= h.isDisponible() ? "Sí" : "No" %>
                                        </span>
                                    </td>
                                    <td class="text-center">
                                        <a href="HabitacionController?accion=editar&numero=<%= h.getNumero() %>" class="btn btn-sm btn-warning">
                                            <i class="bi bi-pencil-square"></i></a>
                                    </td>
                                </tr>
                            <%
                                    }
                                }
                            %>
                        </tbody>
                </table>
            </div>

        </div>
    </div>
</div>

<script>
    // Mostrar toast si hay mensaje desde backend
    document.addEventListener("DOMContentLoaded", function () {
        var toastEl = document.getElementById('mensajeHabitacion');

        <% if(request.getAttribute("mensaje") != null) { %>
            var bsToast = new bootstrap.Toast(toastEl, { delay: 3000, autohide: true });
            bsToast.show();
        <% } %>
    });

    // Limpiar búsqueda + ocultar toast + reset tabla
    function limpiarBusqueda() {
        // limpiar campos
        document.getElementById("buscarNumero").value = "";
        document.getElementById("buscarEstado").value = "";

        // ocultar toast
        const toastEl = document.getElementById("mensajeHabitacion");
        var bsToast = bootstrap.Toast.getInstance(toastEl);
        if (bsToast) bsToast.hide();
        toastEl.style.display = "none";

        // limpiar tabla
        const tbody = document.querySelector('table tbody');
        tbody.innerHTML = '<tr><td colspan="6" class="text-center">No hay habitaciones para mostrar.</td></tr>';
    }
</script>
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.*, modelo.Habitacion"%>

<div class="container-fluid py-4">
    <h2 class="fw-semibold text-dark mb-4">
        <i class="bi bi-door-closed me-2"></i>Consultar Habitaciones
    </h2>

    <!-- Mensaje -->
    <div id="mensajeHabitacion"
         class="alert <%= (request.getAttribute("tipoMensaje") != null) ? request.getAttribute("tipoMensaje") : "alert-info" %>"
         style="display: <%= (request.getAttribute("mensaje") != null) ? "block" : "none" %>;">
        <%= (request.getAttribute("mensaje") != null) ? request.getAttribute("mensaje") : "Ingrese criterios de búsqueda." %>
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
                                            <i class="bi bi-pencil-square"></i> Editar
                                        </a>
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
    function limpiarBusqueda() {
        document.getElementById("formBuscarHabitacion").reset();
    }

    // Desaparece el mensaje automáticamente
    window.addEventListener("DOMContentLoaded", () => {
        const mensaje = document.getElementById("mensajeHabitacion");
        if (mensaje && mensaje.style.display === "block") {
            setTimeout(() => {
                mensaje.style.transition = "opacity 0.5s ease";
                mensaje.style.opacity = "0";
                setTimeout(() => { mensaje.style.display = "none"; }, 500);
            }, 3000);
        }
    });
    
    function limpiarBusqueda() {
        document.getElementById("buscarNumero").value = "";
        document.getElementById("buscarEstado").value = "";

        document.getElementById("mensajeHabitacion").style.display = "none";

        const tbody = document.querySelector('table tbody');
        tbody.innerHTML = '<tr><td colspan="6" class="text-center">No hay habitaciones para mostrar.</td></tr>';
    }
</script>
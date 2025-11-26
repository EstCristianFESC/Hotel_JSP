<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.*, modelo.Reserva"%>

<%
    // Asegurar que siempre exista la lista
    List<Reserva> reservas = (List<Reserva>) request.getAttribute("reservas");
    if (reservas == null) reservas = new ArrayList<>();
%>

<div class="container-fluid py-4">
    <h2 class="fw-semibold text-dark mb-4">
        <i class="bi bi-calendar-check me-2"></i>Mis Reservas
    </h2>

    <!-- Mensaje -->
    <div id="mensajeReserva"
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
            <form id="formBuscarReserva" action="<%=request.getContextPath()%>/ReservaController" method="get" class="row g-3 mb-4">
                <input type="hidden" name="accion" value="misReservas">

                <div class="col-md-4">
                    <label class="form-label fw-semibold">Cédula Cliente:</label>
                    <input type="text" class="form-control" id="buscarCedula" name="cedula"
                           placeholder="Número de cédula"
                           value="<%= request.getParameter("cedula") != null ? request.getParameter("cedula") : "" %>">
                </div>

                <div class="col-md-3">
                    <label class="form-label fw-semibold">Fecha Entrada:</label>
                    <input type="date" class="form-control" id="fechaEntrada" name="fechaEntrada"
                           value="<%= request.getParameter("fechaEntrada") != null ? request.getParameter("fechaEntrada") : "" %>">
                </div>

                <div class="col-md-3">
                    <label class="form-label fw-semibold">Fecha Salida:</label>
                    <input type="date" class="form-control" id="fechaSalida" name="fechaSalida"
                           value="<%= request.getParameter("fechaSalida") != null ? request.getParameter("fechaSalida") : "" %>">
                </div>

                <div class="col-12 d-flex align-items-end gap-2">
                    <button type="submit" class="btn btn-sm btn-info text-white px-3 py-2">
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
                            <th>Habitación</th>
                            <th>Fecha Entrada</th>
                            <th>Fecha Salida</th>
                            <th>Estado</th>
                            <th>Total</th>
                            <th>Acciones</th>
                        </tr>
                    </thead>

                    <tbody>
                    <%
                        if (reservas.isEmpty()) {
                    %>
                        <tr><td colspan="6" class="text-center">No hay reservas para mostrar.</td></tr>
                    <%
                        } else {
                            for (Reserva r : reservas) {
                    %>
                        <tr>
                            <td><%= r.getHabitacionNumero() %></td>
                            <td><%= r.getFechaEntrada() %></td>
                            <td><%= r.getFechaSalida() %></td>
                            <td><%= r.getEstado() %></td>
                            <td>$ <%= String.format("%,.0f", r.getTotal()).replace(',', '.') %></td>

                            <td>
                                <form action="<%=request.getContextPath()%>/ReservaController" method="post" style="display:inline;">
                                    <input type="hidden" name="idReserva" value="<%= r.getId() %>">
                                    <%
                                        switch (r.getEstado()) {
                                            case "RESERVADA":
                                    %>
                                                <button type="submit" name="accion" value="cancelar" class="btn btn-sm btn-danger mb-1">
                                                    Cancelar
                                                </button>
                                                <a href="CheckinController?accion=formCheckin&idReserva=<%= r.getId() %>" 
                                                   class="btn btn-sm btn-success mb-1">
                                                   <i class="bi bi-box-arrow-in-right"></i> Check-In
                                                </a>
                                    <%
                                                break;

                                            case "CHECKIN":
                                    %>
                                        <a href="<%=request.getContextPath()%>/CheckinController?accion=checkoutFactura&idReserva=<%= r.getId() %>" 
                                           class="btn btn-sm btn-warning mb-1">
                                            Check-Out
                                        </a>

                                        <a href="<%=request.getContextPath()%>/CheckinController?accion=consumos&idReserva=<%= r.getId() %>" 
                                           class="btn btn-sm btn-info mb-1">
                                            <i class="bi bi-basket"></i> Ver/Agregar Consumos
                                        </a>
                                    <%
                                                break;

                                            case "OUT":
                                    %>
                                                <span class="badge bg-secondary">Finalizado</span>
                                    <%
                                                break;

                                            case "CANCELADA":
                                    %>
                                                <span class="badge bg-dark">Cancelada</span>
                                    <%
                                                break;

                                            case "FINALIZADA":
                                    %>
                                                <span class="badge bg-dark">Sin acción</span>
                                    <%
                                                break;
                                        }
                                    %>

                                </form>
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

<!-- JS -->
<script>
    document.addEventListener("DOMContentLoaded", function () {
        var toastEl = document.getElementById('mensajeReserva');
        <% if(request.getAttribute("mensaje") != null) { %>
            var bsToast = new bootstrap.Toast(toastEl, { delay: 3000, autohide: true });
            bsToast.show();
        <% } %>
    });

    function limpiarBusqueda() {
        document.getElementById("buscarCedula").value = "";
        document.getElementById("fechaEntrada").value = "";
        document.getElementById("fechaSalida").value = "";

        const toastEl = document.getElementById("mensajeReserva");
        var bsToast = bootstrap.Toast.getInstance(toastEl);
        if (bsToast) bsToast.hide();
        toastEl.style.display = "none";

        const tbody = document.querySelector("table tbody");
        tbody.innerHTML = `<tr><td colspan="6" class="text-center">No hay reservas para mostrar.</td></tr>`;
    }
</script>
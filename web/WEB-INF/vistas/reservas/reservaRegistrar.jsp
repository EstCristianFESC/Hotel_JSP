<%@page import="modelo.Cliente"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<div class="container-fluid py-4">

    <h2 class="fw-semibold text-dark mb-4">
        <i class="bi bi-calendar-check me-2"></i>Registrar Reserva
    </h2>

    <!-- TOAST MENSAJE -->
    <div id="mensajeReserva"
         class="toast align-items-center text-bg-<%= (request.getAttribute("tipoMensaje") != null) ? request.getAttribute("tipoMensaje").toString().replace("alert-", "") : "info" %> border-0"
         role="alert" aria-live="assertive" aria-atomic="true"
         style="position: fixed; top: 1rem; right: 1rem; min-width: 260px; z-index: 9999;">
        <div class="d-flex">
            <div class="toast-body" style="font-size: 0.85rem;">
                <%= (request.getAttribute("mensaje") != null) ? request.getAttribute("mensaje") : "Complete los datos para generar una reserva." %>
            </div>
            <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Cerrar"></button>
        </div>
    </div>

    <div class="card shadow-lg border-0 rounded-4">
        <div class="card-body px-4 py-4">

            <!-- ================== FORM FECHAS ================== -->
            <form action="${pageContext.request.contextPath}/ReservaController"
                  method="get" class="mb-4">

                <input type="hidden" name="accion" value="buscarDisponibles">
                <input type="hidden" name="cedula" value="${param.cedula}">

                <div class="row g-3">

                    <div class="col-md-4">
                        <label class="form-label fw-semibold">Fecha de entrada *</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-calendar-event"></i></span>
                            <input type="date" id="fechaEntrada" name="fechaEntrada"
                                   class="form-control"
                                   value="${fechaEntrada}"
                                   required>
                        </div>
                    </div>

                    <div class="col-md-4">
                        <label class="form-label fw-semibold">Fecha de salida *</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-calendar-check"></i></span>
                            <input type="date" id="fechaSalida" name="fechaSalida"
                                   class="form-control"
                                   value="${fechaSalida}"
                                   required>
                        </div>
                    </div>

                    <div class="col-md-3 d-flex align-items-end">
                        <button type="submit" class="btn btn-success w-100">
                            <i class="bi bi-door-open-fill me-1"></i>Ver Habitaciones
                        </button>
                    </div>

                </div>
            </form>

            <!-- ================== TABLA HABITACIONES ================== -->
            <c:if test="${not empty habitaciones}">
                <h4 class="fw-semibold mb-3 text-dark">
                    <i class="bi bi-house-door me-2"></i>Habitaciones disponibles
                </h4>

                <div class="table-responsive">
                    <table class="table table-striped table-hover align-middle">
                        <thead class="table-dark">
                        <tr>
                            <th>Número</th>
                            <th>Tipo</th>
                            <th>Precio / noche</th>
                            <th>Acción</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="h" items="${habitaciones}">
                            <tr>
                                <td>${h.numero}</td>
                                <td>${h.tipo}</td>
                                <td>$ ${h.precio}</td>
                                <td>
                                    <form action="${pageContext.request.contextPath}/ReservaController" method="post">
                                        <input type="hidden" name="accion" value="crearReserva">
                                        <input type="hidden" name="cedula" value="${param.cedula}">
                                        <input type="hidden" name="fechaEntrada" value="${fechaEntrada}">
                                        <input type="hidden" name="fechaSalida" value="${fechaSalida}">
                                        <input type="hidden" name="habitacion" value="${h.numero}">
                                        <button class="btn btn-outline-primary btn-sm" type="submit">
                                            <i class="bi bi-bookmark-check me-1"></i>Reservar
                                        </button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:if>

        </div>
    </div>
</div>

<!-- ================== VALIDACIÓN DE FECHAS ================== -->
<script>
    document.addEventListener("DOMContentLoaded", function () {

        // TOAST
        var toastEl = document.getElementById("mensajeReserva");
        <% if (request.getAttribute("mensaje") != null) { %>
        var bsToast = new bootstrap.Toast(toastEl, {delay: 3000, autohide: true});
        bsToast.show();
        <% } %>

        // VALIDACIÓN DE FECHAS
        const entrada = document.getElementById("fechaEntrada");
        const salida = document.getElementById("fechaSalida");

        const hoy = new Date().toISOString().split("T")[0];
        entrada.setAttribute("min", hoy);

        entrada.addEventListener("change", function () {
            if (!this.value) return;
            let date = new Date(this.value);
            date.setDate(date.getDate() + 1);
            salida.value = "";
            salida.min = date.toISOString().split("T")[0];
        });
    });
</script>
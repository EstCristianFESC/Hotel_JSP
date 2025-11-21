<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="modelo.Habitacion"%>
<jsp:useBean id="habitacion" class="modelo.Habitacion" scope="request" />

<div class="container">
    <h2 class="mb-4"><i class="bi bi-door-closed me-2"></i>Registrar Habitación</h2>
    
    <!-- Mensaje -->
    <div id="mensajeHabitacion"
         class="toast align-items-center text-bg-<%= (request.getAttribute("tipoMensaje") != null) ? request.getAttribute("tipoMensaje").toString().replace("alert-", "") : "info" %> border-0"
         role="alert" aria-live="assertive" aria-atomic="true"
         style="position: fixed; top: 1rem; right: 1rem; min-width: 260px; z-index: 9999;">
        <div class="d-flex">
            <div class="toast-body" style="font-size: 0.85rem;">
                <%= (request.getAttribute("mensaje") != null) ? request.getAttribute("mensaje") : "" %>
            </div>
            <button type="button" class="btn-close btn-close-white me-2 m-auto"
                    data-bs-dismiss="toast" aria-label="Cerrar"></button>
        </div>
    </div>

    <form id="formHabitacion" action="${pageContext.request.contextPath}/HabitacionController" method="post" class="shadow p-4 bg-white rounded">
        <input type="hidden" name="accion" value="registrar">

        <div class="row g-3 mb-3">
            <div class="col-md-4">
                <label for="numero" class="form-label fw-semibold">Número *</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="bi bi-hash"></i></span>
                    <%
                        Habitacion hab = (Habitacion) request.getAttribute("habitacion");
                    %>
                    <input type="number" class="form-control" id="numero" name="numero"
                        <%= (hab != null && hab.getNumero() != 0) ? "value='" + hab.getNumero() + "'" : "" %>
                        placeholder="Número de la habitación" required>
                </div>
            </div>

            <div class="col-md-4">
                <label for="tipo" class="form-label fw-semibold">Tipo *</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="bi bi-door-open"></i></span>
                    <select class="form-select" id="tipo" name="tipo" required>
                        <option value="" disabled selected>Seleccione...</option>
                        <option value="Sencilla">Sencilla</option>
                        <option value="Doble">Doble</option>
                        <option value="Suite">Suite</option>
                    </select>
                </div>
            </div>

            <div class="col-md-4">
                <label for="precioPorNoche" class="form-label fw-semibold">Precio por Noche *</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="bi bi-cash-stack"></i></span>
                    <input type="text" inputmode="numeric" pattern="[0-9\.]*" class="form-control"
                           id="precioPorNoche" name="precioPorNoche" placeholder="Ej: 120.000" required>
                </div>
            </div>
        </div>

        <div class="row g-3 mb-3">
            <div class="col-md-8">
                <label for="descripcion" class="form-label fw-semibold">Descripción</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="bi bi-card-text"></i></span>
                    <textarea class="form-control" id="descripcion" name="descripcion" rows="3"
                              placeholder="Descripción de la habitación"><%= (request.getAttribute("habitacion") != null && ((Habitacion)request.getAttribute("habitacion")).getDescripcion() != null) ? ((Habitacion)request.getAttribute("habitacion")).getDescripcion() : "" %></textarea>
                </div>
            </div>

            <div class="col-md-4">
                <label class="form-label fw-semibold">Estado</label>
                <div class="input-group align-items-center">
                    <span class="input-group-text"><i class="bi bi-door-open"></i></span>
                    <input type="text" id="estadoHabitacion" class="form-control text-center" readonly
                           value="<%= (habitacion != null && habitacion.isDisponible()) ? "Ocupada" : "Disponible" %>">
                    <div class="input-group-text">
                        <div class="form-check form-switch m-0">
                            <input class="form-check-input" type="checkbox" id="checkDisponible"
                                   <%= (habitacion != null && habitacion.isDisponible()) ? "checked" : "" %>>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <hr class="my-3">

        <div class="d-flex flex-wrap justify-content-center gap-2 gap-md-3">
            <button type="button" class="btn btn-sm btn-secondary px-3 py-2" onclick="document.getElementById('formHabitacion').reset();">
                <i class="bi bi-eraser-fill me-1"></i>Limpiar
            </button>
            <button type="submit" name="accion" value="registrar" class="btn btn-sm btn-success px-3 py-2">
                <i class="bi bi-save me-1"></i>Guardar
            </button>
        </div>
    </form>
</div>
                    
<script>
    // Formatear precio automáticamente
    const precioInput = document.getElementById('precioPorNoche');

    precioInput.addEventListener('input', function () {
        let value = this.value.replace(/\D/g, '');
        this.value = value ? Number(value).toLocaleString('de-DE') : '';
    });

    // Mostrar toast si hay mensaje desde el backend
    document.addEventListener("DOMContentLoaded", function () {
        var toastEl = document.getElementById('mensajeHabitacion');

        <% if(request.getAttribute("mensaje") != null) { %>
            var bsToast = new bootstrap.Toast(toastEl, { delay: 3000, autohide: true });
            bsToast.show();
        <% } %>
    });

    // Cambiar estado según checkbox
    const check = document.getElementById("checkDisponible");
    const estado = document.getElementById("estadoHabitacion");

    check.addEventListener("change", () => {
        estado.value = check.checked ? "Disponible" : "Ocupada";
    });
</script>
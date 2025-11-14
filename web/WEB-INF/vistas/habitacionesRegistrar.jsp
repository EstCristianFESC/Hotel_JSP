<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="modelo.Habitacion"%>
<jsp:useBean id="habitacion" class="modelo.Habitacion" scope="request" />

<div class="container">
    <h2 class="mb-4"><i class="bi bi-door-closed me-2"></i>Registrar Habitación</h2>
    
    <!-- Mensaje -->
    <div id="mensajeHabitacion"
         class="alert <%= (request.getAttribute("tipoMensaje") != null) ? request.getAttribute("tipoMensaje") : "alert-info" %>"
         style="display: <%= (request.getAttribute("mensaje") != null) ? "block" : "none" %>;">
        <%= (request.getAttribute("mensaje") != null) ? request.getAttribute("mensaje") : "" %>
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
                           id="precioPorNoche" name="precioPorNoche" placeholder="Ej: 120000" required>
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
                <label class="form-label fw-semibold">Disponibilidad</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="bi bi-door-open"></i></span>
                    <div class="form-check form-switch d-flex align-items-center ms-2">
                        <input class="form-check-input" type="checkbox" id="disponible" name="disponible"
                            <%= (request.getAttribute("habitacion") != null && ((Habitacion)request.getAttribute("habitacion")).isDisponible()) ? "checked" : "checked" %>>
                        <label class="form-check-label ms-2" for="disponible">Disponible</label>
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
    const precioInput = document.getElementById('precioPorNoche');

    precioInput.addEventListener('input', function(e) {
        let value = this.value.replace(/\D/g, '');
        if (value) {
        this.value = Number(value).toLocaleString('de-DE');
        } else {
            this.value = '';
        }
    });
    
    // Función para desaparecer mensaje automáticamente
    document.addEventListener("DOMContentLoaded", () => {
        const mensaje = document.getElementById("mensajeHabitacion");
        if (mensaje && mensaje.style.display === "block") {
            setTimeout(() => {
                mensaje.style.transition = "opacity 0.5s ease";
                mensaje.style.opacity = "0";
                setTimeout(() => {
                    mensaje.style.display = "none";
                }, 500); // espera a que termine la animación
            }, 3000); // 3 segundos antes de desaparecer
        }
    });
</script>
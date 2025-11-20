<%@page import="modelo.Cliente"%>
<%@page contentType="text/html" pageEncoding="UTF-8" %>

<div class="container-fluid py-4">
    <h2 class="fw-semibold text-dark mb-4">
        <i class="bi bi-person-lines-fill me-2"></i>Registrar Clientes
    </h2>

    <!-- Mensaje -->
    <div id="mensajeCliente"
         class="toast align-items-center text-bg-<%= (request.getAttribute("tipoMensaje") != null) ? request.getAttribute("tipoMensaje").toString().replace("alert-", "") : "info" %> border-0"
         role="alert" aria-live="assertive" aria-atomic="true"
         style="position: fixed; top: 1rem; right: 1rem; min-width: 260px; z-index: 9999;">
        <div class="d-flex">
            <div class="toast-body" style="font-size: 0.85rem;">
                <%= (request.getAttribute("mensaje") != null) ? request.getAttribute("mensaje") : "Ingrese la información del cliente." %>
            </div>
            <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Cerrar"></button>
        </div>
    </div>

    <div class="card shadow-lg border-0 rounded-4">
        <div class="card-body px-4 py-4">
            <form id="formCliente" action="${pageContext.request.contextPath}/ClienteController" method="post">

                <!-- Tipo de cliente -->
                <div class="row g-3 mb-4">
                    <div class="col-md-4">
                        <label class="form-label fw-semibold">Tipo de Cliente *</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-person-badge"></i></span>
                            <select class="form-select" id="tipoCliente" name="tipo" onchange="actualizarFormulario()" required>
                                <option value="">Seleccione...</option>
                                <option value="NATURAL" <%= (request.getAttribute("cliente") != null && "NATURAL".equalsIgnoreCase(((Cliente)request.getAttribute("cliente")).getTipo())) ? "selected" : "" %>>Persona Natural</option>
                                <option value="JURIDICO" <%= (request.getAttribute("cliente") != null && "JURIDICO".equalsIgnoreCase(((Cliente)request.getAttribute("cliente")).getTipo())) ? "selected" : "" %>>Persona Jurídica</option>
                            </select>
                        </div>
                    </div>
                </div>

                <!-- Campos principales -->
                <div class="row g-3 mb-3">
                    <div class="col-md-4">
                        <label id="lblId" for="idCliente" class="form-label fw-semibold">Cédula *</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-person-vcard"></i></span>
                            <input type="text" class="form-control" id="idCliente" name="id"
                                   value="<%= (request.getAttribute("cliente") != null) ? ((Cliente)request.getAttribute("cliente")).getId() : "" %>"
                                   placeholder="Ingrese la cédula o NIT" required>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <label id="lblNombre" for="nombre" class="form-label fw-semibold">Nombre *</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-person"></i></span>
                            <input type="text" class="form-control" id="nombre" name="nombre"
                                   value="<%= (request.getAttribute("cliente") != null) ? ((Cliente)request.getAttribute("cliente")).getNombre() : "" %>"
                                   placeholder="Nombre del cliente o empresa" required>
                        </div>
                    </div>
                    <div class="col-md-4" id="campoApellido">
                        <label for="apellido" class="form-label fw-semibold">Apellido</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-person"></i></span>
                            <input type="text" class="form-control" id="apellido" name="apellido"
                                   value="<%= (request.getAttribute("cliente") != null) ? ((Cliente)request.getAttribute("cliente")).getApellido() : "" %>"
                                   placeholder="Apellido del cliente">
                        </div>
                    </div>
                </div>

                <!-- Campos comunes -->
                <div class="row g-3 mb-3">
                    <div class="col-md-4">
                        <label for="telefono" class="form-label fw-semibold">Teléfono</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-telephone"></i></span>
                            <input type="text" class="form-control" id="telefono" name="telefono"
                                   value="<%= (request.getAttribute("cliente") != null) ? ((Cliente)request.getAttribute("cliente")).getTelefono() : "" %>"
                                   placeholder="Ej: 3001234567">
                        </div>
                    </div>
                    <div class="col-md-4">
                        <label for="direccion" class="form-label fw-semibold">Dirección</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-geo-alt"></i></span>
                            <input type="text" class="form-control" id="direccion" name="direccion"
                                   value="<%= (request.getAttribute("cliente") != null) ? ((Cliente)request.getAttribute("cliente")).getDireccion() : "" %>"
                                   placeholder="Calle 123 #45-67">
                        </div>
                    </div>
                    <div class="col-md-4">
                        <label for="email" class="form-label fw-semibold">Correo</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-envelope"></i></span>
                            <input type="email" class="form-control" id="email" name="email"
                                   value="<%= (request.getAttribute("cliente") != null) ? ((Cliente)request.getAttribute("cliente")).getEmail() : "" %>"
                                   placeholder="cliente@email.com">
                        </div>
                    </div>
                </div>

                <hr class="my-4">

                <!-- Botones -->
                <div class="d-flex flex-wrap justify-content-center gap-2 gap-md-3">
                    <button type="button" class="btn btn-sm btn-secondary px-3 py-2" onclick="limpiarCampos()">
                        <i class="bi bi-eraser-fill me-1"></i>Limpiar
                    </button>
                    <button type="submit" name="accion" value="guardar" class="btn btn-sm btn-success px-3 py-2">
                        <i class="bi bi-save me-1"></i>Guardar
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    function actualizarFormulario() {
        const tipo = document.getElementById("tipoCliente").value;
        const lblId = document.getElementById("lblId");
        const lblNombre = document.getElementById("lblNombre");
        const campoApellido = document.getElementById("campoApellido");

        if (tipo === "NATURAL") {
            lblId.innerText = "Cédula *";
            lblNombre.innerText = "Nombre *";
            campoApellido.style.display = "block";
        } else if (tipo === "JURIDICO") {
            lblId.innerText = "NIT *";
            lblNombre.innerText = "Nombre o Razón Social *";
            campoApellido.style.display = "none";
            document.getElementById("apellido").value = "";
        } else {
            campoApellido.style.display = "none";
        }
    }

    function limpiarCampos(){
        document.getElementById("formCliente").reset();
        actualizarFormulario();

        const toastEl = document.getElementById("mensajeCliente");
        if (toastEl) {
            const bsToast = bootstrap.Toast.getInstance(toastEl);
            if (bsToast) bsToast.hide();
        }
    }

    document.addEventListener("DOMContentLoaded", function () {
        actualizarFormulario();

        var toastEl = document.getElementById('mensajeCliente');
        <% if(request.getAttribute("mensaje") != null) { %>
            var bsToast = new bootstrap.Toast(toastEl, { delay: 3000, autohide: true });
            bsToast.show();
        <% } %>
    });
</script>
<%@page import="java.util.*, modelo.Habitacion, modelo.Cliente, dao.ClienteDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    // Inicializar variables de fechas y lista de habitaciones
    String fechaEntrada = request.getAttribute("fechaEntrada") != null ? request.getAttribute("fechaEntrada").toString() : "";
    String fechaSalida = request.getAttribute("fechaSalida") != null ? request.getAttribute("fechaSalida").toString() : "";
    List<Habitacion> lista = (List<Habitacion>) request.getAttribute("habitaciones");
    if (lista == null) lista = new ArrayList<>();
%>

<div class="container-fluid py-4">
    <h2 class="fw-semibold text-dark mb-4">
        <i class="bi bi-calendar-check me-2"></i>Registrar Reserva
    </h2>

    <!-- Toast mensaje general -->
    <div id="mensajeReserva"
         class="toast align-items-center text-bg-<%= (request.getAttribute("tipoMensaje") != null) ? request.getAttribute("tipoMensaje").toString().replace("alert-", "") : "info" %> border-0"
         role="alert" aria-live="assertive" aria-atomic="true"
         style="position: fixed; top: 1rem; right: 1rem; min-width: 260px; z-index: 9999;">
        <div class="d-flex">
            <div class="toast-body" style="font-size: 0.85rem;">
                <%= (request.getAttribute("mensaje") != null) ? request.getAttribute("mensaje") : "Complete los datos para generar una reserva." %>
            </div>
            <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
        </div>
    </div>

    <div class="card shadow-lg border-0 rounded-4">
        <div class="card-body px-4 py-4">

            <!-- FORM FECHAS -->
            <form action="<%=request.getContextPath()%>/ReservaController" method="get" class="mb-4">
                <input type="hidden" name="accion" value="buscarDisponibles">
                <div class="row g-3">
                    <div class="col-md-4">
                        <label class="form-label fw-semibold">Fecha de entrada *</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-calendar-event"></i></span>
                            <input type="date" name="fechaEntrada" class="form-control" value="<%=fechaEntrada%>" required>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label fw-semibold">Fecha de salida *</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-calendar-check"></i></span>
                            <input type="date" name="fechaSalida" class="form-control" value="<%=fechaSalida%>" required>
                        </div>
                    </div>
                    <div class="col-md-3 d-flex align-items-end">
                        <button type="submit" class="btn btn-success w-100">
                            <i class="bi bi-door-open-fill me-1"></i>Ver Habitaciones
                        </button>
                    </div>
                </div>
            </form>

            <!-- TABLA HABITACIONES -->
            <%
                if(lista.isEmpty()) {
            %>
                <div class="alert alert-warning">No hay habitaciones disponibles para las fechas seleccionadas.</div>
            <%
                } else {
            %>
                <h4 class="fw-semibold mb-3 text-dark"><i class="bi bi-house-door me-2"></i>Habitaciones disponibles</h4>
                <div class="table-responsive">
                    <table class="table table-striped table-hover align-middle">
                        <thead class="table-dark">
                            <tr>
                                <th>Número</th>
                                <th>Tipo</th>
                                <th>Precio / noche</th>
                                <th>Disponible</th>
                                <th>Acción</th>
                            </tr>
                        </thead>
                            <tbody>
                            <%
                                for(Habitacion h : lista){
                                    String precioFormateado = String.format("%,d", (long) h.getPrecioPorNoche()).replace(',', '.');
                            %>
                            <tr>
                                <td><%= h.getNumero() %></td>
                                <td><%= h.getTipo() %></td>
                                <td>$ <%= precioFormateado %></td>
                                <td>
                                    <span class="badge <%= h.isDisponible() ? "bg-success" : "bg-danger" %>">
                                        <%= h.isDisponible() ? "Sí" : "No" %>
                                    </span>
                                </td>
                                <td class="text-center">
                                    <button type="button" 
                                            class="btn btn-outline-primary btn-sm reservarBtn" 
                                            data-habitacion="<%= h.getNumero() %>">
                                        <i class="bi bi-bookmark-check me-1"></i>Reservar
                                    </button>
                                </td>
                            </tr>
                            <%
                                }
                            %>
                            </tbody>
                    </table>
                </div>
            <%
                }
            %>

        </div>
    </div>
</div>

<!-- ================= MODAL RESERVA ================= -->
<div class="modal fade" id="reservaModal" tabindex="-1" aria-labelledby="reservaModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <form id="formReserva" action="<%=request.getContextPath()%>/ReservaController" method="post">
                <input type="hidden" name="accion" value="registrar">
                <input type="hidden" name="idHabitacion" id="habitacionModal">
                <input type="hidden" name="fechaEntrada" value="<%=fechaEntrada%>">
                <input type="hidden" name="fechaSalida" value="<%=fechaSalida%>">

                <div class="modal-header">
                    <h5 class="modal-title" id="reservaModalLabel">Registrar Reserva</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>

                <div class="modal-body">
                    <!-- Buscar cliente por cédula -->
                    <div class="mb-3">
                        <label for="cedulaCliente" class="form-label">Número de Documento</label>
                        <input type="text" class="form-control" id="cedulaCliente" name="cedula" required>
                    </div>
                    <div class="mb-3">
                        <button type="button" id="buscarCliente" class="btn btn-info w-100">
                            <i class="bi bi-search me-1"></i>Buscar Cliente
                        </button>
                    </div>

                    <!-- Mostrar datos si existe -->
                    <div id="datosCliente" style="display:none;">
                        <p><strong>Nombre:</strong> <span id="nombreCliente"></span></p>
                        <p><strong>Apellido:</strong> <span id="apellidoCliente"></span></p>
                        <p><strong>Tipo:</strong> <span id="tipoCliente"></span></p>
                    </div>

                    <div id="mensajeModal" class="alert alert-warning" style="display:none;"></div>
                </div>

                <div class="modal-footer">
                    <button type="submit" id="confirmarReserva" class="btn btn-success" disabled>
                        <i class="bi bi-check-circle me-1"></i>Confirmar Reserva
                    </button>
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- ================= SCRIPTS ================= -->
<script>
document.addEventListener("DOMContentLoaded", function () {
    // Toast inicial
    var toastEl = document.getElementById("mensajeReserva");
    <% if(request.getAttribute("mensaje") != null){ %>
        var bsToast = new bootstrap.Toast(toastEl, {delay:3000, autohide:true});
        bsToast.show();
    <% } %>

    // Modal bootstrap
    const reservaModal = new bootstrap.Modal(document.getElementById('reservaModal'));
    let habitacionSeleccionada = null;

    // Botones reservar
    document.querySelectorAll('.reservarBtn').forEach(btn => {
        btn.addEventListener('click', function(){
            habitacionSeleccionada = this.dataset.habitacion;
            document.getElementById('habitacionModal').value = habitacionSeleccionada;

            // Reset modal
            document.getElementById('cedulaCliente').value = '';
            document.getElementById('datosCliente').style.display = 'none';
            document.getElementById('confirmarReserva').disabled = true;
            document.getElementById('mensajeModal').style.display = 'none';

            reservaModal.show();
        });
    });

    // Buscar cliente por cédula
    document.getElementById('buscarCliente').addEventListener('click', function(){
        const cedula = document.getElementById('cedulaCliente').value.trim();
        if(!cedula) return;

        fetch('<%=request.getContextPath()%>/ReservaController?accion=buscarPorCedula&cedula=' + cedula)
            .then(res => res.json())
            .then(data => {
                if(data && data.id) {
                    document.getElementById('nombreCliente').innerText = data.nombre;
                    document.getElementById('apellidoCliente').innerText = data.apellido;
                    document.getElementById('tipoCliente').innerText = data.tipo;
                    document.getElementById('datosCliente').style.display = 'block';
                    document.getElementById('confirmarReserva').disabled = false;
                    document.getElementById('mensajeModal').style.display = 'none';
                } else {
                    document.getElementById('datosCliente').style.display = 'none';
                    document.getElementById('confirmarReserva').disabled = true;
                    document.getElementById('mensajeModal').innerText = 'Cliente no encontrado.';
                    document.getElementById('mensajeModal').style.display = 'block';
                }
            })
            .catch(err => {
                console.error(err);
                document.getElementById('mensajeModal').innerText = 'Error al consultar el cliente.';
                document.getElementById('mensajeModal').style.display = 'block';
            });
    });
});
</script>
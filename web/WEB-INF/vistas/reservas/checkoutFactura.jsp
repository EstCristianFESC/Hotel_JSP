<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="modelo.Reserva, modelo.Checkin, modelo.Consumo" %>
<%@ page import="java.util.List" %>

<%
    Reserva reserva = (Reserva) request.getAttribute("reserva");
    Checkin checkin = (Checkin) request.getAttribute("checkin");
    List<Consumo> consumos = (List<Consumo>) request.getAttribute("consumos");
    int dias = (int) request.getAttribute("dias");
%>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">

<div class="container my-5">
    <div class="text-center mb-4">
        <i class="bi bi-receipt-cutoff fs-1 text-primary"></i>
        <h1 class="fw-bold mt-2">Factura de Reserva</h1>
        <p class="text-muted">Resumen completo de tu estadía</p>
    </div>

    <!-- Información general -->
    <div class="row mb-4">
        <div class="col-md-4">
            <div class="card shadow-sm border-primary">
                <div class="card-body text-center">
                    <i class="bi bi-person-circle fs-2 text-primary"></i>
                    <h5 class="card-title mt-2">Cliente</h5>
                    <p class="card-text"><strong>ID:</strong> <%= reserva.getClienteId() %></p>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card shadow-sm border-success">
                <div class="card-body text-center">
                    <i class="bi bi-house-door-fill fs-2 text-success"></i>
                    <h5 class="card-title mt-2">Habitación</h5>
                    <p class="card-text"><strong>Número:</strong> <%= reserva.getHabitacionNumero() %></p>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card shadow-sm border-warning">
                <div class="card-body text-center">
                    <i class="bi bi-calendar-event-fill fs-2 text-warning"></i>
                    <h5 class="card-title mt-2">Estadía</h5>
                    <p class="card-text"><strong>Días:</strong> <%= dias %></p>
                </div>
            </div>
        </div>
    </div>

    <!-- Totales -->
    <div class="card shadow-sm mb-4">
        <div class="card-header bg-primary text-white">
            <i class="bi bi-currency-dollar"></i> Totales
        </div>
        <div class="card-body">
            <div class="row text-center">
                <div class="col-md-4">
                    <h6>Total Habitación</h6>
                    <p class="fs-5">$<%= checkin.getTotalHabitacion() %></p>
                </div>
                <div class="col-md-4">
                    <h6>Total Consumos</h6>
                    <p class="fs-5">$<%= checkin.getTotalConsumos() %></p>
                </div>
                <div class="col-md-4">
                    <h6>Total Final</h6>
                    <p class="fs-4 fw-bold text-success">$<%= checkin.getTotalFinal() %></p>
                </div>
            </div>
        </div>
    </div>

    <!-- Detalle de consumos -->
    <div class="card shadow-sm mb-4">
        <div class="card-header bg-info text-white">
            <i class="bi bi-basket-fill"></i> Detalle de Consumos
        </div>
        <div class="card-body p-0">
            <table class="table table-striped mb-0">
                <thead class="table-light">
                    <tr>
                        <th>Producto</th>
                        <th>Cantidad</th>
                        <th>Valor Unitario</th>
                        <th>Subtotal</th>
                        <th>Fecha</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        for (Consumo c : consumos) {
                    %>
                    <tr>
                        <td><%= c.getNombreProducto() %></td>
                        <td><%= c.getCantidad() %></td>
                        <td>$<%= c.getValorUnitario() %></td>
                        <td>$<%= c.getSubtotal() %></td>
                        <td><%= c.getFecha() %></td>
                    </tr>
                    <%
                        }
                    %>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Botón finalizar -->
    <div class="text-center mb-5">
        <form action="<%=request.getContextPath()%>/CheckinController" method="post" class="d-inline-block">
            <input type="hidden" name="accion" value="finalizarReserva">
            <input type="hidden" name="idReserva" value="<%= reserva.getId() %>">
            <button type="submit" class="btn btn-success btn-lg">
                <i class="bi bi-check-circle-fill me-2"></i> Finalizar Reserva
            </button>
        </form>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
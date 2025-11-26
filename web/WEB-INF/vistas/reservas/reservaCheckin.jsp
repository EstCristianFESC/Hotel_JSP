<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="modelo.Reserva"%>

<%
    Reserva reserva = (Reserva) request.getAttribute("reserva");
%>

<link rel="stylesheet"
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">

<div class="container py-4">

    <!-- ENCABEZADO ESTILO HOTEL -->
    <div class="text-center mb-4">
        <img src="https://cdn-icons-png.flaticon.com/512/1046/1046857.png"
             width="70" class="mb-2">
        <h2 class="fw-bold text-dark">Registro de Check-in</h2>
        <p class="text-muted">Reserva #<%= reserva != null ? reserva.getId() : "" %></p>
        <hr class="mt-3">
    </div>

    <!-- CARD -->
    <div class="card shadow border-0">
        <div class="card-body p-4">

            <form action="<%=request.getContextPath()%>/CheckinController" method="post">
                <input type="hidden" name="accion" value="registrarCheckin">
                <input type="hidden" name="idReserva" value="<%= reserva != null ? reserva.getId() : 0 %>">

                <!-- Datos de la reserva -->
                <div class="mb-3">
                    <label class="form-label fw-semibold">Habitación</label>
                    <input class="form-control" value="<%= reserva.getHabitacionNumero() %>" disabled>
                </div>

                <div class="mb-3">
                    <label class="form-label fw-semibold">Fecha de entrada</label>
                    <input class="form-control" value="<%= reserva.getFechaEntrada() %>" disabled>
                </div>

                <div class="mb-3">
                    <label class="form-label fw-semibold">Fecha de salida</label>
                    <input class="form-control" value="<%= reserva.getFechaSalida() %>" disabled>
                </div>

                <!-- Observaciones -->
                <div class="mb-3">
                    <label class="form-label fw-semibold">Observaciones</label>
                    <textarea class="form-control" name="observaciones" rows="3"
                              placeholder="Notas sobre el check-in (opcional)"></textarea>
                </div>

                <!-- Botones -->
                <div class="mt-4 d-flex justify-content-between">
                    <a class="btn btn-secondary"
                       href="<%=request.getContextPath()%>/ReservaController?accion=misReservas">
                        <i class="bi bi-arrow-left-circle"></i> Volver
                    </a>

                    <button class="btn btn-success px-4" type="submit">
                        <i class="bi bi-check-circle"></i> Confirmar Check-in
                    </button>
                </div>

            </form>
        </div>
    </div>
</div>

<!-- Bootstrap Icons -->
<link rel="stylesheet"href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">

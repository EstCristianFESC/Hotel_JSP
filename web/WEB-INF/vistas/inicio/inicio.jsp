<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<div class="container-fluid">
    <h2 class="fw-semibold text-dark">Panel General</h2>
    <p class="text-muted mb-4">Información rápida de la actividad del hotel.</p>

    <div class="row g-4">

        <!-- Ocupación Actual -->
        <div class="col-md-4">
            <div class="card p-4 shadow-sm border-0">
                <div class="d-flex justify-content-between align-items-center mb-2">
                    <h6 class="text-secondary m-0">Ocupación Actual</h6>
                    <div class="bg-primary bg-opacity-10 text-primary p-3 rounded">
                        <i class="bi bi-graph-up fs-4"></i>
                    </div>
                </div>
                <h3 class="fw-bold mb-0"><%= request.getAttribute("ocupacionActual") %>%</h3>
                <p class="text-muted small">Habitaciones ocupadas hoy</p>
            </div>
        </div>

        <!-- Habitaciones Disponibles -->
        <div class="col-md-4">
            <div class="card p-4 shadow-sm border-0">
                <div class="d-flex justify-content-between align-items-center mb-2">
                    <h6 class="text-secondary m-0">Habitaciones Disponibles</h6>
                    <div class="bg-success bg-opacity-10 text-success p-3 rounded">
                        <i class="bi bi-door-open fs-4"></i>
                    </div>
                </div>
                <h3 class="fw-bold mb-0"><%= request.getAttribute("habitacionesDisponibles") + " / " + request.getAttribute("totalHabitaciones") %></h3>
                <p class="text-muted small">Listas para asignar</p>
            </div>
        </div>

        <!-- Reservas para Hoy -->
        <div class="col-md-4">
            <div class="card p-4 shadow-sm border-0">
                <div class="d-flex justify-content-between align-items-center mb-2">
                    <h6 class="text-secondary m-0">Reservas para Hoy</h6>
                    <div class="bg-warning bg-opacity-10 text-warning p-3 rounded">
                        <i class="bi bi-calendar-check fs-4"></i>
                    </div>
                </div>
                <h3 class="fw-bold mb-0"><%= request.getAttribute("reservasHoy") %></h3>
                <p class="text-muted small">Llegadas esperadas</p>
            </div>
        </div>

        <!-- Check-Outs Pendientes -->
        <div class="col-md-4">
            <div class="card p-4 shadow-sm border-0">
                <div class="d-flex justify-content-between align-items-center mb-2">
                    <h6 class="text-secondary m-0">Check-Outs Pendientes</h6>
                    <div class="bg-danger bg-opacity-10 text-danger p-3 rounded">
                        <i class="bi bi-box-arrow-right fs-4"></i>
                    </div>
                </div>
                <h3 class="fw-bold mb-0"><%= request.getAttribute("checkoutsPendientes") %></h3>
                <p class="text-muted small">Salidas de hoy</p>
            </div>
        </div>

        <!-- Ingresos del Día -->
        <div class="col-md-4">
            <div class="card p-4 shadow-sm border-0">
                <div class="d-flex justify-content-between align-items-center mb-2">
                    <h6 class="text-secondary m-0">Ingresos del Día</h6>
                    <div class="bg-info bg-opacity-10 text-info p-3 rounded">
                        <i class="bi bi-cash-coin fs-4"></i>
                    </div>
                </div>
                <h3 class="fw-bold mb-0">$ <%= request.getAttribute("ingresosDia") %></h3>
                <p class="text-muted small">Total facturado hoy</p>
            </div>
        </div>

        <!-- Huéspedes Actualmente -->
        <div class="col-md-4">
            <div class="card p-4 shadow-sm border-0">
                <div class="d-flex justify-content-between align-items-center mb-2">
                    <h6 class="text-secondary m-0">Huéspedes Actuales</h6>
                    <div class="bg-secondary bg-opacity-10 text-secondary p-3 rounded">
                        <i class="bi bi-people-fill fs-4"></i>
                    </div>
                </div>
                <h3 class="fw-bold mb-0"><%= request.getAttribute("huespedesActuales") %></h3>
                <p class="text-muted small">Personas alojadas</p>
            </div>
        </div>

    </div>
</div>
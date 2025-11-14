<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<div class="container-fluid">
	<h2 class="fw-semibold text-dark">Bienvenido a HotelSys</h2>
	<p class="text-muted mb-5">Sistema de gestión de reservas hoteleras. Selecciona una opción del menú para
		comenzar.</p>

	<div class="row g-4">
		<!-- Card 1 -->
		<div class="col-md-4">
			<div class="card p-4">
				<div class="d-flex justify-content-between align-items-center mb-3">
					<h6 class="text-secondary mb-0">Total Reservas</h6>
					<div class="bg-primary bg-opacity-10 text-primary p-3 rounded">
						<i class="bi bi-calendar-event fs-4"></i>
					</div>
				</div>
				<p class="text-muted small mb-0">Cuantas tenemos</p>
			</div>
		</div>

		<!-- Card 2 -->
		<div class="col-md-4">
			<div class="card p-4">
				<div class="d-flex justify-content-between align-items-center mb-3">
					<h6 class="text-secondary mb-0">Habitaciones Ocupadas</h6>
					<div class="bg-success bg-opacity-10 text-success p-3 rounded">
						<i class="bi bi-door-closed fs-4"></i>
					</div>
				</div>
				<p class="text-muted small mb-0">Cuantas a día de hoy 5/10</p>
			</div>
		</div>

		<!-- Card 3 -->
		<div class="col-md-4">
			<div class="card p-4">
				<div class="d-flex justify-content-between align-items-center mb-3">
					<h6 class="text-secondary mb-0">Check-Ins Pendientes</h6>
					<div class="bg-warning bg-opacity-10 text-warning p-3 rounded">
						<i class="bi bi-check2-circle fs-4"></i>
					</div>
				</div>
				<p class="text-muted small mb-0">En las próximas 24h</p>
			</div>
		</div>
	</div>
</div>
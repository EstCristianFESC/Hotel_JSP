<%@page import="java.util.Calendar"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page contentType="text/html" pageEncoding="UTF-8" %>

<%
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    Date hoy = new Date();

    Calendar cal = Calendar.getInstance();
    cal.setTime(hoy);
    cal.add(Calendar.DATE, 1);
    Date manana = cal.getTime();

    String fechaHoy = sdf.format(hoy);
    String fechaManana = sdf.format(manana);
%>

<!DOCTYPE html>
<div class="container-fluid py-3">
	<h2 class="fw-semibold text-dark mb-4">
		<i class="bi bi-calendar-check me-2"></i>Gestión de Reservas
	</h2>

	<!-- NAV TABS -->
	<ul class="nav nav-tabs mb-4" id="reservaTabs" role="tablist">
		<li class="nav-item" role="presentation">
			<button class="nav-link active" id="crear-tab" data-bs-toggle="tab" data-bs-target="#crear"
				type="button" role="tab">
				<i class="bi bi-plus-circle me-1"></i> Crear Reserva
			</button>
		</li>
		<li class="nav-item" role="presentation">
			<button class="nav-link" id="consultar-tab" data-bs-toggle="tab" data-bs-target="#consultar"
				type="button" role="tab">
				<i class="bi bi-search me-1"></i> Consultar Reservas
			</button>
		</li>
	</ul>

	<div class="tab-content" id="reservaTabsContent">
		<!-- CREAR RESERVA -->
		<div class="tab-pane fade show active" id="crear" role="tabpanel">
			<div class="card shadow-sm rounded-4 border-0">
				<div class="card-body p-4">
					<form class="row g-3">
						<div class="col-md-3">
							<label class="form-label fw-semibold">Código</label>
							<input type="text" class="form-control" placeholder="Autogenerado" disabled>
						</div>

						<div class="col-md-3">
							<label class="form-label fw-semibold">Cédula</label>
							<div class="input-group">
								<input type="text" class="form-control" placeholder="Ingrese cédula">
								<button class="btn btn-outline-primary" type="button"><i
										class="bi bi-search"></i></button>
							</div>
						</div>

						<div class="col-md-3">
							<label class="form-label fw-semibold">Nombre</label>
							<input type="text" class="form-control" placeholder="Nombre del cliente" readonly>
						</div>

						<div class="col-md-3">
							<label class="form-label fw-semibold">Habitación</label>
							<select class="form-select">
								<option selected disabled>Seleccione...</option>
								<option>101</option>
								<option>102</option>
								<option>103</option>
							</select>
						</div>

						<div class="col-md-3">
							<label class="form-label fw-semibold">Fecha Reserva</label>
							<input type="date" class="form-control" id="fechaRegistro"
                                                        value="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>"
                                                        readonly>
						</div>

						<div class="col-md-3">
                                                        <label class="form-label fw-semibold">Fecha Ingreso</label>
                                                        <input type="date" class="form-control" id="fechaIngreso"
                                                                value="<%= fechaHoy %>"
                                                                min="<%= fechaHoy %>">
                                                </div>

                                                <div class="col-md-3">
                                                        <label class="form-label fw-semibold">Fecha Salida</label>
                                                        <input type="date" class="form-control" id="fechaSalida"
                                                                value="<%= fechaManana %>"
                                                                min="<%= fechaManana %>">
                                                </div>

						<div class="col-md-3">
                                                        <label class="form-label fw-semibold">Días</label>
                                                        <input type="number" class="form-control" id="dias" readonly>
                                                </div>

						<div class="col-12">
							<label class="form-label fw-semibold">Servicios Extras</label>
							<div class="d-flex flex-wrap gap-3">
								<div class="form-check">
									<input class="form-check-input" type="checkbox" id="desayuno">
									<label class="form-check-label" for="desayuno">Desayuno</label>
								</div>
								<div class="form-check">
									<input class="form-check-input" type="checkbox" id="almuerzo">
									<label class="form-check-label" for="almuerzo">Almuerzo</label>
								</div>
								<div class="form-check">
									<input class="form-check-input" type="checkbox" id="cena">
									<label class="form-check-label" for="cena">Cena</label>
								</div>
							</div>
						</div>

						<hr class="mt-3">

						<div class="col-md-4">
							<label class="form-label fw-semibold">Subtotal</label>
							<input type="text" class="form-control" readonly>
						</div>

						<div class="col-md-4">
							<label class="form-label fw-semibold">IVA</label>
							<input type="text" class="form-control" readonly>
						</div>

						<div class="col-md-4">
							<label class="form-label fw-semibold">Total</label>
							<input type="text" class="form-control" readonly>
						</div>

						<div class="col-12 text-end mt-3">
							<button type="reset" class="btn btn-outline-secondary me-2"><i
									class="bi bi-eraser me-1"></i> Limpiar</button>
							<button type="submit" class="btn btn-success"><i class="bi bi-save me-1"></i>
								Guardar</button>
						</div>
					</form>
				</div>
			</div>
		</div>

		<!-- CONSULTAR RESERVAS -->
		<div class="tab-pane fade" id="consultar" role="tabpanel">
			<div class="card shadow-sm rounded-4 border-0">
				<div class="card-body p-4">
					<form class="row g-3 mb-4 align-items-end">
						<div class="col-md-3">
							<label class="form-label fw-semibold">Código</label>
							<input type="text" class="form-control" placeholder="Código de reserva">
						</div>

						<div class="col-md-3">
							<label class="form-label fw-semibold">Cédula</label>
							<input type="text" class="form-control" placeholder="Cédula del cliente">
						</div>

						<div class="col-md-3">
							<label class="form-label fw-semibold">Fecha</label>
							<input type="date" class="form-control">
						</div>

						<div class="col-md-3">
							<label class="form-label fw-semibold">Estado</label>
							<select class="form-select">
								<option value="">Todos</option>
								<option value="checkin">Check-in pendiente</option>
								<option value="checkout">Check-out pendiente</option>
								<option value="completado">Completado</option>
							</select>
						</div>

						<div class="col-12 text-end">
							<button type="button" class="btn btn-primary me-2">
								<i class="bi bi-search me-1"></i> Buscar
							</button>
							<button type="reset" class="btn btn-outline-secondary">
								<i class="bi bi-eraser me-1"></i> Limpiar
							</button>
						</div>
					</form>

					<div class="table-responsive">
						<table class="table table-hover align-middle text-center">
							<thead class="table-light">
								<tr>
									<th>Código</th>
									<th>Cédula</th>
									<th>Habitación</th>
									<th>F. Ingreso</th>
									<th>F. Salida</th>
									<th>Estado</th>
									<th>Check</th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<td>R001</td>
									<td>123456789</td>
									<td>102</td>
									<td>2025-11-08</td>
									<td>2025-11-10</td>
									<td>
										<span class="badge bg-primary">Check-in pendiente</span>
									</td>
									<td>
										<button class="btn btn-sm btn-outline-info" data-bs-toggle="modal"
											data-bs-target="#checkModal">
											<i class="bi bi-door-open"></i>
										</button>
									</td>
								</tr>
								<tr>
									<td>R002</td>
									<td>987654321</td>
									<td>105</td>
									<td>2025-11-06</td>
									<td>2025-11-08</td>
									<td>
										<span class="badge bg-warning text-dark">Check-out pendiente</span>
									</td>
									<td>
										<button class="btn btn-sm btn-outline-info" data-bs-toggle="modal"
											data-bs-target="#checkModal">
											<i class="bi bi-door-closed"></i>
										</button>
									</td>
								</tr>
								<tr>
									<td>R003</td>
									<td>555888222</td>
									<td>110</td>
									<td>2025-11-01</td>
									<td>2025-11-03</td>
									<td>
										<span class="badge bg-success">Completado</span>
									</td>
									<td>
										<button class="btn btn-sm btn-outline-secondary" disabled>
											<i class="bi bi-check-circle"></i>
										</button>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
			</div>
		</div>
	</div>

	<!-- MODAL CHECK -->
	<div class="modal fade" id="checkModal" tabindex="-1" aria-hidden="true">
		<div class="modal-dialog modal-dialog-centered">
			<div class="modal-content rounded-4">
				<div class="modal-header">
					<h5 class="modal-title">Detalle de Check</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal"></button>
				</div>
				<div class="modal-body">
					<p><strong>Código:</strong> R001</p>
					<p><strong>Cédula:</strong> 123456789</p>
					<p><strong>Habitación:</strong> 102</p>
					<p><strong>Ingreso:</strong> 2025-11-08</p>
					<p><strong>Salida:</strong> 2025-11-10</p>
				</div>
				<div class="modal-footer">
					<button class="btn btn-success"><i class="bi bi-door-open me-1"></i> Hacer Check</button>
				</div>
			</div>
		</div>
	</div>
</div>

<script>
	const ingreso = document.getElementById('fechaIngreso');
	const salida = document.getElementById('fechaSalida');
	const dias = document.getElementById('dias');

	function sumarUnDia(fecha) {
		const f = new Date(fecha);
		f.setDate(f.getDate() + 1);
		return f.toISOString().split('T')[0];
	}

	function actualizarMinSalida() {
		if (ingreso.value) {
			const minSalida = sumarUnDia(ingreso.value);
			salida.min = minSalida;
			if (salida.value < minSalida) salida.value = minSalida;
		}
	}

	function calcDias() {
		if (ingreso.value && salida.value) {
			const start = new Date(ingreso.value);
			const end = new Date(salida.value);
			if (end > start) {
				const diff = Math.ceil((end - start) / (1000 * 60 * 60 * 24));
				dias.value = diff;
			} else {
				dias.value = '';
			}
		}
	}

	ingreso.addEventListener('change', () => {
		actualizarMinSalida();
		calcDias();
	});

	salida.addEventListener('change', calcDias);

	window.addEventListener('load', calcDias);
</script>
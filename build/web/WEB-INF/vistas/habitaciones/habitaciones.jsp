<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@page import="java.util.List"%>
<%@page import="modelo.Habitacion"%>

<div class="container-fluid py-4">
	<h2 class="fw-semibold text-dark mb-4">
		<i class="bi bi-door-closed me-2"></i>Gestión de Habitaciones
	</h2>

	<% String mensaje = (String) request.getAttribute("mensaje"); %>
	<% if (mensaje != null) { %>
		<div class="alert alert-info alert-dismissible fade show" role="alert">
			<%= mensaje %>
			<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
		</div>
	<% } %>

	<ul class="nav nav-tabs mb-4" id="habitacionesTabs" role="tablist">
		<li class="nav-item">
			<button class="nav-link active" id="registrar-tab" data-bs-toggle="tab" data-bs-target="#registrar" type="button" role="tab">
				<i class="bi bi-plus-circle me-1"></i>Registrar Habitación
			</button>
		</li>
		<li class="nav-item">
			<button class="nav-link" id="consultar-tab" data-bs-toggle="tab" data-bs-target="#consultar" type="button" role="tab">
				<i class="bi bi-search me-1"></i>Consultar Habitaciones
			</button>
		</li>
	</ul>

	<div class="tab-content" id="habitacionesTabsContent">

		<!-- ==================== REGISTRAR ==================== -->
		<div class="tab-pane fade show active" id="registrar" role="tabpanel">
			<div class="card shadow-lg border-0 rounded-4">
				<div class="card-body px-4 py-4">
					<form id="formHabitacion" action="${pageContext.request.contextPath}/HabitacionController" method="post" novalidate>
						<div class="row g-3 mb-4">
							<div class="col-md-3">
								<label for="numero" class="form-label fw-semibold">Número</label>
								<div class="input-group">
									<span class="input-group-text"><i class="bi bi-door-open"></i></span>
									<input type="number" class="form-control" id="numero" name="numero" placeholder="Ej: 101" required>
								</div>
							</div>

							<div class="col-md-3">
								<label for="precio" class="form-label fw-semibold">Precio</label>
								<div class="input-group">
									<span class="input-group-text"><i class="bi bi-cash-stack"></i></span>
									<input type="number" class="form-control" id="precio" name="precio" placeholder="Ej: 120000" min="0" required>
								</div>
							</div>

							<div class="col-md-3">
								<label for="estado" class="form-label fw-semibold">Estado</label>
								<select class="form-select" id="estado" name="estado" required>
									<option value="">Seleccione...</option>
									<option value="Disponible">Disponible</option>
									<option value="Ocupada">Ocupada</option>
								</select>
							</div>

							<div class="col-md-3">
								<label for="descripcion" class="form-label fw-semibold">Descripción</label>
								<div class="input-group">
									<span class="input-group-text"><i class="bi bi-info-circle"></i></span>
									<input type="text" class="form-control" id="descripcion" name="descripcion" placeholder="Ej: Habitación doble" maxlength="100">
								</div>
							</div>
						</div>

						<hr>

						<div class="d-flex flex-wrap justify-content-center gap-2 gap-md-3">
							<button type="button" class="btn btn-sm btn-secondary px-3 py-2" onclick="limpiarCampos()">
								<i class="bi bi-eraser-fill me-1"></i>Limpiar
							</button>
							<button type="submit" name="accion" value="buscar" class="btn btn-sm btn-info text-white px-3 py-2">
								<i class="bi bi-search me-1"></i>Buscar
							</button>
							<button type="submit" name="accion" value="editar" class="btn btn-sm btn-warning text-white px-3 py-2">
								<i class="bi bi-pencil-square me-1"></i>Editar
							</button>
							<button type="submit" name="accion" value="guardar" class="btn btn-sm btn-success px-3 py-2">
								<i class="bi bi-save me-1"></i>Guardar
							</button>
						</div>
					</form>

					<% Habitacion h = (Habitacion) request.getAttribute("habitacion"); 
					   if (h != null) { %>
						<script>
							document.addEventListener("DOMContentLoaded", () => {
								document.getElementById("numero").value = "<%= h.getNumero() %>";
								document.getElementById("precio").value = "<%= h.getPrecioPorNoche() %>";
								document.getElementById("descripcion").value = "<%= h.getDescripcion() %>";
								document.getElementById("estado").value = "<%= h.isDisponible() ? "Disponible" : "Ocupada" %>";
								// Cambiar automáticamente a la pestaña “Registrar”
								const registrarTab = new bootstrap.Tab(document.getElementById('registrar-tab'));
								registrarTab.show();
							});
						</script>
					<% } %>
				</div>
			</div>
		</div>

		<!-- ==================== CONSULTAR ==================== -->
		<div class="tab-pane fade" id="consultar" role="tabpanel">
			<div class="card shadow-lg border-0 rounded-4">
				<div class="card-body px-4 py-4">
					<form id="formConsulta" action="${pageContext.request.contextPath}/HabitacionController" method="get" novalidate>
						<div class="row g-3 mb-3">
							<div class="col-md-6">
								<label for="numeroBuscar" class="form-label fw-semibold">Número</label>
								<div class="input-group">
									<span class="input-group-text"><i class="bi bi-door-open"></i></span>
									<input type="number" class="form-control" id="numeroBuscar" name="numeroBuscar" placeholder="Ej: 101">
								</div>
							</div>

							<div class="col-md-6">
								<label for="estadoBuscar" class="form-label fw-semibold">Estado</label>
								<select class="form-select" id="estadoBuscar" name="estadoBuscar">
									<option value="">Todos</option>
									<option value="Disponible">Disponible</option>
									<option value="Ocupada">Ocupada</option>
								</select>
							</div>
						</div>

						<div class="d-flex flex-wrap justify-content-center gap-2 gap-md-3 mb-4">
							<button type="button" class="btn btn-sm btn-secondary px-3 py-2" onclick="limpiarConsulta()">
								<i class="bi bi-eraser-fill me-1"></i>Limpiar
							</button>
							<button type="submit" name="accion" value="buscar" class="btn btn-sm btn-info text-white px-3 py-2">
								<i class="bi bi-search me-1"></i>Buscar
							</button>
						</div>
					</form>

					<div class="table-responsive">
						<table class="table table-hover align-middle text-center">
							<thead class="table-primary">
								<tr>
									<th>Número</th>
									<th>Precio</th>
									<th>Descripción</th>
									<th>Estado</th>
								</tr>
							</thead>
							<tbody>
								<%
									List<Habitacion> lista = (List<Habitacion>) request.getAttribute("listaHabitaciones");
									if (lista != null && !lista.isEmpty()) {
										for (Habitacion hab : lista) {
								%>
								<tr style="cursor:pointer" onclick="seleccionarHabitacion('<%= hab.getNumero() %>')">
									<td><%= hab.getNumero() %></td>
									<td>$<%= String.format("%,d", hab.getPrecioPorNoche()) %></td>
									<td><%= hab.getDescripcion() %></td>
									<td>
										<span class="badge <%= hab.isDisponible() ? "bg-success" : "bg-danger" %>">
											<%= hab.isDisponible() ? "Disponible" : "Ocupada" %>
										</span>
									</td>
								</tr>
								<% 
										}
									} else { 
								%>
								<tr><td colspan="4" class="text-muted">No se encontraron habitaciones</td></tr>
								<% } %>
							</tbody>
						</table>
					</div>
				</div>
			</div>
		</div>

	</div>
</div>

<script>
	function limpiarCampos() {
		document.getElementById("formHabitacion").reset();
	}

	function limpiarConsulta() {
		document.getElementById("formConsulta").reset();
	}

	function seleccionarHabitacion(numero) {
		// Redirige al layout con la habitación seleccionada
		window.location.href = `${pageContext.request.contextPath}/WEB-INF/vistas/layout.jsp?page=habitaciones.jsp&accion=buscar&numero=${numero}`;
	}
</script>
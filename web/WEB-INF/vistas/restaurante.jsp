<%@page contentType="text/html" pageEncoding="UTF-8" %>
<div class="container-fluid py-3">
	<h2 class="fw-semibold text-dark mb-4">
		<i class="bi bi-egg-fried me-2"></i>Configuración de Precios - Restaurante
	</h2>

	<div class="card shadow-sm rounded-4 border-0">
		<div class="card-body p-4">
			<form class="row g-3">
				<div class="col-md-4">
					<label for="precioDesayuno" class="form-label fw-semibold">Precio Desayuno</label>
					<input type="number" class="form-control" id="precioDesayuno" placeholder="Ej: 15000" min="0">
				</div>

				<div class="col-md-4">
					<label for="precioAlmuerzo" class="form-label fw-semibold">Precio Almuerzo</label>
					<input type="number" class="form-control" id="precioAlmuerzo" placeholder="Ej: 25000" min="0">
				</div>

				<div class="col-md-4">
					<label for="precioCena" class="form-label fw-semibold">Precio Cena</label>
					<input type="number" class="form-control" id="precioCena" placeholder="Ej: 20000" min="0">
				</div>

				<div class="col-12 text-end mt-3">
					<button type="submit" class="btn btn-success">
						<i class="bi bi-save me-1"></i> Guardar
					</button>
				</div>
			</form>
		</div>
	</div>
</div>
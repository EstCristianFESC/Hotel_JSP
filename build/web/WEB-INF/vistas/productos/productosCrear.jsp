<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<div class="container-fluid py-4">

    <h2 class="fw-semibold text-dark mb-4">
        <i class="bi bi-plus-circle me-2"></i>Registrar Nuevo Producto
    </h2>

    <div class="card shadow-lg border-0 rounded-4">
        <div class="card-body px-4 py-4">

            <form action="${pageContext.request.contextPath}/ProductosController" method="post" class="row g-3">

                <input type="hidden" name="accion" value="agregarProducto"/>

                <div class="col-md-6">
                    <label class="form-label fw-semibold">Descripción del Producto:</label>
                    <input type="text" name="descripcion" class="form-control" required
                           placeholder="Ej: Jugo natural, Almuerzo corriente, etc.">
                </div>

                <div class="col-md-4">
                    <label class="form-label fw-semibold">Valor Unitario:</label>
                    <input type="number" name="valor" min="0" class="form-control" id="valorInput"
                           placeholder="Ej: 8500" required>
                </div>

                <div class="col-12 d-flex gap-2 mt-3">

                    <button class="btn btn-success px-4 py-2">
                        <i class="bi bi-check2-circle me-1"></i>Guardar
                    </button>

                    <a href="${pageContext.request.contextPath}/LoginController?page=productos/productos.jsp"
                       class="btn btn-secondary px-4 py-2">
                        <i class="bi bi-arrow-left me-1"></i>Volver
                    </a>
                </div>
            </form>
        </div>
    </div>
</div>
                       
<script>
    const valorInput = document.getElementById('valorInput');

    valorInput.addEventListener('input', (e) => {
        // Guardamos el valor real en un atributo
        const rawValue = e.target.value.replace(/\./g, '');
        e.target.dataset.rawValue = rawValue;

        // Formateamos para mostrar miles
        if (rawValue) {
            const formatted = Number(rawValue).toLocaleString('de-DE'); // miles con puntos
            e.target.value = formatted;
        }
    });

    // Al enviar el formulario, restauramos el valor original
    valorInput.closest('form')?.addEventListener('submit', () => {
        if (valorInput.dataset.rawValue) {
            valorInput.value = valorInput.dataset.rawValue;
        }
    });
</script>
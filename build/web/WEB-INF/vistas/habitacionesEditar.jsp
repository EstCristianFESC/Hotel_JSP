<%@ page contentType="text/html;charset=UTF-8" %>
<%
    modelo.Habitacion habitacion = (modelo.Habitacion) request.getAttribute("habitacion");
%>

<div class="container mt-4">
    <h3>Editar Habitación</h3>
    <form action="HabitacionController" method="post">
        <input type="hidden" name="accion" value="actualizar">
        <input type="hidden" name="numero" value="<%= habitacion.getNumero() %>">

        <!-- Número (solo lectura, no modificable) -->
        <div class="mb-3">
            <label>Número</label>
            <input type="text" class="form-control" value="<%= habitacion.getNumero() %>" readonly>
        </div>

        <!-- Tipo -->
        <div class="mb-3">
            <label>Tipo</label>
            <select name="tipo" class="form-select" required>
                <option value="Sencilla" <%= "Sencilla".equals(habitacion.getTipo()) ? "selected" : "" %>>Sencilla</option>
                <option value="Doble" <%= "Doble".equals(habitacion.getTipo()) ? "selected" : "" %>>Doble</option>
                <option value="Suite" <%= "Suite".equals(habitacion.getTipo()) ? "selected" : "" %>>Suite</option>
            </select>
        </div>

        <!-- Precio por Noche -->
        <%
            // Preparamos el precio como entero
            long precio = habitacion != null ? Math.round(habitacion.getPrecioPorNoche()) : 0;
        %>

        <div class="col-md-4">
            <label for="precioPorNoche" class="form-label fw-semibold">Precio por Noche *</label>
            <div class="input-group">
                <span class="input-group-text"><i class="bi bi-cash-stack"></i></span>
                <input type="text" inputmode="numeric" pattern="[0-9\.]*" class="form-control"
                       id="precioPorNoche" name="precioPorNoche" placeholder="Ej: 120.000"
                       value="<%= precio %>" required>
            </div>
        </div>

        <!-- Descripción -->
        <div class="mb-3">
            <label>Descripción</label>
            <textarea name="descripcion" class="form-control" rows="3"><%= habitacion.getDescripcion() != null ? habitacion.getDescripcion() : "" %></textarea>
        </div>

        <!-- Disponibilidad -->
        <div class="mb-3 form-check form-switch">
            <input class="form-check-input" type="checkbox" name="disponible" id="disponible" <%= habitacion.isDisponible() ? "checked" : "" %>>
            <label class="form-check-label" for="disponible">Disponible</label>
        </div>

        <button type="submit" class="btn btn-primary">Guardar Cambios</button>
        <a href="HabitacionController?accion=listar" class="btn btn-secondary">Cancelar</a>
    </form>
</div>
            
<script>
    const inputPrecio = document.getElementById("precioPorNoche");

    function formatearNumero(valor) {
        valor = valor.toString().replace(/\D/g, '');
        if (!valor) return '';
        return valor.replace(/\B(?=(\d{3})+(?!\d))/g, '.');
    }

    // Formatear valor inicial al cargar la página
    if (inputPrecio.value) {
        inputPrecio.value = formatearNumero(inputPrecio.value);
    }

    // Formatear mientras escribe
    inputPrecio.addEventListener("input", (e) => {
        const cursor = inputPrecio.selectionStart;
        const valorAnterior = inputPrecio.value;
        inputPrecio.value = formatearNumero(inputPrecio.value);
        if (cursor === valorAnterior.length) {
            inputPrecio.selectionStart = inputPrecio.selectionEnd = inputPrecio.value.length;
        }
    });
</script>
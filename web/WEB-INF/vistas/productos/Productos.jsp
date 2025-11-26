<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.*, modelo.Productos"%>

<div class="container-fluid py-4">

    <h2 class="fw-semibold text-dark mb-4">
        <i class="bi bi-basket3 me-2"></i>Productos del Restaurante
    </h2>

    <!-- Mensaje -->
    <div id="mensajeProducto"
         class="toast align-items-center text-bg-<%= (request.getAttribute("tipoMensaje") != null) ? request.getAttribute("tipoMensaje").toString().replace("alert-", "") : "info" %> border-0"
         role="alert" aria-live="assertive" aria-atomic="true"
         style="position: fixed; top: 1rem; right: 1rem; min-width: 260px; z-index: 9999;">
        <div class="d-flex">
            <div class="toast-body" style="font-size: 0.85rem;">
                <%= (request.getAttribute("mensaje") != null) ? request.getAttribute("mensaje") : "Use los filtros para consultar productos." %>
            </div>
            <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
        </div>
    </div>

    <div class="card shadow-lg border-0 rounded-4">
        <div class="card-body px-4 py-4">

            <!-- Filtros -->
            <form action="${pageContext.request.contextPath}/ProductosController"
                  method="get" class="row g-3 mb-4 align-items-end">

                <!-- Campo de búsqueda -->
                <div class="col-md-4">
                    <label class="form-label fw-semibold">Descripción:</label>
                    <input type="text" class="form-control" name="descripcion"
                           value="<%= request.getParameter("descripcion") == null ? "" : request.getParameter("descripcion") %>"
                           placeholder="Ej: Gaseosa, Hamburguesa">
                </div>

                <!-- Filtro Estado -->
                <div class="col-md-3">
                    <label class="form-label fw-semibold">Estado:</label>
                    <select name="estado" class="form-select">
                        <option value="">-- Todos --</option>
                        <option value="1" <%= "1".equals(String.valueOf(request.getParameter("estado"))) ? "selected" : "" %>>Activo</option>
                        <option value="0" <%= "0".equals(request.getParameter("estado")) ? "selected" : "" %>>Inactivo</option>
                    </select>
                </div>

                <!-- Botón Agregar -->
                <div class="col-md-4 d-flex">
                    <a href="${pageContext.request.contextPath}/ProductosController?accion=crear"
                       class="btn btn-sm btn-success px-3 py-2 ms-auto">
                        <i class="bi bi-plus-circle me-1"></i>Nuevo Producto
                    </a>
                </div>

                <!-- Línea completa para Buscar y Limpiar -->
                <div class="col-12 d-flex align-items-end gap-2 mt-2">

                    <!-- Botón Buscar -->
                    <button type="submit" name="accion" value="consultar"
                            class="btn btn-sm btn-info text-white px-3 py-2">
                        <i class="bi bi-search me-1"></i>Buscar
                    </button>

                    <!-- Botón Limpiar -->
                    <button type="button" onclick="limpiarFiltros()" class="btn btn-sm btn-secondary px-3 py-2">
                        <i class="bi bi-eraser me-1"></i>Limpiar
                    </button>

                </div>
            </form>

            <hr>

            <!-- Tabla productos -->
            <div class="table-responsive">
                <table class="table table-striped table-hover align-middle">
                    <thead class="table-dark">
                        <tr>
                            <th>Descripción</th>
                            <th>Valor Unitario</th>
                            <th>Estado</th>
                            <th class="text-center">Acciones</th>
                        </tr>
                    </thead>

                    <tbody>
                    <%
                        List<Productos> lista = (List<Productos>) request.getAttribute("listaProductos");
                        if (lista == null) lista = new ArrayList<>();

                        if (lista.isEmpty()) {
                    %>
                        <tr>
                            <td colspan="4" class="text-center">No hay productos para mostrar.</td>
                        </tr>
                    <% } else {
                        for (Productos p : lista) {
                            String valorFormateado = String.format("%,d", (long)p.getValorUnitario()).replace(",", ".");
                    %>
                        <tr>
                            <td><%= p.getDescripcion() %></td>
                            <td>$ <%= valorFormateado %></td>
                            <td><%= (p.getEstado() == 1) ? "Activo" : "Inactivo" %></td>
                            <td class="text-center">
                                <a href="${pageContext.request.contextPath}/ProductosController?accion=editar&id=<%= p.getId() %>"
                                   class="btn btn-sm btn-warning">
                                   <i class="bi bi-pencil-square"></i> </a>
                            </td>
                        </tr>
                    <% } } %>
                    </tbody>
                </table>
            </div>

        </div>
    </div>
</div>

<script>
    // Mostrar toast si hay mensaje desde backend
    document.addEventListener("DOMContentLoaded", function () {
        var toastEl = document.getElementById("mensajeProducto");

        <% if (request.getAttribute("mensaje") != null) { %>
            var bsToast = new bootstrap.Toast(toastEl, { delay: 3000, autohide: true });
            bsToast.show();
        <% } %>
    });

    // Limpiar filtros + ocultar toast + tabla vacía
    function limpiarFiltros() {
        // limpiar campos
        document.querySelector("input[name=descripcion]").value = "";
        document.querySelector("select[name=estado]").value = "";

        // ocultar toast
        const toastEl = document.getElementById("mensajeProducto");
        var bsToast = bootstrap.Toast.getInstance(toastEl);
        if (bsToast) bsToast.hide();
        toastEl.style.display = "none";

        // limpiar tabla
        const tbody = document.querySelector("table tbody");
        tbody.innerHTML = '<tr><td colspan="4" class="text-center">No hay productos para mostrar.</td></tr>';
    }
</script>
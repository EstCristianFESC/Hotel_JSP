<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.*, modelo.Productos"%>

<div class="container-fluid py-4">

    <h2 class="fw-semibold text-dark mb-4">
        <i class="bi bi-basket3 me-2"></i>Productos del Restaurante
    </h2>

    <!-- Mensaje -->
    <div id="mensajeProducto"
         class="alert <%= (request.getAttribute("tipoMensaje") != null) ? request.getAttribute("tipoMensaje") : "alert-info" %>"
         style="display: <%= (request.getAttribute("mensaje") != null) ? "block" : "none" %>;">
        <%= (request.getAttribute("mensaje") != null) ? request.getAttribute("mensaje") : "Use los filtros para consultar productos." %>
    </div>

    <div class="card shadow-lg border-0 rounded-4">
        <div class="card-body px-4 py-4">

            <!-- Filtros -->
            <form action="${pageContext.request.contextPath}/ProductosController"
                  method="get" class="row g-3 mb-4">

                <div class="col-md-3">
                    <label class="form-label fw-semibold">ID Producto:</label>
                    <input type="number" class="form-control" name="id"
                           value="<%= request.getParameter("id") != null ? request.getParameter("id") : "" %>"
                           placeholder="Ej: 10">
                </div>

                <div class="col-md-5">
                    <label class="form-label fw-semibold">Descripción:</label>
                    <input type="text" class="form-control" name="descripcion"
                           value="<%= request.getParameter("descripcion") != null ? request.getParameter("descripcion") : "" %>"
                           placeholder="Ej: Gaseosa, Hamburguesa">
                </div>

                <div class="col-12 d-flex align-items-end gap-2">

                    <!-- Botón Buscar -->
                    <button type="submit" name="accion" value="consultar" class="btn btn-sm btn-info text-white px-3 py-2">
                        <i class="bi bi-search me-1"></i>Buscar
                    </button>

                    <!-- Botón Limpiar -->
                    <button type="button" onclick="limpiarFiltros()" class="btn btn-sm btn-secondary px-3 py-2">
                        <i class="bi bi-eraser me-1"></i>Limpiar
                    </button>

                    <!-- Botón Agregar -->
                    <a href="${pageContext.request.contextPath}/LoginController?page=productos/productosCrear.jsp"
                       class="btn btn-sm btn-success px-3 py-2 ms-auto">
                        <i class="bi bi-plus-circle me-1"></i>Nuevo Producto
                    </a>
                </div>
            </form>

            <hr>

            <!-- Tabla productos -->
            <div class="table-responsive">
                <table class="table table-striped table-hover align-middle">
                    <thead class="table-dark">
                        <tr>
                            <th>ID</th>
                            <th>Descripción</th>
                            <th>Valor Unitario</th>
                            <th class="text-center">Acciones</th>
                        </tr>
                    </thead>

                    <tbody>
                    <%
                        List<Productos> lista = (List<Productos>) request.getAttribute("productos");
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
                            <td><%= p.getId() %></td>
                            <td><%= p.getDescripcion() %></td>
                            <td>$ <%= valorFormateado %></td>
                            <td class="text-center">
                                <a href="RestauranteProductoController?accion=editar&id=<%= p.getId() %>"
                                   class="btn btn-sm btn-warning">
                                    <i class="bi bi-pencil-square"></i>
                                </a>
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
    function limpiarFiltros() {
        document.querySelector("input[name=id]").value = "";
        document.querySelector("input[name=descripcion]").value = "";
        document.getElementById("mensajeProducto").style.display = "none";

        const tbody = document.querySelector("table tbody");
        tbody.innerHTML = '<tr><td colspan="4" class="text-center">No hay productos para mostrar.</td></tr>';
    }

    // Fade al mensaje
    window.addEventListener("DOMContentLoaded", () => {
        const msj = document.getElementById("mensajeProducto");
        if (msj && msj.style.display === "block") {
            setTimeout(() => {
                msj.style.transition = "opacity .5s";
                msj.style.opacity = "0";
                setTimeout(() => msj.style.display = "none", 500);
            }, 3000);
        }
    });
</script>